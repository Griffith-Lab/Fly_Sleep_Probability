%% FUNCTION: ztTimeEpochBounds
% The output of this function is very similar to that of epochBounds, but
% is specifically intended to make moving average curves of 
% sleep/activity properties more straightforward

%% INPUTS
% EXPT - Data structure containing all of the input data
% sampling_frequency - Duration datatype, the time step between window
%                      centers
% bin_width - Duration datatype, the width of the moving average

%% OUTPUTS
% zt_time - ZT time of each output epoch, relative to EXPT.ZT_TIME_ZERO
% epoch_idx - Two column array of the indexes of each epoch start and end
%             time.

function [zt_time, epoch_idx] = ztTimeEpochBounds(EXPT, sampling_frequency, bin_width  )

time_step       = EXPT.TIMESTAMPS(2) - EXPT.TIMESTAMPS(1);
start_time      = find(EXPT.TIMESTAMPS == EXPT.START_TIME);
end_time        = find(EXPT.TIMESTAMPS == EXPT.END_TIME);
samples_per_day = hours(24)/sampling_frequency;

assert(start_time ~= 0, 'Start time not present in experiment time stamps');
assert(end_time ~= 0, 'End time not present in experiment time stamps');
assert(samples_per_day == round(samples_per_day), 'Sampling frequency must divide 24 hour day evenly');

bin_half_width = (bin_width - time_step)/2;
bin_edges      = [-bin_half_width bin_half_width];
idx_offsets    = ceil(bin_edges/time_step);
sample_centers = find(ismember(EXPT.TIMESTAMPS, EXPT.START_TIME:sampling_frequency:EXPT.END_TIME));
epoch_idx      = sample_centers + idx_offsets;
epoch_idx(epoch_idx < 1) = 1;

temp = find(EXPT.TIMESTAMPS == EXPT.END_TIME);
epoch_idx(epoch_idx > temp) = temp;

sample_timestamps = EXPT.START_TIME:sampling_frequency:EXPT.END_TIME;
zt_time = (sampling_frequency/hours(24) + ((sample_timestamps - EXPT.ZT_TIME_ZERO)/hours(24) - floor((sample_timestamps - EXPT.ZT_TIME_ZERO)/hours(24))))*24;

end