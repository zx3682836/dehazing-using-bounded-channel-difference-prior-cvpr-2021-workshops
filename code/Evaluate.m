
name = 'church_D3'; % road1 road2 flower1 flower2 road1_D3 lawn1_D3 mansion_D3 road1_S10 lawn1_S10 church_S50
name2 = 'church';
haze_free = im2double(imread(['./test/' name '_true.png']));
% haze_free = im2double(imread(['./test/' name '_known.png']));
mask = im2double(imread(['./test/' name2 '_mask.png']));
[rows,cols,~] = size(haze_free);

dcp = im2double(imread(['./test/' name '_dc.png']));
diff = abs(dcp - haze_free).*mask;
sum(diff(:))./(rows*cols*3)

cl = im2double(imread(['./test/' name '_cl.png']));
diff = abs(cl - haze_free).*mask;
sum(diff(:))./(rows*cols*3)


nld = im2double(imread(['./test/' name '_nld.png']));
diff = abs(nld - haze_free).*mask;
sum(diff(:))./(rows*cols*3)


our = im2double(imread(['./test/' name '_cd2.png']));
diff = abs(our - haze_free).*mask;
sum(diff(:))./(rows*cols*3)

% xx = [0.0360
% 0.0452
% 0.0738
% 0.0320
% 0.0427
% 0.0687
% 0.0310
% 0.0385
% 0.0621
% 0.0299
% 0.0334
% 0.0530
% 0.0264
% 0.0375
% 0.0671];
% mean(xx(:))