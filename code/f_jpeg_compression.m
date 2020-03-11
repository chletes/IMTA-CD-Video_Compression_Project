%
% PURPOSE: 
%
% FUNCTION CALL:
%
% [outputs] = name_of_the_function(inputs)
%
% ARGUMENTS IN: Explanation of the inputs
%
%
% ARGUMENTS OUT: Explanation of the outputs
%
% 
%
% EXTERNAL FUNCTIONS USED:
%
%
% SCRIPTS CALLING FUNCTION:
%
%
% REFERENCES/NOTES/COMMENTS:
%
% 
%**********************************************************************************************

function  [compressed_component, Res,QX] = f_jpeg_compression(component)
    addpath('../ressources/TP1_Lossless_Coding/');
    addpath('../ressources/TP2_Lossy_Source_Coding/');
    addpath('../ressources/video_and_code/');
    
    Q50 = [ 16 11 10 16 24 40 51 61;
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56;
            14 17 22 29 51 87 80 62; 
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
     quality = 50;   
     if quality > 50
         QX = round(Q50.*(ones(8)*((100-quality)/50)));
%          QX = uint8(QX);
     elseif quality < 50
         QX = round(Q50.*(ones(8)*(50/quality)));
%          QX = uint8(QX);
     elseif quality == 50
         QX = Q50;
     end
    %QX = Q50;
    
    [row, coln] = size(component);
    dc_coefficients = [];
    ac_coefficients = [];
    true_coefficients = [];
    coefficient_temps = 0;
    for i1 = 1:8:row
        for i2 = 1:8:coln
            block = component(i1:i1+7,i2:i2+7);
            %DCT
            block_DCT = bdct(block, [8,8]); 
            %quantification
            block_DCT = reshape(block_DCT, 8,8); 
            block_q = round(block_DCT./QX);
            coefficients = f_balayage(block_q);
            
            dc_coefficients = [dc_coefficients, coefficients(1)];
            ac_coefficients = [ac_coefficients, coefficients(2:end)];
            ac_rle_co = f_rle_de_coder(coefficients(2:end));
            true_coefficients = [true_coefficients,coefficients(1)-coefficient_temps];
            for i3 = 1:length(ac_rle_co{1,1})
                true_coefficients = [true_coefficients,ac_rle_co{1,1}(i3),ac_rle_co{1,2}(i3)];
            end
            coefficient_temps = coefficients(1);

        end
    end
    
    % DPCM sur dc_coefficients
    dc_dpcm_coefficients = f_dpcm_de_coder(dc_coefficients);
    % RLE sur ac_coefficients
    ac_rle_coefficients = f_rle_de_coder(ac_coefficients);
    % Huffman sur dc_coefficients
    source = cell(1,1);
    source_vector = [];
%     ac_coefficient_index = 1;
%     for i = 1:length (dc_dpcm_coefficients)
%         number_of_coefficients = 0;
%         source_each_block = [];
%         if ac_coefficient_index > length (ac_rle_coefficients{1,2})
%             break;
%         end
%             
%         while true
%             if ac_coefficient_index > length (ac_rle_coefficients{1,2})
%                 break;
%             end
%             number_of_coefficients = number_of_coefficients + ac_rle_coefficients{1,2}(ac_coefficient_index);
%             
%             if number_of_coefficients >= 63
%                 ac_rle_coefficients{1,2}(ac_coefficient_index) = ac_rle_coefficients{1,2}(ac_coefficient_index)-number_of_coefficients + 63;
%                 ac_rle_coefficients{1,1} = [ac_rle_coefficients{1,1}(1:ac_coefficient_index),ac_rle_coefficients{1,1}(ac_coefficient_index),ac_rle_coefficients{1,1}(ac_coefficient_index+1:end)];
%                 ac_rle_coefficients{1,2} = [ac_rle_coefficients{1,2}(1:ac_coefficient_index),number_of_coefficients - 63,ac_rle_coefficients{1,2}(ac_coefficient_index+1:end)];
%                 source_each_block = [source_each_block,ac_rle_coefficients{1,1}(ac_coefficient_index),ac_rle_coefficients{1,2}(ac_coefficient_index)];
%                 ac_coefficient_index = ac_coefficient_index +1;
%                 
%                 break;
%             else
%                 source_each_block = [source_each_block,ac_rle_coefficients{1,1}(ac_coefficient_index),ac_rle_coefficients{1,2}(ac_coefficient_index)];
%                 ac_coefficient_index = ac_coefficient_index +1;
%             end
%             
%         end
%         source_each_block = [dc_dpcm_coefficients(i),source_each_block];
%         source_vector = [source_vector,source_each_block];
%     end
%         
%             
    source{1} =  true_coefficients;
   [compressed_component, Res] = Huff06(source, 1,0);
    
   

        
    
end




