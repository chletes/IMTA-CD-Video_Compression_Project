function t = dct2basemx(m,n)
%dct2basemx - Make a 2D DCT transform matrix
%------------------------------------------------------------------------------
%SYNOPSIS       T = dct2basemx(M,N)
%                 T will be the MN-by-MN orthogonal 2-dimensional DCT base
%                 matrix suitable for transforming M-by-N blocks represented
%                 as columnvectors. 
%                 
%                 The basis blocks can be found in the rows of the matrix T.
%                 Hence,
%                            Y = T*X       <- Transformation
%                            X = T'*X      <- Inverse transformation
%
%               T = dct2basemx(B)
%                 As above with B=[M N].
%
%COMMENT        The baseblocks are not ordered in zig-zag, but rather in
%               a top-down left-right order as given by operations such as
%               im2block.
%
%SEE ALSO       im2block, block2im, dct2, zigzag.
%
%RCSID          $Id: dct2basemx.m,v 1.2 1998/11/21 12:40:02 svan Exp $
%------------------------------------------------------------------------------
%Jonas Svanberg                        (C) 1994 Image Coding Group. LiU, SWEDEN

if nargin == 1
  n = m(2);
  m = m(1);
end

%u = ones(n*m,1)*reshape((0:m-1)'*ones(1,n),1,n*m)
%v = ones(n*m,1)*reshape(ones(m,1)*(0:n-1),1,n*m)

u = mod((0:m*n-1)',m)*ones(1,m*n);
v = floor((0:m*n-1)'/m)*ones(1,m*n);

t = 2/sqrt(n*m) * sqrt(2).^((u~=0)+(v~=0)-2) .* ...
      cos(pi*(u/(2*m)).* (2*u'+1)).*cos(pi*(v/(2*n)).*(2*v'+1));
