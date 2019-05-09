%% FUNCTION: readFlyBoxData
%% INPUTS
% fileName - String of the filename to read, should be Flybox tracker
%            output

%% OUTPUTS
% time_stamps - Raw timestamps from Flybox tracker output
% counts - Raw movement between frames, in units of pixels

function [time_stamps , counts] = readFlyBoxData(track_filename)

tracks = readtable(track_filename);
num_frames = max(tracks.Frame);

% Extract time stamps
posix_time = sort(unique((tracks.Time)));
time_stamps = datetime(posix_time, 'ConvertFrom', 'posixtime');

% Error checking - is the data file corrupted, inconsistent, etc.
assert(length(time_stamps) == num_frames, "Different number of frames and timestamps, check input files");

% Convert position to distance traveled
counts = zeros(num_frames, max(tracks.Fly_ID));
for i = 1:size(counts,2)
    this_fly = tracks(tracks.Fly_ID == i, :);
    counts(2:end,i) = sqrt(diff(this_fly.X_Co).^2 + diff(this_fly.Y_Co).^2);
end

end
