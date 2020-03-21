function [Y,U,V]=yuv_import(filename,dims,numfrm,startfrm)

fid=fopen(filename,'r');
if (fid < 0) 
    error('File does not exist!');
end;

Yd = zeros(dims(1),dims(2));
UVd = zeros(dims(1)/2,dims(2)/2);

frelem = numel(Yd) + 2*numel(UVd);

if (nargin == 4) %go to the starting frame
    fseek(fid, startfrm * frelem , 0);
end;


Y = cell(1,numfrm);
U = cell(1,numfrm);
V = cell(1,numfrm);
for i=1:numfrm
    Yd = fread(fid,[dims(1) dims(2)],'uint8');
    Y{i} = Yd';   
    UVd = fread(fid,[dims(1)/2 dims(2)/2],'uint8');
    U{i} = UVd';
    UVd = fread(fid,[dims(1)/2 dims(2)/2],'uint8');
    V{i} = UVd';    
end;