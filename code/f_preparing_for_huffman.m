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

function  [Huffman_cell] = f_preparing_for_huffman(dc_dpcm_coefficients, ac_rle_coefficients)
    Huffman_cell = {};
    i2 = 1;
    i_read = 1;
    save = 0;
    for i1 = 1:size(dc_dpcm_coefficients, 2)
        number_of_coefficients = 0;
        
        Huffman_cell{1,i2} = dc_dpcm_coefficients(i1);
        i2 = i2 +1;
        while number_of_coefficients < 64 && i_read < size(ac_rle_coefficients{1,1},2)
            if save ~= 0 
                Huffman_cell{1,i2} = ac_rle_coefficients{1,1}(1,i_read);
                Huffman_cell{1,i2+1} = save;
                save = 0;
                i_read = i_read + 1;
                i2 = i2 + 2;
            end
            Huffman_cell{1,i2} = ac_rle_coefficients{1,1}(1,i_read);
            if number_of_coefficients + ac_rle_coefficients{1,2}(1,i_read) > 63
                Huffman_cell{1,i2+1} = 63 - number_of_coefficients;
                number_of_coefficients = 64;
                save = ac_rle_coefficients{1,2}(1,i_read) - Huffman_cell{1,i2+1};
            else
                Huffman_cell{1,i2+1} = ac_rle_coefficients{1,2}(1,i_read);
                number_of_coefficients = number_of_coefficients +  ac_rle_coefficients{1,2}(1,i_read);
                i_read = i_read + 1;
            end
            i2 = i2 + 2;
        end
    end
end




