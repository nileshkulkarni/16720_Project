% addpath('sift/');
pascalImages = 'TrainVal/VOCdevkit/VOC2011/';



keypoint_dir = '/home/nilesh/acads/16720/Project/annotations/aeroplane/';
keypoint_path1 = strcat(keypoint_dir, '2007_000032_1.xml');
keypoint_path2 = strcat(keypoint_dir, '2007_000032_2.xml');
keypoint_paths  = {keypoint_path1, keypoint_path2};
images_dir = '/home/nilesh/acads/16720/Project/TrainVal/VOCdevkit/VOC2011/JPEGImages/';
image_path =  strcat(images_dir,'2007_000032.jpg');
image = imread(image_path);
% imshow(image);
imgray  = rgb2gray(image);
keypoints1 = readKeypoints(keypoint_path1);
keypoints2 = readKeypoints(keypoint_path2);
keypoints = [keypoints1; keypoints2];
% show_keypoints(keypoints(6,:));

% im2ann = image2annotations('/home/nilesh/acads/16720/Project/TrainVal/VOCdevkit/VOC2011/JPEGImages' ,...
%     '/home/nilesh/acads/16720/Project/annotations/');
% hold off;
% figure(2)
% [outputImage,H] = homography(image,10,0, 0);
% imshow(outputImage);
% outsize = size(outputImage);
% % sizeRatio = inSize./outSize;
% newKeyPoints = transformWithHomography(keypoints,H);
% show_keypoints(newKeyPoints);

% points = detectSURFFeatures(imgray);
% imshow(imgray); hold on;
% plot(points.selectStrongest(100));
% 
% figure()
% [outputImage,H] = homography(imgray,10,0, 0);
% points_2 = detectSURFFeatures(outputImage);
% imshow(outputImage); hold on;
% plot(points_2.selectStrongest(100));

pixel_threshold = 8;
matched_points = get_match_points(imgray,15,0,0,keypoints,pixel_threshold);
