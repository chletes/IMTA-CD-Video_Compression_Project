function  [compressed_component, Res,QX] = f_jpeg_compression(component, quality)
    addpath('../ressources/TP1_Lossless_Coding/');
    addpath('../ressources/TP2_Lossy_Source_Coding/');
    addpath('../ressources/video_and_code/');
    %% Debut du calcul de la matrice de quantification. 
    %La qualite de l'image depend de cette matrice.
    
    
    Q50 = [ 16 11 10 16 24 40 51 61;
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56;
            14 17 22 29 51 87 80 62; 
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
     
     if quality > 50
         QX = round(Q50.*(ones(8)*((100-quality)/50)));
%          QX = uint8(QX);
     elseif quality < 50
         QX = round(Q50.*(ones(8)*(50/quality)));
%          QX = uint8(QX);
     elseif quality == 50
         QX = Q50;
     end
    %QX = Q50;
    %%Fin du calcul de la matrice de quantification. 
    %% Debut des etapes pour la compression des blocs 8x8
    [row, coln] = size(component);
    dc_coefficients = [];
    ac_coefficients = [];
    true_coefficients = [];
    coefficient_temps = 0;
    for i1 = 1:8:row
        for i2 = 1:8:coln
            %Decomposition de la composante en blocs 8x8
            block = component(i1:i1+7,i2:i2+7);
            %Calcul de la DCT
            block_DCT = bdct(block, [8,8]); 
            %Ponderation des coefficients de la DCT par la matrice de
            %qualite
            block_DCT = reshape(block_DCT, 8,8); 
            block_q = round(block_DCT./QX);
            %Balayage des coefficients quantifiees... 
            coefficients = f_balayage(block_q);
            %...pour separer la composante DC et les composantes AC...
            dc_coefficients = [dc_coefficients, coefficients(1)];
            ac_coefficients = [ac_coefficients, coefficients(2:end)];
            %... et faire le codage RLE sur les composantes AC...
            ac_rle_co = f_rle_de_coder(coefficients(2:end));
            %... et le codage DPCM sur les composantes DC
            true_coefficients = [true_coefficients,coefficients(1)-coefficient_temps];
            for i3 = 1:length(ac_rle_co{1,1})
                true_coefficients = [true_coefficients,ac_rle_co{1,1}(i3),ac_rle_co{1,2}(i3)];
            end
            coefficient_temps = coefficients(1);
        end
    end
    %%Fin des etapes pour la compression des blocs 8x8
    %% Debut du codage entropique (Huffman)
    source = cell(1,1);
    source_vector = [];
    source{1} =  true_coefficients;
    [compressed_component, Res] = Huff06(source, 1,0);
    %%Fin du codage entropique (Huffman)
end




