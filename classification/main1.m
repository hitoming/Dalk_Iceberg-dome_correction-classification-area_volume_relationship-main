
%%   -------------------------------------------------------------------------
% %  -------------------land cover classification demo1 ------------------------
% % superpixel segmentation and feature extraction
% % Author: Nong Mingyue (Sun yat-sen University)
% % Email: nongmy@mail2.sysu.edu.cn
% % Updated: 2025-03-20
% % Key Functions:
% % Data: DOM、DEM、roi.shp(A polygon of a point, containing land cover label (labels: 1-6).）
% % Superpixel Segmentation: Perform superpixel segmentation on the DOM image to reduce computational complexity and improve classification accuracy.
% % Boundary Visualization: Overlay the superpixel segmentation boundaries onto the original image for better visualization of segmentation results.
% % Feature Extraction
% ------------------------------------------------------------------------

clear all; clc ;close all;
%% % data：DOM、DEM、roi.shp(A polygon of a point, containing land cover label (labels: 1-6).）
domPath = 'E:\dalk\dalk20191217\dom.tif';
dempath = 'E:\dalk\dalk20191217\dem.tif';
roipath = 'E:\dalk\roi\roi06point.shp';
outputFilePath = 'E:\dalk\class_result\cla_test1\class1.tif';
rgb_image = imread(domPath);
[imgHeight, imgWidth, ~] = size(rgb_image);
info = geotiffinfo(domPath);
% % function training_matrix：extracts the roi-points' corresponding row and column numbers in MATLAB.
training_matrix = roi2matrix(info,roipath);
figure;imshow(rgb_image);title('TIFF Image');
mask = (rgb_image(:,:,1) ~= 0) & (rgb_image(:,:,2) ~= 0) & (rgb_image(:,:,3) ~= 0);

%% super-pixels segementation
[L1,N1]=superpixels(rgb_image,500000,'Compactness',3);
L1(~mask) = 999999;
uniqueLabels = unique(L1); 
N1 = length(uniqueLabels); 
figure;imshow(label2rgb(L1_));title('Superpixel Segmentation ');
% % superpixel segmentation result
% % L: segment label,  N:the number of pixels contained in each label.
[L,N]=mergelabel(L1,N1,rgb_image);
% save('superpixels_data2.mat', 'L', 'N');
% load('superpixels_data2.mat', 'L', 'N');
BW = boundarymask(L);
outline = imdilate(BW, strel('disk', 1)); 
outline_rgb = rgb_image;
red_channel = outline_rgb(:,:,1); 
outline_dilated = uint8(outline * 255); 
outline_rgb(:,:,1) = max(red_channel, outline_dilated);
filename = 'superpixel_segmentation.png'; 
figure;imshow(outline_rgb);
title('Superpixel Segmentation with Red Boundaries');

%% Feature Extraction
[dem_image, R_dem] = imread(dempath);
% % ensure the DEM and DOM grids match
dem_resampled = imresize(dem_image, size(rgb_image(:,:,1)));
slope_image = calculate_slope(dem_resampled , mask);
nonZeroslope = slope_image(slope_image ~= 0);

training_matrix(:, 4) = 0;
% % extract  superpixel label of each poi-point
for k = 1:size(training_matrix, 1)
    row = training_matrix(k, 1);
    col = training_matrix(k, 2); 
    idx = sub2ind([imgHeight, imgWidth], row, col);
    training_matrix(k, 4) = L(idx);
end
segments = L;
unique_segments = unique(segments(:));
features = [];
% % - rgb_image: The RGB image
% % - segments: The segmentation result, where each value represents a region
% % - unique_segments: A list of unique values in the segments
% % - dem_resampled: The resampled elevation data
% % - slope_image: The slope image
% % sample point features
dem_feature = dem_features(training_matrix,dem_resampled,slope_image, segments);
save('demfeature1.mat', 'dem_feature');
rgb_feature1 = rgb_features1(training_matrix,rgb_image,segments);
save('rgbfeature1.mat', 'rgb_feature1');
rgb_feature2 = rgb_features2(training_matrix,rgb_image,segments);
save('rgbfeature2.mat', 'rgb_feature2');
% % all segementationsm features
alldem_feature = alldem_features(N,dem_resampled,slope_image, segments);
save('alldem_feature.mat', 'alldem_feature');
allrgb_fea1 = allrgb_features1(N, rgb_image, segments);
save('allrgb_fea1.mat', 'allrgb_fea1');
allrgb_fea2 = allrgb_features2(N, rgb_image, segments);
save('allrgb_fea2.mat', 'allrgb_fea2');

