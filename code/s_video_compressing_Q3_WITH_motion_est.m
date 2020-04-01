clc, clear, close all;
addpath('../ressources/video_and_code/');
addpath('../ressources/TP1_Lossless_Coding/');
addpath('../ressources/BlockMatchingAlgoMPEG/');
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
    quality = 50;  %La qualite est fixee avec cette variable la 
    disp(['Q = ',  num2str(quality), '%']);
    %On obtient les composants YUV de chaque image dans le video ainsi que
    %le nombre de frame.
    [compY,compU,compV,Nframe]=f_yuv_import(file,[176 144],Nframe_max,0);
    motionVectY_video = cell(1,Nframe);
    motionVectU_video = cell(1,Nframe);
    motionVectV_video = cell(1,Nframe);
    disp(['Nombre de frames : ', num2str(Nframe)]);
    % On calcule les motions vectors de chaque frame par utiliser
    % "Exhautive search". Ici, le "target frame" est le frame i et le frame
    % réference est le frame i-1. Le resultat est sauvegardé dans le cell  
    % motionVect..._video, à la position i. Par example: on calcule le
    % motion vector de frame 1 (reference) à frame 2 (target). Donc Le resultat est 
    % sauvegardé à la position 2 dans le cell. 
    % Pout les frames intras, ils n'ont pas besoin de devenir des "target" frames, donc aux positions 
    % des frames intras,il n'y a aucun information.
    for j = 1:ceil(Nframe/gap)-1
        for i = 2+gap*(j-1):gap*j
            [motionVectY_video{i}, EScomputationsY] = motionEstES(compY{i}, compY{i-1}, 8, 7);
            [motionVectU_video{i}, EScomputationsU] = motionEstES(compU{i}, compU{i-1}, 8, 7);
            [motionVectV_video{i}, EScomputationsV] = motionEstES(compV{i}, compV{i-1}, 8, 7); 
        end
    end
    for i = 2+gap*j:Nframe       
        [motionVectY_video{i}, EScomputationsY] = motionEstES(compY{i}, compY{i-1}, 8, 7);
        [motionVectU_video{i}, EScomputationsU] = motionEstES(compU{i}, compU{i-1}, 8, 7);
        [motionVectV_video{i}, EScomputationsV] = motionEstES(compV{i}, compV{i-1}, 8, 7);
    end
        
    compY_predict_video = compY;
    compU_predict_video = compU;
    compV_predict_video = compV; 
    
    % On fait le motion compensation pour les frames non-intras et fait les
    % soustrations avec leur frames originaux. On sauvegarde ces
    % informations.
    for j = 1:ceil(Nframe/gap)-1
        for i = 2+gap*(j-1):gap*j
            compY_predict_video{i} = compY{i} - motionComp(compY{i-1}, motionVectY_video{i}, 8); 
            compU_predict_video{i} = compU{i} - motionComp(compU{i-1}, motionVectU_video{i}, 8);
            compV_predict_video{i} = compV{i} - motionComp(compV{i-1}, motionVectV_video{i}, 8);
        end
    end
    for i = 2+gap*j:Nframe 
        compY_predict_video{i} = compY{i} - motionComp(compY{i-1}, motionVectY_video{i}, 8);
        compU_predict_video{i} = compU{i} - motionComp(compU{i-1}, motionVectU_video{i}, 8);
        compV_predict_video{i} = compV{i} - motionComp(compV{i-1}, motionVectV_video{i}, 8);
    end
    
   % On encode les frames intras et les differences.
   compY_compression_video = cell(1,Nframe);
   compU_compression_video = cell(1,Nframe);
   compV_compression_video = cell(1,Nframe);
   compressed_infoY_video = cell(1,Nframe);
   compressed_infoU_video = cell(1,Nframe);
   compressed_infoV_video = cell(1,Nframe);
    for i = 1:Nframe
        [compY_compression_video{i},compressed_infoY_video{i},QX] = f_jpeg_compression(compY_predict_video{i}, quality);
        [compU_compression_video{i},compressed_infoU_video{i},QX] = f_jpeg_compression(compU_predict_video{i}, quality);
        [compV_compression_video{i},compressed_infoV_video{i},QX] = f_jpeg_compression(compV_predict_video{i}, quality);
        total_bit = total_bit + compressed_infoY_video{i}(1,3) + compressed_infoU_video{i}(1,3) + compressed_infoV_video{i}(1,3);
    end  

    motionY_huffman = cell(1,1);
    motionU_huffman = cell(1,1);
    motionV_huffman = cell(1,1);
    for j = 1:ceil(Nframe/gap)-1
        for i = 2+gap*(j-1):gap*j
            motionY_huffman{1} = reshape ( motionVectY_video{i},[1,length(motionVectY_video{i}(1,:))*2]);
            motionU_huffman{1} = reshape ( motionVectU_video{i},[1,length(motionVectU_video{i}(1,:))*2]);
            motionV_huffman{1} = reshape ( motionVectV_video{i},[1,length(motionVectV_video{i}(1,:))*2]);
           [motionY_compression_video{i},motionY_info] = Huff06(motionY_huffman,1,0);
           [motionU_compression_video{i},motionU_info] = Huff06(motionU_huffman,1,0);
           [motionV_compression_video{i},motionV_info] = Huff06(motionV_huffman,1,0);
           % On utilise le fichier Huff06 pour calculer le nombre de bits
           % totale pour coder le video
           total_bit = total_bit + motionY_info(1,3) + motionU_info(1,3) + motionV_info(1,3);
        end
    end
    % On doit aussi coder les motions vectors pour le processus decoder
    for i = 2+gap*j:Nframe 
            motionY_huffman{1} = reshape ( motionVectY_video{i},[1,length(motionVectY_video{i}(1,:))*2]);
            motionU_huffman{1} = reshape ( motionVectU_video{i},[1,length(motionVectU_video{i}(1,:))*2]);
            motionV_huffman{1} = reshape ( motionVectV_video{i},[1,length(motionVectV_video{i}(1,:))*2]);
           [motionY_compression_video{i},motionY_info] = Huff06(motionY_huffman,1,0);
           [motionU_compression_video{i},motionU_info] = Huff06(motionU_huffman,1,0);
           [motionV_compression_video{i},motionV_info] = Huff06(motionV_huffman,1,0);
           total_bit = total_bit + motionY_info(1,3) + motionU_info(1,3) + motionV_info(1,3);
    end
    
    %% Decoder
    % On decode les frames intras, les differences et motion vectors et sauvegarde dans un cell
    for j = 1:ceil(Nframe/gap)-1
        for i = 2+gap*(j-1):gap*j
            motionY_reconstructed = Huff06(motionY_compression_video{i});
            motionU_reconstructed = Huff06(motionU_compression_video{i});
            motionV_reconstructed = Huff06(motionV_compression_video{i});
            motionY_reconstructed_video{i} = reshape(motionY_reconstructed{1},[2,length(motionVectY_video{i}(1,:))]);
            motionU_reconstructed_video{i} = reshape(motionU_reconstructed{1},[2,length(motionVectU_video{i}(1,:))]);
            motionV_reconstructed_video{i} = reshape(motionV_reconstructed{1},[2,length(motionVectV_video{i}(1,:))]);
        end
    end
    for i = 2+gap*j:Nframe 
        motionY_reconstructed = Huff06(motionY_compression_video{i});
        motionU_reconstructed = Huff06(motionU_compression_video{i});
        motionV_reconstructed = Huff06(motionV_compression_video{i});
        motionY_reconstructed_video{i} = reshape(motionY_reconstructed{1},[2,length(motionVectY_video{i}(1,:))]);
        motionU_reconstructed_video{i} = reshape(motionU_reconstructed{1},[2,length(motionVectU_video{i}(1,:))]);
        motionV_reconstructed_video{i} = reshape(motionV_reconstructed{1},[2,length(motionVectV_video{i}(1,:))]);
    end

    for i = 1:Nframe

        compY_decoded_video{i} = f_jpeg_decompression(compY_compression_video{i}, QX, size(compY{i}));
        compU_decoded_video{i} = f_jpeg_decompression(compU_compression_video{i}, QX, size(compU{i}));
        compV_decoded_video{i} = f_jpeg_decompression(compV_compression_video{i}, QX, size(compV{i}));
    end
    %On utilise la motion compensation pour decoder les images non-intras
    for j = 1:ceil(Nframe/gap)-1
        for i = 2+gap*(j-1):gap*j
            imgCompY_decoded = motionComp(compY_decoded_video{i-1}, motionY_reconstructed_video{i}, 8);
            compY_decoded_video{i} = compY_decoded_video{i} + imgCompY_decoded;
            imgCompU_decoded = motionComp(compU_decoded_video{i-1}, motionU_reconstructed_video{i}, 8);
            compU_decoded_video{i} = compU_decoded_video{i} + imgCompU_decoded;
            imgCompV_decoded = motionComp(compV_decoded_video{i-1}, motionV_reconstructed_video{i}, 8);
            compV_decoded_video{i} = compV_decoded_video{i} + imgCompV_decoded;            
        end
    end
    for i = 2+gap*j:Nframe 
            imgCompY_decoded = motionComp(compY_decoded_video{i-1}, motionY_reconstructed_video{i}, 8);
            compY_decoded_video{i} = compY_decoded_video{i} + imgCompY_decoded;
            imgCompU_decoded = motionComp(compU_decoded_video{i-1}, motionU_reconstructed_video{i}, 8);
            compU_decoded_video{i} = compU_decoded_video{i} + imgCompU_decoded;
            imgCompV_decoded = motionComp(compV_decoded_video{i-1}, motionV_reconstructed_video{i}, 8);
            compV_decoded_video{i} = compV_decoded_video{i} + imgCompV_decoded;
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
        compressed_size_video = compressed_size_video + size(compY_compression_video{i},1)+ size(compU_compression_video{i},1)+ size(compV_compression_video{i},1)+size(motionY_compression_video{i},1)+size(motionU_compression_video{i},1)+size(motionV_compression_video{i},1); % Car on doit coder aussi les vectors des mouvements.   
    end
    rate = (uncompressed_size_video )/(compressed_size_video);
    disp(['Compression rate of the video = ', num2str(rate)]);

% % Play video
    for i = 1:Nframe
        video(:,:,:,i) = (rgbImage{i});
    end
    implay(video,Nframe/10);
    
     
end


