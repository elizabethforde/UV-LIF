%%% SCRIPT FOR ANALYSIS OF MBS DATA
%%% This script reverse engineers the MBS data and produces a boxplot of
%%% the instrument fluorescence response.
%%% Advice for usage:
%%% (1) Set path for acquisition data (e.g. as shown for the 
%%%     MBS_M and BG unwashed sample ) and import using the required import file
%%%     (e.g. importStuffMBS_M)
%%% (2) assign number of standard deviations for analysis

% % import acquisition datafile(s)
file1 = importMBS_M('C:\DSTL_2017_complete\Worked up data\MBS2\Bacteria - BG Unwashed\20092017_BG_unwashed_0000.csv', {','});

% assign number of standard deviations here
SD = 3;

% deal with acquisition data here
data = [file1];
% pull XE1-8 data from datafiles
XE1 = (data(:,2));
XE2 = (data(:,3));
XE3 = (data(:,4));
XE4 = (data(:,5));
XE5 = (data(:,6));
XE6 = (data(:,7));
XE7 = (data(:,8));
XE8 = (data(:,9));
% and size + shape 
Size = (data(:,12));
Shape = (data(:,36));
% FT flag too
FT = (data(:,15));

% group together
data2 = [XE1, XE2, XE3, XE4, XE5, XE6, XE7, XE8, Size, Shape, FT];

% extract FT only (FT = 1)
FTdata = data2(data2(:,11) == 1, :);
% pull XE1-8 data FT  
XE1_FT = (FTdata(:,1));
XE2_FT = (FTdata(:,2));
XE3_FT = (FTdata(:,3));
XE4_FT = (FTdata(:,4));
XE5_FT = (FTdata(:,5));
XE6_FT = (FTdata(:,6));
XE7_FT = (FTdata(:,7));
XE8_FT = (FTdata(:,8));
Size_FT = (FTdata(:,9));
Shape_FT = (FTdata(:,10));


% get size and shape acquisition data prior to reverse engineering
acq_data = data2(data2(:,11) == 0, :);
acq_size = (acq_data(:,9));
acq_shape = (acq_data(:,10));


% Reverse engineer
data3=data2;
[rows,columns]=size(data2);
count=0;
XE1_tot=0;
XE2_tot=0;
XE3_tot=0;
XE4_tot=0;
XE5_tot=0;
XE6_tot=0;
XE7_tot=0;
XE8_tot=0;
Size_tot=0;
Shape_tot=0;
first_non_ft=0;
for i=1:rows
   if data2(i,11) == 1 
       count=count+1
       first_non_ft=0
       XE1_tot=XE1_tot+data2(i,1);
       XE2_tot=XE2_tot+data2(i,2);
       XE3_tot=XE3_tot+data2(i,3);
       XE4_tot=XE4_tot+data2(i,4);
       XE5_tot=XE5_tot+data2(i,5);
       XE6_tot=XE6_tot+data2(i,6);
       XE7_tot=XE7_tot+data2(i,7);
       XE8_tot=XE8_tot+data2(i,8);
       Size_tot=Size_tot+data2(i,9);
       Shape_tot=Shape_tot+data2(i,10);
   elseif data2(i,11) == 0 && count > 0 && first_non_ft == 0
       first_non_ft = 1;
       FT_mean = [XE1_tot, XE2_tot, XE3_tot, XE4_tot, XE5_tot, XE6_tot, XE7_tot, XE8_tot, Size_tot, Shape_tot]/count;
       data3(i,1:10)=data2(i,1:10)+FT_mean;
       count=0;
       XE1_tot=0;
       XE2_tot=0;
       XE3_tot=0;
       XE4_tot=0;
       XE5_tot=0;
       XE6_tot=0;
       XE7_tot=0;
       XE8_tot=0;
       Size_tot=0;
       Shape_tot=0;
   elseif data2(i,11) == 0 && first_non_ft > 0
       data3(i,1:10)=data2(i,1:10)+FT_mean;
       
   end
   
end

% Acquistion data
Acquisitiondata = data3(data3(:,11) == 0, :);

% XE1-8 (_R) as reversed
XE1_R = (Acquisitiondata(:,1));
XE2_R = (Acquisitiondata(:,2));
XE3_R = (Acquisitiondata(:,3));
XE4_R = (Acquisitiondata(:,4));
XE5_R = (Acquisitiondata(:,5));
XE6_R = (Acquisitiondata(:,6));
XE7_R = (Acquisitiondata(:,7));
XE8_R = (Acquisitiondata(:,8));
Size_R = (Acquisitiondata(:,9));
Shape_R = (Acquisitiondata(:,10));




% mean and SD of FT (_R) 
XE1_MSD = mean(XE1_FT) + std(XE1_FT)*SD;
XE2_MSD = mean(XE2_FT) + std(XE2_FT)*SD;
XE3_MSD = mean(XE3_FT) + std(XE3_FT)*SD;
XE4_MSD = mean(XE4_FT) + std(XE4_FT)*SD;
XE5_MSD = mean(XE5_FT) + std(XE5_FT)*SD;
XE6_MSD = mean(XE6_FT) + std(XE6_FT)*SD;
XE7_MSD = mean(XE7_FT) + std(XE7_FT)*SD;
XE8_MSD = mean(XE8_FT) + std(XE8_FT)*SD;
Size_MSD = mean(Size_FT) + std(Size_FT)*SD;
Shape_MSD = mean(Shape_FT) + std(Shape_FT)*SD;
% group
FTbaseline = [XE1_MSD, XE2_MSD, XE3_MSD, XE4_MSD, XE5_MSD, XE6_MSD, XE7_MSD, XE8_MSD, Size_MSD, Shape_MSD];

% APPLY THRESHOLD Reversed and deducted FT
XE1_R_FT = XE1_R - XE1_MSD;
XE2_R_FT = XE2_R - XE2_MSD;
XE3_R_FT = XE3_R - XE3_MSD;
XE4_R_FT = XE4_R - XE4_MSD;
XE5_R_FT = XE5_R - XE5_MSD;
XE6_R_FT = XE6_R - XE6_MSD;
XE7_R_FT = XE7_R - XE7_MSD;
XE8_R_FT = XE8_R - XE8_MSD;
Size_R_FT = Size_R - Size_MSD;
Shape_R_FT = Shape_R - Shape_MSD;

%%%% THERE ARE TWO OPTIONS HERE, EITHER:
%%% (1) Include reverseengineered/thresholded particle size and shape (Size_R_FT, Shape_R_FT)
%%% (2) Use size and shape values prior to reverse engineering/thresholding
%%% (acq_size, acq_shape)
%%% OPTION 1:
%%data4 = [XE1_R_FT, XE2_R_FT, XE3_R_FT, XE4_R_FT, XE5_R_FT, XE6_R_FT, XE7_R_FT, XE8_R_FT, Size_R_FT, Shape_R_FT];
%%% OPTION 2 (used in paper):
data4 = [XE1_R_FT, XE2_R_FT, XE3_R_FT, XE4_R_FT, XE5_R_FT, XE6_R_FT, XE7_R_FT, XE8_R_FT, acq_size, acq_shape];

% set negatives to zero
data5=data4;
data5(data5<0)= 0;
% if cols 1 to 8 equal zero = REMOVE!
data6 = data5(any(data5(:,1:8),2),:);
% set zeroes to NaN
data6=data6;
data6(data6==0) = NaN;

% DATA 7  = boxplotting
data7 = [data6(:,[1:8])];
% reassign size/shape
Particlesize = [data6(:,9)];
Particleshape = [data6(:,10)];

% % boxplot of fluorescence response
figure(101)
p = prctile(data7,[5 25 75 95])
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

% formatting 
set(gca, 'xticklabel',{'XE1', 'XE2', 'XE3', 'XE4', 'XE5', 'XE6', 'XE7', 'XE8'});
set(gca, 'FontSize', 16, 'ylim', [0 2200]);
xlabel('BG unwashed');
ylabel('Fluorescence [a.u]');
