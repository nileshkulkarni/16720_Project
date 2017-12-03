function  im2annotation = image2annotations(imagesDir, annontationDir)
    im2annotation = containers.Map;
    
    function image = createImageStruct(imageName)
%         image.im = im2double(imread(imageName));
        image.path = imageName;
        image.annotations = cell(0,0);
        image.annotationPaths = cell(0,0);
    end
    
    for file = dir(imagesDir)'
       if file.isdir == 0
           image = createImageStruct(strcat(file.folder, '/', file.name));
           key = strrep(file.name,'.jpg','');
           im2annotation(key) = image;
       end
    end

    files = dir(annontationDir);
    
    for folder = files'
        if folder.isdir == 1 && ~(strcmp(folder.name,'.') ||  strcmp(folder.name,'..'))
            folderdir = dir(strcat(folder.folder,'/',folder.name));
            for file = folderdir'
                if ~(strcmp(file.name,'.') ||  strcmp(file.name,'..'))
                    xmlfile = strcat(file.folder,'/',file.name);
                    [keypoints, imageName] = readKeypoints(xmlfile);
                    imageObject = im2annotation(char(imageName));
                    imageObject.annotations{end+1,1} = keypoints;
                    imageObject.annotationPaths{end+1,1} = xmlfile;
                    im2annotation(char(imageName)) = imageObject;
                end
            end
        end
    end 
end