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

function  [image_DCT] = f_jpeg_compression1(component)
    addpath('../ressources/TP2_Lossy_Source_Coding/');
    addpath('../ressources/video_and_code/');

    % DCT of each 8x8 block of the image component
    image_DCT = bdct(component, [8,8]);
    
    %Quantification (scalar uniform)

end




