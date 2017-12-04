function matched_points = getMatchesConv(net,image, angle, tx, ty, keypoints, pixel_threshold)

    features = getCNNFeatures(net, image);
    size_f = size(image);
    indices = sub2ind(size_f(1:2), keypoints(:,2), keypoints(:,1));
    features = features(indices,:);

    [warpImage,H] = homography(image,angle,tx, ty);
    newKeyPoints = transformWithHomography(keypoints,H);
%     warpImage = image;
%     H = eye(3);
%     newKeyPoints = keypoints;
    [meshXOnImage,meshYOnImage] = meshgrid(1:size(warpImage,2), 1:size(warpImage,1));
    meshXOnImage = meshXOnImage(:);
    meshYOnImage = meshYOnImage(:);
    allFeaturesWarpImage = getCNNFeatures(net, warpImage);
%     allFeaturesWarpImage = get_surf_descriptors_at(warpImage, [meshXOnImage, meshYOnImage]);
    
    %Find nearest matching feature match
    matchingPairs = zeros(size(features,1),2);
    for j=1:size(features,1)
        currentImageFeature = features(j,:);
        minDist = Inf;
        mini = nan;
        difference = sum((allFeaturesWarpImage - currentImageFeature).^2, 2);
        [minDist,mini] = min(difference);    
        matchingPairs(j,:) = [j ,mini];
    end
   
    error_threshold = sqrt(2)*pixel_threshold; 
    
    matched_points= 0;
    
    for i=1:size(matchingPairs,1)
       p1 = matchingPairs(i,1); p2 = matchingPairs(i,2);
       input = keypoints(p1,:);
       predictedMatch = [meshXOnImage(p2) meshYOnImage(p2)];
       groundTruth = newKeyPoints(p1,:);
       er = norm(groundTruth - predictedMatch);
       if er < error_threshold
           matched_points = matched_points + 1;
       end
    end
end