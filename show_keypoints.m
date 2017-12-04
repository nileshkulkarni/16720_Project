function show_keypoints(keypoints, col)
    hold on;
    plot(keypoints(:,1), keypoints(:,2),col, 'MarkerSize',20);
end