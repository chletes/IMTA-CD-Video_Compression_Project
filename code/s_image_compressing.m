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
addpath('../ressources/TP1_Lossless_Coding/');
tic
%Filename
file = "../data/images/news.qcif";

% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    %% Codage de l'image
    [compY,compU,compV]=yuv_readimage(fid);
    size_compY = size (compY);
    size_compU = size (compU);
    size_compV = size (compV);
    [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY);
    [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU);
    [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV);
    %% Décodage de l'image
    compY_decoded = f_jpeg_decompression(compY_compression, QX, size_compY);
    compU_decoded = f_jpeg_decompression(compU_compression, QX, size_compU);
    compV_decoded = f_jpeg_decompression(compV_compression, QX, size_compV);
    [compR, compG, compB] = f_yuv_to_rgb(compY, compU, compV);
    rgbImage = cat(3, (compR),(compG),(compB));
    
    toc    
    fclose(fid);
    %% Calcul de la distorsion
    mse = sum(sum(((compY_decoded - compY).^2)))/(size(compY,1)*size(compY,2));
    PSNR = 10*log10(  ( (  max(max(compY))  )^2   )/mse);
    
    %% Lecture de l'image décompressé
    figure (1);
    imshow(rgbImage); 
end


