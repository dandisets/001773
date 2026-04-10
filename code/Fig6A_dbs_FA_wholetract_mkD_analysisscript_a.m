clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

% load list
list = importdata('dbs_FA_wholetract_mkD_data_a.xlsx');

%% ANOVA
y = list.data(:,1);
g1 = list.data(:,2);
g2 = list.data(:,3);
g3 = list.data(:,4);

model_mat=[1 0 0;
    0 1 0;
    0 0 1;
    1 1 0;
    1 0 1;
    0 1 1;
    1 1 1;];
[p,tbl,stats] = anovan(y,{g1,g2,g3},"Model",model_mat,"Varnames",["PrePost","side","tract"]);

% posthoc
[c,m,h] = multcompare(stats);
[results,~,~,gnames] = multcompare(stats,"Dimension",[1 2 3]);
tbl2 = array2table(results,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl2.("Group A")=gnames(tbl2.("Group A"));
tbl2.("Group B")=gnames(tbl2.("Group B"));

%% bar plot
figure;
tract_label = ["CB","UF","FM"];
for tract = 1:3
    subplot(1,3,tract); hold on;
    xb = 0;
    for side = 1:2
        for ope = 1:2
            fa_tract_mean = mean(list.data(list.data(:,2) == ope & list.data(:,3) == side & list.data(:,4) == tract, 1));
            fa_tract_sem = std(list.data(list.data(:,2) == ope & list.data(:,3) == side & list.data(:,4) == tract, 1))/length(list.data(list.data(:,2) == ope & list.data(:,3) == side & list.data(:,4) == tract, 1))^0.5;
            xb = xb+1;
            bar(xb, fa_tract_mean,'w');
            errorbar(xb, fa_tract_mean, fa_tract_sem,'k');
        end
    end
    ylim([-0 0.5]);
    title(tract_label(tract));
    ylabel('FA');
    xticks(1:4);
    xticklabels({'pre-shamside','post-shamside','pre-controlside','post-controlside'});
end

%% boxplot with asterisk
figure;
tract_label = ["CB","UF","FM"];

for tract = 1:3
    subplot(1,3,tract); hold on;

    data_all = [];
    group_all = [];
    xb = 0;

    for side = 1:2
        for prepost = 1:2
            xb = xb + 1;

            idx = (list.data(:,2) == prepost & ...
                list.data(:,3) == side & ...
                list.data(:,4) == tract);

            fa_vals = list.data(idx,1);

            data_all = [data_all; fa_vals];
            group_all = [group_all; xb*ones(length(fa_vals),1)];

        end
    end

    boxplot(data_all, group_all,'Symbol','');

    % ylim([0 1]);
    title(tract_label(tract));
    ylabel('FA');
    ylim([-0.05 1.05]);
    xticks(1:4);
    xticklabels({'pre-shamside','post-shamside','pre-controlside','post-controlside'});

    % add asterisk
    yl = ylim;
    ypos = yl(2) * 0.9;

    % stimulation side (side = 1)
    for k = 1:size(tbl2,1)
        A = string(tbl2{k,1});
        B = string(tbl2{k,2});

        cond1 = (A == sprintf('PrePost=1,side=1,tract=%d',tract) && ...
            B == sprintf('PrePost=2,side=1,tract=%d',tract));
        cond2 = (A == sprintf('PrePost=2,side=1,tract=%d',tract) && ...
            B == sprintf('PrePost=1,side=1,tract=%d',tract));

        if cond1 || cond2
            p = tbl2{k,6};

            if p < 0.001
                text(1.5, ypos, "***", 'FontSize',20, 'Color','r', ...
                    'HorizontalAlignment','center');
            elseif p < 0.01
                text(1.5, ypos, "**", 'FontSize',20, 'Color','r', ...
                    'HorizontalAlignment','center');
            elseif p < 0.05
                text(1.5, ypos, "*", 'FontSize',20, 'Color','r', ...
                    'HorizontalAlignment','center');
            end
            break;
        end
    end

    % control side (side = 2)
    for k = 1:size(tbl2,1)
        A = string(tbl2{k,1});
        B = string(tbl2{k,2});

        cond1 = (A == sprintf('PrePost=1,side=2,tract=%d',tract) && ...
            B == sprintf('PrePost=2,side=2,tract=%d',tract));
        cond2 = (A == sprintf('PrePost=2,side=2,tract=%d',tract) && ...
            B == sprintf('PrePost=1,side=2,tract=%d',tract));

        if cond1 || cond2
            p = tbl2{k,6};

            if p < 0.001
                text(3.5, ypos, "***", 'FontSize',20, 'Color','b', ...
                    'HorizontalAlignment','center');
            elseif p < 0.01
                text(3.5, ypos, "**", 'FontSize',20, 'Color','b', ...
                    'HorizontalAlignment','center');
            elseif p < 0.05
                text(3.5, ypos, "*", 'FontSize',20, 'Color','b', ...
                    'HorizontalAlignment','center');
            end
            break;
        end
    end
end

%% sample size
n_all = size(list.data,1);

n_cb_pre_sham = sum(list.data(:,4) == 1 & list.data(:,2) == 1 & list.data(:,3) == 1);
n_cb_post_sham = sum(list.data(:,4) == 1 & list.data(:,2) == 2 & list.data(:,3) == 1);
n_cb_pre_con = sum(list.data(:,4) == 1 & list.data(:,2) == 1 & list.data(:,3) == 2);
n_cb_post_con = sum(list.data(:,4) == 1 & list.data(:,2) == 2 & list.data(:,3) == 2);

n_uf_pre_sham = sum(list.data(:,4) == 2 & list.data(:,2) == 1 & list.data(:,3) == 1);
n_uf_post_sham = sum(list.data(:,4) == 2 & list.data(:,2) == 2 & list.data(:,3) == 1);
n_uf_pre_con = sum(list.data(:,4) == 2 & list.data(:,2) == 1 & list.data(:,3) == 2);
n_uf_post_con = sum(list.data(:,4) == 2 & list.data(:,2) == 2 & list.data(:,3) == 2);

n_fm_pre_sham = sum(list.data(:,4) == 3 & list.data(:,2) == 1 & list.data(:,3) == 1);
n_fm_post_sham = sum(list.data(:,4) == 3 & list.data(:,2) == 2 & list.data(:,3) == 1);
n_fm_pre_con = sum(list.data(:,4) == 3 & list.data(:,2) == 1 & list.data(:,3) == 2);
n_fm_post_con = sum(list.data(:,4) == 3 & list.data(:,2) == 2 & list.data(:,3) == 2);

%% tbl to excel
writetable(tbl2, 'dbs_FA_wholetract_mkD_tbl2_results.xlsx');