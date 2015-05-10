function [morphed_im] = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)


%%%%%%%%%%%% This code is for my demo script, with image resizing %%%%%
    [l1,w1,d] = size(im1);
    [l2,w2,d] = size(im2);
    l = max(l1, l2);
    w = max(w1, w2);
    
    num_pix1 = l1*w1;
    num_pix2 = l2*w2;
    num_pix = l*w;
    [pixel_i, pixel_j] = ind2sub([l,w], 1:num_pix);
    pix_coordinates = [reshape(pixel_j, num_pix,1), reshape(pixel_i, num_pix,1)];
    morphed_im = zeros(l,w,d);

    %compute intermediate shape (target points for triangles)
    ctr_pts_target = (1-warp_frac)*im1_pts(1:(end-4),:)+warp_frac*im2_pts(1:(end-4),:);
    crn_pts_target = [1 1; max(w1,w2), 1; 1, max(l1, l2); max(w1,w2),max(l1,l2)];
    ctr_pts_target = [ctr_pts_target; crn_pts_target];

%%%%%%%%%%% This code is used for the evaluator script  %%%%%%%%%%%%
%     [l,w,d] = size(im1);
%     num_pix = l*w;
%     [pixel_i, pixel_j] = ind2sub([l,w], 1:num_pix);
%     pix_coordinates = [reshape(pixel_j, num_pix,1), reshape(pixel_i, num_pix,1)];
%     ctr_pts_target = (1-warp_frac)*im1_pts+warp_frac*im2_pts;
%     morphed_im = zeros(l,w,d);
%     num_pix1 = num_pix;
%     num_pix2 = num_pix;
%     l1=l; l2=l;
%     w1=w; w2=w;
    

%%%%%%%%%%% Standard Code %%%%%%%%%%%%%%%%%%%%%

    % determine which coordinates are in which triangle of the target
    % image
    [t, P] = tsearchn(ctr_pts_target, tri, pix_coordinates);
    
    %find the corresponding pixel in the corresponding triangle of the
    %source image, using barycentric coordinates.
    
    for ii=1:size(tri, 1)
        
        %transfortmation 1: pixel position in target to barycentric
        to_bary = [ctr_pts_target(tri(ii, :)', :)';1,1,1]; %target triangle stuff
        pts_in_tri = pix_coordinates(t==ii, :);
        xy_target = [pts_in_tri'; ones(1, length(pts_in_tri))];
        
        bary_vec = to_bary\xy_target;
        
        %trasforamtion 2: barycentric to pixel position in original
        from_bary2 = [im2_pts(tri(ii,:)',:)';1,1,1]; %source triangle stuff
        xy_source2 = (from_bary2*bary_vec)';
        xy_source2 = round([xy_source2(:,1)./xy_source2(:,3), xy_source2(:,2)./xy_source2(:,3)]);
        from_bary1 = [im1_pts(tri(ii,:)',:)';1,1,1]; %source triangle stuff
        xy_source1 = (from_bary1*bary_vec)';
        xy_source1 = round([xy_source1(:,1)./xy_source1(:,3), xy_source1(:,2)./xy_source1(:,3)]);
        
        %set the color of the target pixel
        morphed_inds = sub2ind(size(morphed_im), pts_in_tri(:,2),pts_in_tri(:,1));
        im1_inds = sub2ind(size(im1), xy_source1(:,2),xy_source1(:,1));
        im1_inds(im1_inds > num_pix1) = num_pix1;
        im2_inds = sub2ind(size(im2), xy_source2(:,2),xy_source2(:,1));
        im2_inds(im2_inds > num_pix2) = num_pix2;
        
        for j = 0:d-1
            morphed_im(morphed_inds+l*w*j) = ((1-dissolve_frac)*im1(im1_inds+l1*w1*j)+dissolve_frac*im2(im2_inds+l2*w2*j));
        end

        
    end
