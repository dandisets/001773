clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\'); 
cd(maindir);

file_UF = ["FA_UFsup_L_mkN.xlsx","FA_UFsup_R_mkN.xlsx","FA_UFsup_R_mkT.xlsx","FA_UFsup_L_mkT.xlsx","FA_UFinf_L_mkN.xlsx","FA_UFinf_R_mkN.xlsx","FA_UFinf_R_mkT.xlsx","FA_UFinf_L_mkT.xlsx"];

for i = 1:4
    clear FA_Array && list;

    % load FA list
    list = importdata(file_UF(i));

    %calculate FA mean based on y; stimside
    Xaxis = list.data(:,1);
    Yaxis = list.data(:,2);
    Zaxis = list.data(:,3);
    preFAvalue = list.data(:,4);
    postFAvalue = list.data(:,5);
    FA_T= table(Xaxis,Yaxis,Zaxis,preFAvalue,postFAvalue);

    %summary meand and std in each "y axis' group
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


for i = 5:8
    clear FA_Array && list;

    % load FA list
    list = importdata(file_UF(i));

    %calculate FA mean based on y; stimside
    Xaxis = list.data(:,1);
    Yaxis = list.data(:,2);
    Zaxis = list.data(:,3);
    preFAvalue = list.data(:,4);
    postFAvalue = list.data(:,5);
    FA_T= table(Xaxis,Yaxis,Zaxis,preFAvalue,postFAvalue);

    %summary meand and std in each "y axis' group
    FA_Group = groupsummary(FA_T,'Zaxis',["mean","std"]);

    %convert table into array
    FA_Array= table2array(FA_Group);

    %calculate sem
    FA_Array(:,11) = FA_Array(:,8)./sqrt(FA_Array(:,2));
    FA_Array(:,12) =FA_Array(:,10)./sqrt(FA_Array(:,2));

    % save FA_Group 
    FA_Group_all{i} = FA_Group;
    FA_Array_all{i} = FA_Array;

    if i==5
        FA_data_5 = FA_Array;
    elseif i==6
        FA_data_6 = FA_Array;
    elseif i==7
        FA_data_7 = FA_Array;
    elseif i==8
        FA_data_8 = FA_Array;


    end
end


%make figure
%mk N prepost in stim side
%blue pre, red post
figure;
subplot(4,2,1); hold on;
%Stim Pre UFsup
plot(FA_data_1(:,1),FA_data_1(:,7),'bo-');
errorbar(FA_data_1(:,1),FA_data_1(:,7),FA_data_1(:,11),'b');
%Stim Post UFsup
plot(FA_data_1(:,1),FA_data_1(:,9),'ro-');
errorbar(FA_data_1(:,1),FA_data_1(:,9),FA_data_1(:,12),'r');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey N UFsup stim side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);


subplot(4,2,3); hold on;
%Stim Pre UFinf with adjusted axis coordinates
FA_data_5(:,1) = FA_data_5(:,1)*-1;
plot(FA_data_5(:,1),FA_data_5(:,7),'bo-');
errorbar(FA_data_5(:,1),FA_data_5(:,7),FA_data_5(:,11),'b');
%Stim Post UFinf with adjusted axis coordinates
plot(FA_data_5(:,1),FA_data_5(:,9),'ro-');
errorbar(FA_data_5(:,1),FA_data_5(:,9),FA_data_5(:,12),'r');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey N UFinf stim side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);

%mk N prepost in control side
%cyan pre, mazenda post
subplot(4,2,2); hold on;
%Stim Pre UFsup
plot(FA_data_2(:,1),FA_data_2(:,7),'co-');
errorbar(FA_data_2(:,1),FA_data_2(:,7),FA_data_2(:,11),'c');
%Stim Post UFsup
plot(FA_data_2(:,1),FA_data_2(:,9),'mo-');
errorbar(FA_data_2(:,1),FA_data_2(:,9),FA_data_2(:,12),'m');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey N UFsup control side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);


subplot(4,2,4); hold on;
%Stim Pre UFinf with adjusted axis coordinates
FA_data_6(:,1) = FA_data_6(:,1)*-1;
plot(FA_data_6(:,1),FA_data_6(:,7),'co-');
errorbar(FA_data_6(:,1),FA_data_6(:,7),FA_data_6(:,11),'c');
%Stim Post UFinf with adjusted axis coordinates
plot(FA_data_6(:,1),FA_data_6(:,9),'mo-');
errorbar(FA_data_6(:,1),FA_data_6(:,9),FA_data_6(:,12),'m');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey N UFinf control side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);


%mk T prepost in stim side
%blue pre, red post
subplot(4,2,5); hold on;
%Stim Pre UFsup
plot(FA_data_3(:,1),FA_data_3(:,7),'bo-');
errorbar(FA_data_3(:,1),FA_data_3(:,7),FA_data_3(:,11),'b');
%Stim Post UFsup
plot(FA_data_3(:,1),FA_data_3(:,9),'ro-');
errorbar(FA_data_3(:,1),FA_data_3(:,9),FA_data_3(:,12),'r');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey T UFsup stim side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);

%blue pre, red post
subplot(4,2,7); hold on;
%Stim Pre UFinf with adjusted axis coordinates
FA_data_7(:,1) = FA_data_7(:,1)*-1;
plot(FA_data_7(:,1),FA_data_7(:,7),'bo-');
errorbar(FA_data_7(:,1),FA_data_7(:,7),FA_data_7(:,11),'b');
%Stim Post UFinf with adjusted axis coordinates
plot(FA_data_7(:,1),FA_data_7(:,9),'ro-');
errorbar(FA_data_7(:,1),FA_data_7(:,9),FA_data_7(:,12),'r');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey T UFinf stim side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);

%mk T prepost in control side
%cyan pre, mazenda post
subplot(4,2,6); hold on;
%Stim Pre UFsup
plot(FA_data_4(:,1),FA_data_4(:,7),'co-');
errorbar(FA_data_4(:,1),FA_data_4(:,7),FA_data_4(:,11),'c');
%Stim Post UFsup
plot(FA_data_4(:,1),FA_data_4(:,9),'mo-');
errorbar(FA_data_4(:,1),FA_data_4(:,9),FA_data_4(:,12),'m');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey T UFsup control side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);

subplot(4,2,8); hold on;
%Stim Pre UFinf with adjusted axis coordinates
FA_data_8(:,1) = FA_data_8(:,1)*-1;
plot(FA_data_8(:,1),FA_data_8(:,7),'co-');
errorbar(FA_data_8(:,1),FA_data_8(:,7),FA_data_8(:,11),'c');
%Stim Post UFinf with adjusted axis coordinates
plot(FA_data_8(:,1),FA_data_8(:,9),'mo-');
errorbar(FA_data_8(:,1),FA_data_8(:,9),FA_data_8(:,12),'m');
%make label etc
xlabel("Axis");
ylabel("FA value");
title("Monkey T UFinf control side");
ylim([0 1]);
xlim([-50 20]);
xticks(-50:5:20);

