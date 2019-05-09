%% FUNCTION: calculateSleepLatency
%% INPUTS
% sleep - Numeric matrix (bin x fly) of sleep (sleep = 1, wake = 0)
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% total - Numeric matrix (epoch x fly) of the total sleep time

function total = calculateTotalSleep(sleep, epoch_idx )

total = zeros(size(epoch_idx, 1), size(sleep, 2));

for i = 1:size(sleep,2)
    fly_total = [];
    for j = 1:size(epoch_idx, 1)
        this_sleep = sleep(epoch_idx(j,1):epoch_idx(j,2),i);
        fly_total = vertcat(fly_total, sum(this_sleep));
    end
    total(:,i) = fly_total;
end

end
