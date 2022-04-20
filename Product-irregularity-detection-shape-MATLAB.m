function varargout = zadatak(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zadatak_OpeningFcn, ...
                   'gui_OutputFcn',  @zadatak_OutputFcn, ...
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


function zadatak_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

%Aktivira se pri otvaranju koda, gasi tekst rezultata testiranja, postavlja
%slike A i B na 0, radi pravilnog poreðenja ako nisu unešene.
function varargout = zadatak_OutputFcn(~, eventdata, handles) 
varargout{1} = handles.output;
set(handles.text5,'visible','off')
A=0;
B=0;
setappdata(handles.figure1,'Slika1',A);
setappdata(handles.figure1,'Slika2',B);

%Dio kojim se unosi slika A i sprema u memoriju aplikacije.
function pushbutton1_Callback(hObject, eventdata, handles)
[FileName,PathName]=uigetfile({'*.jpg';'*.png'},'Izaberi sliku');
A=imread(strcat(PathName,FileName));
setappdata(handles.figure1,'Slika1',A);
axes(handles.axes1);
imshow(A); 

%Dio kojim se unosi slika B i sprema u memoriju aplikacije.
function pushbutton2_Callback(hObject, eventdata, handles)
[FileName,PathName]=uigetfile({'*.jpg';'*.png'},'Izaberi sliku');
B=imread(strcat(PathName,FileName));
setappdata(handles.figure1,'Slika2',B);
axes(handles.axes2);
imshow(B); 

%Dio kojim se testira ispravnost,tj. postojanje greške i u zavisnosti od
%toga da li su unešene obje slike, te da li je proizvod ispravan ili ne,
%ispisuje odgovarajuæu poruku.
function pushbutton3_Callback(hObject, eventdata, handles)
idealniProizvod=getappdata(handles.figure1,'Slika1');
testiraniProizvod=getappdata(handles.figure1,'Slika2');
if idealniProizvod==zeros | testiraniProizvod==zeros
string1='Nisu unešene potrebne slike za ispitivanje.';
set(handles.text6,'String',string1);
string2='Nisu ispunjeni uslovi za poèetak ispitivanja.';
set(handles.text5,'String',string2);
set(handles.text5,'visible','on') 
else
string3='Unešene su potrebne slike za testiranje.';
set(handles.text6,'String',string3);
Jacinaslike1= mean2(idealniProizvod);
Jacinaslike2=mean2(testiraniProizvod);
if Jacinaslike2>=Jacinaslike1
    od=imsubtract(testiraniProizvod,idealniProizvod);
else 
    od=imsubtract(idealniProizvod,testiraniProizvod);
end
if od==0
string2='Proizvod je ispravan.';
set(handles.text5,'String',string2)
set(handles.text5,'visible','on')
cla(handles.axes3)
cla(handles.axes4)
else
string1='Pronaðena je greška.';
set(handles.text5,'String',string1)
set(handles.text5,'visible','on') 
end
end


%Dio koda koji restartuje sistem
function pushExit_Callback(hObject, eventdata, handles)
set(handles.text6,'String', 'Unesite sliku proizvoda bez greške i sliku proizvoda èija se ispravnost želi testirati.'); 
set(handles.text5,'visible','off');
cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)

%Dio koda kojim se izlazi iz GUI aplikacije
function pushbutton6_Callback(hObject, eventdata, handles)
delete(handles.figure1)



function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Dio koda kojim se odreðuje lokacija greške
function pushbutton8_Callback(hObject, eventdata, handles)
idealniProizvod=getappdata(handles.figure1,'Slika1');
testiraniProizvod=getappdata(handles.figure1,'Slika2');
if idealniProizvod==zeros | testiraniProizvod==zeros
string1='Nisu unešene potrebne slike za ispitivanje.';
set(handles.text6,'String',string1);
string2='Nisu ispunjeni uslovi za poèetak ispitivanja.';
set(handles.text5,'String',string2);
set(handles.text5,'visible','on') 
else
string3='Unešene su potrebne slike za testiranje.';
set(handles.text6,'String',string3);
Jacinaslike1= mean2(idealniProizvod);
Jacinaslike2=mean2(testiraniProizvod);
if Jacinaslike2>=Jacinaslike1
    od=imsubtract(testiraniProizvod,idealniProizvod);
else 
    od=imsubtract(idealniProizvod,testiraniProizvod);
end
if od==0
string2='Proizvod je ispravan.';
set(handles.text5,'String',string2)
set(handles.text5,'visible','on')
cla(handles.axes3)
cla(handles.axes4)
else
a=str2num(get(handles.edit1,'String'))
if a<1| a>50
string7='Unijeli ste preciznost koja nije u definisanim granicama.';
msgbox(string7,'Greška.','error')
else
C1=rgb2gray(od);
obiljezja=detectBRISKFeatures(C1);
axes(handles.axes4)
imshow(testiraniProizvod); hold on;
plot(obiljezja.selectStrongest(a));
hold off
end
end
end


%Dio koda koji prikazuje grešku
function pushbutton9_Callback(hObject, eventdata, handles)
idealniProizvod=getappdata(handles.figure1,'Slika1');
testiraniProizvod=getappdata(handles.figure1,'Slika2');
if idealniProizvod==zeros | testiraniProizvod==zeros
string1='Nisu unešene potrebne slike za ispitivanje.';
set(handles.text6,'String',string1);
string2='Nisu ispunjeni uslovi za poèetak ispitivanja.';
set(handles.text5,'String',string2);
set(handles.text5,'visible','on') 
else
string3='Unešene su potrebne slike za testiranje.';
set(handles.text6,'String',string3);
Jacinaslike1= mean2(idealniProizvod);
Jacinaslike2=mean2(testiraniProizvod);
if Jacinaslike2>=Jacinaslike1
    od=imsubtract(testiraniProizvod,idealniProizvod);
else 
    od=imsubtract(idealniProizvod,testiraniProizvod);
end
if od==0
string2='Proizvod je ispravan.';
set(handles.text5,'String',string2)
set(handles.text5,'visible','on')
cla(handles.axes3)
cla(handles.axes4)
else
axes(handles.axes3)
imshow(od); 
end
end
