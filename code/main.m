close all;
clear all;
% 
% 
img_gri = im2double(imread('./image/real-052.png'));
% img_gri = im2double(imread('E:\Dehazing\SOTS\nyuhaze500\hazy/1416_10.png'));
% % img_gri = im2double(imread('E:\Dehazing\SOTS\outdoor\hazy/0097_0.85_0.08.jpg'));
% img_gri = im2double(imread('E:\Dehazing\test2/YST_Bing_667.jpeg'));
% img_gri = im2double(imread('D:\Matlab\Dehazing\Analize_3/test/8.png'));
% % img_gri = im2double(imread('./Challenge/1.jpg'));
% img_gri = im2double(imread('./Airlight/YT_Google_298.jpeg'));
% img_gri = im2double(imread('./Real-world/1411_10.jpg'));
% img_gri = im2double(imread('./test/4.png'));
% img_gri = im2double(imread('./HQ/10.jpg'));
% img_gri = im2double(imread('./Challenge/2.jpg'));
% img_gri = im2double(imread('./去雾处理原始图像/seafog5.png')); %YST_Bing_667

% D:\Matlab\Dehazing\Analize_3\test

% E:\Dehazing\SOTS\nyuhaze500\hazy
% img_gri = min(max(img_gri,0.00001),0.99999);

% img = imresize(img_gri,[300,300]);
img = imresize(img_gri,1);
% [rows,cols,~] = size(img);

% figure,imshow(img);v3
% img = img_gri(200:300,910:1000,:);
% img = img_gri(420:500,600:650,:);
% img = img_gri(120:200,400:500,:);
figure(100),imshow(img);
% figure,imshow(img);
% img_heavy_haze_patch = img(500:520,230:250,:);
% img_heavy_haze_patch = img(350:370,330:350,:);
% figure,imshow(img_heavy_haze_patch);

[rows,cols,~] = size(img);

patch_size = 21;
if (min(rows,cols)<300)
patch_size = 11;
end
patch_size2 = 3;
gramma = 1.0;

rows2 = rows;
cols2 = cols;
% img = imresize(img,[rows - mod(rows,patch_size)+patch_size,cols - mod(cols,patch_size)+patch_size ]);
img = padarray(img,[patch_size - mod(rows,patch_size)+patch_size,patch_size - mod(cols,patch_size)+patch_size ],'replicate','post');
[rows,cols,~] = size(img);

img2 = imresize(img,1);
dark_channel = get_dark_channel(img2, 15);
A_global = get_atmosphere(img2, dark_channel) +0.0;

% A_global = [1,0.6,1];
% A_global = reshape(estimate_airlight(im2double(img).^(1)),1,1,3);

% A_global = (estimate_airlight(im2double(img).^(gramma)));

% [R,G,B] = extimate_airlight(img,patch_size,patch_size2);
% A_global = [R,G,B] ;

% A_global = [0.94, 0.97, 0.986]; % 32 √ 2.5
% A_global = [0.65, 0.7, 0.71]; % 33 1.5
% A_global = [0.9, 0.97, 0.988]; % 34 
% A_global = [ 0.755, 0.77, 0.77]; % 35 √
% A_global = [0.67, 0.67, 0.66]; % 36 √
% A_global = [0.76 ,0.724 ,0.62]; % 37 √
% A_global = [0.81, 0.81, 0.82]; % 38 √
% A_global = [0.8, 0.8, 0.816]; % 30 √ 增强
% A_global = [0.46 ,0.57 ,0.8]; % 44 √ 
% A_global = [0.77 ,0.77 ,0.75]; % 45 √ 增强
% A_global = [0.95, 1.01, 1.05]; % 46
% A_global = [0.73, 0.8, 0.92]; % 51
A_global = [0.617, 0.73, 0.883]; % 52 √ 
% A_global = [0.666, 0.936 ,1.08]; % 57√
% A_global = [ 0.575, 0.6125 ,0.7]; % 58 √
% A_global = [0.67 ,0.72 ,0.825]; % 57
% A_global = [0.67 ,0.72 ,0.825]; % 50
% A_global = [1.14, 1.24, 1.32]; % 39 √
% A_global = [0.72 ,0.785 ,0.81]; % 43 √
% A_global = [0.14 ,0.53, 0.83]; % night
% A_global = [0.63, 0.66, 0.71]; % 54
% A_global = [0.549, 0.75, 0.985]; % 51

% A_global =[0.53 ,0.53 0.53]; % 40 1.5
% A_global =[0.9, 0.93 ,0.935]; % tree_input 1.5

% A = max(img_gri(:));
% A_global = [0.73, 0.8, 0.92];
% A_global = [1,1,1];
% % % % % 
% A_global = [0.5,0.6,1];
% A_global=[0.49, 0.59, 0.76];
% A_global=[0.7, 0.7, 0.7];
% A = [0.783295136236313,0.812375859434683,0.809167303284950];

% 0.9 ,0.93 ,0.935
A_global = A_global.^gramma;

img = real(img.^gramma);

dark_img = minimumfilter(img, 1);

ii = 0;
% dark_img = img;

trans = zeros([rows,cols]);
A_img = zeros([rows,cols,3]);
for i = floor(patch_size/2) + 1:floor(patch_size/2)*2 + 1:rows
    for j = floor(patch_size/2) + 1:floor(patch_size/2)*2 + 1:cols
% i = 137;
% j = 221;
          i,j
%          if i > 160 && i < 200 && j > 60 && j < 100
%                           x = 0
%          end
%         if i <300 || j <300
%             continue
%         end
%         if i == 300 && j == 300
%             x = 0
%         end
%         width_left = max(1,i - 50);
%         width_right = min(rows,i + 50);
%         height_left = max(1,j - 50);
%         height_right = min(cols,j + 50);
%         patch = img(width_left:width_right, height_left:height_right,:);
%         dark_channel_patch = dark_channel(width_left:width_right, height_left:height_right,:);
%         A = get_atmosphere(patch, dark_channel_patch);
%         A = max (A, A_global);
        up = max(1,i - patch_size2);
        down = min(rows,i + patch_size2);
        left = max(1,j - patch_size2);
        right = min(cols,j + patch_size2);
        patch = dark_img(up:down,left:right,:);
%         up = max(1,i - patch_size2*2);
%         down = min(rows,i + patch_size2*2);
%         left = max(1,j - patch_size2*2);
%         right = min(cols,j + patch_size2*2);
%         patch = dark_img(up:2:down,left:2:right,:);
% 
        patch_size3 = 31 - min(exp(std(patch(:))*5)*10,21);
        
        if (min(rows,cols)<300)
        patch_size3 = 9 - min(exp(std(patch(:))*3)*10,6);
        end
        
        patch_size3 = floor(patch_size3);
        up = max(1,i - patch_size3);
        down = min(rows,i + patch_size3);
        left = max(1,j - patch_size3);
        right = min(cols,j + patch_size3);
        patch = dark_img(up:down,left:right,:);

        trans(i,j) = estimate_trans(patch,A_global);
        A_img(i,j,:) = A_global;
        temp = trans(i,j);
        for k_i = -floor(patch_size/2):1:floor(patch_size/2)
            for k_j = -floor(patch_size/2):1:floor(patch_size/2)
                if i+k_i <= rows && j+k_j <= cols
                    trans(i+k_i,j+k_j) = temp;
                    A_img(i+k_i,j+k_j,:) = A_global;
                end
            end
        end

%         up = max(1,i - patch_size2);
%         down = min(rows,i + patch_size2);
%         left = max(1,j - patch_size2);
%         right = min(cols,j + patch_size2);
%         patch = dark_img(up:down,left:right,:);
%         trans(i,j) = estimate_trans(patch,A_global);
%         A_img(i,j,:) = A_global;
%         temp = trans(i,j);
%         for k_i = -floor(patch_size/2):floor(patch_size/2)
%             for k_j = -floor(patch_size/2):floor(patch_size/2)
%                 if i+k_i <= rows && j+k_j <= cols
%                     trans(i+k_i,j+k_j) = temp;
%                     A_img(i+k_i,j+k_j,:) = A_global;
%                 end
%             end
%         end

    end
end

boundingR = 1 - img(:,:,1)./A_img(:,:,1);
boundingG = 1 - img(:,:,2)./A_img(:,:,2);
boundingB = 1 - img(:,:,3)./A_img(:,:,3);
bounding = max(max(boundingR,boundingG),boundingB);

trans = interp(trans,img,A_global,patch_size);
trans = guidedfilter(rgb2gray(img), trans, patch_size - 5, 0.1);

% out = wls_optimization(trans*255, (1 - trans)*255, (img)*255, 0.05 )/255;

% A_img(:,:,1) = guidedfilter(rgb2gray(img), A_img(:,:,1), 20, 0.01);
% A_img(:,:,2) = guidedfilter(rgb2gray(img), A_img(:,:,2), 20, 0.01);
% A_img(:,:,3) = guidedfilter(rgb2gray(img), A_img(:,:,3), 20, 0.01);

% A = A + 0.1;
% Radiance(:,:,1) = min(max((img(:,:,1) - A(1).*(1-trans))./max(trans,0.01),0),1);
% Radiance(:,:,2) = min(max((img(:,:,2) - A(2).*(1-trans))./max(trans,0.01),0),1);
% Radiance(:,:,3) = min(max((img(:,:,3) - A(3).*(1-trans))./max(trans,0.01),0),1);

Radiance(:,:,1) = min(max((img(:,:,1) - A_img(:,:,1).*(1-trans))./max(trans,0.01),0),1);
Radiance(:,:,2) = min(max((img(:,:,2) - A_img(:,:,2).*(1-trans))./max(trans,0.01),0),1);
Radiance(:,:,3) = min(max((img(:,:,3) - A_img(:,:,3).*(1-trans))./max(trans,0.01),0),1);

Radiance = Radiance.^(1./gramma);
Radiance = Radiance(1:rows2,1:cols2,:);

% adj_percent = [0.02, 0.98];
% Radiance = adjust(Radiance,adj_percent);

% figure(4),imshow(Radiance);
figure,imshow(trans);
figure(4),imshow(Radiance);



% imwrite(Radiance,['C:\Users\zx\Desktop\Figures\' '33_result.png']);
% imwrite(trans,['C:\Users\zx\Desktop\Figure.1\' 'trans.png']);

% Radiance = imresize(Radiance,[rows2,cols2]);
% imwrite(Radiance,['./test/' 'church_D3_cd2.png']);

% Radiance = imresize(Radiance,[rows2,cols2]);
% imwrite(Radiance,'test_result.png');

% img_light_haze_patch = img(420:520,700:800,:);
% figure,imshow(img_light_haze_patch);

% x = analy(img_heavy_haze_patch);
% y = analy(img_light_haze_patch);


