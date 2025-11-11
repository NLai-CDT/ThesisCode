function [electrodeRank_TW, electrodeWeights_TW] = CSPRank(CSP_Filter_TW, num_windows)
% CSPRank: Ranks electrodes based on the most discriminatory spatial filters 
%          in CSP matrices for each time window.
%
% INPUTS:
%   - CSP_Filter_TW: Cell array where each cell contains CSP spatial filters 
%                    (size: filters x electrodes) for a specific time window.
%   - num_windows: Integer specifying the number of sliding windows.
%
% OUTPUTS:
%   - electrodeRank_TW: Cell array containing the ranked electrode indices for each time window.
%   - electrodeWeights_TW: Cell array containing the corresponding weights 
%                          of the ranked electrodes for each time window.
%
% Example Usage:
%   [electrodeRank_TW, electrodeWeights_TW] = CSPRank(CSP_Filter_TW, 41);

    % Initialize output cell arrays
    electrodeRank_TW = cell(1, num_windows);
    electrodeWeights_TW = cell(1, num_windows);

    % Loop through each time window
    for w = 1:num_windows
        % Choose first and last spatial filters (most discriminatory for each class)
        CSPMatrix = CSP_Filter_TW{w}([1, end], :); % Extract two filters: first and last
        
        % Sort the absolute values of the two filters in descending order
        [sortedSF1, idxSF1] = sort(abs(CSPMatrix(1, :)), 'descend'); % First spatial filter
        [sortedSF2, idxSF2] = sort(abs(CSPMatrix(2, :)), 'descend'); % Last spatial filter

        % Initialize ranking and weights storage
        electrodeRank = [];       % Stores indices of electrodes
        electrodeWeights = [];    % Stores weights of electrodes
        selectedFlags = false(1, size(CSPMatrix, 2)); % Flags to track already selected electrodes
        
        % Counters for each spatial filter
        countSF1 = 1;
        countSF2 = 1;

        % Sequentially select electrodes alternately from SF1 and SF2
        while length(electrodeRank) < size(CSPMatrix, 2)
            % Select from SF1
            while selectedFlags(idxSF1(countSF1)) % Skip if already selected
                countSF1 = countSF1 + 1;
            end
            electrodeRank = [electrodeRank, idxSF1(countSF1)];
            electrodeWeights = [electrodeWeights, sortedSF1(countSF1)];
            selectedFlags(idxSF1(countSF1)) = true;
            countSF1 = countSF1 + 1;

            % Select from SF2
            while selectedFlags(idxSF2(countSF2)) % Skip if already selected
                countSF2 = countSF2 + 1;
            end
            electrodeRank = [electrodeRank, idxSF2(countSF2)];
            electrodeWeights = [electrodeWeights, sortedSF2(countSF2)];
            selectedFlags(idxSF2(countSF2)) = true;
            countSF2 = countSF2 + 1;
        end

        % Store results for the current time window
        electrodeRank_TW{w} = electrodeRank;
        electrodeWeights_TW{w} = electrodeWeights;
    end
end
