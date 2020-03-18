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
    size_compY = size (compY);
    size_compU = size (compU);
    size_compV = size (compV);
    [compY_compression,compressed_infoY,QX] = f_jpeg_compression(compY);
    [compU_compression,compressed_infoU,QX] = f_jpeg_compression(compU);
    [compV_compression,compressed_infoV,QX] = f_jpeg_compression(compV);
%% decoder
    compY_huff = Huff06(compY_compression);
    compU_huff = Huff06(compU_compression);
    compV_huff = Huff06(compV_compression);
    [compY_decoded] = ac_dc_separated(compY_huff,QX,size_compY);
    [compU_decoded] = ac_dc_separated(compU_huff,QX,size_compU);
    [compV_decoded] = ac_dc_separated(compV_huff,QX,size_compV);
    %[compR, compG, compB] = f_yuv_to_rgb(compY, compU, compV);
    
    %[compR_decoded, compG_decoded, compB_decoded] = f_yuv_to_rgb(compY_decoded, compU_decoded, compV_decoded);
%     rgbImage = cat(3, compR,compG,compB);
%     rgbImage_decoded = cat(3, compR_decoded,compG_decoded,compB_decoded);
%     gray_pixel = 0.27*compR + 0.67*compG + 0.06*compB;
% Im=zeros(size(compR_decoded,1),size(compR_decoded,2),3);
% Im(:,:,1)=compR_decoded;
% Im(:,:,2)=compG_decoded;
% Im(:,:,3)=compB_decoded;
%     imshow(rgbImage);
     figure (2);
     subplot(2,1,1)
      imagesc(compU'); 
     subplot(2,1,2)
     imagesc(compU_decoded'); 
    fclose(fid);
end


