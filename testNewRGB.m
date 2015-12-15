ySize=100;
xSize=200;


NewRGB = zeros(ySize,xSize,3);
NewRGB(:,:,3) = 1;

%NewRGB = AddTextToImage(NewRGB,'asdf',[0 0], [1 1 1], 'Arial', 35);


%Prepare colormap/LUT
myMap = jet(256);
newPartMap=zeros(33,3);
newPartMap(:,3) = 0:0.0156:0.5;
myMap=vertcat(newPartMap,myMap);

myMap(1:2,:)=0;
myMap((end-2):end,:)=1;



testPlaneMono = monoProjectionPlaneFromDevMap(InputNii,10,'axial',5,10);
testPlaneRGB = RGBFromMonoPlane(testPlaneMono, myMap);

NewRGB = placeRGBImage(NewRGB, testPlaneRGB, 10,10);

imshow(NewRGB);