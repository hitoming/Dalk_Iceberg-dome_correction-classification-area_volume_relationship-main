% % Extract features from DEM &  slope

function alldem_fea = alldem_features(N,dem_resampled,slope_image, segments)
    alldem_fea = [];
    for i = 1:N
        segment_value = i; 
        mask3 = (segments == segment_value);
        segment_dem = dem_resampled(mask3);
        segment_demslop = slope_image(mask3);
        mean_dem = mean(segment_dem );
        mean_demslop = mean(segment_demslop);
        feature = [mean_dem,mean_demslop];
        alldem_fea= [alldem_fea; feature];   
    end
