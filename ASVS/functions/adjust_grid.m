function [grid_index,cenutm]=adjust_grid(ph_uw,heading_InSAR,utmxy,win_size,x_min,x_max,y_min,y_max)
% INPUTS:
% ph_uw ------- InSAR phase (rad)
% heading_InSAR ------ azimuth angle in degrees
% utmxy ------ UTM coordinates of points (km)
% win_size ------ grid size (km)
% x_min ------ x_min of grid (km)
% x_max ------ x_max of grid (km)
% y_min ------ y_min of grid (km)
% y_max ------ y_max of grid (km)

% OUTPUTS:
% grid_index ------ index of points in each patch of the grid
% cenutm ------ UTM coordinates of central point of each patch (km)

% By Lin Shen -- University of Leeds

phase=ph_uw(:,1);
index=isnan(phase(:,1));
phase=phase(~index,:);
utmxy=utmxy(~index,:);
heading=heading_InSAR;
theta=-(180+heading-2.5);
wx=win_size/2;
wy=win_size/2;
scatter(utmxy(:,1),utmxy(:,2),[],phase(:,1));
hold on
R=[cosd(theta) -sind(theta); sind(theta) cosd(theta)];
y=(y_min:2*wy:y_max);
x=(x_min:2*wx:x_max);
medi=[median(x),median(y)];
n=1;
for i=1:length(x)
    for j=1:length(y)
        x_cen(n,1)=x(i)-medi(1);
        y_cen(n,1)=y(j)-medi(2);
        p1=R*[x_cen(n,1)-wx,y_cen(n,1)+wy]';
        p2=R*[x_cen(n,1)+wx,y_cen(n,1)+wy]';
        p3=R*[x_cen(n,1)+wx,y_cen(n,1)-wy]';
        p4=R*[x_cen(n,1)-wx,y_cen(n,1)-wy]';
        cenutm(:,n)=R*[x_cen(n,1),y_cen(n,1)]'+medi';
        p5=p1;
        utmx(:,n)=[p1(1);p2(1);p3(1);p4(1);p5(1)]+medi(1);
        utmy(:,n)=[p1(2);p2(2);p3(2);p4(2);p5(2)]+medi(2);
        a(:,n)=inpolygon(utmxy(:,1),utmxy(:,2),utmx(:,n),utmy(:,n));
        plot(utmx(:,n),utmy(:,n),'black-','LineWidth',1.0);
           hold on
        n=n+1;
    end
end
box on
grid_index=a;
ax=gca;
ax.LineWidth=2;
c=colorbar;
c.Label.String = 'InSAR phase (rad)';
c.Label.FontSize = 14;
xlabel('UTMX (km)');
ylabel('UTMY (km)');
     
xl = get(gca,'xlabel');
   
set(xl,'FontName','Arial','FontSize',14,'FontWeight','Bold');
yl = get(gca,'ylabel');
set(yl,'FontName','Arial','FontSize',14,'FontWeight','Bold');
