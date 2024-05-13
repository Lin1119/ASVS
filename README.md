Package for A Spatially Varying Scaling Method (ASVS) for InSAR Tropospheric Corrections

1. Overview 

A spatially varying scaling method (ASVS) for InSAR tropospheric corrections is developed to address a
major limiting factor in Interferometric Synthetic Aperture Radar (InSAR) measurements, that of variable delay
through the troposphere. This approach combines the use of both external weather model data and the
interferometric phase, which has overcome the limitations of using either approach individually.
The distributed ASVS package consists matlab scripts only and is compatible with the StaMPS software and
the TRAIN. The package can also be applied to individual interferograms output from any InSAR software.

Any feedback is welcomed by sending emails to lshen@ldeo.columbia.edu

2. Configuration

2.1 Matlab

The ASVS package has been developed based on Matlab 2018, whereas it is expected to run without large
problems with other versions.

2.2 StaMPS

The ASVS package is compatible with the StaMPS software version 4.0 and could recognize the StaMPS
structure to extract required parameters of interferograms.

2.3 TRAIN

The ASVS package is integrated with the TRAIN version 1beta and could extract tropospheric delays
computed from the external weather model data using the TRAIN automatically.

3. Data preparation

As the ASVS package is independent of any processor of InSAR and InSAR tropospheric correction,
interferometric phase and tropospheric delay phase estimated from the external weather model data should
be provided in advance. A DEM file, a Lon-Lat coordinates file, and other required parameters should be
prepared by users as well. If users process the InSAR with the StaMPS software and use the TRAIN to
compute tropospheric delays from the external weather model data, most of the required processing
parameters can be automatically extracted based on the files of the StaMPS and the TRAIN.
All required parameters should be stored in a Matlab matrix named as parms_ASVS.mat, which an example
of this matrix is included in the package. Please refer to the manual document 'ASVS_Manual.pdf' included in the package for more detailed information about each processing parameter.

4. Programs

4.1 Installation

After unzipping the zipfile of the ASVS package at YOURPATH, to source functions in the sub-folder named
‘functions’, users should be able to run the following command in Matlab. This takes 1-3 minutes to build on a "normal" desktop computer. 
> addpath(‘YOURPATH/ASVS/functions’);

4.2 Step 1 - getting a grid overlapped with the ROI

A grid overlapped with the ROI is generated in step 1 as ‘step1_get_grid.m’. Users may need to run this
step for multiple times to adjust the geometry of the grid until it is well-overlapped with the ROI (e.g.,
figure 3a in Shen et al., 2019). Results of this step are saved in a matlab matrix named as
scaling_grid.mat and will be used in the following step 2.

4.3 Step 2 - estimating spatially varying scaling factors

Spatially varying scaling factors are derived in step 2 as ‘step2_run_ASVS.m’. Outputs of this step are
the scaled tropospheric phase delay anomaly of each single epoch and the estimated smoothed spatially
varying scaling factors of every point in the ROI. These final results are saved in a matlab matrix as
ASVS_results.mat. Please refer to the paper (Shen et al., 2019) for more details about the methodology.
Users then could compute the scaled interferometric tropospheric delays and subtract them from
interferometric phase to derive tropospheric corrected interferograms.

5. Demo

The demo included in this package comprises: a Matlab matrix with interferometric phase, 'phuw_sb2', derived from Sentinel-1 data spanning the period between October 2014 to December 2016, covering the Nevados de Chillán Volcano in central Chile; another Matlab matrix with tropospheric delay phase, 'tca_sb2', estimated from HRES-ECMWF weather model data; a Matlab matrix of DEM, 'hgt'; a Matlab matrix of Lon-Lat coordinates, 'll'; and a Matlab matrix with all required parameters, 'parms_ASVS'. 

Running this demo on a "normal" desktop computer typically takes a few seconds.
