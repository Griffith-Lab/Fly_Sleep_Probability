%% FUNCTION: calculateConditionalWakeProb
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% wake_prob - Numeric matrix (epoch x fly) of P(Wake), the conditional 
%             probability of switching from the active state to the inactive state


function wake_prob = calculateConditionalWakeProb(counts, epoch_idx)

wake_prob = ones(size(epoch_idx, 1), size(counts, 2));

for i = 1:size(counts,2)
    for j = 1:size(epoch_idx, 1)
        this_count = counts(epoch_idx(j,1):epoch_idx(j,2),i);
        
        total_state_transitions = 0;
        inactive_to_active_transitions = 0;
        active = 1;
        
        for k = 1:length(this_count)           
            if(active == 0)
                total_state_transitions = total_state_transitions + 1;
                if(this_count(k) > 0)
                    inactive_to_active_transitions = inactive_to_active_transitions + 1;
                end
            end
            
            if(this_count(k) > 0)
                active = 1;
            else
                active = 0;
            end
        end
        
        if(total_state_transitions > 0)
            wake_prob(j,i) = inactive_to_active_transitions / total_state_transitions;
        else
            wake_prob(j,i) = NaN;
        end
        
    end
end

end