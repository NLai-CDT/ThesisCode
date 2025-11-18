%% Prepare dataset - sliding window for adaptation vs non adaptation

% Load dataset- EEGSignals

% Set parameters
seed=1;
nbFilterPairs = 108*0.5;

%% Training dataset: CSP filter, Projected Signals, Features 
cd ..../AudioCueWalking_analysis/Scripts/

RCSP_Filter = cell(1,18);
CSP_Filter = cell(1,18);
CSP_Riemann_Filter = cell(1,18);

TrainingRaw = cell(1,18);
TrainingProjected= cell(1,18);
TrainingFeatures= cell(1,18);

for i=1:18

    TrainingProjected{1,i}.x = [];
    TrainingProjected{1,i}.y = TrainingDataset{1,i}.y;
    
    %TrainingProjected_R{1,i}.x = [];
    %TrainingProjected_R{1,i}.y = TrainingDataset{1,i}.y;

end

for i=1:18

    %RCSP_Filter{1,i} = learn_DL_CSPLagrangian_auto(TrainingDataset{1,i});
    %CSP_Filter{1,i} = learnCSPLagrangian(TrainingDataset{1,i});
    CSP_Riemann_Filter{1,i} = learnCSPLagrangian_Riemann(TrainingDataset{1,i});

    %TrainingRaw{1,i}=extractRawSignals(TrainingDataset{1,i}, 108);
    
    %TrainingProjected{1,i}.x=extractProjectedSignals(TrainingDataset{1,i}, CSP_Filter{1,i}, nbFilterPairs);
    %TrainingProjected{1,i}.x=extractProjectedSignals(TrainingDataset{1,i}, RCSP_Filter{1,i}, nbFilterPairs);
    %TrainingProjected{1,i}.x=extractProjectedSignals(TrainingDataset{1,i}, CSP_Riemann_Filter{1,i}, nbFilterPairs);

    %TrainingFeatures{1,i}=extractCSPFeatures(TrainingDataset{1,i}, CSP_Filter{1,i}, nbFilterPairs);
    %TrainingFeatures{1,i}=extractCSPFeatures(TrainingDataset{1,i}, RCSP_Filter{1,i}, nbFilterPairs);
    %TrainingFeatures{1,i}=extractCSPFeatures(TrainingDataset{1,i}, CSP_Riemann_Filter{1,i}, nbFilterPairs);

end

% Testing dataset: Projected Signals, Features 

TestingRaw=cell(1,18);
TestingProjected=cell(1,18);
TestingFeatures=cell(1,18);

for i=1:18

    TestingProjected{1,i}.x = [];
    TestingProjected{1,i}.y = TestingDataset{1,i}.y;

    %TestingProjected_R{1,i}.x = [];
    %TestingProjected_R{1,i}.y = TestingDataset{1,i}.y;

end

for i=1:18

    TestingRaw{1,i}=extractRawSignals(TestingDataset{1,i}, 108);
    
    %TestingProjected{1,i}.x=extractProjectedSignals(TestingDataset{1,i}, CSP_Filter{1,i}, nbFilterPairs);
    %TestingProjected{1,i}.x=extractProjectedSignals(TestingDataset{1,i}, RCSP_Filter{1,i}, nbFilterPairs);
    TestingProjected{1,i}.x=extractProjectedSignals(TestingDataset{1,i}, CSP_Riemann_Filter{1,i}, nbFilterPairs);

    %TestingFeatures{1,i}=extractCSPFeatures(TestingDataset{1,i}, CSP_Filter{1,i}, nbFilterPairs);
    %TestingFeatures{1,i}=extractCSPFeatures(TestingDataset{1,i}, RCSP_Filter{1,i}, nbFilterPairs);
    TestingFeatures{1,i}=extractCSPFeatures(TestingDataset{1,i}, CSP_Riemann_Filter{1,i}, nbFilterPairs);

end
