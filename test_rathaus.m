% data = preprocess_rathus('rathaus'); save('rathaus.mat','data');
% data = preprocess_rathus('semper'); save('brussel.mat','data');
%data = preprocess_rathus('brussel'); save('brussel.mat','data');

% load('brussel.mat');
close all;
%Nice pairs : {1,2}, {1,3}, {1,4}, {2,4}, {3,4}, {2,3}, {2,4}, {3,4}
% Bad pairs :, {4,5}, {1,5}, {5,6} , {7,6}
object1 = data{2,1};
object2 = data{3,1};
points3D = [object1.points3D; object2.points3D];
keypoints1 = getkeypointsFrom3D(points3D, object1.cp);
keypoints2 = getkeypointsFrom3D(points3D, object2.cp);

% 
imshow(object1.im);
hold on;
show_keypoints(keypoints1,'r.');
hold off;
pause(1)
figure()
imshow(object2.im)
hold on;
show_keypoints(keypoints2,'b.');
pause(1)

im1 = object1.im;
im2 = object2.im;
clean3Dpoints = remove3DpointsOutsideImages(points3D, object1.cp, object2.cp, size(im1));
pixel_threshold = 8;
downscale = 1/5;
matched_points_surf = get_match_points_between_2_images(rgb2gray(im1), object1.cp, rgb2gray(im2),...
    object2.cp, points3D, pixel_threshold, downscale);

fprintf('Total available Correspondances %d\n',size(clean3Dpoints,1));

fprintf('Matched_points SURF %d\n',matched_points_surf);
net = alexnet();
matched_points_conv = get_conv_match_points_between_2_images(net, im1, object1.cp, im2,...
    object2.cp, clean3Dpoints, pixel_threshold, downscale);
fprintf('Matched_points CONV5 %d\n',matched_points_conv);

