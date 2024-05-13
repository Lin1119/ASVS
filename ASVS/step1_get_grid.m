function []=step1_get_grid(parms_ASVS)
% A spatially varying scaling method (ASVS) for InSAR tropospheric corrections
% Step 1 - getting a grid overlapped with the ROI

% INPUTS:
% parms_ASVS ------- parameters matrix

% By Lin Shen -- University of Leeds
% eels@leeds.ac.uk

parms=parms_ASVS;
stamps_processed = parms.stamps_processed;

%loading the data
if strcmp(stamps_processed,'y')
   fprintf('Stamps processed structure \n');
   load phuw_sb2.mat
   load ps2.mat
else
    fprintf('loading external data \n');
    ph_uw=load(parms.phuw_file);
    ph_uw=ph_uw.phuw_sb2;
    lonlat=load(parms.ll_file);
    lonlat=lonlat.ll;
end

% getting UTM coordinates in km for every point
utm_zone=parms.utm_zone;
utmxy=get_utm(lonlat,utm_zone);

% running this step for multiple times to adjust the grid 
heading_InSAR=parms.heading_InSAR;
win_size=parms.win_size;
x_min=parms.x_min;
x_max=parms.x_max;
y_min=parms.y_min;
y_max=parms.y_max;
[grid_index,cenutm]=adjust_grid(ph_uw,heading_InSAR,utmxy,win_size,x_min,x_max,y_min,y_max);

save scaling_grid.mat grid_index cenutm utmxy 
end
