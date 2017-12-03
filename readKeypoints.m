function [keypoints, image] = readKeypoints(xmlFile)
    DOMnode = xmlread(xmlFile);
    image  = DOMnode.getElementsByTagName('image').item(0).getTextContent();
    keypointNodes = DOMnode.getElementsByTagName('keypoint');
    keypoints = zeros(keypointNodes.getLength(),2);
    for i=0:keypointNodes.getLength()-1
        keypointNode = keypointNodes.item(i);
        keypoints(i+1,1) = str2double(keypointNode.getAttribute('x'));
        keypoints(i+1,2) = str2double(keypointNode.getAttribute('y')); 
    end
end