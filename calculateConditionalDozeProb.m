%% FUNCTION: calculateConditionalDozeProb
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% doze_prob - Numeric matrix (epoch x fly) of P(Doze), the conditional 
%             probability of switching from the active state to the inactive state

function doze_prob = calculateConditionalDozeProb(counts, epoch_idx)

doze_prob = ones(size(epoch_idx, 1), size(counts, 2));

for i = 1:size(counts,2)
    for j = 1:size(epoch_idx, 1)
        this_count = counts(epoch_idx(j,1):epoch_idx(j,2),i);
        
        total_state_transitions = 0;
        active_to_inactive_transitions = 0;
        active = 0;
        
        for k = 1:length(this_count)
            if(active == 1)
                total_state_transitions = total_state_transitions + 1;
                if(this_count(k) == 0)
                    active_to_inactive_transitions = active_to_inactive_transitions + 1;
                end
            end
            
            if(this_count(k) > 0)
                active = 1;
            else
                active = 0;
            end
        end
        
        if(total_state_transitions > 0)
            doze_prob(j,i) = active_to_inactive_transitions / total_state_transitions;
        else
            doze_prob(j,i) = NaN;
        end
        
    end
end

end