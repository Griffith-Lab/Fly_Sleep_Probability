%% FUNCTION: readCountData
%% INPUTS
% fileName - String of the filename to read, should be a DAM monitor file
% monitorNumber - ID number of the monitor, used for merging data

%% OUTPUTS
% D - Struct with three keys:
%     time_stamps - time stamps from monitor file
%     channels - array with monitorNumber and channel number (1-32)
%     counts - counts from monitor file (time x fly)

function D = readCountData( fileName, monitorNumber )
T = readtable(fileName,'ReadVariableNames',false, 'Delimiter', 'tab');

% Check for any data aquision errors
num_errors = nnz(T.Var4 ~= 1);
if(num_errors > 0)
    warning('%d errors found in monitor file %s', num_errors, fileName);
end

% Process time data format
raw_time = strcat(T.Var2, ',', string(T.Var3));
time_stamps = datetime(raw_time, 'InputFormat', 'dd MMM yy,HH:mm:ss');

% Extract count data to array
counts = table2array(T(:,11:42));

% Create monitor / channel annotation (used when merging data files from
% multiple monitors in subsequent processing steps)
channels = horzcat(repmat(monitorNumber, [32 1]), [1:32]');
channels = array2table(channels, 'VariableNames', {'MONITOR' 'CHANNEL'});

% Create output file
D = struct('time_stamps', time_stamps, ...
           'channels', channels, ...
           'counts', counts);
end

