---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
The code used in the following study:
“Characterizing Nearshore Icebergs in front of the Dalk Glacier, East Antarctica by UAV Observation.”

This repository contains MATLAB scripts for processing and analyzing remote sensing data, particularly in relation to Digital Elevation Models (DEM) and land cover classification. The project is divided into three main modules:
	Dome Effect Processing (dome/): Run scripts to process Dome Effect in DEM data

	Land Cover Classification (classification/): Use main1.m for segmentation, then main2.m for classification

	Iceberg Area-Volume Analysis (area_volume/): Run scripts to analyze iceberg area-volume relationships
![image](https://github.com/hitoming/Dalk_Iceberg-dome_correction-classification-area_volume_relationship-main/blob/master/flow.png)

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

Folder Structure and Code Descriptions
------------------------------------------------------------------------------------------
1. Dome Effect Processing (dome/)

	This module focuses on fitting a Dome Effect in DEM data. The workflow includes:

	Data processing

	Surface fitting

	Residual analysis

	Output of results
------------------------------------------------------------------------------------------
2. Land Cover Classification (classification/)

	This module provides MATLAB scripts for land cover classification using superpixel segmentation and machine learning.

Main Scripts:

	main1.m: Superpixel segmentation and feature extraction

	Data : Performs superpixel segmentation to reduce computational complexity

	Visualizes the boundaries of segmentation results

main2.m: Feature selection and Random Forest classification

	Selects and normalizes key features from RGB and DEM data

	Trains a Random Forest model for classification

	Predicts land cover classes and maps them back to the segmentation results

	Saves classification results
------------------------------------------------------------------------------------------
3. Iceberg Area-Volume Analysis (area_volume/)

	This module examines the relationship between iceberg area and volume using log-log coordinate transformations.

	Datasets: UAV-Dalk data and model data

	Applies logarithmic transformation and linear regression

	Computes slope (b), intercept (log(a)), R², and RMSE

	Calculates a 95% confidence interval

	Visualizes the results: UAV data in blue, Model data in red
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
	Requirements:MATLAB

	Required toolboxes for image processing and machine learning

	Data files: DOM, DEM, roi.shp, UAV data, and model data


Clone the repository: https://github.com/hitoming/Dalk_Iceberg-dome_correction-classification-area_volume_relationship-main.git

License:This project is open-source under the MIT License.

Contact：For any questions or collaboration inquiries, please contact  nongmy@mail2.sysu.edu.cn .
