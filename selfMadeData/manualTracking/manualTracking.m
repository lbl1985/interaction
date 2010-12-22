function varargout = manualTracking(varargin)
% MANUALTRACKING M-file for manualTracking.fig
%      MANUALTRACKING, by itself, creates a new MANUALTRACKING or raises the existing
%      singleton*.
%
%      H = MANUALTRACKING returns the handle to a new MANUALTRACKING or the handle to
%      the existing singleton*.
%
%      MANUALTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALTRACKING.M with the given input arguments.
%
%      MANUALTRACKING('Property','Value',...) creates a new MANUALTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualTracking

% Last Modified by GUIDE v2.5 21-Sep-2010 09:45:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @manualTracking_OutputFcn, ...
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


% --- Executes just before manualTracking is made visible.
function manualTracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualTracking (see VARARGIN)

% Choose default command line output for manualTracking
handles.output = hObject;
handles.nclusters = 5;
handles.isSKIP = 0;
setappdata(hObject, 'isSKIP', 1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manualTracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manualTracking_OutputFcn(hObject, eventdata, handles) 
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
pos = get(hObject, 'Value');
% pos = floor(num2str(pos));
figure(2);  imshow(handles.I(:, :, pos));
title(['Reference Frame ' num2str(pos)]);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.Frame = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Type_Callback(hObject, eventdata, handles)
% hObject    handle to Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Type as text
%        str2double(get(hObject,'String')) returns contents of Type as a double
handles.Type = str2double(get(hObject, 'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Clip_Callback(hObject, eventdata, handles)
% hObject    handle to Clip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Clip as text
%        str2double(get(hObject,'String')) returns contents of Clip as a double
handles.Clip = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Clip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Clip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LOAD.
function LOAD_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[srcdirI filenamesI] = rfdatabase(datadir_interaction(handles.Type),[], '.wmv');
filename = [srcdirI filenamesI{1}];
I = movie2var(filename, 1, .25);

handles.I = I(:, :, 40:45); 
handles.clipname = filename(1:end - 4);
handles.cliptype = filename(1:end - 6);

handles.nframe = size(handles.I, 3);
handles.siz = [size(handles.I, 1) size(handles.I, 2)];
handles.FeaturePos = zeros(handles.nclusters, 2, handles.nframe);
c{1} = struct('Area', 1, 'MaxIntensity', 1, 'MaxIntensityPos', [], 'posAfter', [], 'LinkAfter', [], 'posBefore', [], 'LinkBefore', []);
handles.R_RegionPointCorr = repmat(c, [handles.nframe 1]);
handles.savePath = ['C:\Users\XPS\Documents\MATLAB\work\interaction\manualTracking\TrackingResult\' handles.cliptype '\'];
handles.saveNAME = [handles.clipname '_manualTracking'];

set(handles.slider1, 'Max', uint8(handles.nframe));
set(handles.slider1, 'Min', 1);
set(handles.slider1, 'Value', 1);
set(handles.slider1, 'SliderStep', 1/(handles.nframe -1) * ones(1, 2));

handles.Frame = 1;
handles.j = 1;

set(handles.edit1, 'String', num2str(handles.Frame));
handles.fig = figure(1);
for i = 1 : 20
    figure(handles.fig);
    imshow(handles.I(:, :, i));
    pause(1/11);
end
imshow(I(:, :, handles.Frame));
% [xt yt] = ginput(1);

guidata(hObject, handles);



% --- Executes on button press in SAVE.
function SAVE_Callback(hObject, eventdata, handles)
% hObject    handle to SAVE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FeaturesPos = handles.FeaturesPos;
R_RegionPointCorr = handles.R_RegionPointCorr;
saveWholeName = [handles.savePath handles.saveNAME];
save(saveWholeName, 'FeaturesPos', 'R_RegionPointCorr');
clear FeaturesPos R_RegionPointCorr;
display(['Finish Saving']);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in START.
function START_Callback(hObject, eventdata, handles)
% hObject    handle to START (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
while (handles.Frame <= handles.nframe)    
    set(handles.edit1, 'String', num2str(handles.Frame));    
    figure(handles.fig); imshow(handles.I(:, :, handles.Frame));  
    set(handles.slider1, 'Value', handles.Frame);
    
    while(handles.j <= handles.nclusters) 
%         isSKIP = getappdata(handles.SKIP, 'isSKIP');

        set(handles.edit4, 'String', num2str(handles.j));
        if handles.j <= handles.nclusters
%             w = waitforbuttonpress;
%             isSKIP = guidata(handles.isSKIP);
            [x y] = ginput(1);
            
            if x < 1 || y < 1 || y > handles.siz(1) || x > handles.siz(2)
                x = []; y = [];
                handles.FeaturesPos(handles.j,:, handles.Frame) = [0 0];
            else
                handles.FeaturesPos(handles.j,:, handles.Frame) = [x y];                
            end
            
            handles.R_RegionPointCorr{handles.Frame}(handles.j).MaxIntensityPos = [x y];
            if handles.Frame ~= 1            
                handles.R_RegionPointCorr{handles.Frame - 1}(handles.j).posAfter = [x y];
                handles.R_RegionPointCorr{handles.Frame - 1}(handles.j).LinkBefore = handles.j;
            end
            if handles.Frame ~= handles.nframe
                handles.R_RegionPointCorr{handles.Frame + 1}(handles.j).posBefore = [x y];
                handles.R_RegionPointCorr{handles.Frame + 1}(handles.j).LinkBefore = handles.j;
            end
        end
        tFeaturesPos = handles.FeaturesPos(:, :, handles.Frame);
%         tR_RegionPointCorr = handles.R_RegionPointCorr{handles.Frame}(handles.j);
        set(handles.uitable1, 'Data', tFeaturesPos);
%         set(handles.uitable2, 'Data', tR_RegionPointCorr);
        handles.j = handles.j + 1;
    end
    handles.Frame = handles.Frame + 1;
    handles.j = 1;
    guidata(hObject, handles);
end
guidata(hObject, handles);
