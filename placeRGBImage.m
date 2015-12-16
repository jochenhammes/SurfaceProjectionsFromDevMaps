function outputImage = placeRGBImage(baseImage, imageToPlace,x,y)
%   places an RGB image onto another RGB-image

xSize = size(imageToPlace,2);
ySize = size(imageToPlace,1);

outputImage = baseImage;

outputImage((1+y):(y+ySize),(1+x):(x+xSize),:) = imageToPlace(:,:,:);
end
