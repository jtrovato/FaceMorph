function morphed_im = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y,ay_y, w_y, ctr_pts, sz)

U = @(r) r.^2.*log(r.^2); %function for the radial basis function
[ls,ws,d] = size(im_source);
l = sz(1);
w = sz(2);
morphed_im = zeros(l,w,d);

[xi, yi] = meshgrid(1:w, 1:l);


fx = a1_x + ax_x*xi + ay_x*yi;
fy = a1_y + ax_y*xi + ay_y*yi;

%loop over control points
for kk=1:size(ctr_pts, 1)
    to_sum = U(sqrt((ctr_pts(kk,1)-xi).^2 + (ctr_pts(kk,2)-yi).^2));
    to_sum(isnan(to_sum)) = 0;
    fx = fx + w_x(kk)*to_sum;
    fy = fy + w_y(kk)*to_sum;
    
end

%round and clamp
fx = round(fx);
fy = round(fy);
fx(fx > ws) = ws; fx(fx < 1) = 1;
fy(fy >ls) = ls; fy(fy < 1) = 1;

% asign morph_im pixel values, have to use linear indexing to avoid memory
% issues with subscript indexing.
morphed_inds = sub2ind([l,w], yi, xi);
source_inds = sub2ind([ls,ws], fy, fx);
for layer = 0:d-1
    morphed_im(morphed_inds + w*l*layer) = im_source(source_inds + ws*ls*layer);
end


