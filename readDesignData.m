%% FUNCTION: readDesignData
%% INPUTS
% fileName - String of the filename to read, should be design metadata file

%% OUTPUTS
% S - Struct containing the metadata from the design file

function S = readDesignData( fileName )

% Read data into 2 column table
T = readtable(fileName, 'Delimiter', 'tab', 'readVariableNames', true);

% Sanity checks
assert(sum(ismember(T.FIELD, 'START TIME'))   == 1, 'START TIME error in design file' );
assert(sum(ismember(T.FIELD, 'END TIME'))     == 1, 'END TIME error in design file' );
assert(sum(ismember(T.FIELD, 'ZT TIME ZERO')) == 1, 'ZT TIME ZERO error in design file' );
assert(sum(ismember(T.FIELD, 'TEMP STEP'))     > 0, 'TEMP STEP missing in design file' );

% Convert manditory times to datetime format
start_time = datetime(T(strcmp(T.FIELD, 'START TIME'), 2).VALUE, 'InputFormat', 'dd MMM yy,HH:mm:ss');
zt_time    = datetime(T(strcmp(T.FIELD, 'ZT TIME ZERO'), 2).VALUE, 'InputFormat', 'dd MMM yy,HH:mm:ss');
end_time   = datetime(T(strcmp(T.FIELD, 'END TIME'), 2).VALUE, 'InputFormat', 'dd MMM yy,HH:mm:ss');

% Convert TEMP STEP field to array of datetime & value 
subT = T(strcmp(T.FIELD, 'TEMP STEP'),2);
for i = 1:height(subT)
    substrings          = strsplit(char(subT.VALUE(i)), ',');
    temperature_time(i) = datetime(strcat(substrings{1:2}), 'InputFormat', 'dd MMM yyHH:mm:ss');
    temperature_deg(i)  = str2num(substrings{3});
end


% Convert LIGHT PULSE field to array of datetime start and stop 
subT = T(strcmp(T.FIELD, 'LIGHT PULSE'),2);
for i = 1:height(subT)
    substrings  = strsplit(char(subT.VALUE(i)), ',');
    lights(i,1) = datetime(strcat(substrings{1:2}), 'InputFormat', 'dd MMM yyHH:mm:ss');
    
    h = strsplit(char(substrings(3)), ':');
    d = duration(str2num(h{1}),str2num(h{2}),str2num(h{3})); 
    lights(i,2) = lights(i,1) + d;
end

% Convert SHAKE PULSE field to array of datetime start and stop
subT = T(strcmp(T.FIELD, 'SHAKE PULSE'),2);
for i = 1:height(subT)
    substrings = strsplit(char(subT.VALUE(i)), ',');
    shake(i,1) = datetime(strcat(substrings{1:2}), 'InputFormat', 'dd MMM yyHH:mm:ss');
    
    h = strsplit(char(substrings(3)), ':');
    d = duration(str2num(h{1}),str2num(h{2}),str2num(h{3})); 
    shake(i,2) = shake(i,1) + d;
end

% Convert MOVEMENT THRESHOLD field to double
subT = T(strcmp(T.FIELD, 'MOVEMENT THRESHOLD'),2);
for i = 1:height(subT)
    threshold = str2num(subT.VALUE{1});
end

% Convert TIME STEP field to duration
subT = T(strcmp(T.FIELD, 'TIME STEP'),2);
for i = 1:height(subT)
    temp = split(subT.VALUE{1},':');
    hr = str2num(temp{1});
    mn = str2num(temp{2});
    sc = str2num(temp{3});
    time_step = duration(hr,mn,sc);
end

% Produce struct output file
S = struct('MONITOR_MODEL', T(strcmp(T.FIELD, 'MONITOR MODEL'), 2).VALUE, ...
           'INCUBATOR', T(strcmp(T.FIELD, 'INCUBATOR'), 2).VALUE, ...
           'START_TIME', start_time, ...
           'ZT_TIME_ZERO', zt_time, ...
           'END_TIME', end_time, ...
           'HEAT_STEP', struct('step_time', temperature_time, 'step_heat', temperature_deg));

if(exist('lights', 'var'))
    S.LIGHT_PULSE = lights;
end       
       
if(exist('shake', 'var'))
    S.SHAKE_PULSE = shake;
end

if(exist('threshold', 'var'))
    S.MOVE_THRESHOLD = threshold;
end

if(exist('time_step', 'var'))
    S.TIME_STEP = time_step;
end
       
end

