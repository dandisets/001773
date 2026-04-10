clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

% load list
list = importdata('dbs_FC25norm_mkD_concatenated_all_data_a.xlsx');

%% ROI analysis - ANOVA
fc_25_roi = list.data(:,4);
stim_25_roi = list.data(:,7);
side_25_roi = list.data(:,8);
roi_25_roi = list.data(:,6);

model_mat=[1 0 0;
    0 1 0;
    0 0 1;
    1 1 0;
    1 0 1;
    0 1 1;
    1 1 1;];

figure;
[p_25_roi,tbl_25_roi,stats_25_roi] = anovan(fc_25_roi,{stim_25_roi,side_25_roi,roi_25_roi},"Model",model_mat,"Varnames",["PrePost","side","roi"]);
[c_25_roi,m_25_roi,h_25_roi] = multcompare(stats_25_roi);
[results_25_roi,~,~,gnames_25_roi] = multcompare(stats_25_roi,"Dimension",[1 2 3]);
tbl_25_roi = array2table(results_25_roi,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl_25_roi.("Group A")=gnames_25_roi(tbl_25_roi.("Group A"));
tbl_25_roi.("Group B")=gnames_25_roi(tbl_25_roi.("Group B"))


%% Box plot for ROI (17 brain regions); tile with asterisk
roiTable = readtable('FC_ROI_label.xlsx');
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
                list.data(:,8) == side);

            vals = list.data(idx,4);
            vals = vals(:);

            if ~isempty(vals)
                data_all = [data_all; vals];
                group_all = [group_all; xb*ones(length(vals),1)];
            end
        end
    end

    if ~isempty(data_all)
        boxplot(data_all, group_all, 'Symbol', '');
    end

    ylim([-0.1 0.2]);
    title(string(roi_label(roi)), 'Interpreter','none');

    xticks(1:4);
    xticklabels({'pre-shamside','post-shamside','pre-ctrlside','post-ctrlside'});
    xtickangle(45);

    yl = ylim;
    ypos = yl(2) * 0.9;

    for m = 1:size(tbl_25_roi,1)
        if string(tbl_25_roi{m,1}) == sprintf('PrePost=1,side=1,roi=%d',roi) && ...
                string(tbl_25_roi{m,2}) == sprintf('PrePost=2,side=1,roi=%d',roi)

            if tbl_25_roi{m,6} < 0.001
                text(1.5,ypos,"***",'FontSize',20,'color','r','HorizontalAlignment','center');
            elseif tbl_25_roi{m,6} < 0.01
                text(1.5,ypos,"**",'FontSize',20,'color','r','HorizontalAlignment','center');
            elseif tbl_25_roi{m,6} < 0.05
                text(1.5,ypos,"*",'FontSize',20,'color','r','HorizontalAlignment','center');
            end
        end
    end

    for m = 1:size(tbl_25_roi,1)
        if string(tbl_25_roi{m,1}) == sprintf('PrePost=1,side=2,roi=%d',roi) && ...
                string(tbl_25_roi{m,2}) == sprintf('PrePost=2,side=2,roi=%d',roi)

            if tbl_25_roi{m,6} < 0.001
                text(3.5,ypos,"***",'FontSize',20,'color','b','HorizontalAlignment','center');
            elseif tbl_25_roi{m,6} < 0.01
                text(3.5,ypos,"**",'FontSize',20,'color','b','HorizontalAlignment','center');
            elseif tbl_25_roi{m,6} < 0.05
                text(3.5,ypos,"*",'FontSize',20,'color','b','HorizontalAlignment','center');
            end
        end
    end
end


%% nw analysis - data reorganization for nw
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


%% Network analysis - ANOVA
fc_25_6nw   = Network_data(:,4);
stim_25_6nw = Network_data(:,7);
side_25_6nw = Network_data(:,8);
nw_25_6nw   = Network_data(:,10);

model_mat=[1 0 0;
    0 1 0;
    0 0 1;
    1 1 0;
    1 0 1;
    0 1 1;
    1 1 1;];

figure;
[p_25_6nw,tbl_25_6nw,stats_25_6nw] = anovan(fc_25_6nw,{stim_25_6nw,side_25_6nw,nw_25_6nw},"Model",model_mat,"Varnames",["PrePost","side","network"]);
[c_25_6nw,m_25_6nw,h_25_6nw] = multcompare(stats_25_6nw);
[results_25_6nw,~,~,gnames_25_6nw] = multcompare(stats_25_6nw,"Dimension",[1 2 3]);
tbl_25_6nw = array2table(results_25_6nw,"VariableNames", ...
    ["Group A","Group B","Lower Limit","A-B","Upper Limit","P-value"]);
tbl_25_6nw.("Group A")=gnames_25_6nw(tbl_25_6nw.("Group A"));
tbl_25_6nw.("Group B")=gnames_25_6nw(tbl_25_6nw.("Group B"))



%% Box plot for Network (6 brain nteworks); tile
figure;
t = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

Network_label = ["DMN","SAN","CEN","LIM","SMN","VIS"];

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
                Network_data(:,8) == side);

            vals = Network_data(idx,4);
            vals = vals(:);

            if ~isempty(vals)
                data_all = [data_all; vals];
                group_all = [group_all; xb*ones(length(vals),1)];
            end
        end
    end

    if ~isempty(data_all)
        boxplot(data_all, group_all, 'Symbol', '');
    end

    ylim([-0.1 0.15]);
    title(Network_label(Network), 'Interpreter','none');

    xticks(1:4);
    xticklabels({'pre-shamside','post-shamside','pre-ctrlside','post-ctrlside'});
    xtickangle(45);

    yl = ylim;
    ypos = yl(2) * 0.9;

    for m = 1:size(tbl_25_6nw,1)
        if string(tbl_25_6nw{m,1}) == sprintf('PrePost=1,side=1,network=%d',Network) && ...
                string(tbl_25_6nw{m,2}) == sprintf('PrePost=2,side=1,network=%d',Network)

            if tbl_25_6nw{m,6} < 0.001
                text(1.5,ypos,"***",'FontSize',20,'color','r','HorizontalAlignment','center');
            elseif tbl_25_6nw{m,6} < 0.01
                text(ypos,ypos,"**",'FontSize',20,'color','r','HorizontalAlignment','center');
            elseif tbl_25_6nw{m,6} < 0.05
                text(1.5,ypos,"*",'FontSize',20,'color','r','HorizontalAlignment','center');
            end
        end
    end


    for m = 1:size(tbl_25_6nw,1)
        if string(tbl_25_6nw{m,1}) == sprintf('PrePost=1,side=2,network=%d',Network) && ...
                string(tbl_25_6nw{m,2}) == sprintf('PrePost=2,side=2,network=%d',Network)

            if tbl_25_6nw{m,6} < 0.001
                text(3.5,ypos,"***",'FontSize',20,'color','b','HorizontalAlignment','center');
            elseif tbl_25_6nw{m,6} < 0.01
                text(3.5,ypos,"**",'FontSize',20,'color','b','HorizontalAlignment','center');
            elseif tbl_25_6nw{m,6} < 0.05
                text(3.5,ypos,"*",'FontSize',20,'color','b','HorizontalAlignment','center');
            end
        end
    end
end


%% ROI sample size (summary) for mkD script
roiTable = readtable('FC_ROI_label.xlsx');
roi_label = string(roiTable.ROI_Name);

n_roi_summary = table();

for roi = 1:17
    n_pre_stim  = sum(list.data(:,6)==roi & list.data(:,7)==1 & list.data(:,8)==1);
    n_post_stim = sum(list.data(:,6)==roi & list.data(:,7)==2 & list.data(:,8)==1);

    n_pre_ctrl  = sum(list.data(:,6)==roi & list.data(:,7)==1 & list.data(:,8)==2);
    n_post_ctrl = sum(list.data(:,6)==roi & list.data(:,7)==2 & list.data(:,8)==2);

    n_roi_summary.ROI(roi,1) = roi_label(roi);
    n_roi_summary.PreStim(roi,1)  = n_pre_stim;
    n_roi_summary.PostStim(roi,1) = n_post_stim;
    n_roi_summary.PreCtrl(roi,1)  = n_pre_ctrl;
    n_roi_summary.PostCtrl(roi,1) = n_post_ctrl;
end

disp(n_roi_summary)


%% Network sample size (summary) for mkD script
Network_label = ["DMN","SAN","CEN","LIM","SMN","VIS"];

n_network_summary = table();

for Network = 1:6
    n_pre_stim  = sum(Network_data(:,10)==Network & Network_data(:,7)==1 & Network_data(:,8)==1);
    n_post_stim = sum(Network_data(:,10)==Network & Network_data(:,7)==2 & Network_data(:,8)==1);

    n_pre_ctrl  = sum(Network_data(:,10)==Network & Network_data(:,7)==1 & Network_data(:,8)==2);
    n_post_ctrl = sum(Network_data(:,10)==Network & Network_data(:,7)==2 & Network_data(:,8)==2);

    n_network_summary.Network(Network,1) = Network_label(Network);
    n_network_summary.PreStim(Network,1)  = n_pre_stim;
    n_network_summary.PostStim(Network,1) = n_post_stim;
    n_network_summary.PreCtrl(Network,1)  = n_pre_ctrl;
    n_network_summary.PostCtrl(Network,1) = n_post_ctrl;
end

disp(n_network_summary)


%% save
writetable(n_roi_summary, 'FC_mkD_n_roi_summary.xlsx');
writetable(n_network_summary, 'FC_mkD_n_network_summary.xlsx');

%% tbl to excel
writetable(tbl_25_6nw, 'dbs_FC_25norm_mkD_tbl_25_6nw_results.xlsx');
writetable(tbl_25_roi, 'dbs_FC_25norm_mkD_tbl_25_roi_results.xlsx');