clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\'); 
cd(maindir);

% load list
list = importdata('dbs_behavior_data_a.xlsx');

%ANOVA and posthoc for mk N & T
y = list.data(list.data(:,6) == 1, 2); %movement
y2 = list.data(list.data(:,6) == 1, 3); %foraging
g1 = list.data(list.data(:,6) == 1, 4); %mk
g2 = list.data(list.data(:,6) == 1, 5); %stim
g3 = list.data(list.data(:,6) == 1, 6); %group

% anova 
[p,tbl,stats] = anovan(y,{g1,g2},"Model", "full", "Varnames",["monkey","stim"]);
[p2,tbl2,stats2] = anovan(y2,{g1,g2},"Model", "full", "Varnames",["monkey","stim"]);

%%posthoc 
figure;
subplot(1,2,1);
[c,m,h] = multcompare(stats, "Dimension", [1,2]);
subplot(1,2,2);
[c2,m2,h2] = multcompare(stats2, "Dimension", [1,2]);

% box plot
figure;
subplot(1,2,1);
hold on;

move_mean_monkey1_stim6w = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 2));
move_mean_monkey2_stim6w = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 2));
move_mean_monkey3_stim6w = mean(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 2));

move_mean_monkey1_pre = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 2));
move_mean_monkey2_pre = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 2));
move_mean_monkey3_pre = mean(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 2));

plot(2,move_mean_monkey1_stim6w ,'bo');
plot(2,move_mean_monkey2_stim6w ,'b^');
plot(2,move_mean_monkey3_stim6w ,'ksquare');

plot(1,move_mean_monkey1_pre ,'bo');
plot(1,move_mean_monkey2_pre ,'b^');
plot(1,move_mean_monkey3_pre ,'ksquare');

    move_mean_monkey1_sem_stim6w = std(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 2))^0.5;
    move_mean_monkey2_sem_stim6w = std(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 2))^0.5;
    move_mean_monkey3_sem_stim6w = std(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 2))^0.5;
    move_mean_monkey1_sem_pre = std(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 2))^0.5;
    move_mean_monkey2_sem_pre = std(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 2))^0.5;
    move_mean_monkey3_sem_pre = std(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 2))^0.5;
    
    errorbar(1, move_mean_monkey1_pre,  move_mean_monkey1_sem_pre,'k');
        errorbar(1, move_mean_monkey2_pre,  move_mean_monkey2_sem_pre,'k');
        errorbar(1, move_mean_monkey3_pre,  move_mean_monkey3_sem_pre,'k');
    
    errorbar(2, move_mean_monkey1_stim6w,  move_mean_monkey1_sem_stim6w,'k');
        errorbar(2, move_mean_monkey2_stim6w,  move_mean_monkey2_sem_stim6w,'k');
        errorbar(2, move_mean_monkey3_stim6w,  move_mean_monkey3_sem_stim6w,'k');

ylim([0 0.8]);
xlim([0 3]);
xticks([1 2]);
xticklabels({'Pre-DBS','Post-DBS'});
ylabel('Probability of Movement')
title("Movement");

subplot(1,2,2);
hold on;

foraging_mean_monkey1_stim6w = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 3));
foraging_mean_monkey2_stim6w = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 3));
foraging_mean_monkey3_stim6w = mean(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 3));


foraging_mean_monkey1_pre = mean(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 3));
foraging_mean_monkey2_pre = mean(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 3));
foraging_mean_monkey3_pre = mean(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 3));

plot(2,foraging_mean_monkey1_stim6w ,'bo');
plot(2,foraging_mean_monkey2_stim6w ,'b^');
plot(2,foraging_mean_monkey3_stim6w ,'ksquare');

plot(1,foraging_mean_monkey1_pre ,'bo');
plot(1,foraging_mean_monkey2_pre ,'b^');
plot(1,foraging_mean_monkey3_pre ,'ksquare');

    foraging_mean_monkey1_sem_stim6w = std(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 1 & list.data(:,5) == 1, 2))^0.5;
    foraging_mean_monkey2_sem_stim6w = std(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 2 & list.data(:,5) == 1, 2))^0.5;
    foraging_mean_monkey3_sem_stim6w = std(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 2))/length(list.data(list.data(:,4) == 3 & list.data(:,5) == 1, 2))^0.5;
    foraging_mean_monkey1_sem_pre = std(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 1 & list.data(:,5) == 0, 2))^0.5;
    foraging_mean_monkey2_sem_pre = std(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 2 & list.data(:,5) == 0, 2))^0.5;
    foraging_mean_monkey3_sem_pre = std(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 2))/length(list.data(list.data(:,4) == 3 & list.data(:,5) == 0, 2))^0.5;
    
    errorbar(1, foraging_mean_monkey1_pre,  foraging_mean_monkey1_sem_pre,'k');
        errorbar(1, foraging_mean_monkey2_pre,  foraging_mean_monkey2_sem_pre,'k');
        errorbar(1, foraging_mean_monkey3_pre,  foraging_mean_monkey3_sem_pre,'k');
    
    errorbar(2, foraging_mean_monkey1_stim6w,  foraging_mean_monkey1_sem_stim6w,'k');
        errorbar(2, foraging_mean_monkey2_stim6w,  foraging_mean_monkey2_sem_stim6w,'k');
        errorbar(2, foraging_mean_monkey3_stim6w,  foraging_mean_monkey3_sem_stim6w,'k');


ylim([0 0.8]);
xlim([0 3]);
xticks([1 2]);
xticklabels({'Pre-DBS','Post-DBS'});
ylabel('Probability of Foraging')
title("Foraging");


%% Sample size
n_table = table();

n_table.Group = ["Monkey1_preDBS"; "Monkey1_postDBS"; "Monkey2_preDBS"; "Monkey2_postDBS"; "Monkey3_preDBS"; "Monkey3_postDBS"];
n_table.N = [
    sum(list.data(:,4) == 1 & list.data(:,5) == 0);
    sum(list.data(:,4) == 1 & list.data(:,5) == 1);
    sum(list.data(:,4) == 2 & list.data(:,5) == 0);
    sum(list.data(:,4) == 2 & list.data(:,5) == 1);
    sum(list.data(:,4) == 3 & list.data(:,5) == 0);
    sum(list.data(:,4) == 3 & list.data(:,5) == 1)
];

disp(n_table)







