function clean3Dpoints = remove3DpointsOutsideImages(points3D,cp1, cp2, imsize)
    keypoints1 = getkeypointsFrom3D(points3D, cp1);
    keypoints2 = getkeypointsFrom3D(points3D, cp2);
    ids1 = cleanKeyPointIds(keypoints1,imsize);
    keypoints2 = keypoints2(ids1,:);
    clean3Dpoints = points3D(ids1,:);
    ids2 = cleanKeyPointIds(keypoints2,imsize);
    clean3Dpoints = clean3Dpoints(ids2,:);
end