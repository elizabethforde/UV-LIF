%%% SCRIPT FOR ANALYSIS OF WIBS-NEO DATA
%%% Advice for usage:
%%% (1) Set path for both FT data and acquisition data (example shown for
%%%     BG unwashed sample) using the required import file (e.g.
%%%     importstuffNEO).
%%% (2) assign number of standard deviations for analysis


% FT for WIBSNEO (5 files)
file1 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\FORCED TRIGGER\CONVERTED\20170912103424_FT__x0001.csv', {','});
file2 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\FORCED TRIGGER\CONVERTED\20170913142052_FT__x0001.csv', {','});
file3 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\FORCED TRIGGER\CONVERTED\20170914111651_FT__x0001.csv', {','});
file4 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\FORCED TRIGGER\CONVERTED\20170915095009_FT__x0001.csv', {','});
file5 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\FORCED TRIGGER\CONVERTED\20170920124225_FT__x0001.csv', {','});

% % Acquisition datafile(s)
file10 = importNEO('C:\DSTL_2017_complete\Worked up data\NEO\Bacteria - BG Unwashed\CONVERTED\20170920133704__x0001.csv', {','});


% assign number of standard deviations required here
SD = 3

% sort FT data here
FTdata = [file1; file2; file3; file4; file5];
% pull out FL data
ftFL1 = (FTdata(:,3));
ftFL2 = (FTdata(:,4));
ftFL3 = (FTdata(:,5));
% find mean of above
aveFL1 = mean(ftFL1);
aveFL2 = mean(ftFL2);
aveFL3 = mean(ftFL3);
% find stdv + multiply (SD)
sdFL1 = std(ftFL1)*SD;
sdFL2 = std(ftFL2)*SD;
sdFL3 = std(ftFL3)*SD;
% add mean and SD together
baseFL1 = aveFL1 + sdFL1;
baseFL2 = aveFL2 + sdFL2;
baseFL3 = aveFL3 + sdFL3;

% deal with acquisition data here
data = [file10]; 
% pull out time (ms from start)
Time = (data(:,1));
% excited particle column (0 = non-excited)
Excited = (data(:,2));
% pull each FL channel
FL1 = (data(:,3));
FL2 = (data(:,4));
FL3 = (data(:,5));
% size
Size = (data(:,6));
% shape
Shape = (data(:,7));
% and intrinsic FT
FT = (data(:,8));

% remove NANs from shape - reassign to zero (otherwise error)
Shape(isnan(Shape)) = 0;

% group together....
data2 = [Excited, FL1, FL2, FL3, Size, Shape, FT];

% remove any intrinsic FT data in acquisition files (FT flag = 1)
data3 = data2(data2(:,7) <= 0, :);
% Remove non-excited particles (zero fluorescence in each channel)
data4 = data3(any(data3(:,1),2),:);

% remove baseline from acquisition data
blFL1 = data4(:,2) - baseFL1;
blFL2 = data4(:,3) - baseFL2;
blFL3 = data4(:,4) - baseFL3;
% size after FT/non-excited particle removal
Particlesize = data4(:,5);
% particle shape after FT/non-excited particle removal
Particleshape = data4(:,6);

% group 
data5 = [blFL1, blFL2, blFL3, Particlesize, Particleshape];
% set any remaining negatives to zero
data6=data5;
data6(data6<0)= 0;
% find rows which have zero fl in each column of each row + remove
data7 = data6(any(data6(:,1:3),2),:);
% reassign data 7 to change zero to NaN
data7=data7;
data7(data7==0) = NaN;

% grouped for boxplotting
data8 = [data7(:,[1:3])];
% reassign particle size following FT removal
Particlesize = [data7(:,4)];
% reassign particle shape following FT removal
Particleshape = [data7(:,5)];


% boxplot of fluorescence response
figure(101)
p = prctile(data8,[5 25 75 95])
h = boxplot(data8, 'OutlierSize', 1);
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
plot(nanmean(data8), 'bx')
hold off

% formatting/labels
set(gca, 'xticklabel',{'FL1', 'FL2', 'FL3'});
set(gca,'FontSize', 16);
xlabel('BG unwashed');
ylabel('Fluorescence [a.u]');







