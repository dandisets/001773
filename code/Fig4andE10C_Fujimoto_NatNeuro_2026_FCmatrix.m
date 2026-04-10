%-------------------------------------------------------------------
% Functional connectome analysis for Fujimoto SH et al., (2026)
%-------------------------------------------------------------------
clear all; close all;

% set data directory
datadir = char('/Data');
analydir = char('/Codes');
cd(analydir);

% specify ROI mask (use mask after 3dresample)
MASK = "SCHARM"; % atlas (CHARM & SARM)
LEVEL = "4"; % Lv 4

MASKL = strcat(MASK,LEVEL);
MASKROIS = sprintf("SCHARM_in_NMT_15mm.nii.gz'[%s]'",string(str2num(LEVEL)-1));
tmp_label_table_CHARM = importdata(sprintf('CHARM_key_%s.txt',LEVEL),'\t');
tmp_label_table2_CHARM = string(tmp_label_table_CHARM.textdata);
label_table_CHARM = tmp_label_table2_CHARM(2:end,1:2);
tmp_label_table_SARM = importdata(sprintf('SARM_key_%s.txt',LEVEL),'\t');
tmp_label_table2_SARM = string(tmp_label_table_SARM.textdata);
label_table_SARM = tmp_label_table2_SARM(2:end,1:2);
for i = 1:size(label_table_SARM,1)
    label_table_SARM(i,1) = string(str2num(label_table_SARM(i,1))+300);
end
label_table = [label_table_CHARM;label_table_SARM];

% load MRI file list
lname = 'rest_dbs_list';
list = split(importdata(strcat(lname,'.csv'),'\t'),','); %specify .csv file
sesnum = size(list,1); %total number of sessions to analyze

%%
% full connectome analysis (3dNetCorr)
reorder_matrix = importdata('reorder_rois.txt');
for ses = 1:sesnum
    % set file name
    SUBJECT = list{ses,1};
    SESSION = list{ses,2};
    STATE = list{ses,3}; %'Pre' or 'Post'
    TREAT = list{ses,4}; %'DBS' or 'CON1/6'
    if TREAT=="DBS"
        filedir = strcat(datadir,SUBJECT,'_',SESSION,'/','posting.results/'); %specify directory of fanaticor files
    else
        filedir = strcat(datadir,SUBJECT,'_',SESSION,'/','PreInj.results/');
    end
    FILENAME = sprintf('errts.%s.fanaticor+tlrc',SUBJECT);
    if ~isfile(sprintf('%s_%s_%s_%s_000.netcc',SUBJECT,SESSION,MASKL,STATE))
        % copy errts files
        CPFILE = strcat(filedir,FILENAME,'*');
        copyfile(CPFILE, analydir);
        % compute roi-roi correlationroi_val
        system(sprintf('3dNetCorr -inset %s -in_rois %s -fish_z -ts_out -ts_wb_Z -nifti -push_thru_many_zeros -allow_roi_zeros -prefix %s_%s_%s_%s',FILENAME,MASKROIS,SUBJECT,SESSION,MASKL,STATE));
        delete(strcat(analydir,FILENAME,'*')); %has to be deleted because the copied file names are all same!
    end
    % specify number of active ROIs
    if ses==1 && STATE=="Pre"
        nrois = (size(importdata(sprintf('%s_%s_%s_%s_000.netcc',SUBJECT,SESSION,MASKL,STATE),','),1)-7)/2;
    end
    % create netcc 1-D vector
    A = dlmread(sprintf('%s_%s_%s_%s_000.netcc',SUBJECT,SESSION,MASKL,STATE),'\t',nrois+7, 0); % read netcc file - z value array
    A_reorder = A([reorder_matrix',55:nrois],[reorder_matrix',55:nrois]); % reorder ROI labels
    netcc_data_sbj = [];
    for i = 1:nrois
        if i==1
            netcc_data_sbj = A_reorder(1,2:nrois);
        elseif i<nrois
            netcc_data_sbj = [netcc_data_sbj,A_reorder(i,[1:i-1,i+1:nrois])];
        else
            netcc_data_sbj = [netcc_data_sbj,A_reorder(nrois,1:(nrois-1))];
        end
    end
    % make a matrix all session netc vector altogether
    g_netcc_data(ses,1:(nrois-1)*nrois) = netcc_data_sbj; %all sessions
end % each session

%%
% get atlas labels
clear atlas_label_names;
label_example_file = importdata(sprintf('%s_%s_%s_%s_000.netcc',SUBJECT,SESSION,MASKL,STATE),',');
tmp_labels = string(split(label_example_file(5)));
atlas_labels = tmp_labels(2:end);
for i = 1:length(atlas_labels)
    atlas_label_names(i,1) = "EMPTY";
    for j = 1:size(label_table,1)
        if atlas_labels(i)==label_table(j,1)
            atlas_label_names(i,1) = label_table(j,2); % full label
        end
    end
    tmpnames = char(atlas_label_names(i,1));
    if length(tmpnames)>11
        tmpnames = tmpnames(1:11);
    end
    atlas_label_short(i,1) = string(tmpnames); % short label
end
% reordering label name
atlas_label_names = atlas_label_names([reorder_matrix',55:nrois]);
atlas_label_short = atlas_label_short([reorder_matrix',55:nrois]);
%%
% create a heatmap
figure(1);
FIGSIZE = 80;
set(gcf,'Position',[50,0,20*FIGSIZE,12*FIGSIZE]);
g_netcc_pre = g_netcc_data(list(:,3)=="Pre" & (list(:,4)=="DBS" | list(:,4)=="CON1"),:); %Pre DBS scans
g_netcc_post = g_netcc_data((list(:,3)=="Post" & list(:,4)=="DBS") | list(:,4)=="CON6",:); %Post DBS scans (For control mks, post = pre + 6 wks)
g_netcc_diff = g_netcc_post - g_netcc_pre;
mk_list = ["DBS1","DBS2","CTRL1","CTRL2","CTRL3","Sham"];
netcc_sum_diff_all = []; netcc_sum_pre_all = []; netcc_sum_post_all = [];
dbs_mk_list = [1,2,6]; % 1=DBS1, 2=DBS2, 6=Sham

% data matrix for DBS monkeys
for dbscnt = 1:3
    % convert vector to original netcc style matrix
    netcc_matrix_pre = ones(nrois,nrois); netcc_matrix_post = ones(nrois,nrois); netcc_matrix_diff = zeros(nrois,nrois);
    for matrix_row = 1:nrois
        if matrix_row==1
            netcc_matrix_pre(1,2:nrois) = g_netcc_pre(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_post(1,2:nrois) = g_netcc_post(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_diff(1,2:nrois) = g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        elseif matrix_row>1 && matrix_row<nrois
            netcc_matrix_pre(matrix_row,1+matrix_row:nrois) =  g_netcc_pre(dbs_mk_list(dbscnt),(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_post(matrix_row,1+matrix_row:nrois) =  g_netcc_post(dbs_mk_list(dbscnt),(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_diff(matrix_row,1+matrix_row:nrois) =  g_netcc_diff(dbs_mk_list(dbscnt),(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_pre(matrix_row,1:matrix_row-1) =  g_netcc_pre(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
            netcc_matrix_post(matrix_row,1:matrix_row-1) =  g_netcc_post(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
            netcc_matrix_diff(matrix_row,1:matrix_row-1) =  g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
        elseif matrix_row==nrois
            netcc_matrix_pre(nrois,1:(nrois-1)) = g_netcc_pre(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_post(nrois,1:(nrois-1)) = g_netcc_post(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_diff(nrois,1:(nrois-1)) = g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        end
    end
    
    % average connectome
    if dbscnt==1 || dbscnt==2
        netcc_sum_pre_all(:,:,dbscnt) = netcc_matrix_pre;
        netcc_sum_post_all(:,:,dbscnt) = netcc_matrix_post;
        netcc_sum_diff_all(:,:,dbscnt) = netcc_matrix_diff;
    end
end
atlas_label_short = strrep(atlas_label_short,"_"," ");

dbscnt = 3;
% plot color map for individual sessions
subplot(3,4,1);
heatmap(atlas_label_short,atlas_label_short,netcc_matrix_pre,'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Pre")); ylabel(strcat(mk_list(dbs_mk_list(dbscnt)))); colorbar off;
subplot(3,4,2);
heatmap(atlas_label_short,atlas_label_short,netcc_matrix_post,'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Post")); colorbar off;
subplot(3,4,3);
heatmap(atlas_label_short,atlas_label_short,netcc_matrix_diff,'Colormap',parula,'ColorLimits',[-0.1 0.1],'GridVisible','off');
title(strcat(MASKL," Post-Pre"));

% box plots
subplot(3,4,4); hold on;
for dbscnt = 3
    % convert vector to original netcc style matrix
    netcc_matrix_diff = zeros(nrois,nrois);
    for matrix_row = 1:nrois
        if matrix_row==1
            netcc_matrix_diff(1,2:nrois) = g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        elseif matrix_row>1 && matrix_row<nrois
            netcc_matrix_diff(matrix_row,1+matrix_row:nrois) =  g_netcc_diff(dbs_mk_list(dbscnt),(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_diff(matrix_row,1:matrix_row-1) =  g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
        elseif matrix_row==nrois
            netcc_matrix_diff(nrois,1:(nrois-1)) = g_netcc_diff(dbs_mk_list(dbscnt),1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        end
    end
end
sbj_data_mean_sum = []; color_idx = []; color_grp = ['y','r','b'];
for i=1:nrois
    sbj_data_mean = [];
    if i==1
        sbj_data_mean = netcc_matrix_diff(2:nrois,1);
    elseif i<nrois
        sbj_data_mean = netcc_matrix_diff([1:i-1,i+1:nrois],i);
    elseif i==nrois
        sbj_data_mean = netcc_matrix_diff(1:nrois-1,nrois);
    end
    sbj_data_mean_sum = [sbj_data_mean_sum,sbj_data_mean];
    
    if ranksum(sbj_data_mean,zeros(length(sbj_data_mean),1))>=0.05/nrois
        color_idx = [color_idx,1];
    elseif mean(sbj_data_mean)>0
        color_idx = [color_idx,2];
    else
        color_idx = [color_idx,3];
    end
end
boxplot(sbj_data_mean_sum,'Colors',color_grp(color_idx),'PlotStyle','compact','OutlierSize',1,'Symbol','');
plot([54 54],[-0.7 0.4],'k-'); plot([0 nrois],[0 0],'k-');
ylim([-0.45 0.3]); xlabel("FCs"); ylabel("Z diff"); title("Each ROI average FC");

for sbj = 3:5
    % convert vector to original netcc style matrix
    netcc_matrix_pre = ones(nrois,nrois); netcc_matrix_post = ones(nrois,nrois); netcc_matrix_diff = zeros(nrois,nrois);
    for matrix_row = 1:nrois
        if matrix_row==1
            netcc_matrix_pre(1,2:nrois) = g_netcc_pre(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_post(1,2:nrois) = g_netcc_post(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_diff(1,2:nrois) = g_netcc_diff(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        elseif matrix_row>1 && matrix_row<nrois
            netcc_matrix_pre(matrix_row,1+matrix_row:nrois) =  g_netcc_pre(sbj,(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_post(matrix_row,1+matrix_row:nrois) =  g_netcc_post(sbj,(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_diff(matrix_row,1+matrix_row:nrois) =  g_netcc_diff(sbj,(nrois-1)*(matrix_row-1)+matrix_row:(nrois-1)*matrix_row);
            netcc_matrix_pre(matrix_row,1:matrix_row-1) =  g_netcc_pre(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
            netcc_matrix_post(matrix_row,1:matrix_row-1) =  g_netcc_post(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
            netcc_matrix_diff(matrix_row,1:matrix_row-1) =  g_netcc_diff(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*(matrix_row-1)+matrix_row-1);
        elseif matrix_row==nrois
            netcc_matrix_pre(nrois,1:(nrois-1)) = g_netcc_pre(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_post(nrois,1:(nrois-1)) = g_netcc_post(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
            netcc_matrix_diff(nrois,1:(nrois-1)) = g_netcc_diff(sbj,1+(nrois-1)*(matrix_row-1):(nrois-1)*matrix_row);
        end
    end
    % average connectome
    netcc_sum_pre_all(:,:,sbj) = netcc_matrix_pre;
    netcc_sum_post_all(:,:,sbj) = netcc_matrix_post;
    netcc_sum_diff_all(:,:,sbj) = netcc_matrix_diff;
end
atlas_label_short = strrep(atlas_label_short,"_"," ");

dbsdata.pre = netcc_sum_pre_all;
dbsdata.post = netcc_sum_post_all;
dbsdata.diff = netcc_sum_diff_all;
save("dbs_matrix_data.mat","dbsdata");

% average
figure(2);
FIGSIZE = 80;
set(gcf,'Position',[50,0,20*FIGSIZE,12*FIGSIZE]);
% bar graphs
subplot(3,4,1);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_pre_all(:,:,1:2),3),'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Pre")); colorbar off; ylabel("DBS2 AVERAGE");
subplot(3,4,2);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_post_all(:,:,1:2),3),'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Post")); colorbar off;
subplot(3,4,3);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_diff_all(:,:,1:2),3),'Colormap',parula,'ColorLimits',[-0.1 0.1],'GridVisible','off');
title(strcat(MASKL," Post-Pre"));
subplot(3,4,5);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_pre_all(:,:,3:5),3),'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Pre")); colorbar off; ylabel("CNTL3 AVERAGE");
subplot(3,4,6);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_post_all(:,:,3:5),3),'Colormap',parula,'ColorLimits',[-1 1],'GridVisible','off');
title(strcat(MASKL," Post")); colorbar off;
subplot(3,4,7);
heatmap(atlas_label_short,atlas_label_short,mean(netcc_sum_diff_all(:,:,3:5),3),'Colormap',parula,'ColorLimits',[-0.1 0.1],'GridVisible','off');
title(strcat(MASKL," Post-Pre"));
% box plots
subplot(3,4,4); hold on;
sbj_data_mean_sum = []; color_idx = []; color_grp = ['y','r','b'];
for i=1:nrois
    sbj_data_mean = [];
    if i==1
        sbj_data_mean = mean(netcc_sum_diff_all(2:nrois,1,1:2),3);
    elseif i<nrois
        sbj_data_mean = mean(netcc_sum_diff_all([1:i-1,i+1:nrois],i,1:2),3);
    elseif i==nrois
        sbj_data_mean = mean(netcc_sum_diff_all(1:nrois-1,nrois,1:2),3);
    end
    sbj_data_mean_sum = [sbj_data_mean_sum,sbj_data_mean];
    
    if ranksum(sbj_data_mean,zeros(length(sbj_data_mean),1))>=0.05/nrois
        color_idx = [color_idx,1];
    elseif mean(sbj_data_mean)>0
        color_idx = [color_idx,2];
    else
        color_idx = [color_idx,3];
    end
end
boxplot(sbj_data_mean_sum,'Colors',color_grp(color_idx),'PlotStyle','compact','OutlierSize',1,'Symbol','');
plot([54 54],[-0.7 0.4],'k-'); plot([0 nrois],[0 0],'k-');
ylim([-0.45 0.3]); xlabel("FCs"); ylabel("Z diff"); title("Each ROI average FC");
figure(2);
subplot(3,4,8); hold on;
sbj_data_mean_sum = []; color_idx = []; color_grp = ['y','r','b'];
for i=1:nrois
    sbj_data_mean = [];
    if i==1
        sbj_data_mean = mean(netcc_sum_diff_all(2:nrois,1,3:5),3);
    elseif i<nrois
        sbj_data_mean = mean(netcc_sum_diff_all([1:i-1,i+1:nrois],i,3:5),3);
    elseif i==nrois
        sbj_data_mean = mean(netcc_sum_diff_all(1:nrois-1,nrois,3:5),3);
    end
    sbj_data_mean_sum = [sbj_data_mean_sum,sbj_data_mean];
    
    if ranksum(sbj_data_mean,zeros(length(sbj_data_mean),1))>=0.05/nrois
        color_idx = [color_idx,1];
    elseif mean(sbj_data_mean)>0
        color_idx = [color_idx,2];
    else
        color_idx = [color_idx,3];
    end
end
boxplot(sbj_data_mean_sum,'Colors',color_grp(color_idx),'PlotStyle','compact','OutlierSize',1,'Symbol','');
plot([54 54],[-0.7 0.4],'k-'); plot([0 nrois],[0 0],'k-');
ylim([-0.45 0.3]); xlabel("FCs"); ylabel("Z diff"); title("Each ROI average FC");
%%
% Create circular graph
thr = 0.15;
figure(3);
FIGSIZE = 65;
set(gcf,'Position',[50,0,18*FIGSIZE,12*FIGSIZE]);
myLabel = cell(nrois);
for i = 1:nrois
    myLabel{i} = atlas_label_short(i);
end
subplot(1,2,1);
% negative value
x = mean(netcc_sum_diff_all(1:54,1:54,1:2),3);
x(isnan(x)) = 0;
x(x > -thr) = 0;
myColorMap = ones(length(x),3).*[0 0.5 1]; %blue
circularGraph(x,'Colormap',myColorMap,'label',myLabel);
% positive value
x = mean(netcc_sum_diff_all(1:54,1:54,1:2),3);
x(isnan(x)) = 0;
x(x < thr) = 0;
myColorMap = ones(length(x),3).*[1 0.5 0]; %red
circularGraph(x,'Colormap',myColorMap,'label',myLabel);
subplot(1,2,2);
% negative value
x = mean(netcc_sum_diff_all(1:54,1:54,3:5),3);
x(isnan(x)) = 0;
x(x > -thr) = 0;
myColorMap = ones(length(x),3).*[0 0.5 1]; %blue
circularGraph(x,'Colormap',myColorMap,'label',myLabel);
% positive value
x = mean(netcc_sum_diff_all(1:54,1:54,3:5),3);
x(isnan(x)) = 0;
x(x < thr) = 0;
myColorMap = ones(length(x),3).*[1 0.5 0]; %red
circularGraph(x,'Colormap',myColorMap,'label',myLabel);