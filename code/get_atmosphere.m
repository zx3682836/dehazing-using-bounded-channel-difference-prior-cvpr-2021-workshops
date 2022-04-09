function atmosphere = get_atmosphere(image, dark_channel)
% image = imresize(image,0.2);
% dark_channel = imresize(dark_channel,0.2);

[m, n, ~] = size(image);
n_pixels = m * n;

n_search_pixels = floor(n_pixels * 0.001);

dark_vec = reshape(dark_channel, n_pixels, 1);

image_vec = reshape(image, n_pixels, 3);

[~, indices] = sort(dark_vec, 'descend');

accumulator = zeros(1, 3);

for k = 1 : n_search_pixels
    accumulator = accumulator + image_vec(indices(k),:);
end

atmosphere = accumulator / n_search_pixels;

end