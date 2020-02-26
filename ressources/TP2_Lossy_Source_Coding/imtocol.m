function b=imtocol(varargin)
%IM2COL Rearrange image blocks into columns.
%   B = IMTOCOL(A,[M N],'distinct') rearranges each distinct
%   M-by-N block in the image A into a column of B. IM2COL pads A
%   with zeros, if necessary, so its size is an integer multiple
%   of M-by-N. If A = [A11 A12; A21 A22], where each Aij is
%   M-by-N, then B = [A11(:) A12(:) A21(:) A22(:)].
%
%   B = IM2COL(A,[M N],'sliding') converts each sliding M-by-N
%   block of A into a column of B, with no zero padding. B has
%   M*N rows and will contain as many columns as there are M-by-N
%   neighborhoods in A. If the size of A is [MM NN], then the
%   size of B is (M*N)-by-((MM-M+1)*(NN-N+1). Each column of B
%   contains the neighborhoods of A reshaped as NHOOD(:), where
%   NHOOD is a matrix containing an M-by-N neighborhood of
%   A. IM2COL orders the columns of B so that they can be
%   reshaped to form a matrix in the normal way. For example,
%   suppose you use a function, such as SUM(B), that returns a
%   scalar for each column of B. You can directly store the
%   result in a matrix of size (MM-M+1)-by-(NN-N+1) using these
%   calls: 
%
%        B = im2col(A,[M N],'sliding');
%        C = reshape(sum(B),MM-M+1,NN-N+1);
%
%   B = IM2COL(A,[M N]) uses the default block type of
%   'sliding'.
%
%   B = IM2COL(A,'indexed',...) processes A as an indexed image,
%   padding with zeros if the class of A is uint8, or ones if the
%   class of A is double.
%
%   Class Support
%   -------------
%   The input image A can be of class double or of any integer
%   class. The output matrix B is of the same class as the
%   input image.
%
%   See also BLKPROC, COL2IM, COLFILT, NLFILTER.

%   Copyright 1993-2001 The MathWorks, Inc.  
%   $Revision: 5.18 $  $Date: 2001/01/18 15:29:17 $

[a, block, kind, padval] = parse_inputs(varargin{:});

if strcmp(kind, 'distinct')
    % Pad A if size(A) is not divisible by block.
    [m,n] = size(a);
    mpad = rem(m,block(1)); if mpad>0, mpad = block(1)-mpad; end
    npad = rem(n,block(2)); if npad>0, npad = block(2)-npad; end
    
    %aa = mkconstarray(class(a), padval, [m+mpad n+npad]);
    aa(1,1) = a(1,1);
    aa(1:m+mpad,1:n+npad)=padval*ones(m+mpad,n+npad);
    
    aa(1:m,1:n) = a;
    
    [m,n] = size(aa);
    mblocks = m/block(1);
    nblocks = n/block(2);
    
    %b = mkconstarray(class(a), 0, [prod(block) mblocks*nblocks]);
    b(1,1) = a(1,1);
    b(prod(block),mblocks*nblocks) = 0;
    
    %x = mkconstarray(class(a), 0, [prod(block) 1]);
    x(1,1) = a(1,1);
    x(prod(block),1) = 0;

    rows = 1:block(1); cols = 1:block(2);
    for i=0:mblocks-1,
        for j=0:nblocks-1,
            x(:) = aa(i*block(1)+rows,j*block(2)+cols);
            b(:,i+j*mblocks+1) = x;
        end
    end
    
elseif strcmp(kind,'sliding')
    [ma,na] = size(a);
    m = block(1); n = block(2);
    
    if any([ma na] < [m n]) % if neighborhood is larger than image
       b = zeros(m*n,0);
       return
    end
    
    % Create Hankel-like indexing sub matrix.
    mc = block(1); nc = ma-m+1; nn = na-n+1;
    cidx = (0:mc-1)'; ridx = 1:nc;
    t = cidx(:,ones(nc,1)) + ridx(ones(mc,1),:);    % Hankel Subscripts
    tt = zeros(mc*n,nc);
    rows = [1:mc];
    for i=0:n-1,
        tt(i*mc+rows,:) = t+ma*i;
    end
    ttt = zeros(mc*n,nc*nn);
    cols = 1:nc;
    for j=0:nn-1,
        ttt(:,j*nc+cols) = tt+ma*j;
    end
    b = a(ttt);
else
    error([deblank(kind),' is an unknown block type']);
end

%%%
%%% Function parse_inputs
%%%
function [a, block, kind, padval] = parse_inputs(varargin)

switch nargin
case 0
    error('Too few inputs to IM2COL');

case 1
    error('Too few inputs to IM2COL');
    
case 2
    if (strcmp(varargin{2},'indexed'))
        error('Too few inputs to IM2COL');
    else
        % IM2COL(A, [M N])
        a = varargin{1};
        block = varargin{2};
        kind = 'sliding';
        padval = 0;
    end
    
case 3
    if (strcmp(varargin{2},'indexed'))
        % IM2COL(A, 'indexed', [M N])
        a = varargin{1};
        block = varargin{3};
        kind = 'sliding';
        padval = 1;
        
    else
        % IM2COL(A, [M N], 'kind')
        a = varargin{1};
        block = varargin{2};
        kind = varargin{3};
        padval = 0;
        
    end
    
case 4
    % IM2COL(A, 'indexed', [M N], 'kind')
    a = varargin{1};
    block = varargin{3};
    kind = varargin{4};
    padval = 1;
    
otherwise
    error('Too many input arguments to IM2COL');
end

matchStrings = ['sliding '
                'distinct'];
idx = strmatch(kind, matchStrings);
if (isempty(idx))
    error('Block type must be either ''distinct'' or ''sliding''');
end
kind = deblank(matchStrings(idx(1),:));

if (isa(a,'uint8') | isa(a, 'uint16'))
    padval = 0;
end
