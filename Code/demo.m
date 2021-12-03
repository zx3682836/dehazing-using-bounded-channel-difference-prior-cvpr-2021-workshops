close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo script demonstrating the local prior based image dehazing algorithm
% described in the paper:
% Single Image Dehazing Using Bounded Channel Difference Prior. Xuan Zhao, CVPR2021 workshops,
% If you use this code, please cite our paper.
% 
% Author: Xuan Zhao, 2021. 
% 


%% get input image
img = im2double(imread('./images/12.png'));
img = max(img,0.00001);


%% center/block patch size selection
[rows,cols,~] = size(img);
rows2 = rows;
cols2 = cols;
if min(rows,cols) <350
patch_size = 11;
patch_size2 = 3;
else
patch_size = 21;
patch_size2 = 7;
end

img = imresize(img,[rows - mod(rows,patch_size)+patch_size,cols - mod(cols,patch_size)+patch_size ]);
[rows,cols,~] = size(img);


gramma = 1.0;

img2 = imresize(img,1);
dark_channel = get_dark_channel(img2, 15);
A_global = get_atmosphere(img2, dark_channel);

% A_global =[0.9, 0.93 ,0.935]; % tree_input 1.5

A_global = A_global.^gramma;

img = real(img.^gramma);

trans = zeros([rows,cols]);
A_img = zeros([rows,cols,3]);
for i = floor(patch_size/2) + 1:floor(patch_size/2)*2 + 1:rows
    for j = floor(patch_size/2) + 1:floor(patch_size/2)*2 + 1:cols

          i,j

        up = max(1,i - patch_size2);
        down = min(rows,i + patch_size2);
        left = max(1,j - patch_size2);
        right = min(cols,j + patch_size2);
        patch = img(up:down,left:right,:);
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
    end
end

boundingR = 1 - img(:,:,1)./A_img(:,:,1);
boundingG = 1 - img(:,:,2)./A_img(:,:,2);
boundingB = 1 - img(:,:,3)./A_img(:,:,3);
bounding = max(max(boundingR,boundingG),boundingB);

trans = Interpolation(trans,img,A_global,patch_size);
trans = guidedfilter(rgb2gray(img), trans, min(round((min(rows,cols))./30),20), 0.1);

Radiance(:,:,1) = min(max((img(:,:,1) - A_img(:,:,1).*(1-trans))./max(trans,0.01),0),1);
Radiance(:,:,2) = min(max((img(:,:,2) - A_img(:,:,2).*(1-trans))./max(trans,0.01),0),1);
Radiance(:,:,3) = min(max((img(:,:,3) - A_img(:,:,3).*(1-trans))./max(trans,0.01),0),1);

Radiance = Radiance.^(1./gramma);

% adj_percent = [0.005, 0.995];
% Radiance = adjust(Radiance,adj_percent);
% 
figure(1),imshow(img);
figure(2),imshow(trans);
figure(3),imshow(Radiance);


