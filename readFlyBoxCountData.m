%% FUNCTION: readFlyBoxCountData
% This function is a container to read and clean the movement data from the
% Flybox tracker output

%% INPUTS
% fileName - String of the filename to read, should be Flybox tracker
%            output
% S - Struct of design data output by readDesignData, used to clean data

%% OUTPUTS
% D - Struct containing cleaned Flybox count data

function D = readFlyBoxCountData(fileName , S)
[raw_time_stamps , raw_counts] = readFlyBoxData(fileName);
[time_stamps , counts] = cleanFlyboxData(raw_counts, ...
                                         raw_time_stamps, ...
                                         S.MOVE_THRESHOLD, ...
                                         S.START_TIME, ...
                                         S.END_TIME, ...
                                         S.TIME_STEP);
                                     
% Create output file
D = struct('time_stamps', time_stamps, ...
    'channels', 1:size(counts,2), ...
    'counts', counts);

end

