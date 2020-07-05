function PlotAirfoils(varargin)
%PLOTAIRFOILS plots one or more airfoil shapes ((X,Y) .DAT files)
%   Input the file names in full. Airfoil files can be obtained from the
%   UIUC library:
%   https://m-selig.ae.illinois.edu/ads/coord_database.html
%   The first lines are skipped; the file names are used for the legend.
%
% Last modified on July 5, 2020, by Matt Overholt.

% Open the figure
figure('Name','Airfoils');
axis equal
hold on
ledcell = cell(1,nargin);

% Read in each airfoil and plot
for i = 1:nargin
    airfoil = readmatrix(varargin{i},'ExpectedNumVariables',2);
    plot(airfoil(:,1),airfoil(:,2),'LineWidth',1)
    ledcell(1,i) = { varargin{i} };
end

% Set the legend and axes
legend(ledcell)
xlabel('X')
ylabel('Y')
hold off

end
