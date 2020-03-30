clc, clear, close all;
addpath('../ressources/video_and_code/');
addpath('../ressources/TP1_Lossless_Coding/');
tic
%Filename
file = "../data/images/news.qcif";
Nframe_max = 300;
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
    quality = 50;  %La qualite est fixee avec cette variable la 
    disp(['Q = ',  num2str(quality), '%']);
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
    disp(['Nombre de frames : ', num2str(Nframe)]);
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
        %Nous utilisons la compression jpeg pour les frame intras et les differences
        [compY_compression_video{i},compressed_infoY_video{i},QX] = f_jpeg_compression(compY_predict_video{i}, quality);
        [compU_compression_video{i},compressed_infoU_video{i},QX] = f_jpeg_compression(compU_predict_video{i}, quality);
        [compV_compression_video{i},compressed_infoV_video{i},QX] = f_jpeg_compression(compV_predict_video{i}, quality);
        % On utilise le fichier Huff06 pour calculer le nombre de bits
        % totale pour coder le video
        total_bit = total_bit + compressed_infoY_video{i}(1,3) + compressed_infoU_video{i}(1,3) + compressed_infoV_video{i}(1,3);
        
        %% Decoder
        % On decode les frames intras et les differences et sauvegarde dans un cell
        compY_decoded = f_jpeg_decompression(compY_compression_video{i}, QX, size(compY{i}));
        compU_decoded = f_jpeg_decompression(compU_compression_video{i}, QX, size(compU{i}));
        compV_decoded = f_jpeg_decompression(compV_compression_video{i}, QX, size(compV{i}));
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
    toc
    fclose(fid);
    %% Calcul de la distorsion
    PSNR_video = cell(1,Nframe);
    for i = 1:Nframe
        mse = sum(sum(((compY_decoded_video{i} - compY{i}).^2)))/(size(compY{i},1)*size(compY{i},2));
        PSNR = 10*log10(  ( (  max(max(compY{i}))  )^2   )/mse);
        %disp(['PSNR = ',  num2str(PSNR)]);
        PSNR_video{i} = PSNR;
    end
    average_PSNR = 0;
    for i = 1:Nframe
        average_PSNR = average_PSNR + PSNR_video{i};
    end
    average_PSNR = average_PSNR/length(PSNR_video);
    disp(['Average PSNR of the video = ', num2str(PSNR)]);
    
    %% Calcul du taux de compression
    uncompressed_size_video = 0;
    compressed_size_video = 0;
    for i = 1:Nframe
        uncompressed_size_video = uncompressed_size_video + size(compY{i},1)*size(compY{i},2) + size(compU{i},1)*size(compU{i},2) + size(compV{i},1)*size(compV{i},2);
        compressed_size_video = compressed_size_video + size(compY_compression_video{i},1)+ size(compU_compression_video{i},1)+ size(compV_compression_video{i},1);    
    end
    rate = (uncompressed_size_video )/(compressed_size_video);
    disp(['Compression rate of the video = ', num2str(rate)]);
    
    % Play video
    for i = 1:Nframe
        video(:,:,:,i) = (rgbImage{i});
    end
    implay(video,Nframe/10);
    
end


