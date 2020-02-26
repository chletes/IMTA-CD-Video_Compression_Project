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

function  [] = f_jpeg_compression(fid)
    addpath('../ressources/TP2_Lossy_Source_Coding/');
    addpath('../ressources/video_and_code/');


    % Load an image in YUV format. To load the next image, apply the function again.
    [compY,compU,compV]=yuv_readimage(fid);
    
    image_components = [compY, compU, compV];
    
%     for image_component = image_components
%         image_dct = bdct(Image, [8,8]);
%     end
    
    % Close the file
    fclose(fid);

end




