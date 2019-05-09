%% FUNCTION: detectSleepEpisodes
%% INPUTS
% sleep - Numeric matrix (bin x fly) of sleep (1 = sleep, 0 = wake)
% epoch_idx - 2 column matrix of array indexes that bound each epoch

%% OUTPUTS
% episodes - Array of sleep episodes:
%            COL 1 = fly
%            COL 2 = epoch
%            COL 3 = start time relative to epoch start
%            COL 4 = duration of episode, in bins

%% NOTE: Episode duration filter is only valid if the length of each bin = 1 minute;
%%       this filter is only relevant for episodes that cross epoch boundaries

function episodes = detectSleepEpisodes(sleep, epoch_idx  )
min_episode_duration = 5; % Minimum episode duration is 5 minutes

episodes = [];

for i = 1:size(sleep,2)
    for j = 1:size(epoch_idx, 1)
        this_sleep   = sleep(epoch_idx(j,1):epoch_idx(j,2),i);
        sleep_start  = this_sleep(1);
        sleep_switch = diff(this_sleep);
        
        % Find all indexes when an episode starts, including index 1
        episode_start = find(sleep_switch == 1) + 1;
        if(sleep_start == 1)
            episode_start = vertcat(1, episode_start);
        end
        
        % Find all indexes when an episode ends, use the final index if the
        % fly sleeps through it
        episode_end = find(sleep_switch == -1) + 1;
        if(length(episode_end) < length(episode_start))
            episode_end = vertcat(episode_end, length(this_sleep) + 1);
        end
        
        durations     = episode_end - episode_start;
        this_episodes = horzcat(episode_start(durations >= min_episode_duration), durations(durations >= min_episode_duration));
        this_episodes = horzcat(repmat(i, [size(this_episodes, 1) 1]), repmat(j, [size(this_episodes, 1) 1]), this_episodes);
        
        if(size(this_episodes,1) == 0)
            continue
        end
        
        if(size(episodes,1) > 0)
            episodes = vertcat(episodes, this_episodes);
        else
            episodes = this_episodes;
        end
    end
end

end
