function matched_points = get_match_points(image, angle, tx, ty, keypoints)
    features = get_surf_descriptors_at(image,keypoints);

    [warpImage,H] = homography(image,angle,tx, ty);
    newKeyPoints = transformWithHomography(keypoints,H);
%     warpImage = image;
%     H = eye(3);
    newKeyPoints = keypoints;
    [meshXOnImage,meshYOnImage] = meshgrid(1:size(warpImage,2), 1:size(warpImage,1));
    meshXOnImage = meshXOnImage(:);
    meshYOnImage = meshYOnImage(:);
    allFeaturesWarpImage = get_surf_descriptors_at(warpImage, [meshXOnImage, meshYOnImage]);
    
    
    %Find nearest matching feature match
    matchingPairs = zeros(size(features,1),2);
    for j=1:size(features,1)
        currentImageFeature = features(j,:);
        minDist = Inf;
        mini = nan;
        for i=1:size(allFeaturesWarpImage,1)
            d = getDistanceBetweenFeatures(currentImageFeature,allFeaturesWarpImage(i,:));
            if d < minDist
                mini = i;
                minDist = d;
            end
        end
        matchingPairs(j,:) = [j ,mini];
    end
   
    function d = getDistanceBetweenFeatures(f1,f2)
       d = norm(f1-f2)^2;
    end
    pixel_threshold  = 8;
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
%        else
%            'didnt match'
       end
    end
end