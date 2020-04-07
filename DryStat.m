close all;
clear;
clc;
tic;

load('Cylinder_Stat_x15 Table(Dry)');
Tmax =[S(1).ttMax(:);S(2).ttMax(:);S(3).ttMax(:);S(4).ttMax(:);S(5).ttMax(:);S(6).ttMax(:);S(7).ttMax(:);S(8).ttMax(:);S(9).ttMax(:)];
Vmax =[S(1).VsMax(:);S(2).VsMax(:);S(3).VsMax(:);S(4).VsMax(:);S(5).VsMax(:);S(6).VsMax(:);S(7).VsMax(:);S(8).VsMax(:);S(9).VsMax(:)];

figure;
probplot(Tmax);
p = fitdist(Tmax,'tlocationscale');
h = probplot(gca,p); 
set(h,'color','r','linestyle','-');
title('Probability Plot')
legend('Normal','T','t location-scale','Location','SE')
set(gca,'fontsize',14,'fontweight','bold')

figure
ecdf(Tmax)
title('Empirical CDF of T')
xlabel('Time (s)');
set(gca,'fontsize',14,'fontweight','bold')

[f,xi,bw] = ksdensity(Tmax); 
figure
plot(xi,f);
xlabel('Time (s)');
title('Kernel Density Function Estimate of T')
set(gca,'fontsize',14,'fontweight','bold')

figure;
probplot(Vmax);
p = fitdist(Vmax,'tlocationscale');
h = probplot(gca,p); 
set(h,'color','r','linestyle','-');
title('Probability Plot')
legend('Normal','VS','t location-scale','Location','SE')
set(gca,'fontsize',14,'fontweight','bold')

figure
ecdf(Vmax)
xlabel('Phase Velocity (m/s)');
title('Empirical CDF of Phase Velocity')
set(gca,'fontsize',14,'fontweight','bold')

[f,xi,bw] = ksdensity(Vmax); 
figure
plot(xi,f);
xlabel('Phase Velocity (m/s)');
ylabel ('Time (s)');
title('Kernel Density Function Estimate of Phase Velocity')
set(gca,'fontsize',14,'fontweight','bold')

% [pdf,x] = kernel1D(Tmax,100,1e-3);
