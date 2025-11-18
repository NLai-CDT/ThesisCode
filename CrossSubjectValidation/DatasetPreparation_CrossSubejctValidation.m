%% Prepare dataset - temporal dynamics for combined subjects

% Load dataset- EEGSignals

% Set parameters
seed=1;
nbFilterPairs = 108*0.5;

%% Training dataset: CSP filter, Projected Signals, Features 
cd .../AudioCueWalking_analysis/Scripts/

CSP_Filter = [];
TrainingRaw = [];
TrainingProjected= [];
TrainingFeatures= [];

TrainingProjected.x = [];
TrainingProjected.y = TrainingDataset.y;

%CSP_Filter = learnCSPLagrangian(TrainingDataset);
%RCSP_Filter = learn_DL_CSPLagrangian_auto(TrainingDataset);
CSP_Riemann_Filter = learnCSPLagrangian_Riemann(TrainingDataset);

TrainingRaw=extractRawSignals(TrainingDataset, nbFilterPairs);

TrainingProjected.x=extractProjectedSignals(TrainingDataset, CSP_Riemann_Filter, nbFilterPairs);

TrainingFeatures=extractCSPFeatures(TrainingDataset, CSP_Riemann_Filter, nbFilterPairs);



% Testing dataset: Projected Signals, Features 

TestingRaw=[];
TestingProjected=[];
TestingFeatures=[];

TestingProjected.x = [];
TestingProjected.y = TestingDataset.y;


TestingRaw=extractRawSignals(TestingDataset, nbFilterPairs);

TestingProjected.x=extractProjectedSignals(TestingDataset, CSP_Riemann_Filter, nbFilterPairs);

TestingFeatures=extractCSPFeatures(TestingDataset, CSP_Riemann_Filter, nbFilterPairs);
