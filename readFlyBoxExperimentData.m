%% FUNCTION: readFlyBoxExperimentData
%% INPUTS
% fileName - String of the filename to read, should be Flybox experiment file

%% OUTPUTS
% EXPT - Struct containing all of the experimental data

%% NOTE: This function writes EXPT to disk as well as returning it

function EXPT = readFlyBoxExperimentData( fileName )

% Read data into 2 column table
T = readtable(fileName, 'Delimiter', 'tab', 'readVariableNames', true);

% Sanity checks
assert(sum(ismember(T.FIELD, 'FLYBOX')) == 1, 'Must have one flybox file' );
assert(sum(ismember(T.FIELD, 'DESIGN FILE')) == 1, 'Must include design file' );
assert(sum(ismember(T.FIELD, 'FLY FILE')) == 1, 'Must include fly file' );

% Read design data
S = readDesignData(T.VALUE{strcmp(T.FIELD, 'DESIGN FILE')});

% Read fly data
F = readFlyData(T.VALUE{strcmp(T.FIELD, 'FLY FILE')});

% Read quality data
Q = readQualityData(T.VALUE{strcmp(T.FIELD, 'QUALITY FILE')});

% Read in flybox listed in the experiment file
D = readFlyBoxCountData(T.VALUE{strcmp(T.FIELD, 'FLYBOX')} , S);

EXPT = struct('FLIES', F, ...
              'TIMESTAMPS', D.time_stamps', ...
              'CHANNELS', D.channels', ...
              'COUNTS', D.counts, ...
              'QUALITY', Q);
          
pairs = [fieldnames(EXPT), struct2cell(EXPT); fieldnames(S), struct2cell(S)].';
EXPT = struct(pairs{:});

temp = strsplit(fileName, '.');
output_file_name = [char(temp(1:end-1)), datestr(now, 30)];
save(output_file_name, 'EXPT');

end