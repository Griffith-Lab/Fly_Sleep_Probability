%% FUNCTION: calculateHMMStates
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% HMM - struct containing transition and emission probabilities for a HMM

%% OUTPUTS
% states - Maximum likelyhood state prediction based on HMM


function states = calculateHMMStates(counts, HMM)

states = zeros(size(counts));

for i = 1:size(counts,2)
    seq = ones(size(counts,1),1);
    seq(counts(:,i) > 0) = 2;
    
    temp = hmmdecode(seq', HMM.TR, HMM.EMIT);
    [~, temp_seq] = max(temp);
    states(:,i) = temp_seq;
end

end