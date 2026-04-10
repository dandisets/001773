clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

% load list
list = importdata('dbs_EMgratio_MCC_CB_data_a.xlsx');

% g ratio
%ANOVA
y = list.data(:,10);
g1 = list.data(:,13);
g2 = list.data(:,14);
g3 = list.data(:,15);

[p,tbl,stats] = anovan(y,{g1,g2},"Model", "full", "Varnames",["monkey","side"]);


% boxplot
figure;
subplot(2,2,1); hold on;
boxplot([list.data(list.data(:,14) == 2, 10), list.data(list.data(:,14) == 1, 10)] ,'Symbol','','Colors','mc');

for mk = 1:2
    hold on;
    xb = 0;
    for side = 1:2
        gratio_mean = mean(list.data(list.data(:,13) == mk & list.data(:,14) == side, 10));
        gratio_monkey1_mean(side) = mean(list.data(list.data(:,13) == 1 & list.data(:,14) == side, 10));
        gratio_monkey2_mean(side) = mean(list.data(list.data(:,13) == 2 & list.data(:,14) == side, 10));
        xb = xb+1;
    end
    plot([xb xb-1],gratio_monkey1_mean,'bo');
    plot([xb xb-1],gratio_monkey2_mean,'b^');
    ylim([0 1]);
    xlim([0 3]);
    xticks([1 2]);
    xticklabels({'ctrlside','stimside'});
    title("g ratio");
end

%scatter plot
%mk T
subplot(2,2,4); hold on;
scatter(list.data(list.data(:,13) == 2 & list.data(:,14) == 1, 15), list.data(list.data(:,13) == 2 & list.data(:,14) == 1, 10), 'r.');
scatter(list.data(list.data(:,13) == 2 & list.data(:,14) == 2, 15), list.data(list.data(:,13) == 2 & list.data(:,14) == 2, 10), 'b.');
ylim([0 1]);
xlim([0 1200]);
xlabel('axon radius (nm)')
ylabel('g ratio')
title('Monkey T');

%mk N
subplot(2,2,3); hold on;
scatter(list.data(list.data(:,13) == 1 & list.data(:,14) == 1, 15), list.data(list.data(:,13) == 1 & list.data(:,14) == 1, 10), 'r.');
scatter(list.data(list.data(:,13) == 1 & list.data(:,14) == 2, 15), list.data(list.data(:,13) == 1 & list.data(:,14) == 2, 10), 'b.');
ylim([0 1]);
xlim([0 1200]);
xlabel('axon radius (nm)')
ylabel('g ratio')
title('Monkey N');

%% Sample size
n_table = table();

n_table.Group = ["Monkey1_stim"; "Monkey1_ctrl"; "Monkey2_stim"; "Monkey2_ctrl"];
n_table.N = [
    sum(list.data(:,13) == 1 & list.data(:,14) == 1);
    sum(list.data(:,13) == 1 & list.data(:,14) == 2);
    sum(list.data(:,13) == 2 & list.data(:,14) == 1);
    sum(list.data(:,13) == 2 & list.data(:,14) == 2)
];

disp(n_table)




