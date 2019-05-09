%% FUNCTION: detectSleepTimes
%% INPUTS
% EXPT - Data structure containing all of the input data
% epoch_length - Duration data type, length of time in a behavioral epoch

%% OUTPUTS
% epoch_idx - Two column array of the indexes of each epoch start and end
%             time. If the experiment is not evenly divisible, the final 
%             epoch will be shortened.


function epoch_idx = epochBounds(EXPT, epoch_length)
% epochBounds Reurn the index of the start and end of each analysis epoch.
% If the experiment is not evenly divisible, the final epoch will be
% shortened.

start_time = find(EXPT.TIMESTAMPS == EXPT.START_TIME);
assert(start_time ~= 0, 'Start time not present in experiment time stamps');

end_time = find(EXPT.TIMESTAMPS == EXPT.END_TIME);
assert(end_time ~= 0, 'End time not present in experiment time stamps');

marker = EXPT.START_TIME;
epoch_idx = [];

while((marker + epoch_length) <= EXPT.END_TIME)
    epoch_start = find(EXPT.TIMESTAMPS == marker);
    epoch_end = find(EXPT.TIMESTAMPS == (marker + epoch_length)) - 1;
    marker = marker + epoch_length;
    epoch_idx = vertcat(epoch_idx, [epoch_start epoch_end]);
end

if(marker <= EXPT.END_TIME)
    epoch_start = find(EXPT.TIMESTAMPS == marker);
    epoch_end = end_time;
    epoch_idx = vertcat(epoch_idx, [epoch_start epoch_end]);
end
    
    
%