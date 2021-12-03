function output = Interpolation(trans, img, A, patch_size)

bounding = 1 - min(min(img(:,:,1)./A(1),img(:,:,2)./A(2)),img(:,:,3)./A(3));
output = zeros(size(trans));

[rows,cols,~] = size(img);
para_weighting = 100;
for i = 1:rows
    for j = 1:cols

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

            temp_index_i = search_size_i*patch_size + index_i;
            temp_index_j = search_size_j*patch_size + index_j;
            if (temp_index_i >= 1 && temp_index_i<= rows && temp_index_j >= 1 && temp_index_j<= cols)
            number = number + 1;
            list(number,:) = [temp_index_i,temp_index_j];
            end    
        end
    end

    value_sum = 0;
    weighting_sum = 0;
    center_value = bounding(i,j);
    
    for k = 1:1:number
        temp_index = list(k,:);
        temp_value = bounding(temp_index(1),temp_index(2));
        distance = abs(temp_value - center_value);
        tras_temp_value = min(trans(temp_index(1),temp_index(2)),trans(index_i,index_j));
        value_sum = value_sum + exp(para_weighting*-distance) * tras_temp_value;
        weighting_sum = weighting_sum + exp(para_weighting*-distance);
    end
    final_trans_value = value_sum./weighting_sum;
    output(i,j) = final_trans_value;
    end 
end
end

