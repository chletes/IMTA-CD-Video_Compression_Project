% function [compY,compU,compV]=yuv_readimage(fid)
%
% Reads  a qcif image in yuv format
% Input:
%    fid: File id obtained from an fopen
%
% Outputs:
%    compY, compU et compV : YUV components of the image
%
% Example:
% fid = fopen('foreman.qcif','r');
% [compY,compU,compV]=yuv_readimage(fid)

function [compY,compU,compV]=yuv_readimage(fid)

% Format
width = 176;
height = 144;
 
% Read the components
compY = fread(fid,[width height], 'uint8');
compY = compY';
compU = fread(fid, [width/2 height/2], 'uint8');
compV = fread(fid, [width/2 height/2], 'uint8');

end
