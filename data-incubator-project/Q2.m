clear all
clc

[num,txt,raw] = xlsread('MERGED2013_14_PP.csv');

part1 
%finding SAT and undergrad enrollment columns
idx_SAT = find(strcmp(raw(1,:),'SAT_AVG'));
SAT_AVG = num(:,idx_SAT);

idx_UGDS = find(strcmp(raw(1,:),'UGDS'));
UGDS = num(:,idx_UGDS);

%finding weighted mean
SAT_AVG_UGDS = SAT_AVG.*(UGDS/4);

UGDS=UGDS.*(1-isnan(SAT_AVG));
UGDS(isnan(UGDS))=[];
UGDS_cnt = sum(UGDS/4);

SAT_AVG_UGDS(isnan(SAT_AVG_UGDS))=[];
SAT_AVG_UGDS_avg = sum(SAT_AVG_UGDS)/UGDS_cnt;

% SAT_AVG_UGDS_avg = 1095.6143370025

%part2
idx_SAT = find(strcmp(raw(1,:),'SAT_AVG'));
SAT_AVG = num(:,idx_SAT);
indices1 = find(isnan(SAT_AVG) == 1);

idx_ENRL = find(strcmp(raw(1,:),'ENRL_ORIG_YR2_RT'));
ENRL = num(:,idx_ENRL);

idx_ENRLT22 = find(strcmp(raw(1,:),'ENRL_2YR_TRANS_YR2_RT'));
ENRLT22 = num(:,idx_ENRLT22);

idx_ENRLT24 = find(strcmp(raw(1,:),'ENRL_4YR_TRANS_YR2_RT'));
ENRLT24 = num(:,idx_ENRLT24);

%adding up the percentage of all enrollment after 2 years
ENRL2=ENRL+ENRLT22+ENRLT24;
indices2 = find(isnan(ENRL2) == 1);

%finding valid entries 
indices = unique([indices1;indices2]);
SAT_AVG(indices)=[];
ENRL2(indices)=[];

P = corrcoef(SAT_AVG,ENRL2);

%Peason Coef = 0.5141040258

%part3
idx_LOWYR4 = find(strcmp(raw(1,:),'LO_INC_COMP_ORIG_YR4_RT'));
LOWYR4 = num(:,idx_LOWYR4);
indices1 = find(isnan(LOWYR4) == 1);

idx_LOWYR4T24 = find(strcmp(raw(1,:),'LO_INC_COMP_2YR_TRANS_YR4_RT'));
LOWYR4T24 = num(:,idx_LOWYR4T24);
indices2 = find(isnan(LOWYR4T24) == 1);

idx_MIDYR4 = find(strcmp(raw(1,:),'MD_INC_COMP_ORIG_YR4_RT'));
MIDYR4 = num(:,idx_MIDYR4);
indices3 = find(isnan(MIDYR4) == 1);

idx_MIDYR4T24 = find(strcmp(raw(1,:),'MD_INC_COMP_2YR_TRANS_YR4_RT'));
MIDYR4T24 = num(:,idx_MIDYR4T24);
indices4 = find(isnan(MIDYR4T24) == 1);

idx_HIYR4 = find(strcmp(raw(1,:),'HI_INC_COMP_ORIG_YR4_RT'));
HIYR4 = num(:,idx_HIYR4);
indices5 = find(isnan(HIYR4) == 1);

idx_HIYR4T24 = find(strcmp(raw(1,:),'HI_INC_COMP_2YR_TRANS_YR4_RT'));
HIYR4T24 = num(:,idx_HIYR4T24);
indices6 = find(isnan(HIYR4T24) == 1);

%finding institutions with numeric value
indices = unique([indices1;indices2;indices3;indices4;indices5;indices6]);

LOW_PERC=LOWYR4+LOWYR4T24;
HI_PERC=HIYR4+HIYR4T24;

DIFF_PERC=HI_PERC-LOW_PERC;
DIFF_PERC(indices)=[];
DIFF_PERC_avg=mean(DIFF_PERC);

% DIFF_PERC_avg = 0.1369236418

%part4
LOW_PERC(indices)=[];
HI_PERC(indices)=[];
[h,p] = ttest(LOW_PERC,HI_PERC);
p_value_log = log10(p); 

% p_value_log = -inf

%part5
ETH = {'UGDS_WHITE','UGDS_BLACK','UGDS_HISP','UGDS_ASIAN',...
    'UGDS_AIAN','UGDS_NHPI','UGDS_2MOR','UGDS_NRA','UGDS_UNKN'...
    'UGDS_WHITENH','UGDS_BLACKNH','UGDS_API','UGDS_AIANOLD','UGDS_HISPOLD'};
UGDS_ETH_ind = ones(length(num(:,1)),length(ETH));
for i=1:length(ETH)
    idx_UGDS_ETH = find(strcmp(raw(1,:),ETH(i)));
    UGDS_ETH(:,i) = num(:,idx_UGDS_ETH);
    indices = find(UGDS_ETH(:,i)==0|isnan(UGDS_ETH(:,i)) == 1);
    UGDS_ETH_ind(indices,i)=0;
end

UGDS_ETH_flag = sum(UGDS_ETH_ind,2);
UGDS_ETH_flag_indx = find(UGDS_ETH_flag==0);

UGDS_ETH(UGDS_ETH_flag_indx,:)=[];


for i=1:length(UGDS_ETH)
   ETH_DIFF(i) = max(UGDS_ETH(i,:))-min(UGDS_ETH(i,:)); 
end

ETH_DIFF_min = min(ETH_DIFF);

% ETH_DIFF_min = 0.2335

%part7
[num,txt,raw] = xlsread('MERGED2014_15_PP.csv');

idx_SAT = find(strcmp(raw(1,:),'REGION'));
REGION = num(:,idx_SAT);
 
idx_UGDS = find(strcmp(raw(1,:),'LOCALE'));
LOCALE = num(:,idx_UGDS);

%sroting and separating regions 
REGLOC = [REGION,LOCALE];
REGLOCSRT=sortrows(REGLOC,1);
idx = cumsum(diff([0;REGLOCSRT(:,1)])>0);
idxn = histc(idx,unique(idx));
REGLOCSPRT = mat2cell(REGLOCSRT,idxn,size(REGLOCSRT,2));

for i=2:10
   CITYPROB(i,1) = sum(REGLOCSPRT{i,1}(:,2) == 11|...
       REGLOCSPRT{i,1}(:,2) == 12|REGLOCSPRT{i,1}(:,2) == 13)...
       /length(REGLOCSPRT{i,1});
end
CITYPROBMAX = max(CITYPROB);

% CITYPROBMAX = 0.5907429963

