%% FUNCTION: calculateActivityWhenAwake
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% wake_activity - Numeric matrix (epoch x fly) of mean activity during bins in 
%                 which activity is greater than zero

function wake_activity = calculateActivityWhenAwake(counts, epoch_idx)

wake_activity = zeros(size(epoch_idx, 1), size(counts, 2));

for i = 1:size(wake_activity,1)
    for j = 1:size(wake_activity,2)
        total = sum(counts(epoch_idx(i,1):epoch_idx(i,2), j));
        time_awake = length(find(counts(epoch_idx(i,1):epoch_idx(i,2), j) > 0));
        wake_activity(i,j) = total / time_awake;
    end
end

end
