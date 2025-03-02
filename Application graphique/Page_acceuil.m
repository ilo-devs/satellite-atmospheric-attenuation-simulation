function varargout = Page_acceuil(varargin)
% PAGE_ACCEUIL MATLAB code for Page_acceuil.fig
%      PAGE_ACCEUIL, by itself, creates a new PAGE_ACCEUIL or raises the existing
%      singleton*.
%
%      H = PAGE_ACCEUIL returns the handle to a new PAGE_ACCEUIL or the handle to
%      the existing singleton*.
%
%      PAGE_ACCEUIL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PAGE_ACCEUIL.M with the given input arguments.
%
%      PAGE_ACCEUIL('Property','Value',...) creates a new PAGE_ACCEUIL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Page_acceuil_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Page_acceuil_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Page_acceuil

% Last Modified by GUIDE v2.5 28-Mar-2017 02:28:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Page_acceuil_OpeningFcn, ...
                   'gui_OutputFcn',  @Page_acceuil_OutputFcn, ...
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


% --- Executes just before Page_acceuil is made visible.
function Page_acceuil_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Page_acceuil (see VARARGIN)

% Choose default command line output for Page_acceuil
handles.output = hObject;
set(gcf,'CurrentAxes',handles.axes1);
imshow(imread('UV.png'));
set(gcf,'CurrentAxes',handles.axes2);
imshow(imread('poly.jpg'));

%Fait en sorte que la premiére radio button soit séléctionner
set(handles.radiopanel,'SelectedObject',handles.bilan);

handles.currentSelection=get(handles.bilan,'Tag');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Page_acceuil wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Page_acceuil_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in lancement_button.
function lancement_button_Callback(hObject, eventdata, handles)
% hObject    handle to lancement_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentSelection=get(get(handles.radiopanel,'SelectedObject'),'Tag');

if strcmp(handles.currentSelection,'bilan')
    puissance_recue;
elseif strcmp(handles.currentSelection,'hypsogramme')
    trace_hypsogramme;
elseif strcmp(handles.currentSelection,'sensibilite')
    sensibilit;
end

% Update handles structure
guidata(hObject, handles);
