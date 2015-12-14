function [OutputRGB, OutputNii, OutputMono] = CreateSurfProjFromNii(pathToInputNii, MipThickness, TitleText)
%% Environment

%Load  Nii-File
InputNii = load_nii(pathToInputNii);

ScalingFactor = max(InputNii.img(:)) * 256;
Img3DInteger  = uint8(InputNii.img / max(InputNii.img(:)) * 256-1);

MatrixSize = size(Img3DInteger);
EvenMatrixSize = MatrixSize+mod(MatrixSize,2);



% LateralProjections

LateralProjection1 = zeros(MatrixSize(2),MatrixSize(3));


for i=1:size(LateralProjection1, 1)
    for j=1:size(LateralProjection1, 2)
        
        
        clear VoxelValue;
        CountNotZero = 0;
        BrainFound = false;
        
        %Run through first half of image
        for SliceSelector = 1:(EvenMatrixSize(1)/2)
            
            if InputNii.img(SliceSelector,i,j) > 0
                BrainFound = true;
            end
            if BrainFound == true
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > (MipThickness)
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(SliceSelector,i,j);
            
            
        end
        LateralProjection1(i,j) = max(VoxelValue);
        
    end
end

LateralProjection2 = zeros(MatrixSize(2),MatrixSize(3));

for i=1:size(LateralProjection2, 1)
    for j=1:size(LateralProjection2, 2)
        
        clear VoxelValue;
        CountNotZero = 0;
        BrainFound = false;
        
        %Run through first half of image
        for SliceSelector = MatrixSize(1):-1:(EvenMatrixSize(1)/2+1)
            
            if InputNii.img(SliceSelector,i,j) > 0
                BrainFound = true;
            end
            if BrainFound == true
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > (MipThickness)
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(SliceSelector,i,j);
            
            
        end
        LateralProjection2(i,j) = max(VoxelValue);
        
        
    end
end

LateralProjection3 = zeros(MatrixSize(2),MatrixSize(3));

for i=1:size(LateralProjection3, 1)
    for j=1:size(LateralProjection3, 2)
        
        
        clear VoxelValue;
        CountNotZero = 0;
        BrainFound = false;
        
        %Run through first half of image
        for SliceSelector = (EvenMatrixSize(1)/2):-1:1
            
            if InputNii.img(SliceSelector,i,j) > 0
                BrainFound = true;
            end
            if BrainFound == true
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > (MipThickness)
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(SliceSelector,i,j);
            
            
        end
        LateralProjection3(i,j) = max(VoxelValue);
        
    end
end


LateralProjection4 = zeros(MatrixSize(2),MatrixSize(3));
for i=1:size(LateralProjection4, 1)
    for j=1:size(LateralProjection4, 2)
        
        
        clear VoxelValue;
        CountNotZero = 0;
        BrainFound = false;
        
        %Run through first half of image
        for SliceSelector = (EvenMatrixSize(1)/2+1):MatrixSize(1)
            
            if InputNii.img(SliceSelector,i,j) > 0
                BrainFound = true;
            end
            if BrainFound == true
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > (MipThickness)
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(SliceSelector,i,j);
            
            
        end
        LateralProjection4(i,j) = max(VoxelValue);
        
    end
end

%% Axial projections


AxialProjection1 = zeros(MatrixSize(1),MatrixSize(2));

for i=1:size(AxialProjection1, 1)
    for j=1:size(AxialProjection1, 2)
        
        
        clear VoxelValue;
        CountNotZero = 0;
        
        %Run through first half of image
        for SliceSelector = 1:(EvenMatrixSize(3)/2)
            
            if InputNii.img(i,j, SliceSelector) > 0
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > MipThickness
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(i,j, SliceSelector);
            
            
        end
        AxialProjection1(i,j) = max(VoxelValue);
        
    end
end

AxialProjection2 = zeros(MatrixSize(1),MatrixSize(2));

for i=1:size(AxialProjection2, 1)
    for j=1:size(AxialProjection2, 2)
        
        
        clear VoxelValue;
        CountNotZero = 0;
        
        %Run through first half of image
        for SliceSelector = MatrixSize(3):-1:(EvenMatrixSize(3)/2+1)
            
            if InputNii.img(i,j, SliceSelector) > 0
                CountNotZero = CountNotZero + 1;
            end
            if CountNotZero > MipThickness
                break
            end
            
            VoxelValue(SliceSelector) = InputNii.img(i,j, SliceSelector);
            
            
        end
        AxialProjection2(i,j) = max(VoxelValue);
        
    end
end

%% Cutoff f�r z-Transformationen setzen.
CutoffRight = 20;
CutoffLeft = 5;


%% Write brain contours to projections

maxVoxelValue = max(InputNii.img(:));

imgContourLat = imread('LateralBrainContour.bmp');
imgContourTop = imread('TopViewBrainContour.bmp');
%imshow(imgContourLat);

LateralProjection1(imgContourLat > 0) = max(CutoffLeft, CutoffRight);
LateralProjection2(imgContourLat > 0) = max(CutoffLeft, CutoffRight);
LateralProjection3(imgContourLat > 0) = max(CutoffLeft, CutoffRight);
LateralProjection4(imgContourLat > 0) = max(CutoffLeft, CutoffRight);
AxialProjection1(imgContourTop > 0) = max(CutoffLeft, CutoffRight);
AxialProjection2(imgContourTop > 0) = max(CutoffLeft, CutoffRight);

%% Compose Output Image

HorizontalSpacer = zeros(size(AxialProjection1, 2)-size(LateralProjection1, 2), size(LateralProjection1, 1));
VerticalSpacer = zeros(2*size(AxialProjection1,2),5);

Column1 = vertcat(imrotate(LateralProjection1,90), HorizontalSpacer, imrotate(LateralProjection3,90), HorizontalSpacer);
Column2 = fliplr(vertcat(imrotate(LateralProjection2,90), HorizontalSpacer, imrotate(LateralProjection4,90), HorizontalSpacer));
Column3 = vertcat(imrotate(AxialProjection2, 90), imrotate(AxialProjection1, 90));

DisplayProjections = horzcat(VerticalSpacer, Column1, VerticalSpacer, Column2, VerticalSpacer, Column3, VerticalSpacer);

%Insert blank space above colums

HorizontalSpacerTop = zeros(50, size(DisplayProjections,2));
HorizontalSpacerBottom = zeros(30, size(DisplayProjections,2));
DisplayProjections = vertcat(HorizontalSpacerTop, DisplayProjections, HorizontalSpacerBottom);


%Create Nii_Ouput without text on image
OutputNii= make_nii(single(flipud(imrotate(DisplayProjections, 270))));


DisplayProjections2 = DisplayProjections
DisplayProjections(DisplayProjections > CutoffRight) = CutoffRight;
DisplayProjections2(DisplayProjections2 > CutoffLeft) = CutoffLeft;
DisplayProjections2 = DisplayProjections2 / CutoffLeft * CutoffRight;


DisplayProjections = horzcat(DisplayProjections2,DisplayProjections);

colormap(gray);
disp(num2str(max(DisplayProjections(:))));


%% Write text to image

%rescale image
DisplayProjections = imresize(DisplayProjections,2);

verticalOffset = round(size(DisplayProjections, 1)/9);
horizontalOffsetLeftImage = round(size(DisplayProjections, 2)/6/2);


%textColor = [ceil(maxVoxelValue) ceil(maxVoxelValue) ceil(maxVoxelValue)];
%textColor = [max(CutoffLeft, CutoffRight) max(CutoffLeft, CutoffRight) max(CutoffLeft, CutoffRight)];
textColor = max(DisplayProjections(:));

if ~exist ('TitleText', 'var')
    TitleText = 'No filename specified';
else
    TitleText = strrep(TitleText,'wRepacked_','');
    TitleText = strrep(TitleText,'.nii','');
end

DisplayProjections = AddTextToImage(DisplayProjections,TitleText, [1 1], textColor,'Arial', 20);

xPositionMIP = size(DisplayProjections, 2) - 80;
DisplayProjections = AddTextToImage(DisplayProjections, ['MIP: ' num2str(MipThickness)], [1 xPositionMIP], textColor,'Arial', 20);

%L and R for left image
DisplayProjections = AddTextToImage(DisplayProjections,'L', [verticalOffset horizontalOffsetLeftImage], textColor,'Arial', 30);
DisplayProjections = AddTextToImage(DisplayProjections,'R', [verticalOffset 3*horizontalOffsetLeftImage], textColor,'Arial', 30);
DisplayProjections = AddTextToImage(DisplayProjections,'L   R', [verticalOffset ceil(4.75*horizontalOffsetLeftImage)], textColor,'Arial', 30);

%L and R for right image
DisplayProjections = AddTextToImage(DisplayProjections,'L', [verticalOffset horizontalOffsetLeftImage+2*size(DisplayProjections2, 2)], textColor,'Arial', 30);
DisplayProjections = AddTextToImage(DisplayProjections,'R', [verticalOffset 3*horizontalOffsetLeftImage+2*size(DisplayProjections2, 2)], textColor,'Arial', 30);
DisplayProjections = AddTextToImage(DisplayProjections,'L   R', [verticalOffset ceil(4.75*horizontalOffsetLeftImage)+2*size(DisplayProjections2, 2)], textColor,'Arial', 30);



%Draw Colorbars to image
ColorBar = 1:256;
ColorBar = ColorBar/256*max(DisplayProjections(:));

ColRangeColorBar = (ceil(size(DisplayProjections,2)/4)-128):(ceil(size(DisplayProjections,2)/4)+127);
ColRangeColorBar2 = (ceil(size(DisplayProjections,2)*3/4)-128):(ceil(size(DisplayProjections,2)*3/4)+127);
RowRangeColorBar = (size(DisplayProjections,1)-30):(size(DisplayProjections,1)-21);
DisplayProjections(RowRangeColorBar,ColRangeColorBar)=repmat(ColorBar,10,1);
DisplayProjections(RowRangeColorBar,ColRangeColorBar2)=repmat(ColorBar,10,1);

%Draw numbers 
DisplayProjections = AddTextToImage(DisplayProjections,'0.0', [RowRangeColorBar(1)-10, ColRangeColorBar(1)-35], textColor,'Arial', 20);
DisplayProjections = AddTextToImage(DisplayProjections,sprintf('%.1f',CutoffLeft), [RowRangeColorBar(1)-10, ColRangeColorBar(end)+10], textColor,'Arial', 20);

DisplayProjections = AddTextToImage(DisplayProjections,'0.0', [RowRangeColorBar(1)-10, ColRangeColorBar2(1)-35], textColor,'Arial', 20);
DisplayProjections = AddTextToImage(DisplayProjections,sprintf('%.1f',CutoffRight), [RowRangeColorBar(1)-10, ColRangeColorBar2(end)+10], textColor,'Arial', 20);



%% Save and display output
DisplayProjectionsUInt = uint8(DisplayProjections / max(DisplayProjections(:)) * 256);

%Prepare colormap/LUT
myMap = jet(256);
newPartMap=zeros(33,3);
newPartMap(:,3) = 0:0.0156:0.5;
myMap=vertcat(newPartMap,myMap);

myMap(1:2,:)=0;
myMap((end-2):end,:)=1;

%convert monochrome bitmap into rgb using the colormap specified above
DisplayProjectionsRGB = grs2rgb(DisplayProjectionsUInt, myMap);

%Create outputs Mono-Bitmap, RGB-Bitmap, 
%Nifti was already created above
%OutputNii= make_nii(single(flipud(imrotate(DisplayProjections, 270))));
OutputMono = DisplayProjectionsUInt;
OutputRGB = DisplayProjectionsRGB;



end