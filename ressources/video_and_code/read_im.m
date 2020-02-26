% Filename
file = "../../data/images/news.qcif";

% Open the file
fid = fopen(file,'r');

% Load an image in YUV format. To load the next image, apply the function again.
[compY,compU,compV]=yuv_readimage(fid);

% Display image
imagesc(compY);

% Close the file
fclose(fid);
