% Train (on time window as feautres) - per subject 
SHAPValues_Temporal = cell(1,18);
Explainer_Temporal = cell(1,18);

for sub = 1:18

    X_train= TrainingFeatures_Temporal{1,sub}(:, 1:20);
    Y_train= TrainingFeatures_Temporal{1,sub}(:, end);

    X_test= TestingFeatures_Temporal{1,sub}(:, 1:20);
    Y_test= TestingFeatures_Temporal{1,sub}(:, end);

    explainer = shapley(SVMModel_Temporal{1, sub}, X_train, 'QueryPoints', X_test);

    shap_values = fit(explainer, X_test);

    Explainer_Temporal{1, sub} = explainer;
    SHAPValues_Temporal{1, sub} = shap_values ;

end


%% Extract most important TW
OptimalTW_Sub = zeros(1,18);

for sub = 1:18
    shap_values_array = SHAPValues_Temporal{1, sub}.MeanAbsoluteShapley(:,2); % Get structure

    % Convert to array (if needed)
    shap_values_array = table2array(shap_values_array);

    % Find the index of the highest SHAP value
    [~, max_idx] = max(shap_values_array);

    OptimalTW_Sub(sub) = max_idx;

    % Display result
    %fprintf('The most important time window is TW = %d\n', max_idx);

end


%% Plot line plots for shapley values 
% Define subjects
subjects = [1, 18; 3, 13]; % Top row: 1, 18; Bottom row: 3, 13

% Create a new figure
figure;

% Loop through subjects and plot in corresponding subplot positions
for row = 1:2
    for col = 1:2
        sub = subjects(row, col); % Get the subject index
        
        % Convert SHAP values to array
        ShapValues = table2array(SHAPValues_Temporal{1, sub}.MeanAbsoluteShapley(:, 2));
        
        % Define time windows
        TimeWindows = linspace(-1, 1, 20);

        % Create a subplot for each subject
        subplot(2, 2, (row-1)*2 + col); % 2x2 grid, position calculated
        plot(TimeWindows, ShapValues, '-o', 'LineWidth', 2, 'MarkerSize', 6);

        % Customize the x-axis ticks
        xticks(-1:0.1:1); % Set tick positions from -1 to 1 in 0.1 steps
        xtickformat('%.1f'); % Ensure ticks display one decimal place

        % Labels and Title
        xlabel('Time Window (ms)');
        ylabel('Mean (Temporal) SHAP Value');
        title(['Subject ', num2str(sub)]);

        % Grid for better readability
        grid on;
    end
end

sgtitle('Advance Tempo', 'Fontsize', 18, 'FontWeight', 'Bold')
