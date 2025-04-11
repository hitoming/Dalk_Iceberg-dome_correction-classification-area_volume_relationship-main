
%%   -------------------------------------------------------------------------
% %  -------------------land cover classification demo2 ------------------------
% %  feature selection and Random Forest (RF) classification
% % Author: Nong Mingyue (Sun yat-sen University)
% % Email: nongmy@mail2.sysu.edu.cn
% % Updated: 2025-03-20
% % Key Functions:
% % Feature Selection
% %         Select key features from the extracted RGB and DEM features and normalize them.
% %         Generate training data X_train and corresponding category labels y_train.
% % Classification Model Training (Random Forest)
% % Classification Prediction
% %         Normalize the features of all superpixels and use the trained Random Forest model to make predictions.
% %         Map the predicted classes back to the original superpixel segmentation to generate a classified image.
% % Saving Classification Results
% ------------------------------------------------------------------------

%% Features select
% % % There are many extracted features, and select some selection based on the actual situation.
all_roifeature = horzcat(rgb_feature1, rgb_feature2, dem_feature);
all_roifeature = normalize(all_roifeature, 'range');
allselect_roifeature = all_roifeature(:, [1, 3, 4, 5, 9, 10]);
categories = training_matrix(:, 3);
all_features = horzcat(allrgb_feature1, allrgb_feature2, alldem_feature);
all_features = normalize(all_features, 'range');
allselect_feature =all_features(:, [1, 3, 4, 5, 9, 10]);
% save('allselect_feature.mat', 'allselect_feature');

%%  Classification
numFeatures = size(allselect_roifeature, 2);
X_train = allselect_roifeature;
y_train = training_matrix(:, 3);
X_train_scaled = zscore(X_train);
rng(45);
nTrees = 100;
rfModel = TreeBagger(nTrees, X_train_scaled, y_train, 'OOBPrediction', 'On', ...
                     'Method', 'classification');

oobErrorBaggedEnsemble = oobError(rfModel);
figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';
features_mean = mean(X_train, 1);
features_std = std(X_train, 0, 1);
features_scaled = (allselect_feature - features_mean) ./ features_std;
[predicted_labels, scores] = predict(rfModel, features_scaled);
predictions = str2double(predicted_labels);
classified_segments = zeros(size(segments));
for row = 1:size(segments, 1)
    for col = 1:size(segments, 2)
         temp = segments(row, col);
         for i =1: size(predictions)
             if temp==i
                 classified_segments(row, col)=predictions(i);
             end
         end
    end
end
save('classified_segments.mat', 'classified_segments');
% predicted_labels_map： predicted label for each pixel.
unique_labels = unique(classified_segments);
% % label_counts = histcounts(classified_segments(:), [unique_labels; max(unique_labels)+1]);
classified_segments = uint16(classified_segments);
spatialRef = info.SpatialRef;
outputFilePath = 'E:\class.tif';
geotiffwrite(outputFilePath, classified_segments, spatialRef, ...
             'CoordRefSysCode', 'EPSG:32743');