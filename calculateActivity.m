%% FUNCTION: calculateActivity
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% activity - Numeric matrix (epoch x fly) of total activity

function activity = calculateActivity(counts, epoch_idx)

activity = zeros(size(epoch_idx, 1), size(counts, 2));

for i = 1:size(activity,1)
    for j = 1:size(activity,2)
        activity(i,j) = sum(counts(epoch_idx(i,1):epoch_idx(i,2), j));
    end
end

end
