function [ph_InSAR,ph_tropo]=get_anomaly(ph_uw,ph_tropo_era,n_ifg,n_image,ifgday_ix)
% inverting InSAR phase anomalies and tropospheric delay anomalies in single epoch

% INPUTS:
% ph_uw ------ InSAR phase (rad)
% ph_tropo ------ Tropospheric delays (rad)
% n_ifg ------ number of interferograms 
% n_image ------ number of images 
% ifgday_ix ------ design matrix relating the relevant observation epochs for each ifg

% OUTPUTS:
% ph_InSAR ------ InSAR phase anomaly in single epoch (rad)
% ph_tropo ------ Tropospheric delay anomaly in single epoch (rad)

% By Lin Shen -- University of Leeds

G=zeros(n_ifg,n_image);
for i=1:n_ifg
     G(i,ifgday_ix(i,1))=1;
     G(i,ifgday_ix(i,2))=-1;
end
 
ph_tropo=pinv(G)*ph_tropo_era';
ph_tropo=ph_tropo';

ph_InSAR=pinv(G)*ph_uw';
ph_InSAR=ph_InSAR';
end