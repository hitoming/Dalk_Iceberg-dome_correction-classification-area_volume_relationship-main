%% -------------------------------------------------------------------------
% % The process of fitting a Dome Effect of DEM data  
% % Including data processing, surface fitting, residual analysis, and result output.
% % Author: Nong Mingyue (Sun yat-sen University)
% % Email: nongmy@mail2.sysu.edu.cn
% % Updated: 2025-03-20
% % Key Steps:
% % Datasets: data &  validate data;xls columns:longitude;latitude;dem;longitude2;latitude2;id.
% % Surface Fitting:poly22
% % Result Visualization
% % Save the Dome Effct tif
% % -------------------------------------------------------------------------


clear ;close all;clc;

%% Datasets
% % Fitting data：point_dome.xls & Validation data：point.xls
data = readtable("point_dome.xls");
id = data(:,6);
lon = data(:,1); lat = data(:,2); height = data(:,3);
lon = table2array(lon); lat = table2array(lat); height = table2array(height);
validate_data = readtable('point.xls');
validata_lon = validate_data(:,1); validata_lat = validate_data(:,2); validata_height = validate_data(:,3);
validata_lon = table2array(validata_lon); validata_lat = table2array(validata_lat); validata_height = table2array(validata_height);

%% Surface Fitting 
[xData, yData, zData] = prepareSurfaceData( lon, lat, height );
ft = fittype( 'poly22' );
% % Exclude points with large residuals 
indicesToExclude = find(data{:,6} == 117 | data{:,6} == 66 | data{:,6} == 130| data{:,6} == 5| data{:,6} == 4| data{:,6} == 129| data{:,6} == 118);
excludedPoints = zeros(size(xData));
excludedPoints(indicesToExclude) = 1;

% % least squares method
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Normalize = 'on';
opts.Exclude = excludedPoints;

[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
[xValidation, yValidation, zValidation] = prepareSurfaceData( validata_lon, validata_lat, validata_height );
residual = zValidation - fitresult( xValidation, yValidation );
nNaN = nnz( isnan( residual ) );
residual(isnan( residual )) = [];
sse = norm( residual )^2;
rmse = sqrt( sse/length( residual ) );

%% result
% % Dome Effect
figure( 'Name', 'Dome Effect Surface' );
xlim = [min( [xData; xValidation] ), max( [xData; xValidation] )];
ylim = [min( [yData; yValidation] ), max( [yData; yValidation] )];
h = plot( fitresult, [xData, yData], zData, 'Exclude', excludedPoints, 'XLim', xlim, 'YLim', ylim );
legend( h, 'Dome Effect', 'Sample Point', 'Exclude Point',  'Location', 'NorthEast', 'Interpreter', 'none' );
xlabel( 'X(m)', 'Interpreter', 'none' ,'FontSize',12);
ylabel( 'Y(m)', 'Interpreter', 'none','FontSize',12 );
zlabel( 'Elevation (m)', 'Interpreter', 'none' ,'FontSize',12);
grid on
view( -39.0, 30.0 );

% % Residuals
figure( 'Name', 'Residuals' );
h = plot( fitresult, [xData, yData], zData, 'Style', 'Residual', 'Exclude', excludedPoints, 'XLim', xlim, 'YLim', ylim );
legend( h, 'Residual', 'Exclude Point',  'Location', 'NorthEast', 'Interpreter', 'none' );
xlabel( 'X(m)', 'Interpreter', 'none' ,'FontSize',12);
ylabel( 'Y(m)', 'Interpreter', 'none' ,'FontSize',12);
zlabel( 'Residual (m)', 'Interpreter', 'none' ,'FontSize',12);
grid on
view( -39.0, 30.0 );

% % Dome Effect Contour Map
figure( 'Name', 'Contour Map' );
h = plot( fitresult, [xData, yData], zData, 'Style', 'Contour', 'Exclude', excludedPoints, 'XLim', xlim, 'YLim', ylim );
legend( h, 'Dome Effect', 'Sample Point', 'Exclude Point',  'Location', 'SouthEast', 'Interpreter', 'none' );
xlabel( 'X(m)', 'Interpreter', 'none','FontSize',12 );
ylabel( 'Y(m)', 'Interpreter', 'none' ,'FontSize',12);
grid on
hold on
RMSE = gof.rmse;
rsquare = gof.rsquare;
str = sprintf('RMSE: %.3f\nR^2: %.3f',RMSE,rsquare);
text(max(xData), min(yData), str,'FontSize',10,'FontWeight','bold');
colorbar;
hold off;

%% Save the Fitted Dome Effct tif
% % original DEM ("dem.tif") geographic information
% [origin_DEM,R ] = geotiffread("dem.tif");
% save('DEM_with_geo.mat', 'origin_DEM', 'R');
load('DEM_with_geo.mat', 'origin_DEM', 'R');
[numRows,numCols] = size(origin_DEM);
% % Use the fitted surface to construct new elevation data
% % meshgrid generates Y coordinates from top to bottom; but in geographic data, Y values increase from bottom to top (south to north)
[X, Y] = meshgrid(linspace(R.XWorldLimits(1), R.XWorldLimits(2), numCols), ...
                  linspace(R.YWorldLimits(2), R.YWorldLimits(1), numRows));
Dome_Effect = fitresult(X,Y);
filename = 'dome.tif';
fullfilepath = fullfile(pwd, filename);  
% coordRefSysCode = 32743;
% geotiffwrite(fullfilepath,Dome_Effect,R,"CoordRefSysCode",coordRefSysCode);


