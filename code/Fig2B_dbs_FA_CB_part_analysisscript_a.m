clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\'); 
cd(maindir);

% load list
list = importdata('dbs_FA_CB_subpart_data_a.xlsx');

%% ANOVA
y = list.data(:,1);
g1 = list.data(:,2);
g2 = list.data(:,3);
g3 = list.data(:,4);
g4 = list.data(:,5);


model_mat2=[1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    0 1 1 0;
    0 1 0 1;
    0 0 1 1;
    0 1 1 1;];
[p,tbl,stats] = anovan(y,{g1 g2,g3,g4},"Model",model_mat2,"Varnames",["monkey","PrePost","side","part"]);

% posthoc
[c,m,h] = multcompare(stats);
[results,~,~,gnames] = multcompare(stats,"Dimension",[2 3 4]);
tbl2 = array2table(results,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl2.("Group A")=gnames(tbl2.("Group A"));
tbl2.("Group B")=gnames(tbl2.("Group B"));

%% Line chart with asterisk
figure;

% stimulation side 
subplot(2,1,1); hold on;
tract_label = ["SCC","dACC","MCC","aPCC"];

fa_s_pre_part_mean = nan(1,4);
fa_s_pre_part_sem  = nan(1,4);
fa_s_pos_part_mean = nan(1,4);
fa_s_pos_part_sem  = nan(1,4);

for part = 1:4
    % pre, side=1
    idx = (list.data(:,3) == 1 & list.data(:,4) == 1 & list.data(:,5) == part);
    vals = list.data(idx,1);

    fa_s_pre_part_mean(part) = mean(vals);
    fa_s_pre_part_sem(part)  = std(vals) / sqrt(length(vals));

    fa_s_pre_monkey1_mean = mean(list.data(list.data(:,2)==1 & idx,1));
    fa_s_pre_monkey2_mean = mean(list.data(list.data(:,2)==2 & idx,1));

    plot(part, fa_s_pre_monkey1_mean, 'co');
    plot(part, fa_s_pre_monkey2_mean, 'c^');

    % post, side=1
    idx = (list.data(:,3) == 2 & list.data(:,4) == 1 & list.data(:,5) == part);
    vals = list.data(idx,1);

    fa_s_pos_part_mean(part) = mean(vals);
    fa_s_pos_part_sem(part)  = std(vals) / sqrt(length(vals));

    fa_s_pos_monkey1_mean = mean(list.data(list.data(:,2)==1 & idx,1));
    fa_s_pos_monkey2_mean = mean(list.data(list.data(:,2)==2 & idx,1));

    plot(part, fa_s_pos_monkey1_mean, 'mo');
    plot(part, fa_s_pos_monkey2_mean, 'm^');
end

plot(1:4, fa_s_pre_part_mean, 'b-');
errorbar(1:4, fa_s_pre_part_mean, fa_s_pre_part_sem, 'b', 'LineStyle','none');

plot(1:4, fa_s_pos_part_mean, 'r-');
errorbar(1:4, fa_s_pos_part_mean, fa_s_pos_part_sem, 'r', 'LineStyle','none');

ylim([0 0.7]);
xlim([0.5 4.5]);
title("Stimulation side CB");
ylabel('FA');
xticks(1:4);
xticklabels({'SCC','dACC','MCC','PCC'});

% asterisk
yl = ylim;
ypos = yl(2) * 0.92;

for part = 1:4
    for k = 1:size(tbl2,1)
        A = strtrim(string(tbl2{k,1}));
        B = strtrim(string(tbl2{k,2}));

        cond1 = (A == sprintf('PrePost=1,side=1,part=%d',part) && ...
                 B == sprintf('PrePost=2,side=1,part=%d',part));
        cond2 = (A == sprintf('PrePost=2,side=1,part=%d',part) && ...
                 B == sprintf('PrePost=1,side=1,part=%d',part));

        if cond1 || cond2
            p = tbl2{k,6};

            if p < 0.001
                text(part, ypos, "***", 'FontSize',18, 'Color','r', ...
                    'HorizontalAlignment','center');
            elseif p < 0.01
                text(part, ypos, "**", 'FontSize',18, 'Color','r', ...
                    'HorizontalAlignment','center');
            elseif p < 0.05
                text(part, ypos, "*", 'FontSize',18, 'Color','r', ...
                    'HorizontalAlignment','center');
            end
            break;
        end
    end
end


% control side 
subplot(2,1,2); hold on;

fa_c_pre_part_mean = nan(1,4);
fa_c_pre_part_sem  = nan(1,4);
fa_c_pos_part_mean = nan(1,4);
fa_c_pos_part_sem  = nan(1,4);

for part = 1:4
    % pre, side=2
    idx = (list.data(:,3) == 1 & list.data(:,4) == 2 & list.data(:,5) == part);
    vals = list.data(idx,1);

    fa_c_pre_part_mean(part) = mean(vals);
    fa_c_pre_part_sem(part)  = std(vals) / sqrt(length(vals));

    fa_c_pre_monkey1_mean = mean(list.data(list.data(:,2)==1 & idx,1));
    fa_c_pre_monkey2_mean = mean(list.data(list.data(:,2)==2 & idx,1));

    plot(part, fa_c_pre_monkey1_mean, 'co');
    plot(part, fa_c_pre_monkey2_mean, 'c^');

    % post, side=2
    idx = (list.data(:,3) == 2 & list.data(:,4) == 2 & list.data(:,5) == part);
    vals = list.data(idx,1);

    fa_c_pos_part_mean(part) = mean(vals);
    fa_c_pos_part_sem(part)  = std(vals) / sqrt(length(vals));

    fa_c_pos_monkey1_mean = mean(list.data(list.data(:,2)==1 & idx,1));
    fa_c_pos_monkey2_mean = mean(list.data(list.data(:,2)==2 & idx,1));

    plot(part, fa_c_pos_monkey1_mean, 'mo');
    plot(part, fa_c_pos_monkey2_mean, 'm^');
end

plot(1:4, fa_c_pre_part_mean, 'b-');
errorbar(1:4, fa_c_pre_part_mean, fa_c_pre_part_sem, 'b', 'LineStyle','none');

plot(1:4, fa_c_pos_part_mean, 'r-');
errorbar(1:4, fa_c_pos_part_mean, fa_c_pos_part_sem, 'r', 'LineStyle','none');

ylim([0 0.7]);
xlim([0.5 4.5]);
title("Control side CB");
ylabel('FA');
xticks(1:4);
xticklabels({'SCC','dACC','MCC','PCC'});

% asterisk
yl = ylim;
ypos = yl(2) * 0.92;

for part = 1:4
    for k = 1:size(tbl2,1)
        A = strtrim(string(tbl2{k,1}));
        B = strtrim(string(tbl2{k,2}));

        cond1 = (A == sprintf('PrePost=1,side=2,part=%d',part) && ...
                 B == sprintf('PrePost=2,side=2,part=%d',part));
        cond2 = (A == sprintf('PrePost=2,side=2,part=%d',part) && ...
                 B == sprintf('PrePost=1,side=2,part=%d',part));

        if cond1 || cond2
            p = tbl2{k,6};

            if p < 0.001
                text(part, ypos, "***", 'FontSize',18, 'Color','b', ...
                    'HorizontalAlignment','center');
            elseif p < 0.01
                text(part, ypos, "**", 'FontSize',18, 'Color','b', ...
                    'HorizontalAlignment','center');
            elseif p < 0.05
                text(part, ypos, "*", 'FontSize',18, 'Color','b', ...
                    'HorizontalAlignment','center');
            end
            break;
        end
    end
end

%% sample size
n_all = size(list.data,1);

n_SCC_pre_stim = sum(list.data(:,5) == 1 & list.data(:,3) == 1 & list.data(:,4) == 1);
n_SCC_post_stim = sum(list.data(:,5) == 1 & list.data(:,3) == 2 & list.data(:,4) == 1);
n_SCC_pre_con = sum(list.data(:,5) == 1 & list.data(:,3) == 1 & list.data(:,4) == 2);
n_SCC_post_con = sum(list.data(:,5) == 1 & list.data(:,3) == 2 & list.data(:,4) == 2);

n_dACC_pre_stim = sum(list.data(:,5) == 2 & list.data(:,3) == 1 & list.data(:,4) == 1);
n_dACC_post_stim = sum(list.data(:,5) == 2 & list.data(:,3) == 2 & list.data(:,4) == 1);
n_dACC_pre_con = sum(list.data(:,5) == 2 & list.data(:,3) == 1 & list.data(:,4) == 2);
n_dACC_post_con = sum(list.data(:,5) == 2 & list.data(:,3) == 2 & list.data(:,4) == 2);

n_MCC_pre_stim = sum(list.data(:,5) == 3 & list.data(:,3) == 1 & list.data(:,4) == 1);
n_MCC_post_stim = sum(list.data(:,5) == 3 & list.data(:,3) == 2 & list.data(:,4) == 1);
n_MCC_pre_con = sum(list.data(:,5) == 3 & list.data(:,3) == 1 & list.data(:,4) == 2);
n_MCC_post_con = sum(list.data(:,5) == 3 & list.data(:,3) == 2 & list.data(:,4) == 2);

n_PCC_pre_stim = sum(list.data(:,5) == 4 & list.data(:,3) == 1 & list.data(:,4) == 1);
n_PCC_post_stim = sum(list.data(:,5) == 4 & list.data(:,3) == 2 & list.data(:,4) == 1);
n_PCC_pre_con = sum(list.data(:,5) == 4 & list.data(:,3) == 1 & list.data(:,4) == 2);
n_PCC_post_con = sum(list.data(:,5) == 4 & list.data(:,3) == 2 & list.data(:,4) == 2);

%% tbl to excel
writetable(tbl2, 'dbs_FA_CBpart_tbl2_results.xlsx');