function [A] = ChannelRegression(TrainingDataset_TW, TrainingProjected_TW, num_windows)
% ChannelRegression: Performs regression for EEG channels using training data.
%
% INPUTS:
%   - TrainingDataset_TW: Cell array with time-windowed EEG signals 
%                         (each cell contains an x matrix: trials x channels x timepoints).
%   - TrainingProjected_TW: Cell array with projected signals corresponding to each window
%                           (each cell contains projected data: trials x channels x timepoints).
%   - num_windows: Integer representing the number of sliding windows.
%
% OUTPUT:
%   - A: Cell array where each cell contains regression weights for all channels
%        and all trials within the corresponding window.
%
% Example Usage:
%   A = ChannelRegression(TrainingDataset_TW, TrainingProjected_TW, 20);

    % Initialize output as a cell array
    A = cell(1, num_windows);

    % Loop through each window
    for w = 1:num_windows
        % Initialize weights matrix for this window
        A_trial = [];
        A{w} = [];
        
        % Extract the number of trials (3rd dimension size)
        num_trials = size(TrainingDataset_TW{w}.x, 2);

        TrainingDataset = permute(TrainingDataset_TW{w}.x, [3, 1, 2]);

        % Loop through each trial
        for t = 1:num_trials

            % Extract projected signal (y) and original EEG signal (X)
            y = TrainingProjected_TW{w}(:,:,t); % Projected signal
            X = TrainingDataset(:,:,t); % Original EEG Signal
            
            % Transpose projected signal for regression
            y_transposed = y';

            % Initialize channel weights for this trial
            ch_weights = zeros(108, 1);
            
            % Loop through each channel and perform regression
            for ch = 1:108
                % Compute regression coefficient (channel weight)
                ch_weights(ch) = y_transposed(:, ch) \ X(:, ch);
            end
            
            % Append channel weights for this trial to the window's weights
            A_trial = [A_trial; ch_weights'];
        end

        A{w} = mean(A_trial, 1);
    end
end
