%% FUNCTION: detectDeadFlies
%% INPUTS
% EXPT - Data structure containing all of the input data
% time_for_dead - Duration data type, length of time without movement to 
%                 classify as dead

%% OUTPUTS
% alive - Array of detections, 1 = alive, 0 = dead

function alive = detectDeadFlies( EXPT, time_for_dead )

alive          = zeros(size(EXPT.COUNTS,2),1);
idx_final_time = find(EXPT.TIMESTAMPS == EXPT.END_TIME);
idx_dead_time  = find(EXPT.TIMESTAMPS == (EXPT.END_TIME - time_for_dead));

for i = 1:size(EXPT.COUNTS,2)
    if(sum(EXPT.COUNTS( (idx_dead_time + 1):idx_final_time, i)) > 0)
        alive(i) = 1;
    end
end

end
