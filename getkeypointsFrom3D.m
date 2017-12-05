function keypoints = getkeypointsFrom3D(points3D,cp)
    K = cp.K;
    R = cp.R;
    T = cp.T;
    CM = K*[R' -R'*T'];
    points3D = [points3D, ones(size(points3D,1),1)];
    keypoints = CM*points3D';
    keypoints = keypoints./keypoints(3,:);
    keypoints = keypoints';
    keypoints = keypoints(:,[1,2]);
end