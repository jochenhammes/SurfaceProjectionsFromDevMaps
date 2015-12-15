function [ RGBPlane ] = RGBFromMonoPlane( monoPlane, colorMap )
%Creates RGBImage from MonoImage
    monoPlane = monoPlane / max(monoPlane(:));
    monoPlane(1,1)=1;
    monoPlane(1,2)=0;
    monoPlane(monoPlane==0)=0.02
    
    RGBPlane = grs2rgb(monoPlane, colorMap);
end

