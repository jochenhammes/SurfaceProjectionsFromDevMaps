function [OutputRGB] = CreateProjectionsFromDevMap(pathToInputNii, MipThickness, TitleText)
%% Environment

%Load  Nii-File
InputNii = load_nii(pathToInputNii);
MNI_T1 = load_nii('MNI_T1_79_95_68.nii');

maxVoxelValue = max(InputNii.img(:));
upperThreshholdSlices = maxVoxelValue/2;
lowerThreshholdSlices = maxVoxelValue/8;

MatrixSize = size(InputNii.img);
EvenMatrixSize = MatrixSize+mod(MatrixSize,2);

DescriptionText = 'Z-transformed deviation of 18F-T807/AV1451-uptake compared to a norm cohort';

cutOffLow = 4;
cutOffHigh = 20;

ySize=690;
xSize=670;

yRow(1) = 130;
yRow(2)  = 300;
yRow(3)  = 490;

xOffsetColorBar = 610;
xOffsetColorBarText = 630;

textColor = [1 1 1];

outputScalingFactor = 2;

NewRGB = zeros(ySize,xSize,3);
%NewRGB(:,:,3) = 1;


%% Prepare colormap/LUT
myMap = jet(256);
newPartMap=zeros(33,3);
newPartMap(:,3) = 0:0.0156:0.5;
myMap=vertcat(newPartMap,myMap);

myMap(1:2,:)=0;
%myMap((end-2):end,:)=1;


%% LateralProjections

ProjectionsMono{1} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'lateral',1,(EvenMatrixSize(1)/2));
ProjectionsMono{2} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'lateral',MatrixSize(1),(EvenMatrixSize(1)/2+1));
ProjectionsMono{3} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'lateral',(EvenMatrixSize(1)/2),1);
ProjectionsMono{4} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'lateral',(EvenMatrixSize(1)/2+1),MatrixSize(1));


%% Axial projections

ProjectionsMono{5} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'axial',1,(EvenMatrixSize(3)/2));
ProjectionsMono{6} = monoProjectionPlaneFromDevMap(InputNii,MipThickness,'axial',MatrixSize(3),(EvenMatrixSize(3)/2+1));


countourString{1} = 'LateralBrainContour.bmp';
countourString{2} = 'LateralBrainContour.bmp';
countourString{3} = 'MesialBrainContour.bmp';
countourString{4} = 'MesialBrainContour.bmp';
countourString{5} = 'BottomViewBrainContour.bmp';
countourString{6} = 'TopViewBrainContour.bmp';

%% Creation and placement of RGB-Surface Projections 

% Surface Projections with low threshhold for colormap. (cutOffLow)
for i=1:6
    ProjectionsRGB{i} = RGBFromMonoPlane(ProjectionsMono{i}, myMap, cutOffLow, countourString{i});
    if mod(i,2) == 0
        NewRGB = placeRGBImage(NewRGB, imrotate(ProjectionsRGB{i}, 90), 10+100*(i-1),yRow(1)); 
    else
        NewRGB = placeRGBImage(NewRGB, fliplr(imrotate(ProjectionsRGB{i}, 90)), 10+100*(i-1),yRow(1)); 
    end
end


% Surface Projections with high threshhold for colormap. (cutOffHigh)
for i=1:6

    ProjectionsRGB{i} = RGBFromMonoPlane(ProjectionsMono{i}, myMap, cutOffHigh, countourString{i});
        if mod(i,2) == 0
        NewRGB = placeRGBImage(NewRGB, imrotate(ProjectionsRGB{i}, 90), 10+100*(i-1),yRow(2)); 
    else
        NewRGB = placeRGBImage(NewRGB, fliplr(imrotate(ProjectionsRGB{i}, 90)), 10+100*(i-1),yRow(2)); 
    end
end

%% Creation and placement of RGB-Slices

for i=1:12
    verticalOffset = 0;
    horizontalOffset = 10+100*(i-1);
    if i>6
        verticalOffset = 100;
        horizontalOffset = 10+100*((i-6)-1);
    end
    CurrentSliceMono = monoProjectionPlaneFromDevMap(InputNii,10,'axial',5*(i-1)+1,5*i);
    CurrentSliceRGB = RGBFromMonoPlane(CurrentSliceMono, myMap, upperThreshholdSlices);

    %Place T1-MRI    
    CurrentSliceMNI_T1 = monoProjectionPlaneFromDevMap(MNI_T1,10,'axial',5*i-1,5*i);
    NewRGB = placeMonoOnRGB(NewRGB, fliplr(imrotate(CurrentSliceMNI_T1, 90)), horizontalOffset,yRow(3)+verticalOffset); 
    
    %Place Z-Map with transparency Map
    transparencyMap = fliplr(imrotate((CurrentSliceMono > lowerThreshholdSlices),90));
    NewRGB = placeRGBImage(NewRGB, fliplr(imrotate(CurrentSliceRGB, 90)), horizontalOffset,yRow(3)+verticalOffset, transparencyMap); 
    

end


%% Color Bars

ColorBar = RGBFromMonoPlane(repmat((256:-2:1)',1,10), myMap);
NewRGB = placeRGBImage(NewRGB, ColorBar, xOffsetColorBar,yRow(1));
NewRGB = placeRGBImage(NewRGB, ColorBar, xOffsetColorBar,yRow(2));
NewRGB = placeRGBImage(NewRGB, ColorBar, xOffsetColorBar,yRow(3));


%% Resize image

NewRGB = imresize(NewRGB,outputScalingFactor);


%% Write text to image


if ~exist ('TitleText', 'var')
    TitleText = 'No filename specified';
else
    TitleText = strrep(TitleText,'wRepacked_','');
    TitleText = strrep(TitleText,'.nii','');
end

%Title Text
NewRGB = AddTextToImage(NewRGB,TitleText, [1 10]*outputScalingFactor, textColor,'Arial', 20*outputScalingFactor);

%Thresholds to colorbars
NewRGB = AddTextToImage(NewRGB,sprintf('%.1f',cutOffLow), [yRow(1) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
NewRGB = AddTextToImage(NewRGB,'0.0', [(yRow(1)+100) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);

NewRGB = AddTextToImage(NewRGB,sprintf('%.1f',cutOffHigh), [yRow(2) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
NewRGB = AddTextToImage(NewRGB,'0.0', [(yRow(2)+100) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);

NewRGB = AddTextToImage(NewRGB,sprintf('%.1f',upperThreshholdSlices), [yRow(3) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
NewRGB = AddTextToImage(NewRGB,sprintf('%.1f',lowerThreshholdSlices), [(yRow(3)+100) xOffsetColorBarText]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);

% image descriptions, i.e. "L lateral", "above"...
descriptionString{1} = 'L lateral';
descriptionString{2} = 'R lateral';
descriptionString{3} = 'L mesial';
descriptionString{4} = 'R mesial';
descriptionString{5} = 'below';
descriptionString{6} = 'above';

for i=1:6
     NewRGB = AddTextToImage(NewRGB,descriptionString{i}, [(yRow(1)-20) (25+100*(i-1))]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
end
for i=1:6
     NewRGB = AddTextToImage(NewRGB,descriptionString{i}, [(yRow(2)-20) (25+100*(i-1))]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
end


% DescriptionText and MIP thickness
NewRGB = AddTextToImage(NewRGB, DescriptionText, [30 10]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
NewRGB = AddTextToImage(NewRGB, ['3DSSPs with MIP Thickness: ' num2str(MipThickness)], [(yRow(1)-50) 10]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);
NewRGB = AddTextToImage(NewRGB, ['Transverse cuts of deviation map. Maximum Z-value: ' sprintf('%.1f', maxVoxelValue)], [(yRow(3)-30) 10]*outputScalingFactor, textColor,'Arial', 16*outputScalingFactor);


%% return result bitmap
OutputRGB = NewRGB;


end