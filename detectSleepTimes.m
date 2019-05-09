%% FUNCTION: detectSleepTimes
%% INPUTS
% EXPT - Data structure containing all of the input data
% sleep_threshold - Duration data type, length of time without movement to
%                   classify as sleep

%% OUTPUTS
% sleep - Numeric matrix (bin x fly) of sleep (1 = sleep, 0 = wake)

function sleep = detectSleepTimes(EXPT, sleep_threshold)

% Because sleep is initialized with zeros (i.e. awake), only times when the
% fly is found to be asleep need to be modified in the variable
sleep = zeros(size(EXPT.COUNTS));

for i = 1:size(EXPT.COUNTS,2)
    asleep = 0;
    for j = 1:size(EXPT.COUNTS,1)
        if(EXPT.COUNTS(j,i) > 0)
            asleep = 0;
        else
            if(asleep)
                sleep(j,i) = 1;
            else
                % Calculate time of j and j + sleep_threshold
                time_j           = EXPT.TIMESTAMPS(j);
                time_plus_thresh = time_j + sleep_threshold;
                idx_thresh       = find(EXPT.TIMESTAMPS == time_plus_thresh) - 1;
                
                if( idx_thresh <= size(EXPT.COUNTS,1) )
                    if(sum(EXPT.COUNTS(j:idx_thresh, i)) == 0)
                        sleep(j:idx_thresh,i) = 1;
                        asleep = 1;
                    end
                end
            end
        end
    end
end

end