function plot_tramCurves(obj)
x = 0 : 0.5 : obj.spdAbsMax * obj.mps2kph;

te = obj.teFunc(x);
be = - obj.beFunc(x);
fd = obj.fdFunc(x);

hf = figure('Units', 'normalized');
% Keep background when saving
set(hf, 'invertHardcopy', 'off') 
% Position with negative braking effort. 
% [left bottom width height]
hf.Position = [.37   .22    .25   .58];
axes('Position', [.12, .09, .86, .86]);

hLines = plot(x, te, x, be, x, fd); box off
h_labels = [ylabel('Force [kN]'), xlabel('Speed [km/h]')];
h_title = title(strcat(obj.name, '__Force Curves'),...
    'Interpreter', 'none');

%- Limits
axis tight
yLim = get(gca, 'YLim');
ylim([yLim(1)-1, yLim(2) + 1]);

set(hLines, 'lineWidth', 2);
set(hLines(2), 'LineStyle', '--')
set(hLines(3), 'LineStyle', ':')

hTextLegend = ...
    legend({'Tractive effort', 'Braking effort',...
    'Fricitional drag'}, 'FontName', 'TimesNewRomans');
set(hTextLegend, 'Location', 'best', 'Box', 'off')


set([h_labels,h_title], 'FontWeight', 'bold',...
    'FontSize', 10, 'FontName', 'TimesNewRomans')