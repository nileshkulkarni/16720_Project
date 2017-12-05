function ids = cleanKeyPointIds(keypoints, imsize)
    ids = find(keypoints(:,1) < imsize(2) & keypoints(:,2) < imsize(1));
end