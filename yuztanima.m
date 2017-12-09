function varargout = yuztanima(varargin)

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

function yuztanima_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = yuztanima_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function BtnOpenImage_Callback(hObject, eventdata, handles)

[handles.SecilenResimAdi, handles.SecilenResimYolu] = uigetfile({'*.jpg','jpeg image(*.jpg)'; 
    '*.png','png image(*.png)'; '*.*','All'},'Resim Seç');
if ~isequal(handles.SecilenResimAdi,0)
    handles.SecilenResim = fullfile(handles.SecilenResimYolu,handles.SecilenResimAdi);
    handles.ResimOku = imread(handles.SecilenResim);
    guidata(hObject,handles);
    axes(handles.axes1);
    cla reset
    imshow(handles.ResimOku);
    
    handles.ResimVeritabaniYolu = handles.SecilenResimYolu;
  
    set(handles.secilenresimbaslik,'String','Seçilen Resim'); 
else
    return
end

function BtnFaceRecognition_Callback(hObject, eventdata, handles)

%Yüzü bulma nesnesi
YuzBul = vision.CascadeObjectDetector;
%Bulunan yüzlerin koordinat deðerlerini matris olarak alýyoruz.
YuzKutu = step(YuzBul,handles.ResimOku);

axes(handles.axes1);
imshow(handles.ResimOku);

hold on
for i = 1:size(YuzKutu,1)
    rectangle('Position',YuzKutu(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','y'); 
end
hold off;

handles.ResimVeritabaniYolu = uigetdir('', 'Veritananýný Seçiniz.' );

T = VeritabaniOlustur(handles.ResimVeritabaniYolu);
[m, A, Eigenfaces] = EigenfaceCore(T);
OutputName = Recognition(handles.SecilenResim, m, A, Eigenfaces);

SelectedImage = strcat(handles.ResimVeritabaniYolu,'\',OutputName);
SelectedImage = imread(SelectedImage);

guidata(hObject,handles);
axes(handles.axes2);
cla reset
imshow(SelectedImage);
set(handles.eslesenresim,'String','Eþleþen Resim');

str = strcat('Eþleþen Resim : ',OutputName);
disp(str)

function BtnSaveImage_Callback(hObject, eventdata, handles)

resimkayit = getframe(handles.axes1);
[DosyaAdiKayit, DosyaYoluKayit] = uiputfile({'*.jpg','jpeg image(*.jpg)'; 
    '*.png','png image(*.png)'; '*.*','All'},'Resmi Kaydet');
DosyaTamYoluKayit = fullfile(DosyaYoluKayit,DosyaAdiKayit);
if ~isequal(DosyaAdiKayit,0);
    imwrite(resimkayit.cdata,DosyaTamYoluKayit);
else
    return
end


    
