function [] = step2_run_ASVS(parms_ASVS)
% A spatially varying scaling method (ASVS) for InSAR tropospheric corrections
% Step 2 - estimating spatially varying scaling factors

% INPUTS:
% parms_ASVS ------ parameters matrix

% By Lin Shen -- University of Leeds
% eels@leeds.ac.uk

parms=parms_ASVS;
stamps_processed = parms.stamps_processed;
train_processed = parms.train_processed;

% loading the data
if strcmp(stamps_processed,'y')
   fprintf('Stamps processed structure \n');
   load ps2.mat 
   load phuw_sb2.mat
   load hgt2.mat
   load scaling_grid.mat
else
    fprintf('loading external interferograms \n');
    ph_uw=load(parms.phuw_file);
    ph_uw=ph_uw.ph_uw;
    hgt=load(parms.hgt_file);
    hgt=hgt.hgt;
    n_ifg=parms.n_ifg;
    n_image=parms.n_image;
    ifgday_ix=load(parms.ifgday_ix_file);
    ifgday_ix=ifgday_ix.ifgday_ix;
    load scaling_grid.mat
end

if strcmp(train_processed,'y')
   fprintf('TRAIN processed structure \n');
   load tca_sb2.mat
   
else
    fprintf('loading external tropospheric delays \n');
    ph_tropo_era=load(parms.ph_tropo_era_file);
    ph_tropo_era=ph_tropo_era.ph_tropo_era;
end
% inverting InSAR phase anomalies and tropospheric delay anomalies in single epoch
[ph_InSAR,ph_tropo]=get_anomaly(ph_uw,ph_tropo_era,n_ifg,n_image,ifgday_ix);

% estimating spatially varying scaling factors for every point and scale the tropospheric delay anomalies 
[ph_tropo_scaled,sm_scaling_factor]=run_scaling(ph_InSAR,ph_tropo,utmxy,hgt,grid_index,cenutm,parms.sm_std,n_image);
% ph_tropo_scaled ------- scaled tropospheric delay anomalies in single epoch
% sm_scaling_factor ------- smoothed spatially-varying scaling factor for every points

save ASVS_results.mat ph_tropo_scaled sm_scaling_factor
end
