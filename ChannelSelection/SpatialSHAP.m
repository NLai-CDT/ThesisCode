function [shapleyValues_TW, explainer_TW, ElectrodeWeight] = SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile, absolute)
% SpatialSHAP: Computes Shapley values for EEG electrodes across multiple time windows
%              using a pre-trained blackbox model and SHAP analysis.
%
% INPUTS:
%   - TrainingFeatures_TW: Cell array where each cell contains training features 
%                          for a specific time window (samples x channels+label).
%   - TestingFeatures_TW: Cell array where each cell contains testing features 
%                         for a specific time window (samples x channels+label).
%   - blackbox: Cell array of pre-trained blackbox models corresponding to each time window.
%   - featureNamesFile: String, path to the Excel file containing electrode labels.
%
% OUTPUTS:
%   - shapleyValues_TW: Cell array where each cell contains mean absolute Shapley values 
%                       for the EEG channels in the corresponding time window.
%   - explainer_TW: Cell array of SHAP explainer objects for each time window.
%
% Example Usage:
%   featureNamesFile = 'ElectrodesLabels.xlsx';
%   [shapleyValues_TW, explainer_TW] = SpatialSHAP(TrainingFeatures_TW, TestingFeatures_TW, blackbox, featureNamesFile);

    % Number of sliding time windows
    num_windows = size(blackbox, 2);
    
    % Initialize output cell arrays
    shapleyValues_TW = cell(1, num_windows);
    explainer_TW = cell(1, num_windows);
    ElectrodeWeight = cell(1, num_windows);
    
    % Load feature names (electrode labels) from the Excel file
    featureNamesTable = readtable(featureNamesFile, 'ReadVariableNames', false);
    featureNames = table2cell(featureNamesTable(1:108, :)); % Assuming first 108 rows are electrode labels
    
    % Loop through each time window
    for w = 1:num_windows
        % Extract training features and labels
        XTrain = TrainingFeatures_TW{w}(:, 1:end-1); % Features (remove last column)
        YTrain = TrainingFeatures_TW{w}(:, end);     % Labels (last column)
        
        % Convert training dataset into a table with electrode labels
        XTrainTable = array2table(XTrain);
        XTrainTable.Properties.VariableNames = featureNames;

        % Extract testing features and convert into a table
        XTest = TestingFeatures_TW{w}(:, 1:end-1);
        XTestTable = array2table(XTest);
        XTestTable.Properties.VariableNames = featureNames;

        % Create the SHAP explainer using the blackbox model
        explainer = shapley(blackbox{w}, XTrainTable, 'QueryPoints', XTestTable);
        
        if absolute
            % Compute mean absolute Shapley values across all query points
            shapleyValues = explainer.MeanAbsoluteShapley;

            shapleyValues_TW{w} = shapleyValues;
            ElectrodeWeight{w} = table2array(shapleyValues(1:108,2))';
        else 

            shapleyTable = explainer.ShapleyValues;
            shapleyValues_TW{w} = shapleyTable;

            all_SHAP_class1 = table2array(explainer.ShapleyValues(1:108,2));

            averaged_SHAP = mean(all_SHAP_class1, 2);

            shapleyValues = averaged_SHAP';
            ElectrodeWeight{w} = shapleyValues;


        end
        
        % Store results for the current window
        explainer_TW{w} = explainer;
        

    end
end
