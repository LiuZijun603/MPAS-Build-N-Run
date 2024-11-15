clear;clc
xspacing = 0.063;
yspacing = 0.1;
xlen   = 0.17;
ylen   = 0.25;
figure(1)
set(gcf,'position',[150 150 600 930])
colors = [0.1 0.7 0.7;
            1 0.4 0.6;
          254/255 200/255 104/255;
          0.4 0.5 0.6];
subplot(2,4,1);
subplot('position',[xspacing 3*yspacing+ylen+yspacing xlen ylen])
data = ncread('rmse_bias.nc','rain_bias');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)  
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = max(data);
% hold on;
% plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 

%legend;

xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([-1.1 0.2])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing 3*yspacing+ylen+yspacing xlen ylen]);


subplot(2,4,2);
subplot('position',[xspacing+xlen+xspacing 3*yspacing+ylen+yspacing xlen ylen])
data = ncread('rmse_bias.nc','slp_bias');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on; 
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = min(data);
% hold on;
% plot(mm(1),'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([-0.7 0.9])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing+xlen+xspacing 3*yspacing+ylen+yspacing xlen ylen]);



subplot(2,4,3);
subplot('position',[xspacing+(xlen+xspacing)*2 3*yspacing+ylen+yspacing xlen ylen])
data = ncread('rmse_bias.nc','H500_bias');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on; 
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
mm   = min(data);
hold on;
plot(mm(1),'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([-0.6 1])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing+xlen+xspacing 3*yspacing+ylen+yspacing xlen ylen]);


subplot(2,4,4);
subplot('position',[xspacing+(xlen+xspacing)*3 3*yspacing+ylen+yspacing xlen ylen])
data = ncread('rmse_bias.nc','U500_bias');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                 %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = max(data);
% hold on;
% plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([-0.6 1.3])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing+2*xlen+2*xspacing 3*yspacing+ylen+yspacing xlen ylen]);



subplot(2,4,5);
subplot('position',[xspacing 3*yspacing xlen ylen])
data = ncread('rmse_bias.nc','rain_rmse');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = max(data);
% hold on;
% plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([0 5.0])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing 3*yspacing xlen ylen]);


subplot(2,4,6);
subplot('position',[xspacing+xlen+xspacing 3*yspacing xlen ylen])
data = ncread('rmse_bias.nc','slp_rmse');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = max(data);
% hold on;
% plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([0 1.0])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing 3*yspacing xlen ylen]);


subplot(2,4,7);
subplot('position',[xspacing+(xlen+xspacing)*2 3*yspacing xlen ylen])
data = ncread('rmse_bias.nc','H500_rmse');

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
mm   = max(data);
mm(1) = NaN;
mm(2) = NaN;
mm(4) = NaN;
hold on;
plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([0 1])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing+xlen+xspacing 3*yspacing xlen ylen]);

subplot(2,4,8);
subplot('position',[xspacing+(xlen+xspacing)*3 3*yspacing xlen ylen])
data = ncread('rmse_bias.nc','U500_rmse');
data = flip(data,2);

hb = boxplot(data,...              
                    'Color','k',...                                   %箱体边框及异常点颜色
                    'symbol','.',...                                  %异常点形状
                    'Notch','off',...                                  %异常点形状
                    'OutlierSize',4,...                               %是否是凹口的形式展现箱线图，默认非凹口
                    'labels',{'G60-3km', 'R3km.small' ,'R15-3km.big','R3km.big'});
set(hb,'LineWidth',1.5)                                               %箱型图线宽
mx   = mean(data);
hold on;
plot(mx,'.','MarkerSize', 20, 'Color', 'black') 
% mm   = max(data);
% hold on;
% plot(mm,'.','MarkerSize', 20, 'Color', [192/255, 192/255, 192/255]) 
xtickangle(60)

h = findobj(gca,'Tag','Box');
for j = 1:length(h)
    patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);%赋颜色填充箱型图内部
end

ylim([0 4])
box on
set(gca,'Linewidth',1.5);
set(gca,'FontSize',16);
h = figure(1);
%set(h,'units','normalized','position',[xspacing+2*xlen+2*xspacing 3*yspacing xlen ylen]);

