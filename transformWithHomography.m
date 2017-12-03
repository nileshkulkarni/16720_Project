function finalPoints = transformWithHomography(inputPoints, H)
    % initial Point N x 2
    homgenousPoints =  ones(3, size(inputPoints,1));
    homgenousPoints(1,:) = inputPoints(:,1)';
    homgenousPoints(2,:) = inputPoints(:,2)';
    finalPoints = H * homgenousPoints;
    finalPoints = finalPoints(1:2,:)';
end