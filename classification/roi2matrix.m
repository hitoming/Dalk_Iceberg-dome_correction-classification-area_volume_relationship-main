function training_matrix = roi2matrix(info,roipath)

    
    [shapeStruct, shapeAttributes] = shaperead(roipath);
    pixelWidth = info.PixelScale(1);  
    pixelHeight = info.PixelScale(2); 

    training_points = struct('Row', {}, 'Column', {}, 'Attributes', {});

    for k = 1:length(shapeStruct)
        x = shapeStruct(k).X;
        y = shapeStruct(k).Y;

        if x >= info.BoundingBox(1,1) && x <= info.BoundingBox(2,1) && ...
                y >= info.BoundingBox(1,2) && y <= info.BoundingBox(2,2)
            col = floor((x - info.BoundingBox(1,1)) / pixelWidth) + 1;
            row = floor((info.BoundingBox(2,2) - y) / pixelHeight) + 1;

            training_points(end+1).Row = row;
            training_points(end).Column = col;
            training_points(end).Attributes = shapeAttributes(k);
        end
    end

    numPoints = length(training_points);
    training_matrix = zeros(numPoints, 3);

for k = 1:numPoints
    training_matrix(k, 1) = training_points(k).Row; 
    training_matrix(k, 2) = training_points(k).Column; 
    training_matrix(k, 3) = str2double(training_points(k).Attributes.CLASS_ID); 
end
