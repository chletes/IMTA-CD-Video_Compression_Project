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
%Filename
file = "../data/images/news.qcif";
Nframe_max = 10^6;
total_bit = 0;
% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    %On obtient les composants YUV de chaque image dans le video ainsi que
    %le nombre de frame.
    [compY,compU,compV,Nframe]=f_yuv_import("../data/images/news.qcif",[176 144],Nframe_max,0);
    compY_compression_video = cell(1,Nframe);
    compU_compression_video = cell(1,Nframe);
    compV_compression_video = cell(1,Nframe);
    compressed_infoY_video = cell(1,Nframe);
    compressed_infoU_video = cell(1,Nframe);
    compressed_infoV_video = cell(1,Nframe);
    compY_decoded_video = cell(1,Nframe);
    compU_decoded_video = cell(1,Nframe);
    compV_decoded_video = cell(1,Nframe);
    %% Encoder
    for i = 1:Nframe
        size_compY = size (compY{i});
        size_compU = size (compU{i});
        size_compV = size (compV{i});
        % Nous utilisons la compression jpeg pour chaque image dans le
        % video sans relation avec les autres
        [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY{i});
        [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU{i});
        [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV{i});
        % Nous sauvegradons chaque image compressé dans chaque cell
        % correspondant
        compY_compression_video{i} = compY_compression;
        compU_compression_video{i} = compU_compression;
        compV_compression_video{i} = compV_compression;
        compressed_infoY_video{i} = compressed_infoY;
        compressed_infoU_video{i} = compressed_infoU;
        compressed_infoV_video{i} = compressed_infoV;
        % On utilise le fichier Huff06 pour calculer le nombre de bits
        % totale pour coder le video
        total_bit = total_bit + compressed_infoY (1,3)+compressed_infoU (1,3)+compressed_infoV (1,3);

        
    %% Decoder
        % On decode chaque image et sauvegarde dans un cell
        compY_decoded = f_jpeg_decompression(compY_compression, QX, size_compY);
        compU_decoded = f_jpeg_decompression(compU_compression, QX, size_compU);
        compV_decoded = f_jpeg_decompression(compV_compression, QX, size_compV);
        compY_decoded_video{i} = compY_decoded;
        compU_decoded_video{i} = compU_decoded;
        compV_decoded_video{i} = compV_decoded;        

    end
    % On retourne à la domaine RGB
    for i = 1:Nframe
        [compR, compG, compB] = f_yuv_to_rgb(compY_decoded_video{i}, compU_decoded_video{i}', compV_decoded_video{i}');
        rgbImage{i} = cat(3, (compR),(compG),compB);
    end
    
    % Play video
    for i = 1:Nframe
        video(:,:,:,i) = (rgbImage{i});
    end
    implay(video,Nframe/10);
    fclose(fid);
end


