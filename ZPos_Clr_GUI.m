function varargout = ZPos_Clr_GUI(varargin)
% ZPos_Clr_GUI MATLAB code for ZPos_Clr_GUI.fig
%      ZPos_Clr_GUI, by itself, creates a new ZPos_Clr_GUI or raises the existing
%      singleton*.
%
%      H = ZPos_Clr_GUI returns the handle to a new ZPos_Clr_GUI or the handle to
%      the existing singleton*.
%
%      ZPos_Clr_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZPos_Clr_GUI.M with the given input arguments.
%
%      ZPos_Clr_GUI('Property','Value',...) creates a new ZPos_Clr_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZPos_Clr_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZPos_Clr_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZPos_Clr_GUI

% Last Modified by GUIDE v2.5 12-Jul-2017 09:55:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZPos_Clr_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ZPos_Clr_GUI_OutputFcn, ...
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


% --- Executes just before ZPos_Clr_GUI is made visible.
function ZPos_Clr_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZPos_Clr_GUI (see VARARGIN)

set(handles.text3,'String',get(handles.slider1,'Value'));
set(handles.text4,'String',get(handles.slider2,'Value'));
set(handles.text5,'String',get(handles.slider3,'Value'));
set(handles.text11,'String',get(handles.slider5,'Value'));
set(handles.text13,'String',get(handles.slider6,'Value'));
set(handles.text15,'String',get(handles.slider7,'Value'));
set(handles.text17,'String',get(handles.slider8,'Value'));

% Choose default command line output for ZPos_Clr_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZPos_Clr_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZPos_Clr_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


sliderval = num2str(get(hObject,'Value'));
assignin('base','sliderval',sliderval);
set(handles.text3,'String',num2str(sliderval));


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


SenVert = get(handles.slider2,'Value');
MountAngle = get(handles.slider3,'Value');
GroundPresep = get(handles.slider1,'Value');
Gamma = get(handles.slider5,'Value');
ObjHeightPersep = get(handles.slider6,'Value');
ObjDistancePersep = get(handles.slider7,'Value');
ClrObjHeight = get(handles.slider8,'Value');
BHeight = 1.05 ;
BLength = 1.118 ;
WAngle = 40 ;

ZPos = linspace(0.1,2.4,461); %increment 5mm
ZPosT = transpose(ZPos);

Height = linspace(0.1,6,591);
HeightT = transpose(Height);

DistanceHi = linspace(0,300,6001); %increment 50mm
DistanceHiT = transpose(DistanceHi);

if abs(MountAngle) >= abs((SenVert)/2)
    h = msgbox('Warning: MountAngle >= SenVert , some or all outputs maybe incorrect');
end


[Ground,GroundCrit,ZPosGround, gH, gL] = GetZPosition(SenVert,MountAngle,GroundPresep,ZPosT,BHeight,BLength,WAngle);

% figure
Gndh(1:2) = plot(handles.axes1,Ground,ZPosT,'r--',GroundCrit,ZPosGround,'g','LineWidth',2');
xlim(handles.axes1,[0 Ground(end)])
ylim(handles.axes1,[0 ZPosT(end)])

grid (handles.axes1,'on')
grid (handles.axes1,'minor')
title(handles.axes1,'Sensor height vs Distance to perceive Gnd')
xlabel(handles.axes1,'Distance to perceive (m)')
ylabel(handles.axes1,'Sensor height (Z-position (m))')
legend(handles.axes1,'All',['Target criteria ' num2str(GroundPresep) 'm'],'Location','northwest')

Gndh(3) = patch([0,gH(1,1),gH(2,1), 0],[gH(1,2),gH(1,2),gH(2,2), gH(2,2)],'g','Parent',handles.axes1);
Gndh(4) = patch([0,gL(1,1),gL(2,1), 0],[gL(1,2),gL(1,2),gL(2,2), gL(2,2)],'g','Parent',handles.axes1);

alpha(Gndh(3),.5)
alpha(Gndh(4),.5)

uistack(Gndh(3),'bottom')
uistack(Gndh(4),'bottom')
uistack(Gndh(1),'top')
uistack(Gndh(2),'top')


% hold (handles.axes1,'off')

[objpersep,ObjCrit,ZPosObj,objpersepProbable,ZPosProbable,oH,oL] = GetZPositionObject(SenVert,MountAngle,Gamma,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep,ObjDistancePersep,BLength,BHeight,WAngle);

% plot(handles.axes2,objpersep,ZPosT,'r--',ObjCrit,ZPosObj,'g','LineWidth',2')
% xlim(handles.axes2,[0 objpersep(end)])
% ylim(handles.axes2,[0 ZPosT(end)])
% 
% ZPosObjA = ZPosObj;
% ZPosObjA(isnan(ZPosObj)) = 0;
% if norm(ZPosObjA) > 0
%     hold (handles.axes2,'on')
%     h = area(handles.axes2,ObjCrit,ZPosObj, max(ZPosObj));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (handles.axes2,'on')
% grid (handles.axes2,'minor')
% title(handles.axes2,'Sensor height vs Distance to perceive Obj')
% xlabel(handles.axes2,'Distance to perceive (m)')
% ylabel(handles.axes2,'Max sensor height (Z-position (m))')
% % legend(handles.axes2,'All','Target criteria (30cm @ 1.3m)','Location','northwest')
% legend(handles.axes2,'All',['Target criteria ' num2str(ObjHeightPersep) 'm' ' @' num2str(ObjDistancePersep) 'm'],'Location','northwest')
% hold (handles.axes2,'off')

Objh(1:2) = plot(handles.axes2,objpersep,ZPosT,'r--',ObjCrit,ZPosObj,'g','LineWidth',2');
xlim(handles.axes2,[0 objpersep(end)])
ylim(handles.axes2,[0 ZPosT(end)])

grid (handles.axes2,'on')
grid (handles.axes2,'minor')
title(handles.axes2,'Sensor height vs Distance to perceive Obj')
xlabel(handles.axes2,'Distance to perceive (m)')
ylabel(handles.axes2,'Max sensor height (Z-position (m))')
legend(handles.axes2,'All',['Target criteria ' num2str(ObjHeightPersep) 'm' ' @' num2str(ObjDistancePersep) 'm'],'Location','northwest')

Objh(3) = patch([0,oH(1,1),oH(2,1), 0],[oH(1,2),oH(1,2),oH(2,2), oH(2,2)],'g','Parent',handles.axes2);
Objh(4) = patch([0,oL(1,1),oL(2,1), 0],[oL(1,2),oL(1,2),oL(2,2), oL(2,2)],'g','Parent',handles.axes2);

alpha(Objh(3),.5)
alpha(Objh(4),.5)

uistack(Objh(3),'bottom')
uistack(Objh(4),'bottom')
uistack(Objh(1),'top')
uistack(Objh(2),'top')

% plot(handles.axes3,objpersep,ZPosT,'r--',objpersepProbable,ZPosProbable,'g','LineWidth',2')
% xlim(handles.axes3,[0 objpersep(end)])
% ylim(handles.axes3,[0 ZPosT(end)])
% 
% ZPosProbableA = ZPosProbable;
% ZPosProbableA(isnan(ZPosProbable)) = 0;
% if norm(ZPosProbableA) > 0
%     hold (handles.axes3,'on')
%     h = area(handles.axes3,objpersepProbable,ZPosProbable, max(ZPosProbable));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (handles.axes3,'on')
% grid (handles.axes3,'minor')
% title(handles.axes3,'Sensor height vs Distance to perceive Gnd & Obj')
% xlabel(handles.axes3,'Distance to perceive (m)')
% ylabel(handles.axes3,'Max sensor height (Z-position (m))')
% legend(handles.axes3,'All',['Target criteria ' num2str(ObjHeightPersep) 'm' ' @' num2str(ObjDistancePersep) 'm'],'Location','northwest')
% hold (handles.axes3,'off')


[swT,Clri] = GetZPositionClearance(SenVert,MountAngle,Gamma,DistanceHi,ClrObjHeight);

DistanceHiT(isnan(swT)) = NaN;

% plot(handles.axes4,DistanceHiT,swT,'LineWidth',2')

% swTA = swT;
% swTA(isnan(swT)) = 0;
% if norm(swTA) > 0
%     hold (handles.axes4,'on')
%     h = area(handles.axes4,DistanceHiT,swT,max(swT));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
% grid (handles.axes4,'on')
% grid (handles.axes4,'minor')
% title(handles.axes4,['Sensor height vs suspended object ' num2str(ClrObjHeight) 'm high'])
% xlabel(handles.axes4,'Min Distance to perceive (m)')
% ylabel(handles.axes4,'Sensor height (Z-position (m))')
% hold (handles.axes4,'off')

Clrh(1) = plot(handles.axes4,DistanceHiT,swT,'LineWidth',2');
xlim(handles.axes4,[0 max(DistanceHiT)])
ylim(handles.axes4,[0 max(swT)])

% swTA = swT;
% swTA(isnan(swT)) = 0;
% if norm(swTA) > 0
%     hold on
%     h = area(DistanceHiT,swT,max(swT));
%     h(1).FaceColor = [0 0.9 0];
%     alpha(.5)
% end
grid (handles.axes4,'on')
grid (handles.axes4,'minor')
title(handles.axes4,['Sensor height vs suspended object ' num2str(ClrObjHeight) 'm high'])
xlabel(handles.axes4,'Min Distance to perceive (m)')
ylabel(handles.axes4,'Sensor height (Z-position (m))')

Clrh(2) = patch([max(DistanceHiT),Clri(1,1),Clri(2,1), max(DistanceHiT)],[Clri(1,2),Clri(1,2),Clri(2,2), Clri(2,2)],'g','Parent',handles.axes4);
alpha(Clrh(2),.5)

uistack(Clrh(1),'top')

% clear (SenVert,MountAngle,GroundPresep,ZPosT,HeightT,Ground,ZPosGround,ObjHeightPersep,ObjDistancePersep)
% clear (Ground,GroundCrit,ZPosGround,objpersep,ObjCrit,ZPosObj,objpersepProbable,ZPosProbable)

% [drag, momentum, vanderwaals, total] = get_aero_vs_momentum(Velocity, SnowSize, Seperation, Material,Ls);

% plot(handles.axes1,Ls,drag,'b--',Ls,momentum,'g--',Ls,total,'m',Ls,vanderwaals,'r','LineWidth',2')
% 
% grid (handles.axes1,'on')
% title(handles.axes1,'Adhesive vs Removal Force')
% xlabel(handles.axes1,'Particle diameter(m)')
% ylabel(handles.axes1,'Force (N)')
% legend(handles.axes1,'Aero drag','Momentum','Total removal force','Van der Waals')
% 
% Qs = linspace( 1*10^-6,10*10^-6,i);
% [drag, momentum, vanderwaals, total] = get_aero_vs_momentum(Velocity, SnowSize, Seperation, Material,Qs);
% 
% plot(handles.axes2,Qs,drag,'b--',Qs,momentum,'g--',Qs,total,'m',Qs,vanderwaals,'r','LineWidth',2')
% 
% grid (handles.axes2,'on')
% title(handles.axes2,'Adhesive vs Removal Force(1-10um)')
% xlabel(handles.axes2,'Particle diameter(m)')
% ylabel(handles.axes2,'Force (N)')
% legend(handles.axes2,'Aero drag','Momentum','Total removal force','Van der Waals')


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderval2 = num2str(get(hObject,'Value'));
assignin('base','sliderva2l',sliderval2);
set(handles.text4,'String',num2str(sliderval2));


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderval3 = num2str(get(hObject,'Value'));
assignin('base','sliderval3',sliderval3);
set(handles.text5,'String',num2str(sliderval3));


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderval5 = num2str(get(hObject,'Value'));
assignin('base','sliderval5',sliderval5);
set(handles.text11,'String',num2str(sliderval5));

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderval6 = num2str(get(hObject,'Value'));
assignin('base','sliderval6',sliderval6);
set(handles.text13,'String',num2str(sliderval6));

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderval7 = num2str(get(hObject,'Value'));
assignin('base','sliderval7',sliderval7);
set(handles.text15,'String',num2str(sliderval7));

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderval8 = num2str(get(hObject,'Value'));
assignin('base','sliderval8',sliderval8);
set(handles.text17,'String',num2str(sliderval8));

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
