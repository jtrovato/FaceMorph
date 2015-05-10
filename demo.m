% CIS581 Project 2 - Face Morphing

%% image preprocessing
close all; clear all;

im1 = double(imread('me.jpg'))/255;
im2 = double(imread('emma.jpg'))/255;
scale = .5;
im1 = imresize(im1, scale);
im2 = imresize(im2, scale);


[l1,w1,d1] = size(im1);
[l2,w2,d2] = size(im2);
if d1 ~= d2
    error('use images of same format');
end

l = max(l1, l2);
w = max(w1, w2);

if l1<l2 && w1<w2
    sc = min(l2/l1, w2/w1);
    im1 = imresize(im1, sc);
elseif l2<l1 && w2<w1
    sc = min(l1,l2, w1/w2);
    im2 = imresize(im2, sc);
else
    %they are kinda the same size so dont resize anything.
end

%% Task 1: Defining Correspondences and Traingulation
[im1_pts, im2_pts] = click_correspondences(im1, im2);
crn_pts = [1 1; max(w1,w2), 1; 1, max(l1, l2); max(w1,w2),max(l1,l2)];
im_pts = (im1_pts(1:(end-4),:) + im2_pts(1:(end-4),:))./2;
im_pts = [im_pts; crn_pts];
tri = delaunay(im_pts(:,1), im_pts(:,2));


%% Sanity Check
figure();
imshow(im2);
hold on;
triplot(tri, im_pts(:,1), im_pts(:,2));

%% Task 2: Image Morph via Triangualtion

figure();
num_frames = 60;
for ii = 1:num_frames
    warp_frac = ii/num_frames;
    dissolve_frac = ii/num_frames;
    morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac);
    subplot(1,3,1);
    subimage(im1);
    subplot(1,3,2);
    subimage(morphed_im);
    subplot(1,3,3);
    subimage(im2);
    drawnow;
    frame = ii
end

%% create video:
num_frames = 60;
h_avi = VideoWriter('me2emma_tri.avi', 'Uncompressed AVI');
h_avi.FrameRate = 10;
h_avi.open();
for ii = 1:num_frames
    warp_frac = ii/num_frames;
    dissolve_frac = ii/num_frames;
    morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac);
    imshow(morphed_im)
    drawnow;
    
    h_avi.writeVideo(getframe(gca));
    frame = ii
end
h_avi.close();
clear h_avi;


%% Task 3: Image Morph via Thin Plate Spline


figure();
sz = [l,w];
num_frames = 10;
for ii = 1:num_frames
    warp_frac = ii/num_frames;
    dissolve_frac = ii/num_frames;
    morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac, sz);
    subplot(1,3,1);
    subimage(im1);
    subplot(1,3,2);
    subimage(morphed_im);
    subplot(1,3,3);
    subimage(im2);
    drawnow;
    frame = ii
end

%% create video:
num_frames = 60;
sz = [l,w];
h_avi = VideoWriter('me2emma_tps.avi', 'Uncompressed AVI');
h_avi.FrameRate = 10;
h_avi.open();
for ii = 1:num_frames
    warp_frac = ii/num_frames;
    dissolve_frac = ii/num_frames;
    morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac, sz);
    imshow(morphed_im)
    drawnow;
    h_avi.writeVideo(getframe(gca));
    frame = ii
end
h_avi.close();
clear h_avi;

