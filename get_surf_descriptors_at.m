function [features] = get_surf_descriptors_at(image, keypoints)
    [features,~] = extractFeatures(image,keypoints,'method','SURF','FeatureSize',128);
end