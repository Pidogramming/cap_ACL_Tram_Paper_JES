function varargout = guiCapBankSimData(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiCapBankSimData_OpeningFcn, ...
                   'gui_OutputFcn',  @guiCapBankSimData_OutputFcn, ...
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


% --- Executes just before guiCapBankSimData is made visible.
function guiCapBankSimData_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiCapBankSimData (see VARARGIN)

fontName = 'Times New Roman'; 
fontSize = 10 ;               
%--------- Inputs ---------------
cb = varargin{1};
cm = varargin{2};

%--------- Main Figure ------------
% set(handles.mainFigure, 'menubar', 'figure')

%------- Supercap Image -----------
axes(handles.Image)
imshow(cb.image);
title(cb.name,...
    'FontName',fontName, 'fontSize', fontSize, 'interpreter', 'none')


%------- nModules & nPS(Parallel strings) ----------
set(handles.nModules, 'String',...
    [num2str(cb.numModules),'  Total modules']);
set(handles.nPS, 'String', ...
    [num2str(cb.numParallelStrings),'  Parallel strings']);
set(handles.nSeries, 'String',...
    [num2str(cb.numModulesSeries),'  Modules in seiries'])

%-  -   -   Table 1 Data -  -   -  7 Rows x 3 Columns
dataTable1 = {
    'Voltage full charge  [V]', ...
    sprintf('%.0f', cm.voltageFullCharge), ...
    sprintf('%.0f', cb.voltageFullCharge);...       % Row 1 End
    'Capacitance  [F]', ...
    sprintf('%.4g', cm.capacitance),...
    sprintf('%.4g', cb.capacitance);...             % Row 2 End
    'Energy full charge  [kWh]',....
    sprintf('%.2f', cm.energyFullCharge/1e3),...
    sprintf('%.2f', cb.energyFullCharge/1e3);...    % Row 3 End
    sprintf('ESR  [m\x2126]'),...
    sprintf('%.0f', cm.ESR * 1e3),...
    sprintf('%.0f', cb.ESR * 1e3);...               % Row 4 End
    'Current max continous  [A]',...
    sprintf('%.0f', cm.currentMax),...
    sprintf('%.0f', cb.currentMax);...
    'Voltage max series  [V]', ...
    sprintf('%.0f', cm.voltageMaxSeries),...
    sprintf('%.0f', cm.voltageMaxSeries);...
    'Mass  [kg]',...
    sprintf('%.0f', cm.mass),...
    sprintf('%.0f', cb.mass);...
   };
set(handles.Table1, 'Data', dataTable1)

%---------- Table 2 Data ----------------
if not(isempty(cb.soe))
dataTable2 = {
    'State of Charge  [%]',...
    sprintf('%.3g', cm.soeArray(1) * 100),...
    sprintf('%.3g', cb.soeArray(1) * 100);...
    'Voltage  [V]', ...
    sprintf('%.0f', cm.voltageArray(1)),...
    sprintf('%.0f', cb.voltageArray(1));...
    'Energy stored  [kWh]',...
    sprintf('%.2f', cm.soeArray(1) * cm.energyFullCharge /1e3),...
    sprintf('%.2f', cb.soeArray(1) * cb.energyFullCharge /1e3);...
    };

else
    dataTable2 = {
        'State of Charge  [%]', 'NaN', 'NaN';...
        'Voltage  [V]', 'NaN', 'NaN';...
        'Energy stored  [kWh]', 'NaN', 'NaN';...
        };
end

set(handles.Table2, 'Data', dataTable2)

% Choose default command line output for guiCapBankSimData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiCapBankSimData wait for user response (see UIRESUME)
% uiwait(handles.mainFigure);


% --- Outputs from this function are returned to the command line.
function varargout = guiCapBankSimData_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
