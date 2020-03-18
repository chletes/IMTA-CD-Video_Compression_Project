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
    
    Q = [   0.299   0.587   0.114;
            -0.169  -0.331  0.5;
            0.5     -0.419  -0.081];
        
    Qinv = inv(Q);
    
    compU_x4 = zeros(2*size(compU,1), 2*size(compU,2));
    i1 = 1;
    i2 = 1;
    for index1 = 1: 1 : size(compU,1)
        for index2 = 1: 1: size(compU,2)
            compU_x4(i1,i2) = compU(index1,index2);
            compU_x4(i1+1,i2) = compU(index1,index2);
            compU_x4(i1,i2+1) = compU(index1,index2);
            compU_x4(i1+1,i2+1) = compU(index1,index2);
            i2 = i2 + 2;
        end
        i1 = i1 + 2;
        i2 = 1;
    end
    
    compV_x4 = zeros(2*size(compV,1), 2*size(compV,2));
    i1 = 1;
    i2 = 1;
    for index1 = 1: 1 : size(compV,1)
        for index2 = 1: 1: size(compV,2)
            compV_x4(i1,i2) = compV(index1,index2);
            compV_x4(i1+1,i2) = compV(index1,index2);
            compV_x4(i1,i2+1) = compV(index1,index2);
            compV_x4(i1+1,i2+1) = compV(index1,index2);
            i2 = i2 + 2;
        end
        i1 = i1 + 2;
        i2 = 1;
    end
    compR = Qinv(1,1)*compY' + Qinv(1,2)*compU_x4' + Qinv(1,3)*compV_x4';
    compG = Qinv(2,1)*compY' + Qinv(2,2)*compU_x4' + Qinv(2,3)*compV_x4';
    compB = Qinv(3,1)*compY' + Qinv(3,2)*compU_x4' + Qinv(3,3)*compV_x4';
    
    compR = compR';
    compG = compG';
    compB = compB';
end




