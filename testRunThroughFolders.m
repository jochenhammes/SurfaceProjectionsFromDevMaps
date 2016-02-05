%------------------------------------------------------
% Runs through Folders and creates TIP Output with pseudonyms
%------------------------------------------------------



clear all

parentPath = '/Volumes/MMNI_RAID/RAID_MMNI/TIP_Paper/Patients/';
pathOutputFolder = '/Volumes/MMNI_RAID/RAID_MMNI/TIP_Paper/TIP_Output/';

%List of folders with patientData
parentContents = dir(parentPath);
patientFolders = {parentContents([parentContents(:).isdir]).name};

%Remove '.' and '..' from list of subfolders
patientFolders(ismember(patientFolders, {'.','..'})) = [];

%Run through all real folders in directory

for i = 1:size(patientFolders,2)
    CurrentPathToDevMap = [parentPath patientFolders{i} '/DeviationMapsDecIncTau/'];
    CurrentFilename = dir(strcat(CurrentPathToDevMap,'DevInc*.nii'));
       
    %Find path to DeviationMap-File
    CurrentPathToDevMap = [CurrentPathToDevMap CurrentFilename.name];
    %disp(CurrentPathToDevMap); 
    
    %Create Key for Pseudonymization
    if i < 10
        keystring = ['0' num2str(i)];
    else
        keystring = num2str(i);
    end
    
    %Save Key in Keytable
    Keytable(i).key = keystring;
    Keytable(i).name = patientFolders{i};
    
    %Create TIP-Output and save
    OutputRGB = CreateProjectionsFromDevMap(CurrentPathToDevMap, 10, ['Patient: ' keystring]);
    imwrite(OutputRGB, [pathOutputFolder 'TIP_' keystring '.bmp']);
    
end