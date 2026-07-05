---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------
The code used in the following study:
“Characterizing Nearshore Icebergs in front of the Dalk Glacier, East Antarctica by UAV Observation.”

This repository contains MATLAB scripts for processing and analyzing remote sensing data, particularly in relation to Digital Elevation Models (DEM) and land cover classification. The project is divided into three main modules:
	Dome Effect Processing (dome/): Run scripts to process Dome Effect in DEM data

	Land Cover Classification (classification/): Use main1.m for segmentation, then main2.m for classification

	Iceberg Area-Volume Analysis (area_volume/): Run scripts to analyze iceberg area-volume relationships
![image](https://github.com/hitoming/Dalk_Iceberg-dome_correction-classification-area_volume_relationship-main/blob/main/image/flow.png)

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
------------------------------------------------------------------------------------------
2. Iceberg Area-Volume Analysis (area_volume/)

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

The boundary and geometric data of icebergs are provided. Due to the large data volume, 10m resolution DEM and DOM data are provided for reference. Please contact us via email if you need higher resolution data.
Clone the repository: https://github.com/hitoming/Dalk_Iceberg-dome_correction-classification-area_volume_relationship-main.git

License:This project is open-source under the MIT License.

Contact：For any questions or collaboration inquiries, please contact  nongmy@mail2.sysu.edu.cn .
