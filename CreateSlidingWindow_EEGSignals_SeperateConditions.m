% Load Windowed Datasets as Adaptation_Condition & NonAdaptation_Condition

Adaptation_Condition= Adaptation_Delay;
NonAdaptation_Condition= NonAdaptation_Delay;
%% Adaptation 
Adaptation=cell(1,18);

for i = 1:width(Adaptation_Condition)
    for j = 1:height(Adaptation_Condition)
        for k=1:height(Adaptation_Condition{j,i})
             if ~isempty(Adaptation_Condition{j,i})

                 Condition=Adaptation_Condition{j,i}{k,1};

                 Adaptation{1,i} = vertcat(Adaptation{1,i}, Condition);

             end
        end
    end
end

%% Non-adaptation
NonAdaptation=cell(1,18);

for i = 1:width(NonAdaptation_Condition)
    for j = 1:height(NonAdaptation_Condition)
        for k=1:height(NonAdaptation_Condition{j,i})
             if ~isempty(NonAdaptation_Condition{j,i})

                 NonCondition=NonAdaptation_Condition{j,i}{k,1};

                 NonAdaptation{1,i} = vertcat(NonAdaptation{1,i}, NonCondition);

             end
        end
    end
end

%% Concatonate into single EEGSignals (per subject) EEGSignals.x and EEGSignals.y

Combined=vertcat(Adaptation, NonAdaptation);

EEGSignals_sub=cell(1,18);

for i=1:width(EEGSignals_sub)
    EEGSignals_sub{i}.x=[];
    EEGSignals_sub{i}.y=[];
end


for i=1:width(EEGSignals_sub)
    EEGSignals_sub{1,i}.x=Adaptation{1,i};
    EEGSignals_sub{1,i}.x=vertcat(EEGSignals_sub{1,i}.x, NonAdaptation{1,i});

    EEGSignals_sub{1,i}.x = cat(3, EEGSignals_sub{1,i}.x{:});
    
    EEGSignals_sub{1,i}.x=permute(EEGSignals_sub{1,i}.x, [2 1 3]);

end

for i=1:width(EEGSignals_sub)

    class_ones=ones(1, size(Combined{1,i},1)); % Adaptation
    class_zeros=zeros(1, size(Combined{2,i},1)); % NonAdaptation

    %disp(size(ones,1))
    %disp(size(zeros,1))

    EEGSignals_sub{1,i}.y=[class_ones,class_zeros];

end

%% Concatenate into EEGSignal
EEGSignal.x=[];
EEGSignal.y=[];

for i=1:size(EEGSignals_sub, 2)

    EEGSignal.x=cat(3, EEGSignal.x, EEGSignals_sub{1,i}.x);
    EEGSignal.y=[EEGSignal.y, EEGSignals_sub{1,i}.y];

end