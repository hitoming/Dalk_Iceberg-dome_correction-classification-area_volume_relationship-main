% % Extract features from GLCM (Gray Level Co-occurrence Matrix).
% % entropy, contrast, correlation, energy, and homogeneity

function rgb_fea = rgb_features2(training_matrix, rgb_image, segments)

    rgb_fea = [];
    % for i = 1:2
    for i = 1:size(training_matrix, 1)
        segment_value = training_matrix(i, 4); 
        mask2 = (segments == segment_value);
        
        gray_image = rgb2gray(rgb_image);       
        gray_image_double = double(gray_image);
        masked_gray_image = gray_image_double(mask2);      
        glcm_image = NaN(size(mask2), 'like', gray_image_double);     
        glcm_image(mask2) = masked_gray_image;
        glcm_image(glcm_image == 0) = NaN;    
        offsets = [0 1; -1 1; -1 0; -1 -1]; 
        glcm = graycomatrix(glcm_image, 'Offset', offsets, 'Symmetric', true, ...
                            'NumLevels', 256, 'GrayLimits', [1 256]);
        
        stats = graycoprops(glcm, {'contrast', 'correlation', 'energy', 'homogeneity'});
        
        contrast_avg = mean(stats.Contrast);
        correlation_avg = mean(stats.Correlation);
        energy_avg = mean(stats.Energy);
        homogeneity_avg = mean(stats.Homogeneity);
        
        entropy_vals = zeros(size(glcm, 3), 1);
        for i = 1:size(glcm, 3)
            glcm_norm = glcm(:, :, i) / sum(sum(glcm(:, :, i)));
            entropy_vals(i) = -sum(nonzeros(glcm_norm .* log2(glcm_norm + eps))); 
        end
        entropy_avg = mean(entropy_vals); 

        feature = [entropy_avg, ...
                   contrast_avg, correlation_avg, energy_avg, homogeneity_avg];
        rgb_fea = [rgb_fea; feature];
    
    end
