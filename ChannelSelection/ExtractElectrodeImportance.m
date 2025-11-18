%% Obtain datasets (Filter, Projected and Features) 
num_windows = size(TrainingDataset_TW, 2);

for w = 1:num_windows
    TrainingDataset_TW{w}.x = permute(TrainingDataset_TW{w}.x, [3, 1, 2]);
    TestingDataset_TW{w}.x = permute(TestingDataset_TW{w}.x, [3, 1, 2]);
end


% find CSP filter per time window

CSP_Filter_TW = cell(1, 20);

for w = 1:num_windows
    CSP_Filter_TW{w} = learn_DL_CSPLagrangian_auto(TrainingDataset_TW{w});
end

% Project onto signals (per time window) 

TrainingProjected_TW = cell(1,num_windows);

nbFilterPairs = 108*0.5;

for w = 1:num_windows
    TrainingProjected_TW{w} = extractProjectedSignals(TrainingDataset_TW{w}, CSP_Filter_TW{w}, nbFilterPairs);
end

% Extract Features 

nbFilterPairs = 108*0.5;

TrainingFeatures_TW = cell(1,num_windows);
TestingFeatures_TW = cell(1,num_windows);

for w = 1:num_windows
    TrainingFeatures_TW{w} = extractCSPFeatures(TrainingDataset_TW{w}, CSP_Filter_TW{w}, nbFilterPairs);
    TestingFeatures_TW{w} = extractCSPFeatures(TestingDataset_TW{w}, CSP_Filter_TW{w}, nbFilterPairs);
end


%% Extract electrode importance

% Set parameters
% Choose method for electrode importance extracts - 'ChannelRegression',
% 'CSPRank', SpatialSHAP_Abs','SpatialSHAP', 'SumSHAP',
% 'CorrelationCoefficient'


Method = "ChannelRegression";
num_windows = 20;

%featureNamesFile = "....\Interpretability\ElectrodesLabels.xlsx";


% Obtain electrode weights 

if strcmp(Method, "ChannelRegression")
    ElectrodeWeight = ChannelRegression(TrainingDataset_TW, TrainingProjected_TW, num_windows);

elseif strcmp(Method, "CSPRank")
    [ElectrodeRank, ElectrodeWeight] = CSPRank(CSP_Filter_TW, num_windows);

elseif strcmp(Method, "SpatialSHAP_Abs")
    [shapleyValues_TW, explainer_TW, ElectrodeWeight] = SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile, true);
   
elseif strcmp(Method, "SpatialSHAP")
    [shapleyValues_TW, explainer_TW, ElectrodeWeight]= SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile, false);

elseif strcmp(Method, "SumSHAP")
    ElectrodeWeight = SumSHAP(CSP_Filter_TW, num_windows);

elseif strcmp(Method, "CorrelationCoefficient")
    ElectrodeWeight = CorrelationCoefficient(TrainingDataset_TW, num_windows);

end


%% Order electrode ranking (most to least) - using ElectrodeWeight

Weight = cell(1, num_windows);
Indices = cell(1, num_windows);

if strcmp(Method, "CSPRank")
    for w = 1:num_windows

        % Select the top weights and their corresponding indices
        topWeights = ElectrodeWeight{w};
        topIndices = ElectrodeRank{w};

        Weight{w} = topWeights;
        Indices{w} = topIndices;

    end

else
    for w = 1:num_windows

        weightsArray  = ElectrodeWeight{w};

        % Sort weights in descending order and preserve the indices
        [sortedWeights, sortedIndices] = sort(weightsArray, 'descend');

        % Select the top weights and their corresponding indices
        topWeights = sortedWeights;
        topIndices = sortedIndices;

        Weight{w} = topWeights;
        Indices{w} = topIndices;

    end
end


%% Store & save into Weight_Methods and Indices_Methods

%Initialise for storage
Weights_Methods = struct('ChannelRegression', [], ...
   'CSPRank', [], ...
   'SpatialSHAP_Abs', [], ...
   'SpatialSHAP', [], ...
   'SumSHAP', [], ...
   'CorrelationCoefficient', []);

Indices_Methods = struct('ChannelRegression', [], ...
   'CSPRank', [], ...
   'SpatialSHAP_Abs', [], ...
   'SpatialSHAP', [], ...
   'SumSHAP', [], ...
   'CorrelationCoefficient', []);


Weights_Methods.ChannelRegression = Weight;
Indices_Methods.ChannelRegression = Indices;




%% Extract 'top' electrodes - using ElectrodeWeight

Weight = cell(1, num_windows);
Indices = cell(1, num_windows);

N_Electrodes = 10;

if strcmp(Method, "CSPRank")
    for w = 1:num_windows

        % Select the top weights and their corresponding indices
        topWeights = ElectrodeWeight{w}(1:N_Electrodes);
        topIndices = ElectrodeRank{w}(1:N_Electrodes);

        Weight{w} = topWeights;
        Indices{w} = topIndices;

    end

else
    for w = 1:num_windows

        weightsArray  = ElectrodeWeight{w};

        % Sort weights in descending order and preserve the indices
        [sortedWeights, sortedIndices] = sort(weightsArray, 'descend');

        % Select the top weights and their corresponding indices
        topWeights = sortedWeights(1:N_Electrodes);
        topIndices = sortedIndices(1:N_Electrodes);

        Weight{w} = topWeights;
        Indices{w} = topIndices;

    end
end

