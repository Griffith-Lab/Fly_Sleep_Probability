%% FUNCTION: readFlyData
%% INPUTS
% fileName - String of the filename to read, should be fly metadata file

%% OUTPUTS
% T - Table containing the metadata

function T = readFlyData( fileName )
T = readtable(fileName, 'Delimiter', 'tab', 'readVariableNames', true);
T.DOB = datetime(T.DOB, 'InputFormat', 'dd MMM yy');
end

