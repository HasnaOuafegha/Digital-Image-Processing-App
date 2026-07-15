
img = imread('fleur.png');
gray = rgb2gray(img);

figure;
subplot(1,2,1); imshow(img);   title('Original')
subplot(1,2,2); imshow(gray); title('Image en niveaux de gris')

figure;
histogram(gray(:), 256);
title('Histogramme de l image en niveaux de gris');
xlabel('Intensite');
ylabel('Nombre de pixels');

pixels  = double(gray(:));
N       = numel(pixels);
moyenne = sum(pixels) / N;

ecart_type = sqrt(sum((pixels - moyenne).^2) / N);

valeur_min = double(min(gray(:)));
valeur_max = double(max(gray(:)));


disp(['Moyenne    = ', num2str(moyenne)])
disp(['Ecart type = ', num2str(ecart_type)])
disp(['Min        = ', num2str(valeur_min)])
disp(['Max        = ', num2str(valeur_max)])
% =========================================================
% 2. TRANSFORMATIONS NON LINEAIRES
% =========================================================
gray_double = double(gray) / 255;
gamma1 = gray_double .^ 0.5;
gamma2 = gray_double .^ 1.5;


figure;
subplot(1,3,1); imshow(gray);   title('Original')
subplot(1,3,2); imshow(gamma1); title('Gamma 0.5')
subplot(1,3,3); imshow(gamma2); title('Gamma 1.5')

log_img = log(1 + gray_double) / log(2);

figure;
subplot(1,2,1); imshow(gray);    title('Original')
subplot(1,2,2); imshow(log_img); title('Logarithmique')

exp_img = gray_double .^ 2;

figure;

subplot(1,2,1); imshow(gray);    title('Original')
subplot(1,2,2); imshow(exp_img); title('Exponentielle')
% =========================================================
% 3. AMELIORATION DU CONTRASTE
% =========================================================
gray_double = double(gray);
min_val = min(gray_double(:));
max_val = max(gray_double(:));

contrast_img = (gray_double - min_val) / (max_val - min_val);

figure;
subplot(1,2,1); imshow(gray);          title('Original')
subplot(1,2,2); imshow(contrast_img);  title('Etirement du contraste')

img_compressed = 50 + (double(gray) / 255) * 100;

min_val = min(img_compressed(:));
max_val = max(img_compressed(:));

contrast_img = (img_compressed - min_val) / (max_val - min_val);
contrast_img = uint8(contrast_img * 255);

% 🔹 affichage
figure;
subplot(1,3,1); imshow(gray); title('Original')

subplot(1,3,2); 
imshow(uint8(img_compressed)); 
title('Image compressée [50,150]')

subplot(1,3,3); 
imshow(contrast_img); 
title('Après étirement')


gray_double = double(gray);
[counts, ~] = histcounts(gray_double(:), 256);

cdf = cumsum(counts) / numel(gray_double);

equalized = uint8(255 * cdf(gray_double + 1));
figure;
subplot(1,2,1); imshow(gray);      title('Original')
subplot(1,2,2); imshow(equalized); title('Egalisation')
% =========================================================
% 4. DETECTION DES CONTOURS — SOBEL
% =========================================================

sobel_x = [-1 0 1; -2 0 2; -1 0 1];

sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];

gx = conv2(double(gray), sobel_x, 'same');
gy = conv2(double(gray), sobel_y, 'same');

edges = sqrt(gx.^2 + gy.^2);

figure;
subplot(1,2,1); imshow(gray);        title('Image originale')
subplot(1,2,2); imshow(edges, []);   title('Contours Sobel')
% =========================================================
% 5. SEGMENTATION — METHODE OTSU
% =========================================================

gray_double = double(gray);
[counts, ~] = histcounts(gray_double(:), 256);
p = counts / sum(counts);
omega = cumsum(p);
mu = cumsum(p .* (1:256));
mu_t = mu(end);
sigma_b = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega) + eps);
[~, idx] = max(sigma_b);
threshold_otsu = (idx - 1) / 255;
binary_otsu = double(gray)/255 > threshold_otsu;
disp(['Seuil OTSU = ', num2str(idx - 1), ' / 255'])
figure;
subplot(1,2,1); imshow(gray);        title('Original')
subplot(1,2,2); imshow(binary_otsu); title('Segmentation OTSU')


% =========================================================
% 6. SEUILLAGE MANUEL
% =========================================================

seuil_manuel = 128;   
binary_manuel = double(gray)/255 > (seuil_manuel / 255);

figure;
subplot(1,2,1); imshow(gray);          title('Original')
subplot(1,2,2); imshow(binary_manuel); title(['Manuel (seuil = ', num2str(seuil_manuel), ')'])