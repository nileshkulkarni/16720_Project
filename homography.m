function [warpIm, H, moveImageXY] = homography(im, theta1, tx, ty)
%     R1 = eye(3);
%     R2 = [1 0 0 ; 0 cos(theta1) sin(theta1); 0 -sin(theta1) cos(theta1)];
%     R2 = [1 0 0 ; 0 cos(theta1) sin(theta1); 0 -sin(theta1) cos(theta2)];
%   
%     R = eul2rotm([degtorad(theta1),0, degtorad(theta2)]);
%     H  = [R(:,1:2)  [tx;ty;1]];
    H = [cosd(theta1) -sind(theta1) tx; ...
    sind(theta1) cosd(theta1) ty; ...
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