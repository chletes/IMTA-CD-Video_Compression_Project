function  [Image_origin_decoded] = f_jpeg_decompression(component_coded, QX,size_comp)
    %% Début du codage entropique (Huffman)
    comp_huff = Huff06(component_coded);
    %%Fin du codage entropique (Huffman)
    %% Début des étapes pour le décodage
    %Le plus important (et le plus difficile) ici c'est la séparation des 
    %coefficients DC et AC
    numrows = size_comp (1);
    numcols = size_comp (2);
    dc_component = [];
    ac_component = comp_huff{1};
    j = 1;
    dc_position = [1];
    while j < length (comp_huff{1})
        dc_component = [dc_component,comp_huff{1}(j)];
        count = 0;
        j = j + 1;
        while count < 63
            count = count + comp_huff{1}(j+1);
            if count == 63
                j = j+1;
            else j = j+2;
            end
        end
        j = j+1;
        dc_position = [dc_position,j];
    end
    %Décodage DPCM des composants DC
    for i = 2:length (dc_component)
        dc_component(i) = dc_component(i-1) + dc_component(i);
    end
    %Décodage RLE des composants AC
    for i = dc_position
        ac_component(i) = pi;
    end
    ac_component = ac_component(ac_component~=pi);
    ac_component_rle = cell(1,2);
    ac_component_rle{1} = ac_component(1:2:end-1)';
    ac_component_rle{2} = ac_component(2:2:end)';
    ac_coefficients_decoded = f_rle_de_coder( ac_component_rle);
    %Début des étapes pour la décompression des blocs 8x8
    total_image = zeros(64,length(ac_coefficients_decoded)/63);
    block_position = 1;
    for i = 1:63:length(ac_coefficients_decoded)
        each_block = [];
        each_block = [dc_component(block_position),ac_coefficients_decoded(i:i+62)];
        %Balayage inverse des blocs
        each_block_debalayage = f_balayage_inverse(each_block,8,8);
        %Quantification inverse des blocs
        each_block_dequatification = each_block_debalayage.*QX;
        each_block_ibdct = ibdct (reshape(each_block_dequatification,64,1),[8,8],[8,8]);
        each_block_ibdct = reshape(each_block_ibdct,64,1);
        %each_block_dequatification = reshape(each_block_dequatification, 64,1);
        total_image (:,block_position) = each_block_ibdct;
        block_position = block_position + 1;
    end
    Image_origin_decoded = zeros(size_comp);
    block_position = 1;
    for i1 = 1:8:numrows
        for i2 = 1:8:numcols
            Image_origin_decoded (i1:i1+7,i2:i2+7)= reshape(total_image (:,block_position),8,8);
            block_position = block_position + 1;
        end
    end
end




