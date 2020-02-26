function im=ibdct(t, bsize, imsize)
%ibdct - inverse block dct of image
%------------------------------------------------------------------------------
%SYNOPSIS	im = ibdct(t, [M N], [MM NN])
%		  Perform blockwise inverse dct on the transform image t,
%                 using blocks of size MxN. Each column in t is considered
%                 as a transform block and the resulting image will have
%                 size MMxNN.
%
%
%SEE ALSO	bdct
%
%RCSID          $Id: ibdct.m,v 1.1 1998/11/22 11:35:51 harna Exp $
%------------------------------------------------------------------------------
%Harald Nautsch                        (C) 1998 Image Coding Group. LiU, SWEDEN

if (nargin == 0)
  error('No input arguments.')
end

if (nargin < 3)
  error('Wrong number of input arguments.')
end

if (length(bsize) == 1)
  bsize = [bsize bsize];
end

if (length(imsize) == 1)
  imsize = [imsize imsize];
end

if (prod(bsize) ~= size(t, 1))
  error('The blocksize does not fit the transform image.')
end

im=coltoim(dct2basemx(bsize)'*t, bsize, imsize, 'distinct');

