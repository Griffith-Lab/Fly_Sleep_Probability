%% FUNCTION: readQualityData
%% INPUTS
% fileName - String of the filename to read, should be quality metadata file

%% OUTPUTS
% T - Table containing the quality metadata

function T = readQualityData( fileName )

T = readtable(fileName, 'Delimiter', 'tab', 'readVariableNames', true);

end

