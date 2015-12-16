function [ RGBPlane ] = RGBFromMonoPlane( monoPlane, colorMap, cutOff, contourOverlay)
%Creates RGBImage from MonoImage

if exist('cutOff','var') && ~isempty(cutOff)
    monoPlane(monoPlane>cutOff) = cutOff;
end;

if ~exist('contourOverlay','var')
    contourOverlay = '';
end;


monoPlane = monoPlane / max(monoPlane(:));


monoPlane(1,1)=1;
monoPlane(1,2)=0;
monoPlane(monoPlane==0)=0.02;

RGBPlane = grs2rgb(monoPlane, colorMap);

if ~strcmp(contourOverlay, '')

    imgContour = imread(contourOverlay);

    for i = 1:size(imgContour, 1)
        for j = 1:size(imgContour, 2)
            if imgContour(i,j) > 0
                RGBPlane(i,j,:) = 1;
            end
        end
    end
    
end




end

