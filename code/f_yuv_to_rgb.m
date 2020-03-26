function  [compR, compG, compB] = f_yuv_to_rgb(compY, compU, compV)
    
    compY = double(compY);
    compU = imresize(double(compU),2,'bicubic');
    compV = imresize(double(compV),2,'bicubic');

    compB = compY'+1.773*(compU-128);
    compR = compY'+1.403*(compV-128);
    compG = compY' - 0.334*(compU-128) - 0.714*(compV-128);
    
    compR = uint8(compR');
    compG = uint8(compG');
    compB = uint8(compB');
end




