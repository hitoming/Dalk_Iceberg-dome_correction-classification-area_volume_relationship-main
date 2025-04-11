function training_matrix = roi2matrix(info,roipath)

    % 目的是为了将roi的点在DOM数据里面的行列号提取出来
    % 然后再根据行列号提取点在其分割后的图像的id
    
    [shapeStruct, shapeAttributes] = shaperead(roipath);
    pixelWidth = info.PixelScale(1);  % 像素宽度，通常对应东西方向的大小
    pixelHeight = info.PixelScale(2); % 像素高度，通常对应南北方向的大小
    
    % 初始化一个结构数组来存储训练点
    training_points = struct('Row', {}, 'Column', {}, 'Attributes', {});
    
    % 循环每个点，检查是否在栅格范围内
    for k = 1:length(shapeStruct)
        x = shapeStruct(k).X;
        y = shapeStruct(k).Y;
    
        % 根据栅格的BoundingBox确定点是否在栅格范围内
        if x >= info.BoundingBox(1,1) && x <= info.BoundingBox(2,1) && ...
                y >= info.BoundingBox(1,2) && y <= info.BoundingBox(2,2)
    
            % 将地理坐标转换为栅格的行列号
            col = floor((x - info.BoundingBox(1,1)) / pixelWidth) + 1;
            row = floor((info.BoundingBox(2,2) - y) / pixelHeight) + 1;
    
            % 存储信息
            training_points(end+1).Row = row;
            training_points(end).Column = col;
            training_points(end).Attributes = shapeAttributes(k);
        end
    end
    % 初始化一个有427行3列的矩阵，427是您提供的struct数组的长度
    numPoints = length(training_points);
    training_matrix = zeros(numPoints, 3);

    % 填充矩阵
for k = 1:numPoints
    training_matrix(k, 1) = training_points(k).Row; % 行号
    training_matrix(k, 2) = training_points(k).Column; % 列号
    training_matrix(k, 3) = str2double(training_points(k).Attributes.CLASS_ID); % CLASS_ID，转换为数值
end

%%