function [im1_pts, im2_pts] = click_correspondences(im1, im2)
    

    [im1_pts, im2_pts] = cpselect(im1, im2, 'Wait', true);
    
    %add corners automatically
    [i1, j1, ~] = size(im1);
    [i2, j2, ~] = size(im2);
    im1_pts = [im1_pts; [1,1];[j1,1];[1,i1];[j1,i1]];
    im2_pts = [im2_pts; [1,1];[j2,1];[1,i2];[j2,i2]];