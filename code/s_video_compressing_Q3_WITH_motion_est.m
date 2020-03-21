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
addpath('../ressources/BlockMatchingAlgoMPEG/');
%Filename
file = "../data/images/news.qcif";
Nframe = 50;
gap = 8;
total_bit = 0;
% Open the file
fid = fopen(file,'r');
if (fid == -1)
    disp('Error with your file, check the filename.');
else
    [compY,compU,compV]=f_yuv_import(file,[176 144],Nframe,0);
    motionVectY_video = cell(1,Nframe);
    motionVectU_video = cell(1,Nframe);
    motionVectV_video = cell(1,Nframe);
    x = linspace(1,Nframe,Nframe);
    for j = 1:Nframe/gap-1
        for i = 2+gap*(j-1):gap*j
            
            [motionVectY, EScomputationsY] = motionEstES(compY{i}, compY{i-1}, 8, 7);
            motionVectY_video{i} = motionVectY;           
            [motionVectU, EScomputationsU] = motionEstES(compU{i}, compU{i-1}, 8, 7);
            motionVectU_video{i} = motionVectU;
            [motionVectV, EScomputationsV] = motionEstES(compV{i}, compV{i-1}, 8, 7); 
            motionVectV_video{i} = motionVectV;
%             [motionVectY, EScomputationsY] = motionEstES(compY{i}, compY{gap*j+1}, 8, 7);
%             motionVectY_video{i}(3:4,:) = motionVectY;           
%             [motionVectU, EScomputationsU] = motionEstES(compU{i}, compU{gap*j+1}, 8, 7);
%             motionVectU_video{i}(3:4,:) = motionVectU;
%             [motionVectV, EScomputationsV] = motionEstES(compV{i}, compV{gap*j+1}, 8, 7); 
%             motionVectV_video{i}(3:4,:) = motionVectV;
        end
    end
    for i = 2+gap*j:Nframe       
        [motionVectY, EScomputationsY] = motionEstES(compY{i}, compY{i-1}, 8, 7);
        [motionVectU, EScomputationsU] = motionEstES(compU{i}, compU{i-1}, 8, 7);
        [motionVectV, EScomputationsV] = motionEstES(compV{i}, compV{i-1}, 8, 7);
        motionVectY_video{i} = motionVectY;
        motionVectU_video{i} = motionVectU;
        motionVectV_video{i} = motionVectV;
    end
        
    compY_predict_video = compY;
    compU_predict_video = compU;
    compV_predict_video = compV; 
    for j = 1:Nframe/gap-1
        for i = 2+gap*(j-1):gap*j
            imgCompY = motionComp(compY{i-1}, motionVectY_video{i}, 8);
            compY_predict_video{i} = compY{i} - imgCompY;           
            imgCompU = motionComp(compU{i-1}, motionVectU_video{i}, 8);
            compU_predict_video{i} = compU{i} - imgCompU;
            imgCompV = motionComp(compV{i-1}, motionVectV_video{i}, 8);
            compV_predict_video{i} = compV{i} - imgCompV;
%             [motionVectY, EScomputationsY] = motionEstES(compY{i}, compY{gap*j+1}, 8, 7);
%             motionVectY_video{i}(3:4,:) = motionVectY;           
%             [motionVectU, EScomputationsU] = motionEstES(compU{i}, compU{gap*j+1}, 8, 7);
%             motionVectU_video{i}(3:4,:) = motionVectU;
%             [motionVectV, EScomputationsV] = motionEstES(compV{i}, compV{gap*j+1}, 8, 7); 
%             motionVectV_video{i}(3:4,:) = motionVectV;
        end
    end
    for i = 2+gap*j:Nframe 
        imgCompY = motionComp(compY{i-1}, motionVectY_video{i}, 8);
        compY_predict_video{i} = compY{i} - imgCompY;
        imgCompU = motionComp(compU{i-1}, motionVectU_video{i}, 8);
        compU_predict_video{i} = compU{i} - imgCompU;
        imgCompV = motionComp(compV{i-1}, motionVectV_video{i}, 8);
        compV_predict_video{i} = compV{i} - imgCompV;        
    end
    

%     compY_predict_video = cell(1,Nframe);
%     compU_predict_video = cell(1,Nframe);
%     compV_predict_video = cell(1,Nframe);    
%     compY_compression_video = cell(1,Nframe);
%     compU_compression_video = cell(1,Nframe);
%     compV_compression_video = cell(1,Nframe);
%     compressed_infoY_video = cell(1,Nframe);
%     compressed_infoU_video = cell(1,Nframe);
%     compressed_infoV_video = cell(1,Nframe);
%     compY_decoded_video = cell(1,Nframe);
%     compU_decoded_video = cell(1,Nframe);
%     compV_decoded_video = cell(1,Nframe);
    %predicted coding
%     compY_predict_video{1} = compY{1};
%     compU_predict_video{1} = compU{1};
%     compV_predict_video{1} = compV{1};
%     for i = 2:Nframe
%         compY_predict_video{i} = compY{i} - compY{i-1};
%         compU_predict_video{i} = compU{i} - compU{i-1};
%         compV_predict_video{i} = compV{i} - compV{i-1};
%     end
    
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
    end  

    motionY_huffman = cell(1,1);
    motionU_huffman = cell(1,1);
    motionV_huffman = cell(1,1);
    for j = 1:Nframe/gap-1
        for i = 2+gap*(j-1):gap*j
            motionY_huffman{1} = reshape ( motionVectY_video{i},[1,length(motionVectY_video{i}(1,:))*2]);
            motionU_huffman{1} = reshape ( motionVectU_video{i},[1,length(motionVectU_video{i}(1,:))*2]);
            motionV_huffman{1} = reshape ( motionVectV_video{i},[1,length(motionVectV_video{i}(1,:))*2]);
           [motionY_compression,motionY_info] = Huff06(motionY_huffman,1,0);
           [motionU_compression,motionU_info] = Huff06(motionU_huffman,1,0);
           [motionV_compression,motionV_info] = Huff06(motionV_huffman,1,0);
           motionY_compression_video{i} = motionY_compression;
           motionU_compression_video{i} = motionU_compression;
           motionV_compression_video{i} = motionV_compression;
           total_bit = total_bit + motionY_info(1,3) + motionU_info(1,3) + motionV_info(1,3);
        end
    end
    for i = 2+gap*j:Nframe 
            motionY_huffman{1} = reshape ( motionVectY_video{i},[1,length(motionVectY_video{i}(1,:))*2]);
            motionU_huffman{1} = reshape ( motionVectU_video{i},[1,length(motionVectU_video{i}(1,:))*2]);
            motionV_huffman{1} = reshape ( motionVectV_video{i},[1,length(motionVectV_video{i}(1,:))*2]);
           [motionY_compression,motionY_info] = Huff06(motionY_huffman,1,0);
           [motionU_compression,motionU_info] = Huff06(motionU_huffman,1,0);
           [motionV_compression,motionV_info] = Huff06(motionV_huffman,1,0);
           motionY_compression_video{i} = motionY_compression;
           motionU_compression_video{i} = motionU_compression;
           motionV_compression_video{i} = motionV_compression;
           total_bit = total_bit + motionY_info(1,3) + motionU_info(1,3) + motionV_info(1,3);
    end
    
    %% decoder
    for j = 1:Nframe/gap-1
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
        compY_huff = Huff06(compY_compression_video{i});
        compU_huff = Huff06(compU_compression_video{i});
        compV_huff = Huff06(compV_compression_video{i});
        [compY_decoded] = f_ac_dc_separated(compY_huff,QX,size_compY);
        [compU_decoded] = f_ac_dc_separated(compU_huff,QX,size_compU);
        [compV_decoded] = f_ac_dc_separated(compV_huff,QX,size_compV);
        compY_decoded_video{i} = compY_decoded;
        compU_decoded_video{i} = compU_decoded;
        compV_decoded_video{i} = compV_decoded;  
    end
%   %      [compR, compG, compB] = f_yuv_to_rgb(compY{i}, compU{i}, compV{i});
% 
%     %    [compR_decoded, compG_decoded, compB_decoded] = f_yuv_to_rgb(compY_decoded, compU_decoded, compV_decoded);
%     %     rgbImage = cat(3, compR,compG,compB);
%     %     rgbImage_decoded = cat(3, compR_decoded,compG_decoded,compB_decoded);
%     %     gray_pixel = 0.27*compR + 0.67*compG + 0.06*compB;
%     % Im=zeros(size(compR_decoded,1),size(compR_decoded,2),3);
%     % Im(:,:,1)=compR_decoded;
%     % Im(:,:,2)=compG_decoded;
%     % Im(:,:,3)=compB_decoded;
%     %     imshow(rgbImage);
% %           figure (2);
% %           subplot(2,1,1)
% %           imagesc(compY{1}'); 
% %          subplot(2,1,2)
% %           imagesc(compY_decoded'); 
%     end
    for j = 1:Nframe/gap-1
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

%           figure (2);
%           subplot(2,1,1)
%           imagesc(compY{end}); 
%          subplot(2,1,2)
%           imagesc(compY_decoded_video{end});
% % Play video
    for i = 1:Nframe
        video(:,:,i) = uint8(compY_decoded_video{i});
    end
     fclose(fid);
     implay(video,Nframe/10);
     
end


