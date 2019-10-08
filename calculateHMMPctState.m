%% FUNCTION: calculateHMMPctState
%% INPUTS
% states - Numeric matrix (bin x fly) of states
% epoch_idx - 2 column matrix of array indexes that bound each epoch
% states_of_interest - Numeric matrix of numerator states
% bg_states - Numeric matrix of denominator states

%% OUTPUTS
% pct_state - Numeric matrix (epoch x fly) % time in states_of_interest


function pct_state = calculateHMMPctState(states, epoch_idx, states_of_interest, bg_states)

pct_state = zeros(size(epoch_idx, 1), size(states, 2));

for i = 1:size(states,2)
    for j = 1:size(epoch_idx, 1)
        this_seq = states(epoch_idx(j,1):epoch_idx(j,2),i);
        
        major_state = sum(ismember(this_seq, states_of_interest));
        minor_state = sum(ismember(this_seq, bg_states));
        pct_state(j,i) = major_state / minor_state;
end

end