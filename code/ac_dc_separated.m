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


function [dc_component,ac_coefficients_decoded] = ac_dc_separated(comp_huff)
     dc_component = [];
     ac_component = comp_huff{1};
%     j = 2;
       j = 1;
     dc_position = [1];
    while j < length (comp_huff{1})

        dc_component = [dc_component,comp_huff{1}(j)];
        count = 0;
        j = j + 1;
        while count < 63
            count = count + comp_huff{1}(j+1);
            if count == 63
                j = j+1;
            else j = j+2;
            end
        end
         j = j+1;
      dc_position = [dc_position,j];
    end
    for i = 2:length (dc_component)
        dc_component(i) = dc_component(i-1) + dc_component(i);
    end
    for i = dc_position;
        ac_component(i) = pi;
    end
    ac_component = ac_component(ac_component~=pi);
    ac_component_rle = cell(1,2);
    ac_component_rle{1} = ac_component(1:2:end-1)';
    ac_component_rle{2} = ac_component(2:2:end)';
    ac_coefficients_decoded = f_rle_de_coder( ac_component_rle);
    
    
    total_image = zeros(64,length(ac_coefficients_decoded)/63);
    block_position = 1;
    for i = 1:63:length(ac_coefficients_decoded)-63
        each_block = [];
        each_block = [dc_component(block_position),ac_coefficients_decoded(i:i+62)];
        each_block_debalayage = f_decoder_balayage(each_block,8,8);
        total_image (:,block_position) = each_block_debalayage;
        block_position = block_position + 1;
       
    end
end
