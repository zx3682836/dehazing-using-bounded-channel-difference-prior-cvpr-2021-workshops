function output = Matting(trans, img, A, patch_size)

% color_variation_map = abs((img(:,:,1)-img(:,:,2))) + ...
% abs((img(:,:,1)-img(:,:,3))) + ...
% abs((img(:,:,2)-img(:,:,3))) ;
% 
% color_variation_map = abs((img(:,:,1)./A(1)-img(:,:,2)./A(2))) + ...
% abs((img(:,:,1)./A(1)-img(:,:,3)./A(3))) + ...
% abs((img(:,:,2)./A(2)-img(:,:,3)./A(3))) ;

% boundingR = 1 - img(:,:,1)./A(1);
% boundingG = 1 - img(:,:,2)./A(2);
% boundingB = 1 - img(:,:,3)./A(3);
% bounding = max(max(boundingR,boundingG),boundingB);

bounding = 1 - min(min(img(:,:,1)./A(1),img(:,:,2)./A(2)),img(:,:,3)./A(3));
output = zeros(size(trans));

% figure,imshow(bounding);
[rows,cols,~] = size(img);
para_weighting = 30;
for i = 1:rows
    for j = 1:cols
%     if j == cols
%         xxx = 0
%     end

%     if (trans(i,j) ~= 0)
%         output(i,j) = trans(i,j);
%         continue
%     end
    
    %求出周围有透射率的像素点的坐标
    %搜索半径为30
%     up = max(1,i-30);
%     down = min(rows,i+30);
%     left = max(1, j-30

    index_i = floor(i./patch_size )*patch_size + floor(patch_size/2)+1;
    index_j = floor(j./patch_size )*patch_size + floor(patch_size/2)+1;
    
    if (index_i < 1 || index_i > rows)
         index_i = floor(i./patch_size )*patch_size + 11 - patch_size;
    end    
    if index_j < 1 || index_j > cols
         index_j = floor(j./patch_size )*patch_size + 11 - patch_size;
    end
    
    list(1,:) = [index_i,index_j];
    number = 1;
    local_search_size = 5;
    for search_size_i = -local_search_size:1:local_search_size
        for search_size_j = -local_search_size:1:local_search_size
%             if search_size_i == 0 && search_size_j == 0
%                 continue
%             end
            temp_index_i = search_size_i*patch_size + index_i;
            temp_index_j = search_size_j*patch_size + index_j;
            if (temp_index_i >= 1 && temp_index_i<= rows && temp_index_j >= 1 && temp_index_j<= cols)
            number = number + 1;
            list(number,:) = [temp_index_i,temp_index_j];
            end    
        end
    end
%     list
    %根据坐标 和bounding图，求出相应的像素加权
    %双边上采样
    value_sum = 0;
    weighting_sum = 0;
    center_value = bounding(i,j);
    
    for k = 1:1:number
        temp_index = list(k,:);
%         temp_index
        temp_value = bounding(temp_index(1),temp_index(2));
        distance = abs(temp_value - center_value);
%         distance = patch_distance(bounding,i,j,temp_index,3);
%         value_list(k) = (trans(temp_index(1),temp_index(2)));
        tras_temp_value = min(trans(temp_index(1),temp_index(2)),trans(index_i,index_j));
%         tras_temp_value = trans(temp_index(1),temp_index(2));
        value_sum = value_sum + exp(para_weighting*-distance) * tras_temp_value;
        weighting_sum = weighting_sum + exp(para_weighting*-distance);
    end
    final_trans_value = value_sum./weighting_sum;
%     output(i,j) = min(final_trans_value,trans(index_i,index_j));
    output(i,j) = final_trans_value;
%     output(i,j) = (final_trans_value + mean(value_list(:)))/2;
    
    end 
end


end

function distance = patch_distance(bounding,i,j,temp_index,patch_size)
[rows,cols,~] = size(bounding);

up = max(1,i-patch_size);
down = min(rows,i+patch_size);
left = max(1, j-patch_size);
right = max(cols, j+patch_size);
patch_1 = bounding(up:down,left:right);

up = max(1,temp_index(1)-patch_size);
down = min(rows,temp_index(1)+patch_size);
left = max(1, temp_index(2)-patch_size);
right = max(cols, temp_index(2)+patch_size);
patch_2 = bounding(up:down,left:right);

diff = (abs(patch_1 - patch_2));
distance = norm(diff(:),1)./(patch_size.^2);

end