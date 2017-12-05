try
    fprintf("Closing existing pool\n");
    parpool close;
catch ME
    disp(ME.message);
end
parpool('local',3)
tic

% random seed for reproducibility
rng(5)

%% options 
pixel_threshold = 8;
num_keys = 10;
rotation = -60 : 2 : 60;
translation = -30 : 5 : 30;
net_name = 'alexnet';
conv_layer = 'conv5';
filename = strcat('cnn_',net_name, '_',conv_layer,'.mat');

%% keypoint annotations for images paths
imagesDir = 'TrainVal/VOCdevkit/VOC2011/JPEGImages';
annotationsDir = 'annotations/';
% get annotations for every image
% annotations = image2annotations(imagesDir, annotationsDir);
% image names are keys
keys = annotations.keys;
% randomly sample keys
keys = datasample(keys,num_keys);

%% find matching points for each image
% CNN to use
net = alexnet();

% counts
img_count = 0;

matches_img_rot = cell(length(keys),1);
matches_img_trans = cell(length(keys),1);


detected_rot = 0;
detected_trans = 0;

total_rot_count = cell(length(keys),1);
total_trans_count = cell(length(keys),1);

parfor i = 1 : length(keys)
    % get string key from cell array
    matches_rot = [];
    matches_trans = [];
    k = keys(i);
    k = k{1,1};
    % keypoints for the image
    ann = annotations(k);
    img = imread(ann.path);
    ann = ann.annotations;
    if length(ann) == 0
        continue
    end
    keypoints = [];
    for j = 1 : length(ann)
        keypoints = [keypoints; ann{j,1}];
    end
    % scale keypoints with image size
    imSize = size(img);
    scale_x = imSize(2)/227.;
    scale_y = imSize(1)/227.;
    img = imresize(img, [227,227]);
    keypoints(:,1) = keypoints(:,1)/double(scale_x);
    keypoints(:,2) = keypoints(:,2)/double(scale_y);
    keypoints = round(keypoints);
    %remove keypoints with negative values
    keypoints(keypoints(:,1) <= 0 | keypoints(:,1) > 227, :) = [];
    keypoints(keypoints(:,2) <= 0 | keypoints(:,2) > 227, :) = [];
    
    % get matches using cnn features
    % for all rotation and translation values
    for j = 1 : length(rotation)
        rot  = rotation(j);
        matches = getMatchesConv(net,img,rot,0,0,keypoints,pixel_threshold);
        matches_rot = [matches_rot, matches];
    end
    
    for j = 1 : length(translation)
        trans = translation(j);
        matches = getMatchesConv(net,img,0,trans,trans,keypoints,pixel_threshold);
        matches_trans = [matches_trans, matches];
    end
    
    matches_img_rot{i,1} = matches_rot;
    matches_img_trans{i,1} = matches_trans;
    total_rot_count {i,1} = length(keypoints)*length(rotation);
    total_trans_count {i,1} = length(keypoints)*length(translation);
    
%     img_count = img_count + 1;
%     total_rot = total_rot + length(keypoints)*length(rotation);
%     total_trans = total_trans + length(keypoints)*length(translation);
 
end

fprintf("Total number of images processed: %d / %d\n", ...
    img_count, length(keys));

fprintf("ROT | matched %d / %d keypoints\n", ...
        sum(matches_rot), total_rot)
fprintf("TRANS | matched %d / %d keypoints\n", ...
        sum(matches_trans), total_trans)

fprintf("ROT | Average accuracy : %f%%\n", ...
    (100.0 * sum(matches_rot))/total_rot );
fprintf("TRANS | Average accuracy : %f%%\n", ...
    (100.0 * sum(matches_trans))/total_trans );

save(filename,  'keys', ...
                'pixel_threshold', ...
                'rotation', ...
                'translation', ...
                'matches_rot', ...
                'matches_trans', ...
                'total_rot', ...
                'total_trans');

toc


delete(gcp);

