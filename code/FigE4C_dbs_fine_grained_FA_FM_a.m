clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\');
cd(maindir);

file_FM = ["FA_FM_L_mkN.xlsx","FA_FM_R_mkN.xlsx","FA_FM_R_mkT.xlsx","FA_FM_L_mkT.xlsx"];

for i = 1:4
    clear FA_Array && list;

    % load FA list
    list = importdata(file_FM(i));

    %calculate FA mean based on y; stimside
    Xaxis = list.data(:,1);
    Yaxis = list.data(:,2);
    Zaxis = list.data(:,3);
    preFAvalue = list.data(:,4);
    postFAvalue = list.data(:,5);
    FA_T= table(Xaxis,Yaxis,Zaxis,preFAvalue,postFAvalue);

    %summary mean and std in each "y axis' group
    FA_Group = groupsummary(FA_T,'Yaxis',["mean","std"]);

    %convert table into array
    FA_Array= table2array(FA_Group);

    %calculate sem
    FA_Array(:,11) = FA_Array(:,8)./sqrt(FA_Array(:,2));
    FA_Array(:,12) =FA_Array(:,10)./sqrt(FA_Array(:,2));

    % save FA_Group
    FA_Group_all{i} = FA_Group;
    FA_Array_all{i} = FA_Array;

    if i==1
    	FA_data_1 = FA_Array;
    elseif i==2
    	FA_data_2 = FA_Array;
    elseif i==3
    	FA_data_3 = FA_Array;
    elseif i==4
    	FA_data_4 = FA_Array;
    end
end

%make figure
%mk N prepost in stim side whole tract by z axis
%blue pre, red post
subplot(4,2,1); hold on;
%Stim Pre UFsup
FA_data_1(:,1) = FA_data_1(:,1);
plot(FA_data_1(:,1),FA_data_1(:,7),'bo-');
errorbar(FA_data_1(:,1),FA_data_1(:,7),FA_data_1(:,11),'b');
%Stim Post UFsup
plot(FA_data_1(:,1),FA_data_1(:,9),'ro-');
errorbar(FA_data_1(:,1),FA_data_1(:,9),FA_data_1(:,12),'r');
%make label etc
xlabel("AP Axis");
ylabel("FA value");
title("Monkey N FM stim side");
ylim([0 1]);
xlim([-55 -25]);
xticks(-55:5:-25);


%mk N prepost in control side whole tract by z axis
%blue pre, red post
subplot(4,2,2); hold on;
%Stim Pre UFsup
FA_data_2(:,1) = FA_data_2(:,1);
plot(FA_data_2(:,1),FA_data_2(:,7),'co-');
errorbar(FA_data_2(:,1),FA_data_2(:,7),FA_data_2(:,11),'c');
%Stim Post UFsup
plot(FA_data_2(:,1),FA_data_2(:,9),'mo-');
errorbar(FA_data_2(:,1),FA_data_2(:,9),FA_data_2(:,12),'m');
%make label etc
xlabel("AP Axis");
ylabel("FA value");
title("Monkey N FM control side");
ylim([0 1]);
xlim([-55 -25]);
xticks(-55:5:-25);


%mk T prepost in stim side whole tract by z axis
%blue pre, red post
subplot(4,2,3); hold on;
%Stim Pre UFsup
FA_data_3(:,1) = FA_data_3(:,1);
plot(FA_data_3(:,1),FA_data_3(:,7),'bo-');
errorbar(FA_data_3(:,1),FA_data_3(:,7),FA_data_3(:,11),'b');
%Stim Post UFsup
plot(FA_data_3(:,1),FA_data_3(:,9),'ro-');
errorbar(FA_data_3(:,1),FA_data_3(:,9),FA_data_3(:,12),'r');
%make label etc
xlabel("AP Axis");
ylabel("FA value");
title("Monkey T FM stim side");
ylim([0 1]);
xlim([-55 -25]);
xticks(-55:5:-25);



%mk T prepost in control side whole tract by z axis
%blue pre, red post
subplot(4,2,4); hold on;
%Stim Pre UFsup
FA_data_4(:,1) = FA_data_4(:,1);
plot(FA_data_4(:,1),FA_data_4(:,7),'co-');
errorbar(FA_data_4(:,1),FA_data_4(:,7),FA_data_4(:,11),'c');
%Stim Post UFsup
plot(FA_data_4(:,1),FA_data_4(:,9),'mo-');
errorbar(FA_data_4(:,1),FA_data_4(:,9),FA_data_4(:,12),'m');
%make label etc
xlabel("AP Axis");
ylabel("FA value");
title("Monkey T FM control side");
ylim([0 1]);
xlim([-55 -25]);
xticks(-55:5:-25);

