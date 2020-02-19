function utm=get_utm(lonlat,utm_zone)
% getting utm coordinates of each point

% By Lin Shen -- University of Leeds
utm=ll2utm(lonlat(:,2),lonlat(:,1),utm_zone);
utm=utm/1000;
end