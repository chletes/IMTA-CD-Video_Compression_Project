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
Nframe = 100;
gap = 8;
total_bit = 0;
% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    [compY,compU,compV]=f_yuv_import(file,[176 144],Nframe,0);
    compY_predict_video = cell(1,Nframe);
    compU_predict_video = cell(1,Nframe);
    compV_predict_video = cell(1,Nframe);    
    compY_compression_video = cell(1,Nframe);
    compU_compression_video = cell(1,Nframe);
    compV_compression_video = cell(1,Nframe);
    compressed_infoY_video = cell(1,Nframe);
    compressed_infoU_video = cell(1,Nframe);
    compressed_infoV_video = cell(1,Nframe);
    compY_decoded_video = cell(1,Nframe);
    compU_decoded_video = cell(1,Nframe);
    compV_decoded_video = cell(1,Nframe);
    %predicted coding
    compY_predict_video = compY;
    compU_predict_video = compU;
    compV_predict_video = compV;
    for j = 1:Nframe/gap-1
        for i = 2+gap*(j-1):gap*j

            compY_predict_video{i} = compY{i} - compY{i-1};
            compU_predict_video{i} = compU{i} - compU{i-1};
            compV_predict_video{i} = compV{i} - compV{i-1};
        end
    end
    for i = 2+gap*j:Nframe       
            compY_predict_video{i} = compY{i} - compY{i-1};
            compU_predict_video{i} = compU{i} - compU{i-1};
            compV_predict_video{i} = compV{i} - compV{i-1};
    end

    for i = 1:Nframe
        size_compY = size (compY{i});
        size_compU = size (compU{i});
        size_compV = size (compV{i});
        [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY_predict_video{i});
        [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU_predict_video{i});
        [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV_predict_video{i});
        compY_compression_video{i} = compY_compression;
        compU_compression_video{i} = compU_compression;
        compV_compression_video{i} = compV_compression;
        compressed_infoY_video{i} = compressed_infoY;
        compressed_infoU_video{i} = compressed_infoU;
        compressed_infoV_video{i} = compressed_infoV;
        total_bit = total_bit + compressed_infoY (1,3)+compressed_infoU (1,3)+compressed_infoV (1,3);
        
    %% decoder
        
        %compY_huff = Huff06(compY_compression);
        %compU_huff = Huff06(compU_compression);
        %compV_huff = Huff06(compV_compression);
        %[compY_decoded] = f_ac_dc_separated(compY_huff,QX,size_compY);
        %[compU_decoded] = f_ac_dc_separated(compU_huff,QX,size_compU);
        %[compV_decoded] = f_ac_dc_separated(compV_huff,QX,size_compV);
        compY_decoded = f_jpeg_decompression(compY_compression, QX, size_compY);
        compU_decoded = f_jpeg_decompression(compU_compression, QX, size_compU);
        compV_decoded = f_jpeg_decompression(compV_compression, QX, size_compV);
        compY_decoded_video{i} = compY_decoded;
        compU_decoded_video{i} = compU_decoded;
        compV_decoded_video{i} = compV_decoded;        
  %      [compR, compG, compB] = f_yuv_to_rgb(compY{i}, compU{i}, compV{i});

    %    [compR_decoded, compG_decoded, compB_decoded] = f_yuv_to_rgb(compY_decoded, compU_decoded, compV_decoded);
    %     rgbImage = cat(3, compR,compG,compB);
    %     rgbImage_decoded = cat(3, compR_decoded,compG_decoded,compB_decoded);
    %     gray_pixel = 0.27*compR + 0.67*compG + 0.06*compB;
    % Im=zeros(size(compR_decoded,1),size(compR_decoded,2),3);
    % Im(:,:,1)=compR_decoded;
    % Im(:,:,2)=compG_decoded;
    % Im(:,:,3)=compB_decoded;
    %     imshow(rgbImage);
%           figure (2);
%           subplot(2,1,1)
%           imagesc(compY{1}'); 
%          subplot(2,1,2)
%           imagesc(compY_decoded'); 
    end
    for j = 1:Nframe/gap-1
        for i = 2+gap*(j-1):gap*j
            compY_decoded_video{i} = compY_decoded_video{i} + compY_decoded_video{i-1};
            compU_decoded_video{i} = compU_decoded_video{i} + compU_decoded_video{i-1};
            compV_decoded_video{i} = compV_decoded_video{i} + compV_decoded_video{i-1};
        end
    end
    for i = 2+gap*j:Nframe       
            compY_decoded_video{i} = compY_decoded_video{i} + compY_decoded_video{i-1};
            compU_decoded_video{i} = compU_decoded_video{i} + compU_decoded_video{i-1};
            compV_decoded_video{i} = compV_decoded_video{i} + compV_decoded_video{i-1};
    end
    for i = 1:Nframe
        [compR, compG, compB] = f_yuv_to_rgb(compY_decoded_video{i}, compU_decoded_video{i}', compV_decoded_video{i}');
        rgbImage{i} = cat(3, (compR),(compG),compB);
    end

%           figure (2);
%           subplot(2,1,1)
%           imagesc(compY{3}); 
%          subplot(2,1,2)
%           imagesc(compY_decoded_video{3});
% Play video
    for i = 1:Nframe
        imshow(rgbImage{i});
    end
    fclose(fid);
end


