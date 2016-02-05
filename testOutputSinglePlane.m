InputNii = load_nii('/Volumes/MMNI_RAID/RAID_MMNI/TestOutput/TheissenTest18-Nov-2015/DeviationMapsDecIncTau/DevInc_wRepacked_TheissenTest1.nii')

MatrixSize = size(InputNii.img);
EvenMatrixSize = MatrixSize+mod(MatrixSize,2);


%Prepare colormap/LUT
myMap = jet(256);
newPartMap=zeros(33,3);
newPartMap(:,3) = 0:0.0156:0.5;
myMap=vertcat(newPartMap,myMap);

myMap(1:2,:)=0;
myMap((end-1):end,:)=1;



for i= 1:13
    testPlaneMono = monoProjectionPlaneFromDevMap(InputNii,10,'axial',5*(i-1)+1,5*i);
    imshow(RGBFromMonoPlane(testPlaneMono, myMap));
    pause(0.4)
end

