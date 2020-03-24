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

function  [compR, compG, compB] = f_yuv_to_rgb(compY, compU, compV)
    
    Q = [   0.2126   0.7152   0.0722;
            -0.09991  -0.33609 0.436;
            0.615    -0.55861  -0.05639];
    Qinv = [1 0 1.13983; 1 -0.39465 -0.58060; 1 2.03211 0 ];
        
     Qinv = inv(Q);
    %Qinv = Qinv';
    compY = double(compY);
    compU = imresize(double(compU),2,'bicubic');
    compV = imresize(double(compV),2,'bicubic');
%     compU_x4 = zeros(2*size(compU,1), 2*size(compU,2));
%     i1 = 1;
%     i2 = 1;
%     for index1 = 1: 1 : size(compU,1)
%         for index2 = 1: 1: size(compU,2)
%             compU_x4(i1,i2) = compU(index1,index2);
%             compU_x4(i1+1,i2) = compU(index1,index2);
%             compU_x4(i1,i2+1) = compU(index1,index2);
%             compU_x4(i1+1,i2+1) = compU(index1,index2);
%             i2 = i2 + 2;
%         end
%         i1 = i1 + 2;
%         i2 = 1;
%     end
%     
%     compV_x4 = zeros(2*size(compV,1), 2*size(compV,2));
%     i1 = 1;
%     i2 = 1;
%     for index1 = 1: 1 : size(compV,1)
%         for index2 = 1: 1: size(compV,2)
%             compV_x4(i1,i2) = compV(index1,index2);
%             compV_x4(i1+1,i2) = compV(index1,index2);
%             compV_x4(i1,i2+1) = compV(index1,index2);
%             compV_x4(i1+1,i2+1) = compV(index1,index2);
%             i2 = i2 + 2;
%         end
%         i1 = i1 + 2;
%         i2 = 1;
%     end
%     compR = Qinv(1,1)*compY' + Qinv(1,2)*(compU) + Qinv(1,3)*(compV);
%     compG = Qinv(2,1)*compY' + Qinv(2,2)*(compU) + Qinv(2,3)*(compV);
%     compB = Qinv(3,1)*compY' + Qinv(3,2)*(compU) + Qinv(3,3)*(compV);
    compB = compY'+1.773*(compU-128);
    compR = compY'+1.403*(compV-128);
    compG = compY' - 0.334*(compU-128) - 0.714*(compV-128);
    
    
    compR = uint8(compR');
    compG = uint8(compG');
    compB = uint8(compB');
end




