close all;clear all;clc;
% il y a 300 frames from 0-299,300frames sur news.qcif
% il y a 300 frames from 0-299,300frames sur akiyo.qcif

[Y,U,V]=  yuv_import ('akiyo.qcif',[176 144],300,0)

% for i = 1:length(Y)
% imshow((uint8(Y{i})))
% end

V1 = VideoWriter(['akiyo.avi']);

%V = VideoWriter(['filename.avi'],'Gray Scale AVI');
V1.FrameRate = 80; 
V1.Quality = 100;  
open(V1);
for i=1:300
   img=uint8(Y{i});
   writeVideo(V1,img);
end
close(V1);


