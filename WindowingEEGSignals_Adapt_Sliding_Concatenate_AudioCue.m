%% Set parameters
%clearvars -except all_events EEG_dataset

Ns=50; % Window Size
O = Ns*0.5; % Overlap 

% Sliding Window Parameter
sw=256;% Equals 0.5s 

% Window Parameters
%Start=25;
%End=24;
W=49; % Creates window of 50 samples

%maxWindow=15; %12 for advance, 15 for delay

Condition = 'DelayTempo';


%% Load blocked dataset - sample index and event value
if strcmp(Condition, 'AdvanceTempo')

    Heel_indices = [253,333,153]; % Auditory cue

elseif strcmp(Condition, 'DelayTempo')

    Heel_indices = [259,999,159];

end

% Find sample indices of heel strikes
Row_Indices=cell(19,18);


for i=1:width(Block)
    for j=1:height(Block)

        if ~isempty(Block{j,i})
            
            for k=1:height(Block{j,i})

                if ~isempty(Block{j,i}{k,1})

                Row_Indices{j,i}{k,1} = find(ismember(Block{j,i}{k,1}(:,2), Heel_indices));

                end
           
            end

        end
    end
end

% Find corresponding rows - sample & event value 
HeelStrike_sample=cell(19,18);
for i=1:width(Block)
    for j=1:height(Block)

        if ~isempty(Block{j,i})

            for k=1:height(Block{j,i})

                if ~isempty(Block{j,i}{k,1})

                    for m=1:height(Row_Indices{j,i}{k,1})

                         HeelStrike_sample{j,i}{k,1}(m,:) = Block{j,i}{k,1}(Row_Indices{j,i}{k,1}(m),:);


                    end

                end

            end
        end
    end
end

%% Create sliding windows 

WindowedSignals = cell(19,18);

for i = 1:width(HeelStrike_sample) % Subject ID
    for j = 1:height(HeelStrike_sample) % Run

        for k=1:height(HeelStrike_sample{j,i}) % Block

            if ~isempty(HeelStrike_sample{j,i}{k,1})


                    Index = HeelStrike_sample{j,i}{k,1}(1,1)-sw;
                    disp(['Current Index: ', num2str(Index)]);

                    n=1;

                        while Index <= HeelStrike_sample{j,i}{k,1}(end,1)+sw

                            window = EEG_dataset{j,i}(1:108, Index:Index+W);

                            %disp(Index-Start)

                            WindowedSignals{j,i}{k,1}{n,1}=window;

                            n=n+1;
                            Index=Index+O;
                            disp(['New Index: ', num2str(Index)]);


                end
            end
        end
    end
end