% data = preprocess_rathus('rathaus'); save('rathaus.mat','data');
% data = preprocess_rathus('semper'); save('brussel.mat','data');
% data = preprocess_rathus('brussel'); save('brussel.mat','data');

load('rathaus.mat')
% load('brussel.mat')
% load('semper.mat')

% rathaus
%Nice pairs : {1,2}, {1,3}, {1,4}, {2,4}, {3,4}, {2,3}, {2,4}, {3,4}
% Bad pairs :, {4,5}, {1,5}, {5,6} , {7,6}

for i = 1:length(data)
    for j = 1:length(data)
        
        object1 = data{i,1};
        object2 = data{j,1};

        R1 = object1.cp.R;
        R2 = object2.cp.R;
        R_rel = R2 * R1';

    %     [x1,y1,z1] = decompose_rotation(R1);
    %     x1 = rad2deg(x1);
    %     y1 = rad2deg(y1);
    %     z1 = rad2deg(z1);
    %     fprintf("R1 angles : [%f,%f,%f]\n",x1,y1,z1);
    % 
    %     [x2,y2,z2] = decompose_rotation(R2);
    %     x2 = rad2deg(x2);
    %     y2 = rad2deg(y2);
    %     z2 = rad2deg(z2);
    %     fprintf("R2 angles : [%f,%f,%f]\n",x2,y2,z2);

        [x_rel,y_rel,z_rel] = decompose_rotation(R_rel);
        x_rel = rad2deg(x_rel);
        y_rel = rad2deg(y_rel);
        z_rel = rad2deg(z_rel);
        fprintf("(%d,%d) R_rel angles : [%f,%f,%f]\n",i,j,x_rel,y_rel,z_rel);
        fprintf("Rodrigues angle : %f\n\n\n",norm(rad2deg(rotationMatrixToVector(R_rel))));
        
    end
end

function [x,y,z] = decompose_rotation(R)
	x = atan2(R(3,2), R(3,3));
	y = atan2(-R(3,1), sqrt(R(3,2)*R(3,2) + R(3,3)*R(3,3)));
	z = atan2(R(2,1), R(1,1));
end
