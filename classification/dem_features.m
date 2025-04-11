
% % Extract features from DEM &  slope

function dem_fea = dem_features(training_matrix,dem_resampled,slope_image, segments)
    dem_fea = [];
    for i = 1:size(training_matrix, 1)
        segment_value = training_matrix(i, 4); 
        mask3 = (segments == segment_value);
        segment_dem = dem_resampled(mask3);
        segment_demslop = slope_image(mask3);
        mean_dem = mean(segment_dem );
        mean_demslop = mean(segment_demslop);
        feature = [mean_dem,mean_demslop];
        dem_fea= [dem_fea; feature];   
    end
