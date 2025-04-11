
% 获取select_feature矩阵的列数
numFeatures = size(allselect_roifeature, 2);

X_train = allselect_roifeature;

% 提取第3列作为 y_train,就是类别
y_train = training_matrix(:, 3);

% 使用MATLAB的zscore函数进行标准化
X_train_scaled = zscore(X_train);

% 训练随机森林分类器
% MATLAB使用TreeBagger来创建随机森林模型
% % % 指定随机森林中树的数量
% 设置随机数生成器的种子，以便重现结果
rng(45);

nTrees = 100;

% 创建并训练随机森林模型
rfModel = TreeBagger(nTrees, X_train_scaled, y_train, 'OOBPrediction', 'On', ...
                     'Method', 'classification');

% 可视化OutOfBag误差
oobErrorBaggedEnsemble = oobError(rfModel);
figure;
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';

% 将features也进行标准化
% 根据X_train的均值和标准差来转换features
features_mean = mean(X_train, 1);
features_std = std(X_train, 0, 1);
features_scaled = (allselect_feature - features_mean) ./ features_std;

% 使用分类器对所有超像素进行分类
[predicted_labels, scores] = predict(rfModel, features_scaled);
% TreeBagger的predict方法返回一个元胞数组，需要转换为数值
% 将预测的标签从元胞数组转换为数值数组
predictions = str2double(predicted_labels);
save('predictions.mat', 'predictions');

% 假设segments是一个与原始图像大小相同的矩阵，其中每个元素的值表示它属于的超像素标签
% 假设predictions是一个包含预测标签的列向量

% 初始化一个与segments相同尺寸的矩阵来存储分类结果
classified_segments = zeros(size(segments));


% 遍历segments矩阵的每个元素
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
% classified_segments包含了映射回原始segments大小的分类结果

% 现在predicted_labels_map包含了每个像素的预测标签

% 找出所有唯一的类别标签及其数量
unique_labels = unique(classified_segments);
label_counts = histcounts(classified_segments(:), [unique_labels; max(unique_labels)+1]);

% 显示每个类别及其数量                              
for i = 1:length(unique_labels)
    fprintf('Class %d has %d pixels.\n', unique_labels(i), label_counts(i));
end

% 可视化分类后的segments
figure;
imagesc(classified_segments);
title('Classified Segments');
colormap('jet'); % 或者您喜欢的任何颜色图
colorbar;

% 确保classified_segments是正确的数据类型
% 如果不是整数类型，你可能需要进行转换
classified_segments = uint16(classified_segments);

% 创建一个包含地理参考信息的RasterReference对象
spatialRef = info.SpatialRef;

outputFilePath = 'E:\dalk\class_result\cla_test1\class20240513.tif';
% 使用地理参考信息保存TIFF文件
geotiffwrite(outputFilePath, classified_segments, spatialRef, ...
             'CoordRefSysCode', 'EPSG:32743');


% 循环遍历每一个类别，从1到6
for i = 1:6
    % 创建一个只包含当前类别i的矩阵
    class_i = classified_segments == i;

    % 定义输出文件路径，这里假设输出文件夹为'output'
    outputFilePathi = sprintf('E:\\dalk\\class_result\\cla_test1\\class_%d.tif', i);


    % 保存当前类别的TIFF文件
    geotiffwrite(outputFilePathi, uint16(class_i), spatialRef, ...
                 'CoordRefSysCode', 'EPSG:32743');
end



% 假设 classified_segments 已经是 uint16 类型
% 提取类别1的区域
class_1 = classified_segments == 1;

% 创建一个结构元素，这里使用3x3的方形结构元素
se = strel('square',51);

% 对类别1进行腐蚀操作
eroded_class_1 = imerode(class_1, se);

% 对腐蚀后的结果进行膨胀操作
dilated_class_1 = imdilate(eroded_class_1, se);

% 如果需要保存处理后的结果，继续使用geotiffwrite
outputFilePath = 'E:\\dalk\\class_result\\cla_test1\\class_1_processed51.tif';
geotiffwrite(outputFilePath, uint16(dilated_class_1), spatialRef, ...
             'CoordRefSysCode', 'EPSG:32743');
