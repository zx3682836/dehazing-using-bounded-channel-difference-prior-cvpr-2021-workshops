function dark_channel = get_dark_channel(image, win_size)

[m, n, ~] = size(image);

pad_size = floor(win_size/2);

padded_image = padarray(image, [pad_size pad_size], Inf);

dark_channel = zeros(m, n); 

for j = 1 : m
    for i = 1 : n
        patch = padded_image(j : j + (win_size-1), i : i + (win_size-1), :);
%         patch1 = padded_image(j + 7 : j - 7 + (win_size-1), i + 7 : i - 7+ (win_size-1), :);
%         patch2 = padded_image(j + 5 : j - 5 + (win_size-1), i + 5 : i - 5+ (win_size-1), :);
%         patch3 = padded_image(j + 3 : j - 3 + (win_size-1), i + 3 : i - 3+ (win_size-1), :);
%         patch4 = padded_image(j + 1 : j - 1 + (win_size-1), i + 1 : i - 1+ (win_size-1), :);
% 
%         dark_channel(j,i) = 0.2*min(patch(:))+0.2*min(patch1(:))...
%         +0.2*min(patch2(:))+0.2*min(patch3(:))+0.2*min(patch4(:));
%         patch = padded_image(j + 7 : j - 7 + (win_size-1), i + 7 : i - 7+ (win_size-1), :);
        dark_channel(j,i) = min(patch(:));
%         patch2 = patch(5:11,5:11,:);
%         patch3 = patch(7:9,7:9,:);
%         patch4 = patch(6:10,6:10,:);
%         patch5 = patch(8,8,:);
%         dark_channel(i,j) = 0.1*min(patch(:))+0.3*min(patch2(:))+0.3*min(patch3(:))...
%         +0.2*min(patch4(:))+0.1*min(patch5(:));
     end
end

end