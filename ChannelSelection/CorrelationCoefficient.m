function ElectrodeImportance = CorrelationCoefficient(EEG_data, num_windows)

    ElectrodeImportance = cell(1, num_windows);

    Nt = size(EEG_data{1}.x, 2); 
    Nc = size(EEG_data{1}.x, 1); 
    Ns = size(EEG_data{1}.x, 3); 
    
    % Initialise storage of channel-wise correlation matric (per trial)
    %all_corr = zeros(Nc, Nc, Nt); 
    
    for t = 1:size(EEG_data,2)  % Per time window
        
        all_corr = zeros(Nc, Nc, Nt); 
        
        data = EEG_data{t}.x; 

        % Z-score normalization (trial-wise)
        EEG_Z = (data - mean(data, 3)) ./ std(data, 0, 3);
        
        % Compute correlation matrix for each trial
        for i = 1:Nt

            trial_data = EEG_Z(:,i,:);
            trial_data = squeeze(trial_data);

            % Compute correlation matrix for each trial (between channels)
            all_corr(:,:,i) = corr(trial_data');  % Transpose to correlate across channels
        end
        
        % Mean correlation across trials for each channel
        mean_corr = mean(mean(all_corr, 3), 2); % 1. Find average correlation coefficient matrix Nc *Nc, 2. Per Nc, find average correlation coefficient 
        % (idea if large average correlation = in general had high correlation with other electrodes)
        ElectrodeImportance{t} = mean_corr';
        %ElectrodeImportance{t} = sort(mean_corr, 'descend'); % Rank highest to lowest
        %ElectrodeImportance{t} = ranked_channels(1:N_s); % Select top N_s channels
    end
end

