
% % Extract features
% % grayscale image: mean, standard deviation, inverse distance weighted average (IDW), image energy (the mean of squared pixel values) 
% % each superpixel histogram:the weighted average, variance, skewness, kurtosis, mode, median,  slope 
function rgb_fea = rgb_features1(training_matrix, rgb_image, segments)

    rgb_fea = [];
    for i = 1:size(training_matrix, 1)
    % for i = 1:size(training_matrix, 1)
        segment_value = training_matrix(i, 4);
        mask2 = (segments == segment_value);

        gray_image = rgb2gray(rgb_image);
        segment_pixels_gray = gray_image(mask2);
        segment_pixels_gray = double(segment_pixels_gray);

        [rows, cols] = find(mask2);
        

        center_row = mean(rows);
        center_col = mean(cols);
    
        distances = sqrt((rows - center_row).^2 + (cols - center_col).^2);

        distance_weights = 1 ./ (distances + 0.00001);

        gray_mean = mean(segment_pixels_gray);
        gray_std = std(segment_pixels_gray);
        idw_mean = sum(segment_pixels_gray .* distance_weights) / sum(distance_weights); 
        energy = mean(segment_pixels_gray.^2); 
        
        binEdges = linspace(0, 255, 257); 
        binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2; 
        
        histObject = histogram(segment_pixels_gray, 256, 'Normalization', 'probability');
        binEdges = histObject.BinEdges;
        binCenters = (binEdges(1:end-1) + binEdges(2:end)) / 2;
        histogram1 = histObject.Values; 
    
        hist_mean = sum(binCenters .* histogram1);
        hist_variance = var(histogram1);
        hist_skewness = skewness(histogram1);
        hist_kurtosis = kurtosis(histogram1);
        hist_mode = mode(segment_pixels_gray);
        hist_median = median(segment_pixels_gray);
        hist_slope = (histogram1(end) - histogram1(1)) / length(histogram1); % 坡度
    
        feature = [gray_mean, gray_std, idw_mean, energy,...
                    hist_mean, hist_variance, hist_skewness, hist_kurtosis, hist_mode, hist_median, hist_slope];
        rgb_fea = [rgb_fea; feature];
    
    end
