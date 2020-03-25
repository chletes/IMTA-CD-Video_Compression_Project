function [Y,U,V,Nframe]=yuv_import(filename,dims,numfrm,startfrm)

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


for i=1:numfrm
    Yd = fread(fid,[dims(1) dims(2)],'uint8');
    % Verifier le nombre de frame. Si Yd = [], on s'arret et sauvegarder le
    % nomber de frame.
    stop = isempty(Yd);
    if stop == 1
        Nframe = i - 1;
        break
    else Nframe = numfrm;
    end
    
    Y{i} = Yd';   
    UVd = fread(fid,[dims(1)/2 dims(2)/2],'uint8');
    U{i} = UVd';
    UVd = fread(fid,[dims(1)/2 dims(2)/2],'uint8');
    V{i} = UVd';    
end;