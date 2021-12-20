
function varargout = gui_resultsTramCapLine(varargin)
% GUI_RESULTSTRAMCAPLINE MATLAB code for gui_resultsTramCapLine.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_resultsTramCapLine_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_resultsTramCapLine_OutputFcn, ...
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


% --- Executes just before gui_resultsTramCapLine is made visible.
function gui_resultsTramCapLine_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_resultsTramCapLine (see VARARGIN)

% Hide the menu for copying
set(handles.mainFigure, 'menubar', 'figure')
% set(handles.mainFigure, 'menubar', 'none')
% Maintain background color when saving
set(handles.mainFigure, 'invertHardcopy', 'off') 


% Input objects
trm = varargin{1}; % Tram mover
cap = varargin{2}; % Capacitor bank
line = varargin{3}; % Contact line

time = trm.timeArray / 60;
spd = trm.spdArray * trm.mps2kph;
dst = trm.dstArray / 1e3; % Distance    
tF = trm.tfArray / 1e3; % Tractive Effort
pE = trm.peArray / 1e3; % Electric power demand
egy = trm.egyArray / 1e3; % Energy
cP = cap.powerArray / 1e3; %
lP = line.powerArray / 1e3 ;
cI = cap.currentArray;   
cV = cap.voltageArray;
SoE = cap.soeArray * 100;

%-  -   -   X limit
minTime = 0;
maxTime = max(time);
xLower = minTime - 0.01 * (maxTime - minTime);
xUpper = maxTime + 0.01 * (maxTime - minTime);
xLimit = [xLower   xUpper] ;

%- Line Colors
or = [.85, .33, .1];  % color
lb = [0,  .447,  0.8];

fs = 10;   % Font Size
haxAll = [handles.ax1, handles.ax2, handles.ax3, handles.ax4];
set(haxAll, 'Units', 'normalized')

% % --- ax1 ---     --- Velocity & Tractive Effort ---   
axes(handles.ax1);
% cla reset
hax = gca ;

yyaxis left
plot (time, spd,'LineWidth', 1.4, 'Color', or); 
l1 = ylabel ('Speed [km/h]');
minSpd = 0;
maxSpd = max(spd);
yLower = minSpd - 0.01 * (maxSpd - minSpd);
yUpper = maxSpd + 0.01 * (maxSpd - minSpd);
ylim([yLower, yUpper]) ;
xlim(xLimit);

yyaxis right
plot (time, tF,'LineWidth', 0.8, 'Color', lb); box off
l2 = ylabel ('T_E [kN]');
l3 = xlabel ({'Time [minutes]', 'a)'});
% xticklabels('') ;
[minTF, maxTF] = bounds(tF);
yLower = minTF - (0.01 * (maxTF - minTF));
yUpper = maxTF + (0.01 * (maxTF - minTF));
ylim([yLower, yUpper]) ;
xlim(xLimit);

hl = legend ({'Velocity', 'Tractive effort'}, 'Box', 'off');
set(hl, 'Location', 'northoutside', 'Orientation','horizontal')
hl.Position(2) = (hax.Position(2) + hax.Position(4))*1.01 ;

set([l1, l2, l3], 'FontSize', fs, 'FontWeight', 'bold')

% --- ax2 ---   --- Current & Voltage ---
axes(handles.ax2);
% cla reset
hax2 = gca;
yyaxis left
plot (time, cV/1e3,'LineWidth', 1.5, 'Color', or);
l1 = ylabel ('V_{sc} [kV]');
[cVmin, cVmax] = bounds(cV/1e3);
yLower = cVmin - (0.01 * (cVmax - cVmin));
yUpper = cVmax + (0.01 * (cVmax - cVmin));
ylim([yLower, yUpper]) ;
xlim(xLimit);

yyaxis right
plot (time, cI, 'LineWidth', 0.8, 'Color', lb); box off
l2 = ylabel ('I_{sc} [A]');
l3 = xlabel ({'Time [minutes]', 'b)'});
[cImin, cImax] = bounds(cI);
yLower = cImin - (0.01 * (cImax - cImin));
yUpper = cImax + (0.01 * (cImax - cImin));
ylim([yLower, yUpper]) ;
xlim(xLimit) ;

hl2 = legend ('Voltage', 'Current'); legend boxoff
set(hl2, 'location', 'Northoutside', 'Orientation','horizontal')
hl2.Position(2) = (hax2.Position(2) + hax2.Position(4))*1.01 ;

set([l1, l2, l3], 'FontSize', fs, 'FontWeight', 'bold')


% --- ax3 ---       --- powers ---
axes(handles.ax3)
cla reset
hax3 = gca ;
plot (time, pE,  time, cP ,'-.', time, lP,':m','LineWidth', 1.6 ); box off
l1 = ylabel ('Power [kW]');
[pMin, pMax] = bounds([pE, cP, lP]);
yLower = pMin -  (0.01 * (pMax - pMin));
yUpper = pMax +  (0.01 * (pMax - pMin));
ylim([yLower, yUpper]) 
xlim(xLimit);
l2 = xlabel ({'Time [minutes]', 'c)'});

hlP = legend ({'Demand(P_a+ P_r)', 'Capacitor bank(P_{cb})',...
    'Contact line(P_{cl})'}, 'Box', 'off');
set(hlP, 'location', 'Northoutside', 'Orientation','horizontal')
hlP.Position(2) = (hax3.Position(2) + hax3.Position(4))*1.01 ;
set([l1, l2], 'FontSize', fs, 'FontWeight', 'bold')

% --- ax4 ---       --- distance, energy, SoE ---
axes(handles.ax4)
% cla reset
hax4 = gca ;

yyaxis left
plot (time, SoE, 'LineWidth', 2, 'Color', or)
l1 = ylabel ('SoC_{sc} [%]');
[minSoE, maxSoE] = bounds(SoE);
yLower = minSoE - (0.01 * (maxSoE - minSoE));
yUpper = maxSoE + (0.01 * (maxSoE - minSoE));
ylim([yLower, yUpper]) ;
xlim(xLimit) ;

yyaxis right
hLn = plot (time, egy, time, dst, 'Color', lb); box off
set (hLn(1), 'lineStyle', ':', 'LineWidth', 2) ;
set (hLn(2), 'lineStyle', '-', 'LineWidth', 1) ;
l2 = ylabel ({'Net energy consumed [kWh]', 'Distance travelled [km]'});
l3 = xlabel ({'Time [minutes]','d)'});
[yMin, yMax] = bounds([egy, dst]);
yLower = yMin - (0.01 * (yMax - yMin));
yUpper = yMax + (0.01 * (yMax - yMin));
ylim([yLower, yUpper]) ;
xlim(xLimit) ;

hl4 = legend ({'SoC', 'Energy', 'Distance'}, 'Box', 'off');
set(hl4, 'location', 'Northoutside', 'Orientation','horizontal')
hl4.Position(2) = (hax4.Position(2) + hax4.Position(4))*1.01 ;

set([l1, l2, l3], 'FontSize', fs, 'FontWeight', 'bold')
%--------

% Choose default command line output for gui_resultsTramCapLine
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_resultsTramCapLine wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = gui_resultsTramCapLine_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;