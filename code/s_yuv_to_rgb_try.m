%
%
%
% PURPOSE : 
%
% USAGE : (Command Window) :
%
%
%
% 
% EXTERNAL FUNCTIONS USED :
%
%
% 
% REFERENCES/NOTES/COMMENTS :
%
%
% 
%**********************************************************************************************

clc, clear, close all;
addpath('../ressources/video_and_code/');
%Filename
file = "../data/images/news.qcif";

% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    [compY,compU,compV]=yuv_readimage(fid);
    [compR, compG, compB] = f_yuv_to_rgb(compY, compU, compV);
    rgbImage = cat(3, double(compR),double(compG),double(compB))./255;
    figure (1);
    subplot(2,1,1)
    imshow(rgbImage); 
    title('RGB image');
    subplot(2,1,2)
    imagesc(compY); 
    title('Composante Y');
    fclose(fid);
end

