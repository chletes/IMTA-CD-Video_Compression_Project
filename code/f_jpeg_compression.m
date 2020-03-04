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

function  compressed_component = f_jpeg_compression(component)
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
        
%      if quality > 50
%          QX = round(Q50.*(ones(8)*((100-quality)/50)));
%          QX = uint8(QX);
%      elseif quality < 50
%          QX = round(Q50.*(ones(8)*(50/quality)));
%          QX = uint8(QX);
%      elseif quality == 50
%          QX = Q50;
%      end
    QX = Q50;
    
    [row, coln] = size(component);
    dc_coefficients = [];
    ac_coefficients = [];
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
        end
    end
    
    % DPCM sur dc_coefficients
    dc_dpcm_coefficients = f_dpcm_de_coder(dc_coefficients);
    % RLE sur ac_coefficients
    ac_rle_coefficients = f_rle_de_coder(ac_coefficients);
    % Huffman sur les dc et ac coefficients
    [Huffman_cell] = f_preparing_for_huffman(dc_dpcm_coefficients, ac_rle_coefficients);
    [compressed_component, Res] = Huff06(Huffman_cell, 1,0);
end




