function img_ = minimumfilter(img, radius)
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

[rows,cols,~] = size(img);
R_ = zeros([rows,cols]);
G_ = zeros([rows,cols]);
B_ = zeros([rows,cols]);

for i = 1:rows
    for j = 1:cols
        a = max(1 , i - radius);
        b = min(i + radius, rows);
        c = max(1 , j - radius);
        d = min(j + radius, cols);
        patch = R(a:b,c:d);
        minvalue = min(min(patch));
        R_(i,j) = minvalue;
    end
end

for i = 1:rows
    for j = 1:cols
        a = max(1 , i - radius);
        b = min(i + radius, rows);
        c = max(1 , j - radius);
        d = min(j + radius, cols);
        patch = G(a:b,c:d);
        minvalue = min(min(patch));
        G_(i,j) = minvalue;
    end
end

for i = 1:rows
    for j = 1:cols
        a = max(1 , i - radius);
        b = min(i + radius, rows);
        c = max(1 , j - radius);
        d = min(j + radius, cols);
        patch = B(a:b,c:d);
        minvalue = min(min(patch));
        B_(i,j) = minvalue;
    end
end
img_(:,:,1) = R_;
img_(:,:,2) = G_;
img_(:,:,3) = B_;


end