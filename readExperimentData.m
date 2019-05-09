%% FUNCTION: readExperimentData
% This function is specifically for reading DAM system data. It was named
% before compatibility with other data aquisition systems was integrated.

%% INPUTS
% fileName - String of the filename to read, should be experiment file

%% OUTPUTS
% EXPT - Struct containing all of the experimental data

%% NOTE: This function writes EXPT to disk as well as returning it

function EXPT = readExperimentData( fileName )

% Read data into 2 column table
T = readtable(fileName, 'Delimiter', 'tab', 'readVariableNames', true);

% Sanity checks
assert(sum(ismember(T.FIELD, 'MONITOR')) > 0, 'Must have at least 1 monitor file' );
assert(sum(ismember(T.FIELD, 'DESIGN FILE')) == 1, 'Must include design file' );
assert(sum(ismember(T.FIELD, 'FLY FILE')) == 1, 'Must include fly file' );

% Read design data
S = readDesignData(char(T(strcmp(T.FIELD, 'DESIGN FILE'),2).VALUE));

% Read fly data
F = readFlyData(char(T(strcmp(T.FIELD, 'FLY FILE'),2).VALUE));

% Read in monitors listed in the experiment file
listed_monitors = [];
file_names = {};
subT = T(strcmp(T.FIELD, 'MONITOR'),2);
for i = 1:height(subT)
    substrings = strsplit(char(subT.VALUE(i)), ',');
    file_names(i) = substrings(1);
    listed_monitors(i) = str2num(char(substrings(2)));
end

% Sanity check: based on fly data, what monitors should be imported
inferred_monitors = unique(F.MONITOR);
assert(isequal(length(inferred_monitors),length(listed_monitors)) && ...
       isequal(length(inferred_monitors),length(intersect(inferred_monitors, listed_monitors))), ...
       'The monitor lists in the fly file and experiment file do not match.')

% Read in monitor data
D = readCountData( char(file_names(1)), listed_monitors(1) );
if(length(file_names) > 1)
    for i = 2:length(file_names)
        temp = readCountData( char(file_names(i)), listed_monitors(i) );
        
        %Sanity check: are the timestamps the same?
        assert(isequal(D.time_stamps, temp.time_stamps), 'Timestamps must match exactly between all monitor files');
        D.channels = vertcat(D.channels, temp.channels);
        D.counts = horzcat(D.counts, temp.counts);
    end
end

EXPT = struct('FLIES', F, ...
              'TIMESTAMPS', D.time_stamps, ...
              'CHANNELS', D.channels, ...
              'COUNTS', D.counts);
          
pairs = [fieldnames(EXPT), struct2cell(EXPT); fieldnames(S), struct2cell(S)].';
EXPT = struct(pairs{:});

temp = strsplit(fileName, '.');
output_file_name = [char(temp(1:end-1)), datestr(now, 30)];
save(output_file_name, 'EXPT');

end