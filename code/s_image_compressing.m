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

%Filename
file = "../data/images/news.qcif";

% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    [compY,compU,compV]=yuv_readimage(fid);
    compY_compression = f_jpeg_compression1(compY);
    compU_compression = f_jpeg_compression1(compU);
    compV_compression = f_jpeg_compression1(compV);
    fclose(fid);
end


