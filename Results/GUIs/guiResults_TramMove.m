function varargout = guiResults_TramMove(varargin)
% GUIRESULTS_TRAMMOVE MATLAB code for guiResults_TramMove.fig
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiResults_TramMove_OpeningFcn, ...
                   'gui_OutputFcn',  @guiResults_TramMove_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiResults_TramMove is made visible.
function guiResults_TramMove_OpeningFcn(hObject, ~, handles, varargin)

set(handles.figure, 'menubar', 'figure')
% set(handles.mainFigure, 'menubar', 'none')
%- Maintain background color when saving
set(handles.figure, 'invertHardcopy', 'off') 

set(groot,'defaultLineLineWidth', 1.4)
% fs = 10; % Font Size

obj = varargin{1}; % Tram Object


%--- Plotting Variables ---
%- time
if obj.timeArray(obj.k) < 120  % Less than 2 minutes
    time = obj.timeArray;
    timeUnits = '[sec]';
else
    time = obj.timeArray/60;
    timeUnits ='[minutes]';
end

%- Speed
spd = obj.spdArray * obj.mps2kph;
%- Forces
F = obj.tfArray / 1e3; % Tractive force (effort)
R = obj.rfArray / 1e3; % Resistance force
%- Power
pE = obj.peArray / 1e3; % Electric Power demand
%- Energy & distance
eE = obj.egyArray / 1e3;
S = obj.dstArray / 1e3;

%---  x_limit ---
minX = 0;
maxX = max(time);
xLower = minX - 0.01 * (maxX - minX);
xUpper = maxX + 0.01 * (maxX - minX);
xLimit = [xLower   xUpper];

%-- Colors
%- Line Colors
or = [.85, .33, .1];  % color
lb = [0,  .447,  0.8]; % Light blue

%-- Set units to normalized
axAll = [handles.axes1, handles.axes2, handles.axes3, handles.axes4];
set(handles.figure, 'Resize', 'on');  % Resizable
set([axAll, handles.figure], 'Units', 'normalized')

% --- ax1 --- Velocity & Tractive Effort ---   
axes(handles.axes1);
ax = gca;
% cla reset

yyaxis left
plot (time, spd,'LineWidth', 1.4, 'Color', or); 
ly1 = ylabel ('Speed [km/h]');
[minY, maxY] = bounds(spd);
yLower = minY - 0.01 * (maxY - minY);
yUpper = maxY + 0.01 * (maxY - minY);
ylim([yLower, yUpper]);
xlim(xLimit);

yyaxis right
plot (time, F,'LineWidth', 0.8, 'Color', lb); box off
ly2 = ylabel ('Tractive effort [kN]');
lx = xlabel ({['Time ',timeUnits], 'a)'});
% xticklabels('') ;
[minY, maxY] = bounds(F);
yLower = minY - (0.01 * (maxY - minY));
yUpper = maxY + (0.01 * (maxY - minY));
ylim([yLower, yUpper]) ;
xlim(xLimit);
%-- Set labels text
set([ly1, ly2, lx], 'FontSize', 9, 'FontWeight', 'bold')

ht1 = title({...
    sprintf('Tram name : %s',obj.name),...
    sprintf('Tram ID : %s', obj.ID), ...
    sprintf('Tram move_control remarks : %s', obj.simRemarks),...
    sprintf('Speed max : %.0f km/h', round(obj.spdMax * obj.mps2kph)),...
    sprintf('Speed absolute max : %.0f km/h', obj.spdAbsMax * obj.mps2kph)});
set(ht1, 'Interpreter', 'none', 'HorizontalAlignment', 'right',...
    'FontSize', 9.5, 'FontName', 'TimesNewRomans')

hlg = legend ({'Velocity', 'Tractive effort'});
%-- Rise legend up
hlg.Position(2) = sum(ax.Position([2, 4])) * 1.01;
% -     -   -   -   end_axes1 plot  - -   -   -   -   


%--- axes 2 --- Forces
%- Tractive effort force (tfArray)
%- Sum of resistance forces (rfArray)
axes(handles.axes2)
ax = gca;
% cla reset

hl = plot(time, F, time, R); box off
set(hl(2), 'LineWidth', 0.8)
lby = ylabel('Forces [kN]');
[minY, maxY] = bounds([F, R]);
yLower = minY - 0.01 * (maxY - minY);
yUpper = maxY + 0.01 * (maxY - minY);
ylim([yLower, yUpper]);
lbx = xlabel ({['Time ',timeUnits], 'b)'});
xlim(xLimit);
%-- Set labels text
set([lby, lbx], 'FontSize', 9, 'FontWeight', 'bold')

ht2 = title({...
    sprintf('Mass [tram, people] : [%.4g,  %.4g] tons',...
    obj.massTare / 1e3, obj.massPeople / 1e3),...
    sprintf('Mass OBESD : %.3g tons',obj.massOBESD / 1e3),...
    sprintf('Mass total  : %.4g tons', obj.massTotal / 1e3),...
    sprintf('Mass effective : %.4g tons',obj.massEffective / 1e3),...
    sprintf('Rotary allowance : %.2g%%',obj.rotaryAllowance * 100)});
set(ht2,'Interpreter', 'none', 'HorizontalAlignment', 'right',...
    'FontSize', 9.5, 'FontName', 'TimesNewRomans')

hlg = legend({'Tractive effort', 'Resistance force'});
%-- Rise legend up
hlg.Position(2) = sum(ax.Position([2, 4])) * 1.01;


%--- axes 3 --- Power
%- Electrical power demand (peArray)
axes(handles.axes3)
% ax = gca;
% cla reset

plot(time, pE, 'LineWidth', 1), box off
lby = ylabel('Power demand [kW]');
[minY, maxY] = bounds(pE);
yLower = minY - 0.01 * (maxY - minY);
yUpper = maxY + 0.01 * (maxY - minY);
ylim([yLower, yUpper]);

lbx = xlabel ({['Time ',timeUnits], 'c)'});
xlim(xLimit);
%-- Set labels text
set([lby, lbx], 'FontSize', 9, 'FontWeight', 'bold')

ht3 = title({...
    sprintf('e2m (VVVF * gear * motor) :  %.2g', obj.e2m),...
    sprintf('Aux power demand [kW] :  %.2f', obj.pAux/1e3 )});
set(ht3,'Interpreter', 'none', 'HorizontalAlignment', 'right',...
    'FontSize', 9.5, 'FontName', 'TimesNewRomans')


%--- axes 4 --- Energy & Distance
%- Net energy consumed Left
%- Distance travelled Right
axes(handles.axes4)
% ax = gca;
% cla reset
yyaxis left
plot(time, eE)
lby = ylabel('Net energy consumed [kWh]');
[minY, maxY] = bounds(eE);
yLower = minY - 0.01 * (maxY - minY);
yUpper = maxY + 0.01 * (maxY - minY);
ylim([yLower, yUpper]);

yyaxis right % Distance
plot(time, S, 'LineWidth', 0.8), box off
ylabel('Distance travelled [km]')
[minY, maxY] = bounds(S);
yLower = minY - 0.01 * (maxY - minY);
yUpper = maxY + 0.01 * (maxY - minY);
ylim([yLower, yUpper]);

lbx = xlabel ({['Time ',timeUnits], 'd)'});
xlim(xLimit);
%-- Set labels text
set([lby, lbx], 'FontSize', 9, 'FontWeight', 'bold')

ht4 = title({...
    sprintf('Net energy consumed : %.4g kWh',obj.egy / 1e3),...
    sprintf('Distance travelled : %.4g km', obj.dst / 1e3),...
    sprintf('Travel time : %.4g minutes',obj.time / 60)});
set(ht4,'Interpreter', 'none', 'HorizontalAlignment', 'right',...
    'FontSize', 9.5, 'FontName', 'TimesNewRomans')

legend({'Energy', 'Distance'}, 'Location', 'northWest')

set(groot,'defaultLineLineWidth', 'default')
% - -   -   -   --- Plotting End --- -   -   -   -   

% Choose default command line output for guiResults_TramMove
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guiResults_TramMove_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
