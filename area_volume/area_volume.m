
%% -------------------------------------------------------------------------
% % Relationship between the area and volume of  icebergs by fitting a power-law model 
% % Compare iceberg data between UAV measurements and model.
% % Author: Nong Mingyue (Sun yat-sen University)
% % Email: nongmy@mail2.sysu.edu.cn
% % Updated: 2025-03-20
% % Key Functions:
% % Two datasets: UAV-Dalk data and model data.
% % Logarithmic Transformation and Fitting:
% %      Transforms area and volume data to log-log space for linear regression
% %      Calculates the slope (b), intercept (log10(a)),  R² , RMSE.
% % Confidence Interval Calculation：confidence interval, 95% 
% % Visualization:Blue:UAV data  & Red:Model data
% % 
% % save with High-Resolution 
% ------------------------------------------------------------------------

clc; clear; close all;
%% Datasets 1 :UAV data.

[~, sheetNames] = xlsfinfo("data.xlsx");
disp(sheetNames);
data = readtable("data.xlsx", 'Sheet', sheetNames{2});
[~, idx] = maxk(data.Shape_Area,0);
data_cleaned = data;
data_cleaned(idx, :) = [];
area = data_cleaned.Shape_Area;
volume = data_cleaned.volume_all;                                                                                                                                                             

[x1, sort_idx] = sort(area);
y1 = volume(sort_idx);
log10_x = log10(x1);
log_x = log(x1);
log10_y = log10(y1);

%% Logarithmic Transformation and Fitting
p = polyfit(log10_x, log10_y, 1);
y_fit = polyval(p, log10_x);
slope = p(1);
intercept = p(2);
R_squared = 1 - sum((log10_y - polyval(p, log10_x)).^2) / ...
    sum((log10_y - mean(log10_y)).^2);
RMSE = sqrt(mean((log10_y - y_fit).^2));
% disp(['RMSE: ', num2str(RMSE)]);

%% Confidence Interval Calculation
n = length(x1);
X = [ones(n, 1), log10_x]; 
b = X \ log10_y; 
y_pred = X * b;
residuals = log10_y - y_pred;
sigma = sqrt(sum(residuals.^2) / (n - 2));
alpha = 0.05;
t_val = tinv(1 - alpha / 2, n - 2); 
C = inv(X' * X); 
conf_int = t_val * sigma * sqrt(diag(X * C * X')); 
y_upper = y_pred + conf_int;
y_lower = y_pred - conf_int;
x_plot = 10.^(log10_x);
y_fit_plot = 10.^(y_pred);
y_upper_plot = 10.^(y_upper);
y_lower_plot = 10.^(y_lower);

%%  Visualization
size_set = 8;
xgap_set = 0.1;
fig = figure('units', 'centimeters', 'position', [10, 10, 7, 5]);
hold on;
fill([x_plot; flipud(x_plot)], [y_upper_plot; flipud(y_lower_plot)], [1 1 0.2], 'EdgeColor', 'none', 'FaceAlpha', 0.5); % 置信区间
scatter(x1, y1, size_set , 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', 0.9, ...
        'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.6, 'DisplayName', 'data');
plot(x_plot, y_fit_plot, 'b-', 'LineWidth', 0.5);
set(gca, 'XScale', 'log', 'YScale', 'log');
xticks(10.^(floor(log10(min(area))):ceil(log10(max(area)))));
yticks(10.^(floor(log10(min(volume))):ceil(log10(max(volume)))));
xticklabels(arrayfun(@(x) sprintf('10^{%d}', x), floor(log10(min(area))):ceil(log10(max(area))), 'UniformOutput', false));
yticklabels(arrayfun(@(x) sprintf('10^{%d}', x), floor(log10(min(volume))):ceil(log10(max(volume))), 'UniformOutput', false));
grid on;
set(gca, 'FontName', 'Times New Roman', 'FontSize', size_set);
text('Units', 'normalized', 'Position', [xgap_set, 0.95], ...
    'String',  'UAV Survey', ...
    'FontSize', size_set, 'FontWeight', 'bold', 'Color', 'b');
text('Units', 'normalized', 'Position', [xgap_set, 0.86], ...
    'String', sprintf('log10(V) = %.2f × log10(A) + %.2f', slope, intercept), ...
    'FontSize', size_set, 'Color', 'b');
% 还原系数
% % a = 10^intercept;
% % text('Units', 'normalized', 'Position', [xgap_set, 0.86], ...
% %     'String', sprintf('V = %.2f A^{%.2f}', a, slope), ...
% %     'FontSize', size_set, 'Color', 'b');
text('Units', 'normalized', 'Position', [xgap_set, 0.78], ...
    'String', sprintf('R^2 = %.2f', R_squared), ...
    'FontSize', size_set, 'Color', 'b');
hold on;

%% Datasets 2 : model data.
data = readtable("data.xlsx", 'Sheet', sheetNames{1});
[~, idx] = maxk(data.Shape_Area,0);
data_cleaned = data;
data_cleaned(idx, :) = [];
area = data.Shape_Area;
volume = data.volume_all;                                                                                                                                                             
[x2, sort_idx] = sort(area);
y2 = volume(sort_idx);
log10_x = log10(x2);
log10_y = log10(y2);

%% Logarithmic Transformation and Fitting
p = polyfit(log10_x, log10_y, 1);
y_fit = polyval(p, log10_x);
slope = p(1);
intercept = p(2);
R_squared = 1 - sum((log10_y - polyval(p, log10_x)).^2) / ...
    sum((log10_y - mean(log10_y)).^2);
RMSE = sqrt(mean((log10_y - y_fit).^2));
% disp(['RMSE: ', num2str(RMSE)]);

%% Confidence Interval Calculation
n = length(x2);
X = [ones(n, 1), log10_x]; 
b = X \ log10_y;
y_pred = X * b; 
residuals = log10_y - y_pred;
sigma = sqrt(sum(residuals.^2) / (n - 2)); 
alpha = 0.05;
t_val = tinv(1 - alpha / 2, n - 2);
C = inv(X' * X); 
conf_int = t_val * sigma * sqrt(diag(X * C * X')); 
y_upper = y_pred + conf_int;
y_lower = y_pred - conf_int;
x_plot = 10.^(log10_x);
y_fit_plot = 10.^(y_pred);
y_upper_plot = 10.^(y_upper);
y_lower_plot = 10.^(y_lower);

%%  Visualization
fill([x_plot; flipud(x_plot)], [y_upper_plot; flipud(y_lower_plot)], [0.4 0.4 0.4], 'EdgeColor', 'none', 'FaceAlpha', 0.5); % 置信区间
scatter(x2, y2,size_set *2, 'MarkerEdgeColor', 'k', 'MarkerEdgeAlpha', 0.9, ...
        'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.6, 'DisplayName', 'data');
plot(x_plot, y_fit_plot, 'r-', 'LineWidth', 0.5); 
set(gca, 'XScale', 'log', 'YScale', 'log');
xticks(10.^(floor(log10(min(area))):ceil(log10(max(area)))));
yticks(10.^(floor(log10(min(volume))):ceil(log10(max(volume)))));
xticklabels(arrayfun(@(x) sprintf('10^{%d}', x), floor(log10(min(area))):ceil(log10(max(area))), 'UniformOutput', false));
yticklabels(arrayfun(@(x) sprintf('10^{%d}', x), floor(log10(min(volume))):ceil(log10(max(volume))), 'UniformOutput', false));
set(gca, 'FontSize', size_set, 'FontName', 'Times New Roman','FontWeight', 'bold');
set(gca,'FontName','Times New Roman','FontSize',8,'FontWeight','bold',...
    'XMinorTick','on','XScale','log','XTick',...
    [100 1000 10000 100000 1000000 10000000],'XTickLabel',...
    {'10^{2}','10^{3}','10^{4}','10^{5}','10^{6}','10^{7}'},'YMinorTick','on',...
    'YScale','log','YTick',[1000 100000 10000000 1000000000],'YTickLabel',...
    {'10^{3}','10^{5}','10^{7}','10^{9}'});
xlabel('Area (m^2)', 'Interpreter', 'tex', 'FontWeight', 'bold');
ylabel('Volume (m^3)', 'Interpreter', 'tex','FontWeight', 'bold');
grid on;
set(gca, 'FontSize', size_set);
text('Units', 'normalized', 'Position', [xgap_set, 0.68], ...
    'String',  'Ocean Model', ...
    'FontSize', size_set, 'FontWeight', 'bold','Color', 'r');
text('Units', 'normalized', 'Position', [xgap_set, 0.59], ...
    'String', sprintf('log10(V) = %.2f × log10(A) + %.2f', slope, intercept), ...
    'FontSize', size_set, 'Color', 'r');
% 还原系数
% % a = 10^intercept;
% % text('Units', 'normalized', 'Position', [xgap_set, 0.59], ...
% %     'String', sprintf('V = %.2f A^{%.2f}', a, slope), ...
% %     'FontSize', size_set, 'Color', 'r');
text('Units', 'normalized', 'Position', [xgap_set, 0.51], ...
    'String', sprintf('R^2 = %.2f', R_squared), ...
    'FontSize', size_set, 'Color', 'r');

hold off;


%% save with High-Resolution 
target_width_cm = 7; 
target_height_cm = 5;
dpi = 600; 
pixels_per_cm = dpi / 2.54;
width_pixels = round(target_width_cm * pixels_per_cm); 
height_pixels = round(target_height_cm * pixels_per_cm); 
set(fig, 'PaperPositionMode', 'auto'); 
set(fig, 'Position', [10, 10, width_pixels / dpi * 2.54, height_pixels / dpi * 2.54]);
axis tight; 
set(gca,'FontName', 'Times New Roman', 'LooseInset', [0, 0, 0, 0]); 
save_folder = pwd; 
% % manually adjust the figure before saving it
% save_filename = fullfile(save_folder, 'fig.png');
% print(fig, save_filename, '-dpng', sprintf('-r%d', dpi));

