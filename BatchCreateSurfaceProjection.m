%% Environment
clear all;

pathImagesToProcessFolder = '/Volumes/MMNI_RAID/RAID_MMNI/BatchScriptsMatlab/AutomatedProcessingStream/Images/NormalizedTest/DeviationMapsDecIncTau_new/';
pathOutputFolder = [pathImagesToProcessFolder 'SP/'];

%Create Output Directory
mkdir(pathOutputFolder);

%Find all Files with .nii-Ending in Input Folder
subj=dir(strcat(pathImagesToProcessFolder,'DevInc*.nii'));
numberOfFiles=length(subj);

%% Run through all files in the input folder

for FileNumber = 1:numberOfFiles
    
    %% Call function to create surface projections
    
    OutputRGB = CreateSurfProjFromNii([pathImagesToProcessFolder subj(FileNumber).name], 10, subj(FileNumber).name);
    
    
    %% Save output
        
    
    %Write Bitmaps
    imwrite(OutputRGB, [pathOutputFolder 'SP_RGB'  subj(FileNumber).name '.bmp']);
    %imwrite(OutputMono, [pathOutputFolder 'SP_Mono'  subj(FileNumber).name '.bmp']);
    
    %write Nifti
    %save_nii(OutputNii, [pathOutputFolder 'SP_' subj(FileNumber).name] );
    
%     %ShowImage
%     image(DisplayProjectionsRGB);
    
end