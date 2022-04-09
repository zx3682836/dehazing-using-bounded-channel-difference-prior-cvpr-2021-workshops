function Radiance = exal_func(img)

img = im2double(img);
img = min(max(img,0.00001),0.99999);

% patch_size = 21;
% patch_size2 = 10;
% gramma = 1.0;

[rows,cols,~] = size(img);

patch_size = 21;
if (min(rows,cols)<300)
patch_size = 11;
end
patch_size2 = 3;
gramma = 1.0;


rows2 = rows;
cols2 = cols;

img = padarray(img,[21 - mod(rows,patch_size)+patch_size,21 - mod(cols,patch_size)+patch_size ],'replicate','post');
[rows,cols,~] = size(img);

img2 = imresize(img,1);
dark_channel = get_dark_channel(img2, 15);
A_global = get_atmosphere(img2, dark_channel);

% A_global = (estimate_airlight(im2double(img).^(gramma)));

% [R,G,B] = extimate_airlight(img,patch_size,patch_size2);
% A_global = [R,G,B] ;

% A_global = [0.94, 0.97, 0.986]; % 32 ¡Ì 2.5
% A_global = [0.65, 0.7, 0.71]; % 33 1.5
% A_global = [0.9, 0.97, 0.988]; % 34 
% A_global = [ 0.755, 0.77, 0.77]; % 35 ¡Ì
% A_global = [0.67, 0.67, 0.66]; % 36 ¡Ì
% A_global = [0.76 ,0.724 ,0.62]; % 37 ¡Ì
% A_global = [0.81, 0.81, 0.82]; % 38 ¡Ì
% A_global = [0.8, 0.8, 0.816]; % 30 ¡Ì ÔöÇ¿
% A_global = [0.46 ,0.57 ,0.8]; % 44 ¡Ì 
% A_global = [0.77 ,0.77 ,0.75]; % 45 ¡Ì ÔöÇ¿
% A_global = [0.95, 1.01, 1.05]; % 46
% A_global = [0.73, 0.8, 0.92]; % 51
% A_global = [0.617, 0.73, 0.883]; % 52 ¡Ì 
% A_global = [0.666, 0.936 ,1.08]; % 57¡Ì
% A_global = [ 0.575, 0.6125 ,0.7]; % 58 ¡Ì
% A_global = [0.67 ,0.72 ,0.825]; % 53
% A_global = [0.67 ,0.72 ,0.825]; % 50
% A_global = [1.14, 1.24, 1.32]; % 39 ¡Ì
% A_global = [0.72 ,0.785 ,0.81]; % 43 ¡Ì
% A_global = [0.14 ,0.53, 0.83]; % night
% A_global = [0.63, 0.66, 0.71]; % 54
% A_global = [0.549, 0.75, 0.985]; % 51



% A_global =[0.53 ,0.53 0.53]; % 40 1.5
% A_global =[0.9, 0.93 ,0.935]; % tree_input 1.5

% A = max(img_gri(:));
% A_global = [0.73, 0.8, 0.92];
% A_global = [1,1,1];
% % % 
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
%           i,j
%         if i == 137 && j == 221
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
        
        patch_size3 = floor(31 - min(exp(std(patch(:))*5)*10,21));
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


trans = Matting(trans,img,A_global,patch_size);
trans = guidedfilter(rgb2gray(img), trans, 20, 0.1);

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

end
