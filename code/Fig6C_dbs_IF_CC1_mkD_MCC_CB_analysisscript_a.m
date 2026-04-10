clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

% load list
% mkD MCC-CB
T = readtable('CC1_mkD_MCC_CB_data_a.xlsx');

% t test
% CC1/DAPI ratio
x1 = T{:,3};
x2 = T{:,6};
[h,p,ci,stats] = ttest(x1, x2);

% CC1
x3 = T{:,1};
x4 = T{:,4};
[h2,p2,ci2,stats2] = ttest(x3, x4);

% DAPI
x5 = T{:,2};
x6 = T{:,5};
[h3,p3,ci3,stats3] = ttest(x5, x6);


%Ratio of CC1/DAPI
%boxplot
figure;
subplot(2,2,1); hold on;
boxplot([x2 x1], 'Symbol','','Labels', {'Control side','Sham side'});
ylim([0 100]);
xlim([0 3]);
ylabel('ratio(%)')
title('CC1/DAPI ratio');


% CC1
%boxplot
subplot(2,2,3); hold on;
boxplot([x4 x3], 'Symbol','','Labels', {'Control side','Sham side'});
ylim([0 600]);
xlim([0 3]);
ylabel('cells/field')
title('CC1');

% DAPI
%boxplot
subplot(2,2,4); hold on;
boxplot([x6 x5], 'Symbol','','Labels', {'Control side','Sham side'});
ylim([0 600]);
xlim([0 3]);
ylabel('cells/field')
title('DAPI');

%% Sample size
n = height(T);
disp(n);


