%% FUNCTION: cleanFlyboxData
% Flybox tracking occasionally has delayed or skipped frames that
% complicate further analysis. This function outputs FlyBox count data with
% a uniform time step in the experimental window of interest.

%% INPUTS
% raw_counts - Numeric matrix (frame x fly) of distance traveled from
%              readFlyBoxData
% raw_time_stamps - Datetime format timestamps returned by readFlyBoxData
% movement_threshold - Threshold for minimum distance traveled
% expt_start_time - Datetime format time of the experiment start time
% expt_end_time - Datetime format time of the experiment end time
% time_step - Duration of the time step in the output of the 

%% OUTPUTS
% output_time_stamps - Datetime format timestamps of the bin edges
% output_counts - Numeric matrix (time_step x fly) of the distance traveled

function [output_time_stamps , output_counts] = cleanFlyboxData(raw_counts, raw_time_stamps, movement_threshold , expt_start_time, expt_end_time, time_step)

% Error checking - tell the user if the start or end times are unreasonable
assert( (expt_start_time >= raw_time_stamps(1)) & (expt_start_time <= raw_time_stamps(end)), ...
    'Experiment Start Time does not occur during the tracking file');
assert( (expt_end_time >= raw_time_stamps(1)) & (expt_end_time <= raw_time_stamps(end)), ...
    'Experiment End Time does not occur during the tracking file');

output_bin_edges = (expt_start_time-time_step):time_step:expt_end_time;

% Error checking - tell the user if the ouput times are not what would be expected
assert(unique(diff(output_bin_edges)) == time_step, 'Experiment Start / End / Timestep error, check inputs');

output_time_stamps = output_bin_edges(2:end);
output_counts = zeros(length(output_time_stamps), size(raw_counts, 2));

for i = 2:length(output_bin_edges)
    this_time_idx = find(raw_time_stamps >= output_bin_edges(i-1) & raw_time_stamps < output_bin_edges(i));
    for j = 1:size(output_counts,2)
        temp = raw_counts(this_time_idx,j);
        output_counts(i-1,j) = sum(temp(temp > movement_threshold));
    end
end

end
