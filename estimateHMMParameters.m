%% FUNCTION: estimateHMMParameters
%% INPUTS
% counts - Numeric matrix (bin x fly) of beam breaks or other activity measure
% TRGUESS - Prior probability of hidden state transitions
% EMITGUESS - Prior probability of emission (col 1: no movement, col2:
%            movement)

%% OUTPUTS
% HMM - Estimated transition and emission probability


function HMM = estimateHMMParameters(counts, TRGUESS, EMITGUESS)

seq = ones(size(counts));
seq(counts > 0) = 2;
[TR , EMIT] = hmmtrain(seq' , TRGUESS , EMITGUESS);

HMM.TR = TR;
HMM.EMIT = EMIT;

end