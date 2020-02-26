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

function  [data_out] = f_dpcm_de_coder(data_in)
    data_out = zeros(1,length(data_in));
    data_out(1) = data_in(1);
    for i = 2:length(data_in)
        data_out(i) = data_in(i) - data_in(i-1);
    end
end




