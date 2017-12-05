function data = preprocess_rathus(datadir)

    
    data = cell(0,0);
    for file = dir(char(strcat(datadir,"/*.ppm")))'
        imageFile = strcat(file.folder,'/',file.name);
        cpFile = strcat(imageFile,'.camera');
        threeDFile = strcat(imageFile,".3Dpoints");
        points = read3Dpoints(threeDFile);
        cameraParameters = readCameraParameters(cpFile);
        object = createImageStruct(imageFile, points, cameraParameters);
        data{end+1,1} = object;
    end

    
    function points = read3Dpoints(filename)
        fid = fopen(filename);
        tline = fgetl(fid);
        N = inf;
        L = cell(0,0);
        i = 0;
        while ischar(tline)
            %display(tline)
            i = i+1;
            if i==1
                tline = fgetl(fid);
                continue
            else
                l = sscanf(tline,'%f');
                L{end+1,1} = [l(1:3)'];
            end
            tline = fgetl(fid);
        end
        points = cell2mat(L);
        fclose(fid);
    end

    function cameraParameters = readCameraParameters(cpfile)
        fid = fopen(cpfile);
        N = inf;
        L = cell(0,0);
        K = zeros(3,3);
        R = zeros(3,3);
%         T = zeros(3,1);
        for i = 1:3
            K(i,:) = readFloats(fgetl(fid));
        end
        fgetl(fid);
        for i = 1:3
            R(i,:) = readFloats(fgetl(fid));
        end
        T = readFloats(fgetl(fid));
        cameraParameters = createCameraParameters(K,R,T);
        fclose(fid);
    end

    function l = readFloats(line)
        l = sscanf(line,'%f');
        l = l';
    end
    
    function image = createImageStruct(imageName, points3D, cp)
        image.im = im2double(imread(imageName));
        image.path = imageName;
        image.points3D = points3D;
        image.cp = cp;
    end
    
    function cameraParameters = createCameraParameters(K,R,T)
        cameraParameters.K = K;
        cameraParameters.R = R;
        cameraParameters.T = T;
        
    end


end