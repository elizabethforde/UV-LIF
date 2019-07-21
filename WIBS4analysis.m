%%% SCRIPT FOR ANALYSIS OF WIBS4M AND WIBS4D DATA
%%% Advice for usage:
%%% (1) Set path for both FT data and acquisition data (example shown for
%%%     WIBS4M FT and BG unwashed sample) using the required import file (e.g.
%%%     importstuffWIBS4M).
%%% (2) assign number of standard deviations for analysis

% % FT FOR WIBS4M (1 file only).......
file1 = importWIBS4M('C:\DSTL_2017_complete\Worked up data\WIBS4M\FORCED TRIGGER - USE THIS\13092017_FT_0002.csv', {','});

% % Acquisition datafile(s)
file10 = importWIBS4M('C:\DSTL_2017_complete\Worked up data\WIBS4M\Bacteria - BG Unwashed\20092017_BG_unwashed_0000.csv', {','});

% assign number of standard deviations required here
SD = 3

% sort FT data here
FTdata = [file1]; 
% for WIBS4D remove any 2 values from FT data.... 3 = FT!
FTdata = FTdata(FTdata(:,19) == 3, :);
% pull out FL data
ftFL1 = (FTdata(:,8));
ftFL2 = (FTdata(:,9));
ftFL3 = (FTdata(:,11));
% find mean of above
aveFL1 = mean(ftFL1);
aveFL2 = mean(ftFL2);
aveFL3 = mean(ftFL3);
% find stdv + multiply by SD (as set above)
sdFL1 = std(ftFL1)*SD;
sdFL2 = std(ftFL2)*SD;
sdFL3 = std(ftFL3)*SD;
% add mean and SD together
baseFL1 = aveFL1 + sdFL1;
baseFL2 = aveFL2 + sdFL2;
baseFL3 = aveFL3 + sdFL3;

% deal with acquisition data here
data = [file10];
% pull out WIBS time (ms from start)
Time = (data(:,1));
% pull each FL channel
FL1 = (data(:,8));
FL2 = (data(:,9));
FL3 = (data(:,11));
% size too
Size = (data(:,15));
% and shape
Shape = (data(:,16));
% as well as intrinsic FT
FT = (data(:,19));

% group acquisition data together....
data2 = [Time, FL1, FL2, FL3, Size, Shape, FT];

% remove any intrinsic FT data in acquisition files (FT flag = 3)- 
data3 = data2(data2(:,7) <= 2, :);
 
% remove baseline from acquisition data
blFL1 = data3(:,2) - baseFL1;
blFL2 = data3(:,3) - baseFL2;
blFL3 = data3(:,4) - baseFL3;
% size after intrinsic FT removal
Particlesize = data3(:,5);
% particle shape after intrinsic FT removal
Particleshape = data3(:,6);

% group together
data4 = [blFL1, blFL2, blFL3, Particlesize, Particleshape];
% set any negatives to zero
data5=data4;
data5(data5<0)= 0;
% remove rows which have zero fl values in each column of each row
data6 = data5(any(data5(:,1:3),2),:);
% reassign data 6 to change zero to NaN
data6=data6;
data6(data6==0) = NaN;

% grouped for boxplotting
data7 = [data6(:,[1:3])];
% reassign particle size following FT removal
Particlesize = [data6(:,4)];
% reassign particle shape following FT removal
Particleshape = [data6(:,5)];


% % boxplot of fluorescence response
figure(101)
p = prctile(data7,[5 25 75 95]);
h = boxplot(data7, 'OutlierSize', 1);
% upper whisker length
set(h(1,:),{'ydata'},num2cell(p(end-1:end,:),1)')
% lower whisker length
set(h(2,:),{'ydata'},num2cell(p(2:-1:1,:),1)')
% upper whisker endbar
set(h(3,:),{'ydata'},num2cell(p([end end],:),1)')
% lower whisker endbar
set(h(4,:),{'ydata'},num2cell(p([1 1],:),1)')
% modify body 
set(h(5,:), {'ydata'}, num2cell(p([2 3 3 2 2],:),1)')
% median
set(h(6,:),{'Visible'}, {'on'})
% remove outliers
set(h(7,:),{'visible'},{'off'})
% add in the mean
hold on 
plot(nanmean(data7), 'bx')
hold off

% formatting /labels
set(gca, 'xticklabel',{'FL1', 'FL2', 'FL3'});
set(gca, 'ylim', [0 2200]) 
set(gca, 'FontSize', 16);
xlabel('BG unwashed');
ylabel('Fluorescence [a.u]');


