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
    % encoding starts
    disp('Starting with the JPEG encoding of the image');
    [compY,compU,compV]=yuv_readimage(fid); 
    [compY_compression, compY_info] = f_jpeg_compression(compY);
    disp(['--> Entropy of the Y component is ', num2str(compY_info(1,2)),'.'])
    [compU_compression, compU_info] = f_jpeg_compression(compU);
    disp(['--> Entropy of the U component is ', num2str(compU_info(1,2)),'.'])
    [compV_compression, compV_info] = f_jpeg_compression(compV);
    disp(['--> Entropy of the V component is ', num2str(compV_info(1,2)),'.'])
    disp('JPEG encoding of the image done.');
    % decoding starts
    
    fclose(fid);
end


