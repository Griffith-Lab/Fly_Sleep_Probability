%% FUNCTION: simulateConditionalActivity
%% INPUTS
% number_sim - Number of simulations to run
% sim_duration - Duration of the simulation (duration datatype preferred)
% sim_timestep - Time resolution of simulation (duration datatype preferred)
% probWake - P(Wake) for simulated flies
% probDoze - P(Doze) for simulated flies

%% OUTPUTS
% SIM - Struct containing the simulated timestamps and counts in the same
%       format as an experiment read by readExperimentData

function SIM = simulateConditionalActivity(number_sim, sim_duration, sim_timestep, probWake, probDoze)

%% Params
PRE_SIMULATION_WARMUP = 100; % in steps

%% Determine number of steps in simulation
SIM.TIMESTAMPS = sim_timestep:sim_timestep:sim_duration;
number_steps = length(SIM.TIMESTAMPS) + PRE_SIMULATION_WARMUP;

%% Simulate activity
% 1 = active, 0 = inactive
counts = zeros(length(SIM.TIMESTAMPS), number_sim);

for i = 1:number_sim
    % Reset simulation
    activity = zeros(number_steps, 1);
    activity(1) = round(rand());
    for j = 2:number_steps
        if(activity(j-1)) % if previously active
            if( rand() > probDoze )
                activity(j) = 1; % Fly stays active
            else
                activity(j) = 0; % Fly dozes
            end
        else % if previously not active
            if( rand() > probWake )
                activity(j) = 0; % Fly stays inactive
            else
                activity(j) = 1; % Fly rouses
            end
        end
    end
    counts(:,i) = activity(PRE_SIMULATION_WARMUP+1:end);
end

%% Finalize output
SIM.COUNTS = counts;

end

