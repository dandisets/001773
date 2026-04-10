clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

% load list
list = importdata('dbs_FC25norm_mkNT_concatenated_all_data_a.xlsx');

%% ROI analysis - ANOVA
fc_25_roi = list.data(:,4);
mk_25_roi = list.data(:,5);
stim_25_roi = list.data(:,7);
side_25_roi = list.data(:,8);
roi_25_roi = list.data(:,6);

model_mat=[1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    0 1 1 0;
    0 1 0 1;
    0 0 1 1;
    0 1 1 1;];

figure;
[p_25_roi,tbl_25_roi,stats_25_roi] = anovan(fc_25_roi,{mk_25_roi,stim_25_roi,side_25_roi,roi_25_roi},"Model",model_mat,"Varnames",["Subject","PrePost","side","roi"]);
[c_25_roi,m_25_roi,h_25_roi] = multcompare(stats_25_roi);
[results_25_roi,~,~,gnames_25_roi] = multcompare(stats_25_roi,"Dimension",[2 3 4]);
tbl_25_roi = array2table(results_25_roi,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl_25_roi.("Group A")=gnames_25_roi(tbl_25_roi.("Group A"));
tbl_25_roi.("Group B")=gnames_25_roi(tbl_25_roi.("Group B"))
%% Bar graph
roiTable = readtable('FC_ROI_label.xlsx');
roi_label = roiTable.ROI_Name;

figure;
for roi = 1:17
    subplot(3,7,roi); hold on;
    xb = 0;
    for side = 1:2
        for time = 1:2
            dataSubset = list.data(list.data(:,6) == roi & list.data(:,7) == time & list.data(:,8) == side, :);
            dataSubset = list.data((list.data(:,6) == roi) & (list.data(:,7) == time) & ...
                (list.data(:,8) == side) & ...
                (list.data(:,5) == 1 | list.data(:,5) == 2), :);

            dataSubset_mk1 = dataSubset(dataSubset(:,5) == 1, :);
            dataSubset_mk2 = dataSubset(dataSubset(:,5) == 2, :);

            fc_roi_mean = mean(dataSubset(:,4));
            fc_roi_sem = std(dataSubset(:,4)) / sqrt(height(dataSubset));

            fc_roi_mean_monkey1 = mean(dataSubset_mk1(:,4));
            fc_roi_mean_monkey2 = mean(dataSubset_mk2(:,4));

            xb = xb + 1;

            barColor = '#faa5c6'; % Default color for side = 0
            if side == 2
                barColor = '#a5c4fa'; % Color for side = 1
            end

            bar(xb, fc_roi_mean, 'FaceColor', barColor);
            errorbar(xb, fc_roi_mean, fc_roi_sem, 'k');
            if time == 1
                errorbar(xb, fc_roi_mean, fc_roi_sem, 'r');
            end

            plot(xb, fc_roi_mean_monkey1, ['b', 'o-']);
            plot(xb, fc_roi_mean_monkey2, ['b', '^-']);
        end
    end

    %ylim setting
    ylim([-0.05 0.2]);
    %ylim([0 1.5]);%area 25
    title(roi_label{roi});

    yl = ylim;
    ypos = yl(2) * 0.9;

    for k = 1:size(tbl_25_roi,1)
        if string(tbl_25_roi{k,1})==sprintf('PrePost=1,side=1,roi=%d',roi) && string(tbl_25_roi{k,2})==sprintf('PrePost=2,side=1,roi=%d',roi)
            if tbl_25_roi{k,6}<0.001
                text(1,ypos,"***",'FontSize',20,'color','r');
            elseif tbl_25_roi{k,6}<0.01
                text(1,ypos,"**",'FontSize',20,'color','r');
            elseif tbl_25_roi{k,6}<0.05
                text(1,ypos,"*",'FontSize',20,'color','r');
            end

        end
    end
    for k = 1:size(tbl_25_roi,1)
        if string(tbl_25_roi{k,1})==sprintf('PrePost=1,side=2,roi=%d',roi) && string(tbl_25_roi{k,2})==sprintf('PrePost=2,side=2,roi=%d',roi)
            if tbl_25_roi{k,6}<0.001
                text(3,ypos,"***",'FontSize',20,'color','b');
            elseif tbl_25_roi{k,6}<0.01
                text(3,ypos,"**",'FontSize',20,'color','b');
            elseif tbl_25_roi{k,6}<0.05
                text(3,ypos,"*",'FontSize',20,'color','b');
            end
        end
    end
end
%% Box plot for ROI (17 brain regions); tile with asterisk
roi_label = roiTable.ROI_Name;

figure;
t = tiledlayout(3,7,'TileSpacing','compact','Padding','compact');

for roi = 1:17
    nexttile; hold on;
    xb = 0;

    data_all = [];
    group_all = [];


    for side = 1:2
        for time = 1:2
            xb = xb + 1;

            idx = (list.data(:,6) == roi & ...
                list.data(:,7) == time & ...
                list.data(:,8) == side & ...
                (list.data(:,5) == 1 | list.data(:,5) == 2)); % subject

            vals = list.data(idx,4);
            vals = vals(:);
            % subjectごとのmean（ここも5列目にそろえる）
            idx_mk1 = idx & (list.data(:,5) == 1);
            idx_mk2 = idx & (list.data(:,5) == 2);

            vals_mk1 = list.data(idx_mk1, 4);
            vals_mk2 = list.data(idx_mk2, 4);

            if ~isempty(vals_mk1)
                mean_mk1_all(xb) = mean(vals_mk1);
            end
            if ~isempty(vals_mk2)
                mean_mk2_all(xb) = mean(vals_mk2);
            end
            if ~isempty(vals)
                data_all  = [data_all; vals];
                group_all = [group_all; xb * ones(length(vals),1)];
            end
        end
    end

    if ~isempty(data_all)
        boxplot(data_all, group_all, 'Symbol', '');
    end

    ylim([-0.15 0.3]);
    title(string(roi_label(roi)), 'Interpreter','none');

    xticks(1:4);
    xticklabels({'pre-stimside','post-stimside','pre-ctrlside','post-ctrlside'});
    xtickangle(45);

    % overlay mean for subjects
    offset = 0.08;
    for g = 1:4
        if ~isnan(mean_mk1_all(g))
            plot(g - offset, mean_mk1_all(g), 'o', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','none', ...
                'MarkerSize',6, ...
                'LineWidth',1.2);
        end

        if ~isnan(mean_mk2_all(g))
            plot(g + offset, mean_mk2_all(g), '^', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','none', ...
                'MarkerSize',6, ...
                'LineWidth',1.2);
        end
    end

    yl = ylim;
    ypos = yl(2) * 0.9;

    for k = 1:size(tbl_25_roi,1)
        A = string(tbl_25_roi{k,1});
        B = string(tbl_25_roi{k,2});

        cond1 = (A == sprintf('PrePost=1,side=1,roi=%d',roi) && ...
            B == sprintf('PrePost=2,side=1,roi=%d',roi));
        cond2 = (A == sprintf('PrePost=2,side=1,roi=%d',roi) && ...
            B == sprintf('PrePost=1,side=1,roi=%d',roi));

        if cond1 || cond2
            p = tbl_25_roi{k,6};

            if p < 0.001
                text(1.5, ypos, "***",'FontSize',20,'Color','r','HorizontalAlignment','center');
            elseif p < 0.01
                text(1.5, ypos, "**",'FontSize',20,'Color','r','HorizontalAlignment','center');
            elseif p < 0.05
                text(1.5, ypos, "*",'FontSize',20,'Color','r','HorizontalAlignment','center');
            end
            break;
        end
    end

    for k = 1:size(tbl_25_roi,1)
        A = string(tbl_25_roi{k,1});
        B = string(tbl_25_roi{k,2});

        cond1 = (A == sprintf('PrePost=1,side=2,roi=%d',roi) && ...
            B == sprintf('PrePost=2,side=2,roi=%d',roi));
        cond2 = (A == sprintf('PrePost=2,side=2,roi=%d',roi) && ...
            B == sprintf('PrePost=1,side=2,roi=%d',roi));

        if cond1 || cond2
            p = tbl_25_roi{k,6};

            if p < 0.001
                text(3.5, ypos, "***",'FontSize',20,'Color','b','HorizontalAlignment','center');
            elseif p < 0.01
                text(3.5, ypos, "**",'FontSize',20,'Color','b','HorizontalAlignment','center');
            elseif p < 0.05
                text(3.5, ypos, "*",'FontSize',20,'Color','b','HorizontalAlignment','center');
            end
            break;
        end
    end
end

%% Network analysis - data reorganization for nw
% DMN
DMN = list.data(ismember(list.data(:,6), [1,2,3]), :);
DMN(:, end+1) = 1;

% SAN
SAN = list.data(ismember(list.data(:,6), [4,5]), :);
SAN(:, end+1) = 2;

% CEN
CEN = list.data(ismember(list.data(:,6), [6,7]), :);
CEN(:, end+1) = 3;

% LIM
LIM = list.data(ismember(list.data(:,6), [1,5,8,9,10,11,12]), :);
LIM(:, end+1) = 4;

% SMN
SMN = list.data(ismember(list.data(:,6), [13,14,15]), :);
SMN(:, end+1) = 5;

% VIS
VIS = list.data(ismember(list.data(:,6), [16,17]), :);
VIS(:, end+1) = 6;

% combine all network data
Network_data = [DMN; SAN; CEN; LIM; SMN; VIS];

%% Network FC with area 25 6 nw
fc_25_6nw = Network_data(:,4);
mk_25_6nw = Network_data(:,5);
stim_25_6nw = Network_data(:,7);
side_25_6nw = Network_data(:,8);
nw_25_6nw = Network_data(:,10);

model_mat=[1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1;
    0 1 1 0;
    0 1 0 1;
    0 0 1 1;
    0 1 1 1;];

figure;
[p_25_6nw,tbl_25_6nw,stats_25_6nw] = anovan(fc_25_6nw,{mk_25_6nw,stim_25_6nw,side_25_6nw,nw_25_6nw},"Model",model_mat,"Varnames",["Subject","PrePost","side","network"]);
[c_25_6nw,m_25_6nw,h_25_6nw] = multcompare(stats_25_6nw);
[results_25_6nw,~,~,gnames_25_6nw] = multcompare(stats_25_6nw,"Dimension",[2 3 4]);
tbl_25_6nw = array2table(results_25_6nw,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl_25_6nw.("Group A")=gnames_25_6nw(tbl_25_6nw.("Group A"));
tbl_25_6nw.("Group B")=gnames_25_6nw(tbl_25_6nw.("Group B"))


%% ROI analysis bar graph
figure;
Network_label = ["DMN","SAN","CEN","LIM","SMN","VIS"] ;
for Network = 1:6
    subplot(2,3,Network); hold on;
    xb = 0;
    for side = 1:2
        for time = 1:2
            dataSubset_Network = Network_data(Network_data(:,10) == Network & Network_data(:,7) == time & Network_data(:,8) == side, :);
            dataSubset_Network = Network_data((Network_data(:,10) == Network) & (Network_data(:,7) == time) & ...
                (Network_data(:,8) == side) & ...
                (Network_data(:,5) == 1 | Network_data(:,5) == 2), :);

            dataSubset_Network_mk1 = dataSubset_Network(dataSubset_Network(:,5) == 1, :);
            dataSubset_Network_mk2 = dataSubset_Network(dataSubset_Network(:,5) == 2, :);

            fc_roi_mean = mean(dataSubset_Network(:,4));
            fc_roi_sem = std(dataSubset_Network(:,4)) / sqrt(height(dataSubset_Network));

            fc_roi_mean_monkey1 = mean(dataSubset_Network_mk1(:,4));
            fc_roi_mean_monkey2 = mean(dataSubset_Network_mk2(:,4));

            xb = xb + 1;

            barColor = '#faa5c6'; % Default color for side = 0
            if side == 2
                barColor = '#a5c4fa'; % Color for side = 1
            end

            bar(xb, fc_roi_mean, 'FaceColor', barColor);
            errorbar(xb, fc_roi_mean, fc_roi_sem, 'k');
            if time == 1
                errorbar(xb, fc_roi_mean, fc_roi_sem, 'r');
            end

            plot(xb, fc_roi_mean_monkey1, ['b', 'o-']);
            plot(xb, fc_roi_mean_monkey2, ['b', '^-']);
        end
    end

    %ylim setting
    ylim([-0.05 0.15]);
    %ylim([0 1.5]);
    title(Network_label{Network});

    yl = ylim;
    ypos = yl(2) * 0.9;

    for k = 1:size(tbl_25_6nw,1)
        if string(tbl_25_6nw{k,1})==sprintf('PrePost=1,side=1,network=%d',Network) && string(tbl_25_6nw{k,2})==sprintf('PrePost=2,side=1,network=%d',Network)
            if tbl_25_6nw{k,6}<0.001
                text(1,ypos,"***",'FontSize',20,'color','r');
            elseif tbl_25_6nw{k,6}<0.01
                text(1,ypos,"**",'FontSize',20,'color','r');
            elseif tbl_25_6nw{k,6}<0.05
                text(1,ypos,"*",'FontSize',20,'color','r');
            end

        end
    end
    for k = 1:size(tbl_25_6nw,1)
        if string(tbl_25_6nw{k,1})==sprintf('PrePost=1,side=2,network=%d',Network) && string(tbl_25_6nw{k,2})==sprintf('PrePost=2,side=2,network=%d',Network)
            if tbl_25_6nw{k,6}<0.001
                text(3,ypos,"***",'FontSize',20,'color','b');
            elseif tbl_25_6nw{k,6}<0.01
                text(3,ypos,"**",'FontSize',20,'color','b');
            elseif tbl_25_6nw{k,6}<0.05
                text(3,ypos,"*",'FontSize',20,'color','b');
            end
        end
    end
end

%% Box plot for Network (6 brain networks); tile with asterisk
Network_label = ["DMN","SAN","CEN","LIM","SMN","VIS"] ;

figure;
t = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

for Network = 1:6
    nexttile; hold on;
    xb = 0;

    data_all = [];
    group_all = [];


    for side = 1:2
        for time = 1:2
            xb = xb + 1;

            idx = (Network_data(:,10) == Network & ...
                Network_data(:,7) == time & ...
                Network_data(:,8) == side & ...
                (Network_data(:,5) == 1 | Network_data(:,5) == 2)); % subject

            vals = Network_data(idx,4);
            vals = vals(:);

            idx_mk1 = idx & (Network_data(:,5) == 1);
            idx_mk2 = idx & (Network_data(:,5) == 2);

            vals_mk1 = Network_data(idx_mk1, 4);
            vals_mk2 = Network_data(idx_mk2, 4);

            if ~isempty(vals_mk1)
                mean_mk1_all(xb) = mean(vals_mk1);
            end
            if ~isempty(vals_mk2)
                mean_mk2_all(xb) = mean(vals_mk2);
            end
            if ~isempty(vals)
                data_all  = [data_all; vals];
                group_all = [group_all; xb * ones(length(vals),1)];
            end
        end
    end

    if ~isempty(data_all)
        boxplot(data_all, group_all, 'Symbol', '');
    end

    ylim([-0.15 0.3]);
    title(string(Network_label(Network)), 'Interpreter','none');

    xticks(1:4);
    xticklabels({'pre-stimside','post-stimside','pre-ctrlside','post-ctrlside'});
    xtickangle(45);

    offset = 0.08;
    for g = 1:4
        if ~isnan(mean_mk1_all(g))
            plot(g - offset, mean_mk1_all(g), 'o', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','none', ...
                'MarkerSize',6, ...
                'LineWidth',1.2);
        end

        if ~isnan(mean_mk2_all(g))
            plot(g + offset, mean_mk2_all(g), '^', ...
                'MarkerEdgeColor','k', ...
                'MarkerFaceColor','none', ...
                'MarkerSize',6, ...
                'LineWidth',1.2);
        end
    end

    yl = ylim;
    ypos = yl(2) * 0.9;

    for k = 1:size(tbl_25_6nw,1)
        A = string(tbl_25_6nw{k,1});
        B = string(tbl_25_6nw{k,2});

        cond1 = (A == sprintf('PrePost=1,side=1,network=%d',Network) && ...
            B == sprintf('PrePost=2,side=1,network=%d',Network));
        cond2 = (A == sprintf('PrePost=2,side=1,network=%d',Network) && ...
            B == sprintf('PrePost=1,side=1,network=%d',Network));

        if cond1 || cond2
            p = tbl_25_6nw{k,6};

            if p < 0.001
                text(1.5, ypos, "***",'FontSize',20,'Color','r','HorizontalAlignment','center');
            elseif p < 0.01
                text(1.5, ypos, "**",'FontSize',20,'Color','r','HorizontalAlignment','center');
            elseif p < 0.05
                text(1.5, ypos, "*",'FontSize',20,'Color','r','HorizontalAlignment','center');
            end
            break;
        end
    end

    for k = 1:size(tbl_25_6nw,1)
        A = string(tbl_25_6nw{k,1});
        B = string(tbl_25_6nw{k,2});

        cond1 = (A == sprintf('PrePost=1,side=2,network=%d',Network) && ...
            B == sprintf('PrePost=2,side=2,network=%d',Network));
        cond2 = (A == sprintf('PrePost=2,side=2,network=%d',Network) && ...
            B == sprintf('PrePost=1,side=2,network=%d',Network));

        if cond1 || cond2
            p = tbl_25_6nw{k,6};

            if p < 0.001
                text(3.5, ypos, "***",'FontSize',20,'Color','b','HorizontalAlignment','center');
            elseif p < 0.01
                text(3.5, ypos, "**",'FontSize',20,'Color','b','HorizontalAlignment','center');
            elseif p < 0.05
                text(3.5, ypos, "*",'FontSize',20,'Color','b','HorizontalAlignment','center');
            end
            break;
        end
    end
end

%% disp(n_network_subject_summary)
writetable(n_roi_subject_summary, 'FC_mkNT_n_roi_subject_summary.xlsx');
writetable(n_network_subject_summary, 'FC_mkNT_n_network_subject_summary.xlsx');

%% tbl to excel
writetable(tbl_25_6nw, 'dbs_FC_25norm_mkNT_tbl_25_6nw_results.xlsx');
writetable(tbl_25_roi, 'dbs_FC_25norm_mkNT_tbl_25_roi_results.xlsx');