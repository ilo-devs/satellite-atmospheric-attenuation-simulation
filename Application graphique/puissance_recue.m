function varargout = puissance_recue(varargin)
% PUISSANCE_RECUE MATLAB code for puissance_recue.fig
%      PUISSANCE_RECUE, by itself, creates a new PUISSANCE_RECUE or raises the existing
%      singleton*.
%
%      H = PUISSANCE_RECUE returns the handle to a new PUISSANCE_RECUE or the handle to
%      the existing singleton*.
%
%      PUISSANCE_RECUE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUISSANCE_RECUE.M with the given input arguments.
%
%      PUISSANCE_RECUE('Property','Value',...) creates a new PUISSANCE_RECUE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before puissance_recue_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to puissance_recue_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help puissance_recue

% Last Modified by GUIDE v2.5 04-May-2016 19:20:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @puissance_recue_OpeningFcn, ...
                   'gui_OutputFcn',  @puissance_recue_OutputFcn, ...
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


% --- Executes just before puissance_recue is made visible.
function puissance_recue_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to puissance_recue (see VARARGIN)

% Choose default command line output for puissance_recue
handles.output = hObject;

%Faire en sorte que la premiére radio button soit séléctionner
set(handles.attenuationGroup,'SelectedObject',handles.attenuationGaz);

handles.currentSelection=get(handles.attenuationGaz,'Tag');
set(gcf,'CurrentAxes',handles.axes1);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes puissance_recue wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = puissance_recue_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in retourBoutton.
function retourBoutton_Callback(hObject, eventdata, handles)
% hObject    handle to retourBoutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %Retour à la page d'acceuil
% close;
% Page_acceuil;




% --- Executes on button press in tracerBoutton.
function tracerBoutton_Callback(hObject, eventdata, handles)
% hObject    handle to tracerBoutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentSelection=get(get(handles.attenuationGroup,'SelectedObject'),'Tag');
handles.altitude=str2num(get(handles.valuesAltitude,'String'));
handles.lat=str2num(get(handles.valuesLatitude,'String'));
handles.lon=str2num(get(handles.valuesLongitude,'String'));


if strcmp(handles.currentSelection,'attenuationGaz')
    cla;
    leg={};
    rho=str2num(get(handles.valuesVapeurEau,'String'))
    if get(handles.bandeL,'Value')==1
        att=mainGaz(rho,1.6,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
        leg=[leg 'bande L'];
        hold on

    end
    if get(handles.bandeS,'Value')==1
        att=mainGaz(rho,2.6,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
         leg=[leg 'bande S'];
        hold on

    end
    if get(handles.bandeC,'Value')==1
        att=mainGaz(rho,6,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
        leg=[leg 'bande C'];
        hold on 

    end
    if get(handles.bandeX,'Value')==1
        att=mainGaz(rho,8,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
        leg=[leg 'bande X'];
        hold on 

    end
    if get(handles.bandeKu,'Value')==1
        att=mainGaz(rho,14,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
        leg=[leg 'bande Ku'];
        hold on

    end
    if get(handles.bandeKa,'Value')==1
        att=mainGaz(rho,30,handles.altitude,handles.lat,handles.lon);
        plot(rho,att,'LineWidth',2);
        leg=[leg 'bande Ka'];
        hold on
    end
    xlabel('Concentration en vapeur d''eau [g/m3]');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction du concentration en vapeur d''eau');
    grid on
    legend(leg)
    hold off
elseif strcmp(handles.currentSelection,'attenuationNuage')
    cla;
    leg={};
    liquide=str2num(get(handles.ValuesEauliquide,'String'))
    if get(handles.bandeL,'Value')==1
        att=mainNuage(liquide,1.6,handles.altitude,handles.lat,handles.lon);
        plot(liquide,att,'LineWidth',2);
        leg=[leg 'bande L'];
        hold on

    end
    if get(handles.bandeS,'Value')==1
        att=mainNuage(liquide,2.6,handles.altitude,handles.lat,handles.lon)
        plot(liquide,att,'LineWidth',2);
         leg=[leg 'bande S'];
        hold on

    end
    if get(handles.bandeC,'Value')==1
        att=mainNuage(liquide,6,handles.altitude,handles.lat,handles.lon);
        plot(liquide,att,'LineWidth',2);
        leg=[leg 'bande C'];
        hold on 

    end
    if get(handles.bandeX,'Value')==1
        att=mainNuage(liquide,8,handles.altitude,handles.lat,handles.lon);
        plot(liquide,att,'LineWidth',2);
        leg=[leg 'bande X'];
        hold on 

    end
    if get(handles.bandeKu,'Value')==1
        att=mainNuage(liquide,14,handles.altitude,handles.lat,handles.lon);
        plot(liquide,att,'LineWidth',2);
        leg=[leg 'bande Ku'];
        hold on

    end
    if get(handles.bandeKa,'Value')==1
        att=mainNuage(liquide,30,handles.altitude,handles.lat,handles.lon);
        plot(liquide,att,'LineWidth',2);
        leg=[leg 'bande Ka'];
        hold on
    end
    xlabel('Contenue en eau liquide [kg/m2]');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction du contenue intégrée en eau liquide');
    grid on
    legend(leg)
    hold off    
   
elseif strcmp(handles.currentSelection,'attenuationScint')
    cla;
    leg={};
    refract=str2num(get(handles.Valuesrefraction,'String'))
    if get(handles.bandeL,'Value')==1
        att=mainScintillation(refract,1.6,handles.altitude);
        plot(refract,att,'LineWidth',2);
        leg=[leg 'bande L'];
        hold on

    end
    if get(handles.bandeS,'Value')==1
        att=mainScintillation(refract,2.6,handles.altitude)
        plot(refract,att,'LineWidth',2);
         leg=[leg 'bande S'];
        hold on

    end
    if get(handles.bandeC,'Value')==1
        att=mainScintillation(refract,6,handles.altitude);
        plot(refract,att,'LineWidth',2);
        leg=[leg 'bande C'];
        hold on 

    end
    if get(handles.bandeX,'Value')==1
        att=mainScintillation(refract,8,handles.altitude);
        plot(refract,att,'LineWidth',2);
        leg=[leg 'bande X'];
        hold on 

    end
    if get(handles.bandeKu,'Value')==1
        att=mainScintillation(refract,14,handles.altitude);
        plot(refract,att,'LineWidth',2);
        leg=[leg 'bande Ku'];
        hold on

    end
    if get(handles.bandeKa,'Value')==1
        att=mainScintillation(refract,30,handles.altitude);
        plot(refract,att,'LineWidth',2);
        leg=[leg 'bande Ka'];
        hold on
    end
    xlabel('Terme Humide du coinicide de réfraction');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction de Nhum');
    grid on
    legend(leg) 
    hold off        
       
elseif strcmp(handles.currentSelection,'attenuationPluie')
    cla;
    leg={};
    precipitation=str2num(get(handles.Valuesprecipitation,'String'))
    if get(handles.bandeL,'Value')==1
        att=mainPluie(precipitation,1.6,handles.altitude,handles.lat,handles.lon);
        plot(precipitation,att,'LineWidth',2);
        leg=[leg 'bande L'];
        hold on

    end
    if get(handles.bandeS,'Value')==1
        att=mainPluie(precipitation,2.6,handles.altitude,handles.lat,handles.lon)
        plot(precipitation,att,'LineWidth',2);
         leg=[leg 'bande S'];
        hold on

    end
    if get(handles.bandeC,'Value')==1
        att=mainPluie(precipitation,6,handles.altitude,handles.lat,handles.lon);
        plot(precipitation,att,'LineWidth',2);
        leg=[leg 'bande C'];
        hold on 

    end
    if get(handles.bandeX,'Value')==1
        att=mainPluie(precipitation,8,handles.altitude,handles.lat,handles.lon);
        plot(precipitation,att,'LineWidth',2);
        leg=[leg 'bande X'];
        hold on 

    end
    if get(handles.bandeKu,'Value')==1
        att=mainPluie(precipitation,14,handles.altitude,handles.lat,handles.lon);
        plot(precipitation,att,'LineWidth',2);
        leg=[leg 'bande Ku'];
        hold on

    end
    if get(handles.bandeKa,'Value')==1
        att=mainPluie(precipitation,30,handles.altitude,handles.lat,handles.lon);
        plot(precipitation,att,'LineWidth',2);
        leg=[leg 'bande Ka'];
        hold on
    end
    xlabel('Taux de precipitation [mm/h]');
    ylabel('Puissance recue par le recepteur [dBm]');
    title('Puissance recue en fonction taux de precipitation');
    grid on
    legend(leg)     
    hold off
end



% --- Executes on button press in bandeC.
function bandeC_Callback(hObject, eventdata, handles)
% hObject    handle to bandeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeC


% --- Executes on button press in bandeKu.
function bandeKu_Callback(hObject, eventdata, handles)
% hObject    handle to bandeKu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeKu


% --- Executes on button press in bandeKa.
function bandeKa_Callback(hObject, eventdata, handles)
% hObject    handle to bandeKa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeKa


% --- Executes on button press in bandeS.
function bandeS_Callback(hObject, eventdata, handles)
% hObject    handle to bandeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeS


% --- Executes on button press in bandeL.
function bandeL_Callback(hObject, eventdata, handles)
% hObject    handle to bandeL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeL


% --- Executes on button press in bandeX.
function bandeX_Callback(hObject, eventdata, handles)
% hObject    handle to bandeX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bandeX



function valuesVapeurEauEau_Callback(hObject, eventdata, handles)
% hObject    handle to valuesVapeurEauEau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valuesVapeurEauEau as text
%        str2double(get(hObject,'String')) returns contents of valuesVapeurEauEau as a double


% --- Executes during object creation, after setting all properties.
function valuesVapeurEauEau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valuesVapeurEauEau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function valuesVapeurEau_Callback(hObject, eventdata, handles)
% hObject    handle to ValuesEauliquide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ValuesEauliquide as text
%        str2double(get(hObject,'String')) returns contents of ValuesEauliquide as a double


% --- Executes during object creation, after setting all properties.
function valuesVapeurEau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ValuesEauliquide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ValuesEauliquide_Callback(hObject, eventdata, handles)
% hObject    handle to ValuesEauliquide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ValuesEauliquide as text
%        str2double(get(hObject,'String')) returns contents of ValuesEauliquide as a double


% --- Executes during object creation, after setting all properties.
function ValuesEauliquide_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ValuesEauliquide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function Valuesrefraction_Callback(hObject, eventdata, handles)
% hObject    handle to Valuesrefraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Valuesrefraction as text
%        str2double(get(hObject,'String')) returns contents of Valuesrefraction as a double


% --- Executes during object creation, after setting all properties.
function Valuesrefraction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Valuesrefraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Valuesprecipitation_Callback(hObject, eventdata, handles)
% hObject    handle to Valuesprecipitation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Valuesprecipitation as text
%        str2double(get(hObject,'String')) returns contents of Valuesprecipitation as a double


% --- Executes during object creation, after setting all properties.
function Valuesprecipitation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Valuesprecipitation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valuesLongitude_Callback(hObject, eventdata, handles)
% hObject    handle to valuesLongitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valuesLongitude as text
%        str2double(get(hObject,'String')) returns contents of valuesLongitude as a double


% --- Executes during object creation, after setting all properties.
function valuesLongitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valuesLongitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function valuesLatitude_Callback(hObject, eventdata, handles)
% hObject    handle to valuesLatitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valuesLatitude as text
%        str2double(get(hObject,'String')) returns contents of valuesLatitude as a double


% --- Executes during object creation, after setting all properties.
function valuesLatitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valuesLatitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in attenuationGaz.
function attenuationGaz_Callback(hObject, eventdata, handles)
% hObject    handle to attenuationGaz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of attenuationGaz
set(handles.textVapeur,'Enable','on');
set(handles.valuesVapeurEau,'Enable','on');
%On desactive les autres
set(handles.textLiquide,'Enable','inactive');
set(handles.ValuesEauliquide,'Enable','inactive');
set(handles.textRefraction,'Enable','inactive');
set(handles.Valuesrefraction,'Enable','inactive');
set(handles.texPrecipitation,'Enable','inactive');
set(handles.Valuesprecipitation,'Enable','inactive');


% --- Executes on button press in attenuationNuage.
function attenuationNuage_Callback(hObject, eventdata, handles)
% hObject    handle to attenuationNuage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of attenuationNuage
set(handles.textVapeur,'Enable','inactive');
set(handles.valuesVapeurEau,'Enable','inactive');
set(handles.textLiquide,'Enable','on');
set(handles.ValuesEauliquide,'Enable','on');
set(handles.textRefraction,'Enable','inactive');
set(handles.Valuesrefraction,'Enable','inactive');
set(handles.texPrecipitation,'Enable','inactive');
set(handles.Valuesprecipitation,'Enable','inactive');


% --- Executes on button press in attenuationScint.
function attenuationScint_Callback(hObject, eventdata, handles)
% hObject    handle to attenuationScint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of attenuationScint
set(handles.textVapeur,'Enable','inactive');
set(handles.valuesVapeurEau,'Enable','inactive');
set(handles.textLiquide,'Enable','inactive');
set(handles.ValuesEauliquide,'Enable','inactive');
set(handles.textRefraction,'Enable','on');
set(handles.Valuesrefraction,'Enable','on');
set(handles.texPrecipitation,'Enable','inactive');
set(handles.Valuesprecipitation,'Enable','inactive');


% --- Executes on button press in attenuationPluie.
function attenuationPluie_Callback(hObject, eventdata, handles)
% hObject    handle to attenuationPluie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of attenuationPluie
set(handles.textVapeur,'Enable','inactive');
set(handles.valuesVapeurEau,'Enable','inactive');
set(handles.textLiquide,'Enable','inactive');
set(handles.ValuesEauliquide,'Enable','inactive');
set(handles.textRefraction,'Enable','inactive');
set(handles.Valuesrefraction,'Enable','inactive');
set(handles.texPrecipitation,'Enable','on');
set(handles.Valuesprecipitation,'Enable','on');



function valuesAltitude_Callback(hObject, eventdata, handles)
% hObject    handle to valuesAltitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valuesAltitude as text
%        str2double(get(hObject,'String')) returns contents of valuesAltitude as a double


% --- Executes during object creation, after setting all properties.
function valuesAltitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valuesAltitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
