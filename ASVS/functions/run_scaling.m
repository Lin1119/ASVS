
function [ph_tropo_scaled,sm_scaling_factor]=run_scaling(ph_InSAR,ph_tropo,utm,hgt,grid_index,cenutm,sm_std,n_image)

% INPUTS:
% ph_InSAR ------ InSAR phase anomaly in single epoch (rad)
% ph_tropo ------ Tropospheric delay anomaly in single epoch (rad)
% utm ------ UTM coordinates of points (km)
% hgt ------ elevation of points (m)
% grid_index ------ index of points in each patch of the grid
% cenutm ------ UTM coordinates of central point of each patch (km)
% sm_std ------ Gaussian smoothing width (km)
% n_image ------ number of images 

% OUTPUTS:
% ph_tropo_scaled ------- scaled tropospheric delay anomalies in single epoch
% sm_scaling_factor ------- smoothed spatially varying scaling factor for every points

% By Lin Shen -- University of Leeds

phase=ph_InSAR;
ph_tropo_era=ph_tropo;
index1=isnan(phase(:,1));
index2=isnan(ph_tropo_era(:,1));
index=index1|index2;
phase=phase(~index,:);
ph_tropo_era=ph_tropo_era(~index,:);
hgt=hgt(~index,:); 
a=grid_index(~index,:);


for ifg=1:size(phase,2)

for i=1:size(cenutm,2)
if (sum(a(:,i))>0)
    ph_uw2(a(:,i),i)=phase(a(:,i),ifg);
    ph_tropo2(a(:,i),i)=ph_tropo_era(a(:,i),ifg);
    h=hgt(a(:,i),1);
    [v,p]=hist(h,25);
    a1=h>=p(12);
    a2=h<=p(13);
    index=logical(a1.*a2);
    ptmp=phase(a(:,i),ifg);
    ttmp=ph_tropo_era(a(:,i),ifg);
    offset1=nanmean(ptmp(index,:));
    offset2=nanmean(ttmp(index,:));

    ph_uw3(a(:,i),i)=ph_uw2(a(:,i),i)-offset1;
    ph_tropo3(a(:,i),i)=ph_tropo2(a(:,i),i)-offset2;
    ptmp=ph_uw3(a(:,i),i);
    ttmp=ph_tropo3(a(:,i),i);
    var_signal(i,ifg)=var(ttmp);
    var_noise(i,ifg)=var(ptmp-ttmp);
    ratio(i,ifg)=(var_signal(i,ifg))/var_noise(i,ifg);


end
end

for i=1:size(ph_uw3,2)
[b,c,d]=find(ph_uw3(:,i));
bbb=size(b,1);
bb=size(b,2);
if bb>0 && bbb>0
A=ph_uw3(b,i);
C=ph_tropo3(b,i);
AA=double(A(~isnan(A)));
CC=C(~isnan(A));
GG=[CC,ones(length(CC),1)];
mm=lscov(GG,AA); 
s(i,ifg)=mm(1);
clear CC AA A C G
end
end


  
end

index1=isnan(s(:,ifg));
index2=s(:,ifg)==0;
index=index1|index2;
cenutm=cenutm(:,~index);
s=s(~index,:);
ratio=ratio(~index,:);
N=1;
for sigma=sm_std
for i=1:size(cenutm,2)
    for j=1:length(utm)
        w(j,i)=gausskernel(utm(j,1),utm(j,2),cenutm(1,i),cenutm(2,i),sigma);
    end
end
w=w./sum(w')';


for ifg=1:n_image

ratio_ifg=ratio(:,ifg)';
ratio_ifg2=ratio_ifg/sum(ratio_ifg);
weight=w.*ratio_ifg2;
weight_scale=weight./sum(weight')';
sm_scaling_factor(:,ifg)=weight_scale*s(:,ifg);
ph_tropo_scaled(:,ifg)=ph_tropo(:,ifg).*sm_scaling_factor(:,ifg);

end
N=N+1;
end
end