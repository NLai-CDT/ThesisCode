function [electrode_importance] = SumSHAP(CSP_Filter_TW, num_windows)
%%%%% ? Should be SumRCSP!
% ComputeElectrodeImportance: Computes the importance of EEG electrodes across windows
%                             by summing the absolute values of CSP filters.
%
% INPUTS:
%   - CSP_Filter_TW: Cell array containing CSP spatial filters for each time window.
%                    Each cell contains a matrix of size [channels x filters].
%   - num_windows: Integer representing the number of sliding windows.
%
% OUTPUT:
%   - electrode_importance: Cell array where each cell contains a vector with 
%                           the summed absolute importance of each electrode.
% Example Usage:
%   electrode_importance = ComputeElectrodeImportance(CSP_Filter_TW, 41);

    % Initialize the output as a cell array
    electrode_importance = cell(1, num_windows);

    % Loop through each window
    for w = 1:num_windows
        % Compute the sum of absolute values across all spatial filters
        electrode_importance{w} = sum(abs(CSP_Filter_TW{w}), 1);
    end
end
