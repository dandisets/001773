clear all;
close all;

maindir = char('C:\MATLAB_analy\DBS\data\'); 
cd(maindir);

%% load FA list
% mk N
% mk N dACC-PCC stim side
list = importdata('FA_CB_L_mkN.xlsx');
x = list.data(:,1);
y = list.data(:,2);
z = list.data(:,3);
prefa = list.data(:,4);
postfa = list.data(:,5);

% mk N SCCadj stim side
list_s = importdata('FA_SCC_CB_L_mkN.xlsx');
x_s = list_s.data(:,1);
y_s = list_s.data(:,2);
z_s = list_s.data(:,3);
prefa_s = list_s.data(:,4);
postfa_s = list_s.data(:,5);

% mk N dACC-PCC control side
list2 = importdata('FA_CB_R_mkN.xlsx');
cx = list2.data(:,1);
cy = list2.data(:,2);
cz = list2.data(:,3);
cprefa = list2.data(:,4);
cpostfa = list2.data(:,5);

% mk N SCCadj control side
list2_s = importdata('FA_SCC_CB_R_mkN.xlsx');
cx_s = list2_s.data(:,1);
cy_s = list2_s.data(:,2);
cz_s = list2_s.data(:,3);
cprefa_s = list2_s.data(:,4);
cpostfa_s = list2_s.data(:,5);

%%%mk T
% mk T dACC-PCC stim side
list3 = importdata('FA_CB_R_mkT.xlsx');
x3 = list3.data(:,1);
y3 = list3.data(:,2);
z3 = list3.data(:,3);
prefa3 = list3.data(:,4);
postfa3 = list3.data(:,5);

% mk T SCC stim side
list3_s = importdata('FA_SCC_CB_R_mkT.xlsx');
x3_s = list3_s.data(:,1);
y3_s = list3_s.data(:,2);
z3_s = list3_s.data(:,3);
prefa3_s = list3_s.data(:,4);
postfa3_s = list3_s.data(:,5);

% mk T dACC-PCC control side
list4 = importdata('FA_CB_L_mkT.xlsx');
cx4 = list4.data(:,1);
cy4 = list4.data(:,2);
cz4 = list4.data(:,3);
cprefa4 = list4.data(:,4);
cpostfa4 = list4.data(:,5);

% mk T SCC control side
list4_s = importdata('FA_SCC_CB_L_mkT.xlsx');
cx4_s = list4_s.data(:,1);
cy4_s = list4_s.data(:,2);
cz4_s = list4_s.data(:,3);
cprefa4_s = list4_s.data(:,4);
cpostfa4_s = list4_s.data(:,5);

%%%%mk N dACC-PCC%%%%%%%%
%calculate FA mean based on y; stimside
Xaxis = list.data(:,1);
Yaxis = list.data(:,2);
Zaxis = list.data(:,3);
preFAvalue = list.data(:,4);
postFAvalue = list.data(:,5);
T = table(Xaxis,Yaxis,Zaxis,preFAvalue,postFAvalue);

%calculate FA mean based on y; controlside
%dACC-PCC
Xaxis_c = list2.data(:,1);
Yaxis_c = list2.data(:,2);
Zaxis_c = list2.data(:,3);
preFAvalue_c = list2.data(:,4);
postFAvalue_c = list2.data(:,5);
T2 = table(Xaxis_c,Yaxis_c,Zaxis_c,preFAvalue_c,postFAvalue_c);

% % %stimside
%summary meand and std in each "y axis' group
G = groupsummary(T,'Yaxis',["mean","std"]);

%convert table into array
aG = table2array(G);

%calculate sem
aG(:,11) = aG(:,8)./sqrt(aG(:,2));
aG(:,12) = aG(:,10)./sqrt(aG(:,2));

% % %controlside
%summary meand and std in each "y axis' group
G2 = groupsummary(T2,'Yaxis_c',["mean","std"]);

%convert table into array
aG2 = table2array(G2);

%calculate sem
aG2(:,11) = aG2(:,8)./sqrt(aG2(:,2));
aG2(:,12) = aG2(:,10)./sqrt(aG2(:,2));

%%%%mk N SCC%%%%%%%%
%calculate FA mean based on z; stimside
Xaxis_s = list_s.data(:,1);
Yaxis_s = list_s.data(:,2);
Zaxis_s = list_s.data(:,3);
preFAvalue_s = list_s.data(:,4);
postFAvalue_s = list_s.data(:,5);
T_s = table(Xaxis_s,Yaxis_s,Zaxis_s,preFAvalue_s,postFAvalue_s);

%calculate FA mean based on y; controlside
%dACC-PCC
Xaxis_c_s = list2_s.data(:,1);
Yaxis_c_s = list2_s.data(:,2);
Zaxis_c_s = list2_s.data(:,3);
preFAvalue_c_s = list2_s.data(:,4);
postFAvalue_c_s = list2_s.data(:,5);
T2_s = table(Xaxis_c_s,Yaxis_c_s,Zaxis_c_s,preFAvalue_c_s,postFAvalue_c_s);

% % %stimside
%summary meand and std in each "y axis' group
G_s = groupsummary(T_s,'Zaxis_s',["mean","std"]);
% G_sk = groupsummary(T_s,'Yaxis','Zaxis_s',["mean","std"]);

%convert table into array
aG_s = table2array(G_s);

%calculate sem
aG_s(:,11) = aG_s(:,8)./sqrt(aG_s(:,2));
aG_s(:,12) = aG_s(:,10)./sqrt(aG_s(:,2));

% % %controlside
%summary meand and std in each "y axis' group
G2_s = groupsummary(T2_s,'Zaxis_c_s',["mean","std"]);

%convert table into array
aG2_s = table2array(G2_s);

%calculate sem
aG2_s(:,11) = aG2_s(:,8)./sqrt(aG2_s(:,2));
aG2_s(:,12) = aG2_s(:,10)./sqrt(aG2_s(:,2));


%%%%mk T dACC-PCC%%%%%%%%
%calculate FA mean based on y; stimside
Xaxis3 = list3.data(:,1);
Yaxis3 = list3.data(:,2);
Zaxis3 = list3.data(:,3);
preFAvalue3 = list3.data(:,4);
postFAvalue3 = list3.data(:,5);
T3 = table(Xaxis3,Yaxis3,Zaxis3,preFAvalue3,postFAvalue3);

%calculate FA mean based on y; controlside
Xaxis3_c = list4.data(:,1);
Yaxis3_c = list4.data(:,2);
Zaxis3_c = list4.data(:,3);
preFAvalue3_c = list4.data(:,4);
postFAvalue3_c = list4.data(:,5);
T4 = table(Xaxis3_c,Yaxis3_c,Zaxis3_c,preFAvalue3_c,postFAvalue3_c);

% % %stimside
%summary meand and std in each "y axis' group
G3 = groupsummary(T3,'Yaxis3',["mean","std"]);

%convert table into array
aG3 = table2array(G3);

%calculate sem
aG3(:,11) = aG3(:,8)./sqrt(aG3(:,2));
aG3(:,12) = aG3(:,10)./sqrt(aG3(:,2));

% % %controlside
%summary meand and std in each "y axis' group
G4 = groupsummary(T4,'Yaxis3_c',["mean","std"]);

%convert table into array
aG4 = table2array(G4);

%calculate sem
aG4(:,11) = aG4(:,8)./sqrt(aG4(:,2));
aG4(:,12) = aG4(:,10)./sqrt(aG4(:,2));

%%%%mk T SCC%%%%%%%%
%calculate FA mean based on y; stimside
Xaxis3_s = list3_s.data(:,1);
Yaxis3_s = list3_s.data(:,2);
Zaxis3_s = list3_s.data(:,3);
preFAvalue3_s = list3_s.data(:,4);
postFAvalue3_s = list3_s.data(:,5);
T3_s = table(Xaxis3_s,Yaxis3_s,Zaxis3_s,preFAvalue3_s,postFAvalue3_s);

%calculate FA mean based on y; controlside
Xaxis3_c_s = list4_s.data(:,1);
Yaxis3_c_s = list4_s.data(:,2);
Zaxis3_c_s = list4_s.data(:,3);
preFAvalue3_c_s = list4_s.data(:,4);
postFAvalue3_c_s = list4_s.data(:,5);
T4_s = table(Xaxis3_c_s,Yaxis3_c_s,Zaxis3_c_s,preFAvalue3_c_s,postFAvalue3_c_s);

% % %stimside
%summary meand and std in each "y axis' group
G3_s = groupsummary(T3_s,'Zaxis3_s',["mean","std"]);

%convert table into array
aG3_s = table2array(G3_s);

%calculate sem
aG3_s(:,11) = aG3_s(:,8)./sqrt(aG3_s(:,2));
aG3_s(:,12) = aG3_s(:,10)./sqrt(aG3_s(:,2));

% % %controlside
%summary meand and std in each "y axis' group
G4_s = groupsummary(T4_s,'Zaxis3_c_s',["mean","std"]);

%convert table into array
aG4_s = table2array(G4_s);

%calculate sem
aG4_s(:,11) = aG4_s(:,8)./sqrt(aG4_s(:,2));
aG4_s(:,12) = aG4_s(:,10)./sqrt(aG4_s(:,2));


%% SCC
%mean plot figure with error bar(SEM)
%blue pre, red post
figure;
subplot(4,2,1); hold on;
%Stim Pre
plot(aG_s(:,1),aG_s(:,7),'bo-');
errorbar(aG_s(:,1),aG_s(:,7),aG_s(:,11),'b');
%Stim Post
plot(aG_s(:,1),aG_s(:,9),'ro-');
errorbar(aG_s(:,1),aG_s(:,9),aG_s(:,12),'r');
xlabel("AP axis");
ylabel("FA value");
title("Monkey N SCC stim side");
ylim([0 1]);
xlim([-10 60]);
xticks(-50:5:20);

subplot(4,2,2); hold on;
%Control Pre
plot(aG2_s(:,1),aG2_s(:,7),'co-');
errorbar(aG2_s(:,1),aG2_s(:,7),aG2_s(:,11),'c');
%Control Post
plot(aG2_s(:,1),aG2_s(:,9),'mo-');
errorbar(aG2_s(:,1),aG2_s(:,9),aG2_s(:,12),'m');
xlabel("AP axis");
ylabel("FA value");
title("Monkey N SCC control side");
ylim([0 1]);
xlim([-10 60]);
xticks(-50:5:20);

subplot(4,2,3); hold on;
%Stim Pre
plot(aG3_s(:,1),aG3_s(:,7),'bo-');
errorbar(aG3_s(:,1),aG3_s(:,7),aG3_s(:,11),'b');
%Stim Post
plot(aG3_s(:,1),aG3_s(:,9),'ro-');
errorbar(aG3_s(:,1),aG3_s(:,9),aG3_s(:,12),'r');
xlabel("AP axis");
ylabel("FA value");
title("Monkey T SCC stim side");
ylim([0 1]);
xlim([-10 60]);
xticks(-50:5:20);

subplot(4,2,4); hold on;
%Control Pre
plot(aG4_s(:,1),aG4_s(:,7),'co-');
errorbar(aG4_s(:,1),aG4_s(:,7),aG4_s(:,11),'c');
%Control Post
plot(aG4_s(:,1),aG4_s(:,9),'mo-');
errorbar(aG4_s(:,1),aG4_s(:,9),aG4_s(:,12),'m');
xlabel("AP axis");
ylabel("FA value");
title("Monkey T SCC control side");
ylim([0 1]);
xlim([-10 60]);
xticks(-50:5:20);


%% dACC-PCC
%mean plot figure with error bar(SEM)
%blue pre, red post
subplot(4,2,5); hold on;
%Stim Pre
plot(aG(:,1),aG(:,7),'bo-');
errorbar(aG(:,1),aG(:,7),aG(:,11),'b');
%Stim Post
plot(aG(:,1),aG(:,9),'ro-');
errorbar(aG(:,1),aG(:,9),aG(:,12),'r');
xlabel("AP axis");
ylabel("FA value");
title("Monkey N stim side");
ylim([0 1]);
xlim([-60 10]);
xticks(-50:5:20);

subplot(4,2,6); hold on;
%Control Pre
plot(aG2(:,1),aG2(:,7),'co-');
errorbar(aG2(:,1),aG2(:,7),aG2(:,11),'c');
%Control Post
plot(aG2(:,1),aG2(:,9),'mo-');
errorbar(aG2(:,1),aG2(:,9),aG2(:,12),'m');
xlabel("AP axis");
ylabel("FA value");
title("Monkey N control side");
ylim([0 1]);
xlim([-60 10]);
xticks(-50:5:20);

subplot(4,2,7); hold on;
%Stim Pre
plot(aG3(:,1),aG3(:,7),'bo-');
errorbar(aG3(:,1),aG3(:,7),aG3(:,11),'b');
%Stim Post
plot(aG3(:,1),aG3(:,9),'ro-');
errorbar(aG3(:,1),aG3(:,9),aG3(:,12),'r');
xlabel("AP axis");
ylabel("FA value");
title("Monkey T stim side");
ylim([0 1]);
xlim([-60 10]);
xticks(-50:5:20);

subplot(4,2,8); hold on;
%Control Pre
plot(aG4(:,1),aG4(:,7),'co-');
errorbar(aG4(:,1),aG4(:,7),aG4(:,11),'c');
%Control Post
plot(aG4(:,1),aG4(:,9),'mo-');
errorbar(aG4(:,1),aG4(:,9),aG4(:,12),'m');
xlabel("AP axis");
ylabel("FA value");
title("Monkey T control side");
ylim([0 1]);
xlim([-60 10]);
xticks(-50:5:20);

