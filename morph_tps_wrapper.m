function morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac, sz)

%%%%%%%%%%%%   control point fpr my demo code   %%%%%%%%%%%%%%%
[l1,w1,d] = size(im1);
[l2,w2,d] = size(im2);
ctr_pts = (1-warp_frac)*im1_pts(1:(end-4),:)+warp_frac*im2_pts(1:(end-4),:);
crn_pts = [1 1; max(w1,w2), 1; 1, max(l1, l2); max(w1,w2),max(l1,l2)];
ctr_pts = [ctr_pts; crn_pts];

%%%%%%% control points for the eval script %%%%%%%%%%%%%
%ctr_pts = (1-warp_frac)*im1_pts+warp_frac*im2_pts;


[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, im1_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, im1_pts(:,2));
morphed_im1 = morph_tps(im1, a1_x, ax_x, ay_x, w_x, a1_y, ax_y,ay_y, w_y, ctr_pts, sz);

[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, im2_pts(:,1));
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, im2_pts(:,2));
morphed_im2 = morph_tps(im2, a1_x, ax_x, ay_x, w_x, a1_y, ax_y,ay_y, w_y, ctr_pts, sz);

% blend the images
morphed_im = (1-dissolve_frac).*morphed_im1 + dissolve_frac.*morphed_im2;