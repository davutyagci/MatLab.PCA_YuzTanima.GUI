function varargout = yuztanima(varargin)
% YUZTANIMA MATLAB code for yuztanima.fig
%      YUZTANIMA, by itself, creates a new YUZTANIMA or raises the existing
%      singleton*.
%
%      H = YUZTANIMA returns the handle to a new YUZTANIMA or the handle to
%      the existing singleton*.
%
%      YUZTANIMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YUZTANIMA.M with the given input arguments.
%
%      YUZTANIMA('Property','Value',...) creates a new YUZTANIMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before yuztanima_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to yuztanima_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help yuztanima

% Last Modified by GUIDE v2.5 30-Oct-2017 12:09:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @yuztanima_OpeningFcn, ...
                   'gui_OutputFcn',  @yuztanima_OutputFcn, ...
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

% --- Executes just before yuztanima is made visible.
function yuztanima_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to yuztanima (see VARARGIN)

% Choose default command line output for yuztanima
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes yuztanima wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = yuztanima_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in BtnOpenImage.
function BtnOpenImage_Callback(hObject, eventdata, handles)
% hObject    handle to BtnOpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.DosyaAdi, handles.DosyaYolu] = uigetfile({'*.jpg','jpeg image(*.jpg)'; 
    '*.png','png image(*.png)'; '*.*','All'},'Resim Seç');
if ~isequal(handles.DosyaAdi,0)
    handles.TestImage = fullfile(handles.DosyaYolu,handles.DosyaAdi);
    handles.resim = imread(handles.TestImage);
    guidata(hObject,handles);
    axes(handles.axes1);
    cla reset
    imshow(handles.resim);
    
    handles.TestDatabasePath = handles.DosyaYolu;
  
    set(handles.testresim,'String','Test Resmi'); 
else
    return
end

% --- Executes on button press in BtnSaveImage.
function BtnSaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to BtnSaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

resimkayit = getframe(handles.axes1);
[DosyaAdiKayit, DosyaYoluKayit] = uiputfile({'*.jpg','jpeg image(*.jpg)'; 
    '*.png','png image(*.png)'; '*.*','All'},'Resmi Kaydet');
DosyaTamYoluKayit = fullfile(DosyaYoluKayit,DosyaAdiKayit);
if ~isequal(DosyaAdiKayit,0);
    imwrite(resimkayit.cdata,DosyaTamYoluKayit);
else
    return
end

% --- Executes on button press in BtnFaceRecognition.
function BtnFaceRecognition_Callback(hObject, eventdata, handles)
% hObject    handle to BtnFaceRecognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Yüzü bulma nesnesi
YuzBul = vision.CascadeObjectDetector;
%Bulunan yüzlerin koordinat deðerlerini matris olarak alýyoruz.
YuzKutu = step(YuzBul,handles.resim);

axes(handles.axes1);
imshow(handles.resim);

hold on
for i = 1:size(YuzKutu,1)
    rectangle('Position',YuzKutu(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','y'); 
end
hold off;

handles.TestDatabasePath = uigetdir('', 'Veritananýný Seçiniz.' );

T = CreateDatabase(handles.TestDatabasePath);
[m, A, Eigenfaces] = EigenfaceCore(T);
OutputName = Recognition(handles.TestImage, m, A, Eigenfaces);

SelectedImage = strcat(handles.TestDatabasePath,'\',OutputName);
SelectedImage = imread(SelectedImage);

guidata(hObject,handles);
axes(handles.axes2);
cla reset
imshow(SelectedImage);
set(handles.eslesenresim,'String','Eþleþen Resim');

str = strcat('Eþleþen Resim : ',OutputName);
disp(str)



    
