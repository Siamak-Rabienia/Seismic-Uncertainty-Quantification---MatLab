close all;
clear;
clc;
tic;
fileName = 'Cylinder_Stat_x15 Table(Wet)';

%%%% Reading the Excel file and all Sheets
[~,SheetNames] = xlsfinfo([fileName,'.xlsx']);
nSheets = length(SheetNames);

L=9.8*1e-2; % m  for Cube: 14.5 cm
f0=14*1e3; % Hz
T=1/f0; % s
t0=T/4; % The time of the first peak at the source (s)

Name = SheetNames{1};
Data1 = readtable([fileName,'.xlsx'],'Sheet',Name);
for j = 2:nSheets
    j1=j-1;
    Name = SheetNames{j};
    S(j1).Name = Name;
    VWC=Data1{:,3*j-4};
    ind=~isnan(VWC);
    S(j1).fileNames = Data1{ind,3*j-5};
    S(j1).VWC = Data1{ind,3*j-4};
    S(j1).Saturation = Data1{ind,3*j-3};
    Data = readtable([fileName,'.xlsx'],'Sheet',Name);
    [M,N]=size(Data);
    M=M-1;% Number of samples in the time series 
    N=N/2;% Number of trials with different saturation
    
    % Preallocation
    S(j1).timeAxis=zeros(M,N);
    S(j1).normSignal=zeros(M,N);
    S(j1).ttMax=zeros(1,N);
    S(j1).VsMax=zeros(1,N);
    %
    
    h=waitbar(0,'Data processing is in progress...');
    set(h,'Name',[num2str(j1),' out of ',num2str(nSheets-1)]);
    for k = 1:N
        m=2*(k-1)+1;
        S(j1).timeAxis(:,k)=str2double(Data{2:end,m});
        S(j1).normSignal(:,k)=str2double(Data{2:end,m+1});
        if k==1
            figure
            plot(S(j1).timeAxis(:,k)*1e3,S(j1).normSignal(:,k),'b','linewidth',2)
            xlabel('Time (ms)');
            ylabel('Normalized Signal');
            title(['Infiltration ',num2str(j1),': VWC = ',num2str(S(j1).VWC(k)),' Sat = ',num2str(S(j1).Saturation(k))]);
            set(gca,'fontsize',14,'fontweight','bold','Xlim',[0 2]);
            figName = ['Infiltration ',num2str(j1),' VWC = ',num2str(S(j1).VWC(k)),' Sat = ',num2str(S(j1).Saturation(k))];
            saveas(gcf,[figName,'.fig']);
            saveas(gcf,[figName,'.jpg']);
        end
        [~,imax]=max(S(j1).normSignal(:,k));
        t1=S(j1).timeAxis(imax,k);
        ttMax=t1-t0;
        S(j1).ttMax(k) = ttMax;
        S(j1).VsMax(k) = L/ttMax;
        waitbar(k/N,h);
    end
    close (h);
    figure;
    plot(S(j1).VsMax,'b','linewidth',2);
    xlabel('Saturation Level');
    ylabel('Phase Velocity (m/s)');
    title(['Infiltration ',num2str(j1)]);
    set(gca,'fontsize',14,'fontweight','bold');
    figName = ['Infiltration ', num2str(j1)];
    saveas(gcf,[figName,'.fig']);
    saveas(gcf,[figName,'.jpg']);
end
save([fileName,'.mat'],'S');
toc;

