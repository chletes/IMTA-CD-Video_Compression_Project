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
gap = 7;
total_bit = 0;
% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    %% Encoder
    %On obtient les composants YUV de chaque image dans le video ainsi que
    %le nombre de frame.
    [compY,compU,compV,Nframe]=f_yuv_import(file,[176 144],Nframe_max,0);
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
    
    %predicted coding: ici, on utilise le codage preditif par calculer le
    %difference entre 2 images qui sont à côté pour avoir plus difference
    %posible (donc diminuer le nombre de bit codé)
    compY_predict_video = compY;
    compU_predict_video = compU;
    compV_predict_video = compV;
    
    %On maintient un frame intra (codé completement, sans prendre la difference) dans 
    %chaque "gap"(un nombre) frame. Par example: si %gap = 7; les frames intras sont 
    %apparus dans le position 1,8,15,22,...
    %Le but est de diminuer les errors en raison de quantifier quand on
    %decode. 
    for j = 1:ceil(Nframe/gap)-1
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
        %Nous utilisons la compression jpeg pour les frame intras et les differences
        [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY_predict_video{i});
        [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU_predict_video{i});
        [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV_predict_video{i});
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
        
        % On decode les frames intras et les differences et sauvegarde dans un cell
        compY_decoded = f_jpeg_decompression(compY_compression, QX, size_compY);
        compU_decoded = f_jpeg_decompression(compU_compression, QX, size_compU);
        compV_decoded = f_jpeg_decompression(compV_compression, QX, size_compV);
        compY_decoded_video{i} = compY_decoded;
        compU_decoded_video{i} = compU_decoded;
        compV_decoded_video{i} = compV_decoded;        


    end
    
    %On decode le codage preditif.
     for j = 1:ceil(Nframe/gap)-1
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


