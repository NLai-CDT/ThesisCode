%% SVM classification: Kernel = Linear, C = 1 
clear all 
clc
  
% Set parameters
Condition = 'Features'; % Raw or Features
LoadingPath='.../Combined_Subjects/TrainingTestingDatasets/SeperateConditions/Delay';
seed=1;


% Load dataset 
if strcmp(Condition, 'Raw')
    load(fullfile(LoadingPath, 'TrainingRaw.mat'));
    load(fullfile(LoadingPath, 'TestingRaw.mat'));

elseif strcmp(Condition, 'Features')
    load(fullfile(LoadingPath, 'TrainingFeatures.mat'));
    load(fullfile(LoadingPath, 'TestingFeatures.mat'));

elseif strcmp(Condition, 'Features_R')
    load(fullfile(LoadingPath, 'TrainingFeatures_R.mat'));
    load(fullfile(LoadingPath, 'TestingFeatures_R.mat'));
end


% Create X_train, Y_train, X_test, and Y_test variables
if strcmp(Condition, 'Raw')
    X_train=TrainingRaw(:, 1:end-1);
    Y_train=TrainingRaw(:, end);

    X_test=TestingRaw(:, 1:end-1);
    Y_test=TestingRaw(:, end);

elseif strcmp(Condition, 'Features')
    X_train=TrainingFeatures(:, 1:end-1);
    Y_train=TrainingFeatures(:, end);

    X_test=TestingFeatures(:, 1:end-1);
    Y_test=TestingFeatures(:, end);

elseif strcmp(Condition, 'Features_R')
    X_train=TrainingFeatures_R(:, 1:end-1);
    Y_train=TrainingFeatures_R(:, end);

    X_test=TestingFeatures_R(:, 1:end-1);
    Y_test=TestingFeatures_R(:, end);

end

% Train classifier
rng(seed)
SVMModel= fitcsvm(X_train, Y_train, 'KernelFunction','linear', 'BoxConstraint',1);

% Test classifier

predictions = predict(SVMModel, X_test);

% Performance metrics

confusionMatrix = confusionmat(Y_test, predictions);

accuracy = sum(diag(confusionMatrix)) / sum(confusionMatrix(:));

recall = confusionMatrix(1, 1) / sum(confusionMatrix(1, :));

precision = confusionMatrix(1, 1) / sum(confusionMatrix(:, 1));

F1_score = 2 * (precision * recall) / (precision + recall);


performanceMetrics = [accuracy; recall; precision; F1_score];

