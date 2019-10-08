%% FUNCTION: calculateHMMTotalSleep
%% INPUTS
% states - Numeric matrix (bin x fly) of states
% epoch_idx - 2 column matrix of array indexes that bound each epoch
% state_ids - Numeric matrix of numerator states that correspond to sleep

%% OUTPUTS
% total_sleep - Numeric matrix (epoch x fly) of total bins asleep in each epoch


function total_sleep = calculateHMMTotalSleep(states, epoch_idx, state_ids)

total_sleep = zeros(size(epoch_idx, 1), size(states, 2));

for i = 1:size(states,2)
    for j = 1:size(epoch_idx, 1)
        this_seq = states(epoch_idx(j,1):epoch_idx(j,2),i);
        total_sleep(j,i) = sum(ismember(this_seq, state_ids));
    end
end

end