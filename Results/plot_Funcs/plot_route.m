function plot_route(obj)
% Plots route profile and route gradient in two axes
% First  Axes (above), route profile (altitudes, hoz distance)
% Second Axes (below), gradient (gradient%, actual distance)

fontName = 'TimesNewRomans';
hcf = figure('name', [obj.name,'_Profile']);
set(hcf, 'invertHardcopy', 'off' ) % Keep background @save
set(hcf,'Position', get(hcf,'Position').* [1, .6, 1.4, 1.2])

% -- ax1 -- Plot the Upper axes
hax1 = subplot(2,1, 1);
set(hax1,'Position', get(hax1,'Position').* [.4, 1, 1.2, 1.1])
plot(obj.hozDist/1e3, obj.atd,'LineWidth', 1.5); box off
title('\rightarrow \rightarrow \rightarrow', ...
    'HorizontalAlignment','center', 'FontWeight', 'Bold')
hold on % 'hold on' to add a plot of stations' positions
plot (obj.stnPos_hozDist/1e3, obj.stnAtd,...
    'or','markersize',5,'MarkerFaceColor','y')
hold on % 'hold on' to add station names

% Display stations' names
stnNamesOffset = 1 ;
text(obj.stnPos_hozDist/1e3 ,(obj.stnAtd - stnNamesOffset),...
    obj.stnNames,...
    'FontSize',8, 'FontWeight','bold',...
    'HorizontalAlignment','center',...
    'BackgroundColor',[.6 .9 .7], 'Margin',0.5)
hold off

htx1 = ylabel(hax1, 'Altitude [m]');
% htx2 = xlabel(haxUpper, 'a)');
htx2 = xlabel(hax1, {'a)', 'Horizontal distance [km]'});
xticklabels('') ;

% -- ax2-- plot gradient, the Lower axes
hax2 = subplot(2,1, 2);
set(hax2,'Position', get(hax2,'Position').* [.4, 1, 1.2, 1.1])
s = linspace (0, max(obj.actDist), 3*length(obj.actDist));
% s = obj.actDist;
grad = getGradient(obj, s);
% NOTE:
% The x-axis data in the above (profile) plot is obj.hozDist
plot(s/1e3, grad * 100), box off, hold on
% plot(obj.hozDist/1e3, grad * 100), box off, hold on
xlim([-inf, inf]) % Tights xlim
% Add station points on the gradient plot
s = obj.stnPos_actDist;
grad = getGradient(obj, s) * 0;
plot(obj.stnPos_hozDist/1e3, grad * 100,...
    'or','markersize',3,'MarkerFaceColor','y'), hold off

htx3 = ylabel( hax2, 'Gradient [%]');
%             htx4 = xlabel(haxLower, {'b','Distance [km]'});
htx4 = xlabel(hax2, {'b','Actual distance [km]'});

set([htx1,htx2, htx3, htx4], ...
    'FontName', fontName,'FontWeight', 'Bold','FontSize', 9)
end