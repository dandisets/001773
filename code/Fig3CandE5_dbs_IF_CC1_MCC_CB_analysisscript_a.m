clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\'); 
cd(maindir);

% load list
% MCC-CB
list = importdata('CC1_MCC_CB_data_a.xlsx');

%ANOVA
y1 = list.data(2:end,1);
y2 = list.data(2:end,2);
y3 = list.data(2:end,3);
g1 = list.data(2:end,4);
g2 = list.data(2:end,5);

% CC1/DAPI ratio
[p,tbl,stats] = anovan(y3,{g1,g2},'model','full','varnames',{'monkey','side'});
% number of CC1 positive cell
[p2,tbl2,stats2] = anovan(y1,{g1,g2},'model','full','varnames',{'monkey','side'});
% number of DAPI positive cell
[p3,tbl3,stats3] = anovan(y2,{g1,g2},'model','full','varnames',{'monkey','side'});

%posthoc
[c,m,h] = multcompare(stats,"Dimension",2);
[c2,m2,h2] = multcompare(stats2,"Dimension",2);
[c3,m3,h3] = multcompare(stats3,"Dimension",2);

%Ratio of CC1/DAPI
%boxplot
subplot(2,2,1); hold on;
boxplot([list.data(list.data(:,5) == 2, 3) list.data(list.data(:,5) == 1, 3)], 'Symbol','','Labels', {'Control side','Stim side'});

for mk = 1:2
    hold on;
    xb = 0;
    for side = 1:2
        ratio_mean = mean(list.data(list.data(:,4) == mk & list.data(:,5) == side, 3));
        ratio_monkey1_mean(side) = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == side, 3));
        ratio_monkey2_mean(side) = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == side, 3));
        xb = xb+1;
    end
    plot([xb xb-1],ratio_monkey1_mean,'bo');
    plot([xb xb-1],ratio_monkey2_mean,'b^');
    ylim([0 110]);
    xlim([0 3]);
    ylabel('ratio(%)')
    title("Ratio of CC1/DAPI");
end

%number of CC1 or DAPI positive cells
%boxplot
subplot(2,2,3); hold on;
boxplot([list.data(list.data(:,5) == 2, 1) list.data(list.data(:,5) == 1, 1)], 'Symbol','','Labels', {'Control side','Stim side'});

for mk = 1:2
    hold on;
    xb = 0;
    for side = 1:2
        CC1_mean = mean(list.data(list.data(:,4) == mk & list.data(:,5) == side, 1));
        CC1_monkey1_mean(side) = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == side, 1));
        CC1_monkey2_mean(side) = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == side, 1));
        xb = xb+1;
    end
    plot([xb xb-1],CC1_monkey1_mean,'bo');
    plot([xb xb-1],CC1_monkey2_mean,'b^');
    ylim([0 600]);
    xlim([0 3]);
    ylabel('cells/field')
    title("Number of CC1 positive cells");
end

subplot(2,2,4); hold on;
boxplot([list.data(list.data(:,5) == 2, 2) list.data(list.data(:,5) == 1, 2)], 'Symbol','','Labels', {'Control side','Stim side'});

for mk = 1:2
    hold on;
    xb = 0;
    for side = 1:2
        DAPI_mean = mean(list.data(list.data(:,4) == mk & list.data(:,5) == side, 2));
        DAPI_monkey1_mean(side) = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == side, 2));
        DAPI_monkey2_mean(side) = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == side, 2));
        xb = xb+1;
    end
    plot([xb xb-1],DAPI_monkey1_mean,'bo');
    plot([xb xb-1],DAPI_monkey2_mean,'b^');
    ylim([0 600]);
    xlim([0 3]);
    ylabel('cells/field')
    title("Number of DAPI positive cells");
end

%% Sample size
n_table = table();

n_table.Group = ["Monkey1_stim"; "Monkey1_ctrl"; "Monkey2_stim"; "Monkey2_ctrl"];
n_table.N = [
    sum(list.data(:,4) == 1 & list.data(:,5) == 1);
    sum(list.data(:,4) == 1 & list.data(:,5) == 2);
    sum(list.data(:,4) == 2 & list.data(:,5) == 1);
    sum(list.data(:,4) == 2 & list.data(:,5) == 2)
];

disp(n_table)
