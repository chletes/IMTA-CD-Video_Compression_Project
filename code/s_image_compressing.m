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
    %On aurait pu faire un input() pour que l'utilisateur du 
    %code puisse changer la qualite, mais pour faire nos tests, c'est plus 
    %simple comme ca.
    quality = 10;  %La qualite est fixee avec cette variable la 
    disp(['Q = ',  num2str(quality), '%']);
    [compY,compU,compV]=yuv_readimage(fid);
    size_compY = size (compY);
    size_compU = size (compU);
    size_compV = size (compV);
    [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY, quality);
    [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU, quality);
    [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV, quality);
    %% Decodage de l'image
    compY_decoded = f_jpeg_decompression(compY_compression, QX, size_compY);
    compU_decoded = f_jpeg_decompression(compU_compression, QX, size_compU);
    compV_decoded = f_jpeg_decompression(compV_compression, QX, size_compV);
    [compR, compG, compB] = f_yuv_to_rgb(compY_decoded, compU_decoded, compV_decoded);
    rgbImage = cat(3, (compR),(compG),(compB));
    
    toc    
    fclose(fid);
    %% Calcul de la distorsion
    mse = sum(sum(((compY_decoded - compY).^2)))/(size(compY,1)*size(compY,2));
    PSNR = 10*log10(  ( (  max(max(compY))  )^2   )/mse);
    disp(['PSNR = ',  num2str(PSNR)]);
    %% Calcul du taux de compression
    uncompressed_size = size(compY,1)*size(compY,2) + size(compU,1)*size(compU,2) + size(compV,1)*size(compV,2);
    compressed_size = size(compY_compression,1)+ size(compU_compression,1)+ size(compV_compression,1);
    rate = (uncompressed_size )/(compressed_size);
    disp(['Compression rate : ', num2str(rate)]);
    %% Lecture de l'image decompressee
    figure (1);
    imshow(rgbImage); 
end


