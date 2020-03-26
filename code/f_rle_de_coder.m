function  [data_out] = f_rle_de_coder(data_in)
% data_out = f_rle_de_coder(data_in) (de)compresses the data with the RLE-Algorithm
%   Compression:
%      if data_in is a numbervector data_out{1} contains the values
%      and data_out{2} contains the run lenths
%
%   Decompression:
%      if data_in is a cell array, data_out contains the uncompressed values
%
%      Version 1.0 by Stefan Eireiner (<a href="mailto:stefan-e@web.de?subject=rle">stefan-e@web.de</a>)
%      based on Code by Peter J. Acklam
%      last change 14.05.2004
if iscell(data_in) % decoding
	i = cumsum([ 1 data_in{2} ]);
	j = zeros(1, i(end)-1);
	j(i(1:end-1)) = 1;
	data_out = data_in{1}(cumsum(j));
else % encoding
	if size(data_in,1) > size(data_in,2), data_in = data_in'; end % if data_in is a column vector, tronspose
    i = [ find(data_in(1:end-1) ~= data_in(2:end)) length(data_in) ];
	data_out{2} = diff([ 0 i ]);
	data_out{1} = data_in(i);
end