function [features] = getCNNFeatures(net, img)

    act = activations(net,img,'conv5','OutputAs','channels');
    features = imresize(act, [227, 227]);
    features = reshape(features, [227*227, 256]);
    
end