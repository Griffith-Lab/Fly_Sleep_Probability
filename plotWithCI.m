%% FUNCTION: plotWithCI
%% INPUTS
% data - Numeric array (time x fly) of data to plot
% alpha - alpha level of confidence interval (usually 0.05 or 0.01)
% color - Fill color of confidence interval
% x - x coordinate values, usually time (optional)

%% OUTPUTS
% A plot of the mean and confidence interval of the data, plotted on the
% active axes

function plotWithCI(data, alpha, color, x)

mu = nanmean(data,2);

if (~exist('x', 'var'))
    x = (1:length(mu))';
end

% Remove NaN values
x = x(~isnan(mu));
mu = mu(~isnan(mu));

bounds = [];
for i = 1:size(x)
    temp = data(i,:)';
    temp = temp(~isnan(temp));
    if(length(temp) > 2)
        bounds = horzcat(bounds, paramci(fitdist(temp, 'normal'), 'Parameter', 'mu', 'Alpha', alpha));
    else
        bounds = horzcat(bounds , bounds(:,end));
    end
end

%%figure
hold on
patch([x; x(end:-1:1); x(1)], [bounds(1,:)'; bounds(2,end:-1:1)'; bounds(1,1)], color);
plot(x,mu)

end