% Define methods for electrode importance extraction
Methods = ["ChannelRegression", "CSPRank", "SpatialSHAP_Abs", ...
           "SpatialSHAP", "SumSHAP", "CorrelationCoefficient"];

featureNamesFile = "C:\Users\mailt\OneDrive - University of Glasgow\Documents\RemoteDesktopsBackup\Metoma\BackUp_24_10_2024\AudioCueAnalysis\Adapt_NonAdapt\Interpretability\ElectrodesLabels.xlsx";

% Initialize structs for storing weights and indices
Weights_Methods = struct();
Indices_Methods = struct();

% Iterate through each method
for i = 1:length(Methods)
    Method = Methods(i);  % Current method

    disp(strcat("Extracting electrode importance using ", Method));
    
    num_windows = 20;     % Set number of windows
    
    disp("Step 1 - Extract electrode importance")
    
    % Obtain electrode weights based on the current method
    if Method == "ChannelRegression"
        ElectrodeWeight = ChannelRegression(TrainingDataset_TW, TrainingProjected_TW, num_windows);
    elseif Method == "CSPRank"
        [ElectrodeRank, ElectrodeWeight] = CSPRank(CSP_Filter_TW, num_windows);
    elseif Method == "SpatialSHAP_Abs"
        [shapleyValues_TW, explainer_TW, ElectrodeWeight] = SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile, true);
    elseif Method == "SpatialSHAP"
        [shapleyValues_TW, explainer_TW, ElectrodeWeight] = SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile, false);
    elseif Method == "SumSHAP"
        ElectrodeWeight = SumSHAP(CSP_Filter_TW, num_windows);
    elseif Method == "CorrelationCoefficient"
        ElectrodeWeight = CorrelationCoefficient(TrainingDataset_TW, num_windows);
    else
        error("Unknown method: %s", Method);
    end
    
    disp("Step 2 - Order electrode ranking")

    % Initialize weight and index storage
    Weight = cell(1, num_windows);
    Indices = cell(1, num_windows);
    
    % Process weights and indices for each time window
    if Method == "CSPRank"
        for w = 1:num_windows
            Weight{w} = ElectrodeWeight{w};
            Indices{w} = ElectrodeRank{w};
        end
    else
        for w = 1:num_windows
            weightsArray = ElectrodeWeight{w};
            [sortedWeights, sortedIndices] = sort(weightsArray, 'descend');
            Weight{w} = sortedWeights;
            Indices{w} = sortedIndices;
        end
    end
    
    % Dynamically assign to structs using the current method name
    disp("Step 3 - Save")
    Weights_Methods.(char(Method)) = Weight;
    Indices_Methods.(char(Method)) = Indices;
    
    clearvars -except Weights_Methods Indices_Methods TrainingDataset_TW TrainingProjected_TW TrainingFeatures_TW TestingFeatures_TW CSP_Filter_TW blackbox Methods featureNamesFile

end

% Save results
save('Weights_Methods_Delay.mat', 'Weights_Methods');
save('Indices_Methods_Delay.mat', 'Indices_Methods');
