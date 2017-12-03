function [warpIm, H, moveImageXY] = homography(im, theta, tx, ty)
    H = [cosd(theta) -sind(theta) tx; ...
    sind(theta) cosd(theta) ty; ...
    0 0 1]; 
    tform = projective2d(H);
    corners = [1,1; 1, size(im,1),; size(im,2),1; size(im,2) size(im,1)];
    corners = [corners, ones(size(corners,1),1)];
    newCorners = H*corners';
    outsize = [max(newCorners(2,:)) - min(newCorners(2,:)),...
    max(newCorners(1,:)) - min(newCorners(1,:))]; 

    moveImageXY = [min([0 , newCorners(1,:)]), min([0 , newCorners(2,:)])];  
%     newIm = zeros(outsize);
    insize = size(im);
    M1 = [1 0 -moveImageXY(1); 0  1 -moveImageXY(2); 0 0 1];
    M2 = [insize(2)/outsize(2) 0 1; 0  insize(1)/outsize(1) 0; 0 0 1];
    warpIm = warpH(im, M2*M1*H, ceil(insize), 0);
    H = M2*M1*H;
%      warpIm = warpH(im, H, size(im), 0);
end