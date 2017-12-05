function matched_points = get_match_points_between_2_images(image1, cp1,...
    image2, cp2, points3D, pixel_threshold, downscale)
    
    newSize = size(image1)*downscale;
    image1 = imresize(image1, newSize);
    image2 = imresize(image2, newSize);
    keypointsImage1 =  getkeypointsFrom3D(points3D,cp1)*downscale;
    keypointsImage2 = getkeypointsFrom3D(points3D,cp2)*downscale;
    
    
    alexnetInputSize = [227 227];
    image1 = imresize(image1, alexnetInputSize);
    image2 = imresize(image2, alexnetInputSize);
    scale_x = alexnetInputSize(2)/newSize(2);
    scale_y = alexnetInputSize(1)/newSize(1);
    
    keypointsImage1(:,1) = min(max(ceil(keypointsImage1(:,1)*scale_x),1), alexnetInputSize(2)); 
    keypointsImage2(:,1) = min(max(ceil(keypointsImage2(:,1)*scale_x),1),alexnetInputSize(2));
    
    keypointsImage1(:,2) = min(max(ceil(keypointsImage1(:,2)*scale_y),1), alexnetInputSize(1)); 
    keypointsImage2(:,2) = min(max(ceil(keypointsImage2(:,2)*scale_y),1), alexnetInputSize(1));
    
    
    features1 = get_surf_descriptors_at(image1, keypointsImage1);
    
    [meshXOnImage,meshYOnImage] = meshgrid(1:size(image2,2),...
        1:size(image2,1));
    meshXOnImage = meshXOnImage(:);
    meshYOnImage = meshYOnImage(:);
    allFeaturesWarpImage = get_surf_descriptors_at(image2,...
        [meshXOnImage, meshYOnImage]);
    
    matchingPairs = zeros(size(features1,1),2);
    for j=1:size(features1,1)
        currentImageFeature = features1(j,:);
        minDist = Inf;
        mini = nan;
        difference = sum((allFeaturesWarpImage - currentImageFeature).^2, 2);
        [minDist,mini] = min(difference);    
        matchingPairs(j,:) = [j ,mini];
    end
    
    error_threshold = sqrt(2)*pixel_threshold; 
    
    matched_points= 0;
    predictedMataches = zeros(size(keypointsImage2));
    for i=1:size(matchingPairs,1)
       p1 = matchingPairs(i,1); p2 = matchingPairs(i,2);
       input = keypointsImage1(p1,:);
       predictedMataches(i,:) = [meshXOnImage(p2) meshYOnImage(p2)];
       predictedMatch = predictedMataches(i,:);
       groundTruth = keypointsImage2(p1,:);
       er = norm(groundTruth - predictedMatch);
       if er < error_threshold
           matched_points = matched_points + 1;
       end
    end
end