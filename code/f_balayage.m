function  [source_balayee] = f_balayage(block)
% Zig-zag scanning
% This function reorders a 2-D matrix into a 1-D array following the zizgag
% algorithm (technique)
%
% As an example,
% OUT = f_balayage(IN)
% IN =
%	1     2     3
%	4     5     6
%	7     8     9
%	10    11    12
% OUT = [1     2     4     7     5     3     6     8    10    11     9    12];
%
% IMT ATLANTIQUE
% Binh Minh NGUYEN
% Carlos SANTOS SEISDEDOS
    [num_rows, num_cols]=size(block);
    % Initialise the output vector
    source_balayee=zeros(1,num_rows*num_cols);
    cur_row=1;	cur_col=1;	cur_index=1;
    % First element
    %source_balayee(1)=block(1,1);
    while cur_row<=num_rows && cur_col<=num_cols
        if cur_row==1 && mod(cur_row+cur_col,2)==0 && cur_col~=num_cols
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_col=cur_col+1;							%move right at the top
            cur_index=cur_index+1;

        elseif cur_row==num_rows && mod(cur_row+cur_col,2)~=0 && cur_col~=num_cols
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_col=cur_col+1;							%move right at the bottom
            cur_index=cur_index+1;

        elseif cur_col==1 && mod(cur_row+cur_col,2)~=0 && cur_row~=num_rows
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_row=cur_row+1;							%move down at the left
            cur_index=cur_index+1;

        elseif cur_col==num_cols && mod(cur_row+cur_col,2)==0 && cur_row~=num_rows
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_row=cur_row+1;							%move down at the right
            cur_index=cur_index+1;

        elseif cur_col~=1 && cur_row~=num_rows && mod(cur_row+cur_col,2)~=0
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_row=cur_row+1;		cur_col=cur_col-1;	%move diagonally left down
            cur_index=cur_index+1;

        elseif cur_row~=1 && cur_col~=num_cols && mod(cur_row+cur_col,2)==0
            source_balayee(cur_index)=block(cur_row,cur_col);
            cur_row=cur_row-1;		cur_col=cur_col+1;	%move diagonally right up
            cur_index=cur_index+1;

        elseif cur_row==num_rows && cur_col==num_cols	%obtain the bottom right element
            source_balayee(end)=block(end);							%end of the operation
            break										%terminate the operation
        end
end




