unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, math, Menus, ComCtrls;
type
  TKletka=class
    x:Integer;
    y:Integer;
end;

type
  TForm1 = class(TForm)
    Pole: TImage;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    VerPolosa: TImage;
    GorPolosa: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    Procedure SozdaqnieMasivaKartinok;
	  procedure NovajaIgra(col,row:integer);
    procedure Sortirovka (Tip:integer); //Tip 0-По порядку, 1-в случайном порядке
    procedure Otrisovka (Tip:integer);//Tip 1-Полная отрисовка, 2 - только отрисовка поля
    procedure VivodCifri (col, row, cvet, cifra:integer);
    procedure PoleMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure PoleClick(Sender: TObject);
	  Function proverka (Prx1,Pry1,Prx2,Pry2:integer):integer;
    Procedure proverkaHodov;
    procedure PojavilisHodi;//Если появились ходы, а до этого ходов небыло
    Function poiskNiz (PoX,PoY:integer) : Tkletka;
    Function poiskVpered (PoX,PoY:integer) : Tkletka;
	  Procedure perestroyka;
	  Procedure PokazatTekst (Tip,Vremja:integer);
    procedure Timer1Timer(Sender: TObject);
	  procedure PodschetOchkov(Kol:Integer);
    procedure SohranitHod (ShX1,ShY1,ShZn1,Shx2,shY2,ShZn2:Integer);
	  procedure Konec;
    Function PoiskRekorda(col,row:integer):String;
    Procedure ZamenitRecord(col,row,zn:integer);
	  procedure SohranitRekordi;
    procedure N2Click(Sender: TObject);//Новая игра
    procedure N3Click(Sender: TObject);//Отмена
    procedure N4Click(Sender: TObject);//Пауза
    procedure N5Click(Sender: TObject);//настрйоки
    //Не используется
	  Function PoiskPodskazki :Tkletka;
	  Function poiskVerh (PoX,PoY:integer) : Tkletka;
	  Function poiskNazad (PoX,PoY:integer) : Tkletka;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Mas: array of array of integer; //массив с цифрами
  MasNaj: array of array of integer; //масив нажатых клеток (0-клетка не нажата, 1- нажата, 2-клетка сыграна)
  cveta:TBitMap;//графика
  BufCifra:TBitmap; //графика в памяти
  MaxKol,MaxStrok:Integer;//Максимальное количество колнок и строк
  Kolonki,Stroki:Integer;//Количество колонок и строк минус 1.
  xold,yold:integer; //координаты предыдущей нажатой клетки
  X1,Y1:integer;//Координаты нажатой ячейки
  najata:Boolean;//Есть нажатая ячейка или нет
  Game:String; //Vkluchena,Start,Pause,End
  otstup:integer;
  min,sec:integer;
  MasKart:TBitmap; //Массив картинок
  otmena:TStringList;//Лист с ходами для отмены
  pomosh:integer;//Отсчет времени дял помощи
  PomoshKletka:TKletka;//Клетка с координатами подсказки
  hodi:Boolean;//ходы true-были  false-небыли
  ochki:Integer; //очки
  Recordi:TStringList; //Лист с рекордами из файла
  TekRecord:Integer;  //Текущий рекорд для данного поля
  Kl:Integer;//Размер отображаемой клетки
  KlStandart:Integer;//Стандартный размер клетки зависит от размера картинки и не меняется
  TipSortirovki:Integer; //Еип сортировки 1-по порядку или 1-в разброс
implementation

uses Unit2, Unit3;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
KlStandart:=25; //Стандартный размер клетки зависит от размера картинки и не меняется
Kl:=Round(Screen.Width/41);//Устанвливаем размер ячейки
Otmena:=TStringList.Create;//Создания листа для сохранения ходов
//Загрузка графики
Cveta:=TBitmap.Create;
Cveta.Width:=150;
Cveta.Height:=25;
Cveta.LoadFromFile('Cveta.bmp');
//--------------------
//Создание буферов для графики хронящийся в памяти
BufCifra:=TBitmap.Create;
BufCifra.Width:=Kl;
BufCifra.Height:=Kl;
BufCifra.Canvas.Font.Height:=Kl+6;
BufCifra.Canvas.Font.Name:='Arial';
BufCifra.Canvas.Font.Style:=[fsBold,fsItalic];
BufCifra.Transparent := True;
MasKart:=TBitmap.Create;
//---------------------
//Загрузить рекорды из файла
try
  Recordi:=TStringList.Create;
  Recordi.LoadFromFile('records');
except
end;
//------------------
PomoshKletka:=TKletka.Create;//Создания клетки дял хранения подсказки. И информацию пр оходы есть ил инет.
SozdaqnieMasivaKartinok;//Создаем массив картинок
NovajaIgra(10,10);//Запуск новой игры
TipSortirovki:=0; //Цифры раставляются по порядку
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Otmena.Free;
Cveta.free;
BufCifra.Free;
Recordi.Free;
PomoshKletka.Free;
MasKart.Free;
end;

Procedure TForm1.SozdaqnieMasivaKartinok;
var cvet,cifra:Integer;
Begin
//Устанавливаем размер массива для картинок
MasKart.Width:=6*Kl; // 6 цветов
MasKart.Height:=10*Kl; // цифры от 0 до 9
//---------------------------------------
//Cоздаем масив картинок
For cvet:=0 to 5 do
  For cifra:=0 to 9 do
	  If Cifra=0 then MasKart.Canvas.CopyRect(Bounds(cvet*kl,cifra*kl,Kl,Kl),cveta.Canvas,Bounds(4*25,0,25,25))
    else
		  Begin
	    MasKart.Canvas.CopyRect(Bounds(cvet*kl,cifra*kl,Kl,Kl),cveta.Canvas,Bounds(cvet*25,0,25,25));
      BufCifra.Canvas.TextRect(Bounds(0,0,Kl,Kl),Round((Kl-BufCifra.Canvas.TextWidth(IntToStr(Cifra)))/2),Round((Kl-BufCifra.Canvas.TextHeight(IntToStr(Cifra)))/2),IntToStr(cifra));
      MasKart.Canvas.Draw(cvet*Kl, cifra*Kl, BufCifra);
      end;
//----------------------
end;

procedure TForm1.NovajaIgra(col,row:integer);
var x,c,r,i:integer; cifra:integer; rec:string;
Begin
Game:='Vkluchena';
Mas:=Nil; //обнулить массив
SetLength(Mas,col,row); //задать размеры массива с цифрами
SetLength(MasNaj,col,row); // задать размеры массива с нажатиями
Kolonki:=Col-1; //записать количество колонок
Stroki:=Row-1;  //записать количество строк
Sortirovka(TipSortirovki); //Заполняем массив цифрами
//Прописываем нули в массиве нажатий (все не нажаты)
For r:=0 to Stroki do
  For c:=0 to Kolonki do
    MasNaj[c,r]:=0;
//------------------------------
//Устанвока основных значений игры
xold:=-1;
yold:=-1;
najata:=false;
otstup:=0;
Label4.Visible:=False;
min:=0;
sec:=0;
Timer1.Enabled:=False;
StatusBar1.Panels[0].Text:='0:00';
otmena.Clear;
N3.Enabled:=False;
pomosh:=0;
ochki:=0;
N4.Caption:='Пауза';
N4.Enabled:=False;
ProverkaHodov;//Вызывае мпроверку ходов дял заполнения клетки подсказки и проверки есть ходы или нет
//-------------------------------
//Поиск рекорда для текущего поля
rec:=PoiskRekorda(col,row);
If rec='net' then
  Begin
  TekRecord:=-99999999;
  Statusbar1.Panels[1].Text:='Рекорда нет.'
  end
else
  Begin
  TekRecord:=StrToInt(rec);
  Statusbar1.Panels[1].Text:='Рекорд: '+IntToStr(TekRecord);
  end;
//------------------------
Application.ProcessMessages;
Otrisovka (1); //Отрисовкка поля
end;

procedure TForm1.Sortirovka (Tip:integer);
var c,r,x,i,cifra:integer;
Begin
If Tip=0 then
  Begin
  c:=0; //колонка
  r:=0; //строка
  x:=1;
  repeat
    For i:=1 to length(IntToStr(x)) do
      Begin
      cifra:=StrToInt(copy(IntToStr(x),i,1));
      If cifra=0 then continue;
      Mas[c,r]:=cifra;
      inc(c);
      if (c=kolonki+1) and (r=Stroki) then break;
      if (c=kolonki+1) then
        Begin
        c:=0;
        inc(r);
        end;
      end;
    inc(x);
  until (c=kolonki+1) and (r=Stroki);
  end;
If Tip=1 then
  Begin
  Randomize;
  For r:=0 to stroki do
    For c:=0 to kolonki do
      Begin
      Mas[c,r]:=Random(9)+1;
      end;
  end;
end;

procedure TForm1.Otrisovka (Tip:Integer);
var c,r:Integer; BufPole:TBitMap;
WidthPole,HeightPole,WidthGor,HeightVer,VGOtstup:Integer;
Begin
//Предворительные расчеты размеров
WidthPole:=(kolonki+1)*Kl;//Ширина поля
HeightPole:=(stroki+1)*Kl;//Высота поля
VGOtstup:=Round(Kl/KlStandart);//Высота горизонтальной и ширина вертикальнйо полосы
WidthGor:=WidthPole+VGOtstup;//Ширина горизонтальнйо полосы
HeightVer:=HeightPole+VGOtstup;//Высота вертикальной полосы
//-----------------------------
If Tip=1 then
	Begin
	//Увеличиваем размеры поля b горизонтальной и вертикальной полос
	Pole.Picture.Bitmap.Width:=WidthPole;
	Pole.Picture.Bitmap.Height:=HeightPole;
	Pole.Width:=WidthPole;
	Pole.Height:=HeightPole;
	Pole.Left:=VGOtstup;
	Pole.Top:=VGOtstup;
	GorPolosa.Width:=WidthGor;
	GorPolosa.Height:=VGOtstup;
	GorPolosa.Picture.Bitmap.Width:=WidthGor;
	GorPolosa.Picture.Bitmap.Height:=VGOtstup;
	VerPolosa.Width:=VGOtstup;
	VerPolosa.Height:=HeightVer;
	VerPolosa.Picture.Bitmap.Width:=VGOtstup;
	VerPolosa.Picture.Bitmap.Height:=HeightVer;
	//------------------------
	//Рисуем вертикальную и горизонтальную полосу
	GorPolosa.Canvas.Brush.Color:=$7B7B7B;
	GorPolosa.Canvas.FillRect(GorPolosa.ClientRect);
	VerPolosa.Canvas.Brush.Color:=$7B7B7B;
	VerPolosa.Canvas.FillRect(VerPolosa.ClientRect);
	//---------------------------------------------
	//Установка размеров формы
	Form1.ClientWidth:=WidthGor;
	Form1.ClientHeight:=HeightVer+StatusBar1.Height;
	Form1.Left:=Round((Screen.WorkAreaWidth-Form1.Width)/2);
	Form1.Top:=Round((Screen.WorkAreaHeight-Form1.Height)/2);
	//---------------------------------
	end;
//Создаем буфер для поля
BufPole:=TBitMap.Create;
BufPole.Width:=WidthPole;
BufPole.Height:=HeightPole;
//-------------------------
//Отрисовываем на буффере все ячейки
For r:=0 to stroki do
	For c:=0 to kolonki do
		Begin
		BufPole.Canvas.CopyRect(Bounds(c*Kl,r*Kl,Kl,Kl), MasKart.Canvas,Bounds(0,Mas[c,r]*Kl,Kl,Kl));
		Application.ProcessMessages;
		end;
//----------------------
pole.Canvas.Draw(0,0,BufPole);//Отрисовываем буффер на экран
BufPole.Free;
end;

procedure TForm1.VivodCifri (col, row, cvet, cifra:integer);
Begin
Pole.Canvas.CopyRect(Bounds(col*Kl,row*Kl,Kl,Kl), MasKart.Canvas,Bounds(cvet*Kl,cifra*Kl,Kl,Kl));
End;

procedure TForm1.PoleMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var xnew,ynew:integer;
begin
If game='Pause' then exit; //Если игра не начата (пауза, конец) движение по полю нечего не дает
//Определяем текущую ячейку
xnew:=x div Kl;
yNew:=y div Kl;
//--------------------------
If (xnew=xold) and (ynew=yold) then exit;//Если клетка не изменилась тогда нечего не делаем
//Если клетка изменилась тогда возвращаем цвет старой ячейке	
if (xold<>-1) and (yold<>-1) and (MasNaj[xold,yold]=0) then 
	VivodCifri (xold, yold, 0, Mas[xold,yold]);
//-------------------------------------
//Если  нажатой ячейки небыло тогда просто выделяем новую
If najata<>True  then
  Begin
  xold:=xnew;
  yold:=ynew;
  if MasNaj[xnew,ynew]=0 then VivodCifri (xnew, ynew, 1, Mas[xnew,ynew]);
  end;
//---------------------------
//Если есть нажатая ячека тогда для новой определяем цвет и перерисовываем
If najata=True  then
  Begin
  xold:=xnew;
  yold:=ynew;
  If MasNaj[xnew,ynew]=0 then VivodCifri (xnew, ynew, Proverka(x1,y1,xnew,ynew), Mas[xnew,ynew]);
  end;
//----------------------------
end;

procedure TForm1.PoleClick(Sender: TObject);
var Kletka:Tkletka;
begin
//Если это первое нажатие то включаем таймер и разрешаем паузу
If Timer1.Enabled=False then
  Begin
  Game:='Start';//Игра началась
  N4.Enabled:=True;//Активируем кнопку паузы
  Timer1.Enabled:=True;//Включае мтаймер
  end;
//-------------------------
//Если нажата пустая клетка тогда нечего не делаем
if MasNaj[xold,yold]>0 then exit;
//-------------------------
If najata=false then //Если ячейка не была выбрана тогда:
  Begin
  X1:=Xold;
  Y1:=YOld;
  VivodCifri (x1, y1, 2, Mas[x1,y1]);
  najata:=true;
  masNaj[x1,y1]:=1;
  exit;
  end
else//Если одна ячейка была уже выбрана:
  Begin
  If proverka (x1,y1,xold,yold)<>2 then //если нажатая ячейка не подходит то происходит перевыбор ячейки
    Begin
    najata:=True;
    MasNaj[x1,y1]:=0; //отжимаем старую ячейку и меняем ее цвет
	  VivodCifri (x1, y1, 0, Mas[x1,y1]);
    MasNaj[xold,yold]:=1;//нажимаем новую и меняем ее цвет
    VivodCifri (xold, yold, 2, Mas[xold,yold]);
    x1:=xold;
    y1:=yold;
	  exit;
    end
  else// если нажатая ячека подходит тогда:
    Begin
    najata:=false;
    SohranitHod (x1,y1,Mas[x1,y1],xold,yold,Mas[xold,yold]);
    MasNaj[x1,y1]:=2;
    MasNaj[xold,yold]:=2;
    Mas[x1,y1]:=0;
    Mas[xold,yold]:=0;
    VivodCifri (x1, y1, 4, Mas[x1,y1]);
    VivodCifri (xold, yold, 4, Mas[xold,yold]);
    Pomosh:=0; //обнуляем время помощи
    PodschetOchkov(+10); //увеличиваем количество очков
	  proverkaHodov; //Проверяем остались ли еще ходы
	  exit;
    end;
  end;
end;

Function TForm1.proverka (Prx1,Pry1,Prx2,Pry2:integer):integer;
var px1,px2,py1,py2:Integer;
Begin
If (Mas[Prx1,Pry1]=Mas[Prx2,Pry2]) or (Mas[Prx1,Pry1]+Mas[Prx2,Pry2]=10) then
  Begin
  //проверка по верекали
  If Prx1=Prx2 then
    Begin
    If Pry1>Pry2 then
      Begin
      py1:=Pry1;
      py2:=Pry2;
      end
    else
      Begin
      py1:=Pry2;
      py2:=Pry1;
      end;
    Repeat
      inc(py2);
      If py2=py1 then
        Begin
        Result:=2;
        exit;
        end;
      If Mas[prx2,py2]<>0 then Break;
    until py2=py1;
    end;
  //Проверка на следующихъ строках
  //От первой ячейки ко второй
  py1:=Pry1;
  py2:=Pry2;
  px1:=Prx1;
  px2:=Prx2;
  repeat
    inc(px2);
    If px2=kolonki+1 then
      Begin
      px2:=0;
      inc(py2);
	  If py2=stroki+1 then py2:=0;
      end;
    If (px2=px1) and (py2=py1)    then
      Begin
      Result:=2;
      Exit;
      end;
    If Mas[px2,py2]<>0 then break;
  until (px2=px1) and (py2=py1);
  //От второй к первой
  py1:=Pry2;
  py2:=Pry1;
  px1:=Prx2;
  px2:=Prx1;
  repeat
    inc(px2);
    If px2=kolonki+1 then
      Begin
      px2:=0;
      inc(py2);
	  If py2=stroki+1 then py2:=0;
      end;
    If (px2=px1) and (py2=py1)    then
      Begin
      Result:=2;
      Exit;
      end;
    If Mas[px2,py2]<>0 then
		Begin
      Result:=3;
      exit;
      end;
	until (px2=px1) and (py2=py1);
   end
else Result:=3;
end;

Procedure TForm1.proverkaHodov;
var r,c,x:integer; Kletka:Tkletka;
Begin
Kletka:=Tkletka.Create;
//Исщем в вниз и вперед 
For r:=0 to stroki-1 do //Последнюю строку не проверяем так как ниже нее ничего нет
  For c:=0 to kolonki do
    Begin
    If Mas[c,r]<>0 then
      Begin
      Kletka:=poiskNiz(c,r);
      If (Kletka.x<>-1) and (Kletka.y<>-1) then
        If (Mas[c,r]=Mas[kletka.x,Kletka.y]) or (Mas[c,r]+Mas[kletka.x,Kletka.y]=10) then
          Begin
          PomoshKletka:=Kletka;
		      If hodi=false then PojavilisHodi;
          Exit;
          end;
      Kletka:=poiskVpered(c,r);
      If (Kletka.x<>-1) and (Kletka.y<>-1) then
        If (Mas[c,r]=Mas[kletka.x,Kletka.y]) or (Mas[c,r]+Mas[kletka.x,Kletka.y]=10) then
          Begin
          PomoshKletka:=Kletka;
		      If hodi=false then PojavilisHodi;
          Exit;
          end;
      end;
    end;
//--------------------
//Проверяем что бы цифр было больше чем три иначе конец игры
x:=0;
For r:=0 to stroki do
  For c:=0 to kolonki do
	  Begin
    If Mas[c,r]<>0 then inc(x);
	  If x>3 then break;
	  end;
If x<=3 then
  Begin
  Konec;
  exit;
  end;
//----------------------------------------
//Если нечего не нашли тогда перестраиваем
If hodi=true then //если  ходы перед этим били то просто перестраиваем
	Begin
	hodi:=false;
	PokazatTekst(1,0);//Выводим текст
	Perestroyka;
	exit;
	end
else //если  ходов перед этим небыло то увеличиваем отступ и смотрим можно перестроить или нет
	Begin
	inc(otstup);
	If kolonki+1-otstup*2>=2 then //если получаем больше чем две ячейки в ширену то перестраиваем
		Begin
		Perestroyka;
		exit;
		end
	else //если получаем меньше чем две ячейки в ширину тогда конец игры
		Begin
		otrisovka(2);
		Konec;
		Exit;
		end;
	end;
//--------------------------------------
end;

procedure TForm1.PojavilisHodi;
Begin
hodi:=true;
PokazatTekst(1,800);//Убираем текст с экрана
Otrisovka(2);
end;

Function TForm1.poiskNiz (PoX,PoY:integer): Tkletka;
var n:integer; kletka:Tkletka;
Begin
Kletka:=Tkletka.Create;
n:=0;
Repeat
dec(Poy);
If PoY=-1 then
  Begin
  Kletka.x:=-1;
  Kletka.y:=-1;
  Result:=Kletka;
  Exit;
  end;
If Mas[PoX,PoY]<>0 then
  Begin
  Kletka.x:=PoX;
  kletka.y:=PoY;
  Result:=Kletka;
  n:=1;
  end;
until n=1;
end;

Function TForm1.poiskVpered (PoX,PoY:integer): Tkletka;
var n:integer; OldX,OldY:Integer; kletka:Tkletka;
Begin
Kletka:=Tkletka.Create;
n:=0;
Oldx:=PoX;
Oldy:=PoY;
Repeat
  inc(PoX);
  If PoX=kolonki+1 then
    Begin
    PoX:=0;
    inc(Poy);
    If PoY=stroki+1 then
      Poy:=0;
    end;
  If (Oldx=Pox) and (Oldy=PoY) then
    Begin
    Kletka.x:=-1;
    Kletka.y:=-1;
    Result:=Kletka;
    exit;
    end;
  If Mas[PoX,PoY]<>0 then
    Begin
    Kletka.x:=PoX;
    kletka.y:=PoY;
    Result:=Kletka;
    Exit;
    end;
until n=1;
end;

Procedure TForm1.perestroyka;
var r,c,col,nom:Integer; str:TstringList;
Begin
//Очистить лист отмены, иотключить кнопку отмены до следущего хода
otmena.Clear;
N3.Enabled:=False;
//---------------------
//Создаем список всех оставшихся цифр
str:=TStringList.Create;
For r:=0 to stroki do
  For c:=0 to kolonki do
    if Mas[c,r]<>0 then str.Add(IntToStr(Mas[c,r]));
//-----------------------------
col:=str.Count;//Количесвто оставшихся цифр+1
//Заполняем массив новыми цифрами
nom:=0;
For r:=0 to stroki do
  For c:=0 to kolonki do
    Begin
    If (c>=otstup) and (c<=kolonki-otstup) then
      begin
      if nom>=col then
        Begin
        Mas[c,r]:=0;
        MasNaj[c,r]:=2;
        Continue;
        end;
      Mas[c,r]:=StrToInt(str.Strings[nom]);
      MasNaj[c,r]:=0;
      inc(nom);
      end
    else
      Begin
      Mas[c,r]:=0;
      MasNaj[c,r]:=2;
      end;
    end;
xold:=-1;
yold:=-1;
//--------------------------
proverkaHodov;
end;

Procedure TForm1.PokazatTekst (Tip,Vremja:integer);
var str:string;
Begin
Case tip of
  1: If (Tip=1) and (Form1.ClientWidth>=2*(Form1.ClientHeight-StatusBar1.Height)) then
        str:='ХОДОВ НЕТ!'
      else str:='ХОДОВ'+#13+'НЕТ!';
  2: str:='КОНЕЦ!';
  3: str:='ПАУЗА';
  4: str:='КОНЕЦ!'+#13+'РЕКОРД'
end;
If Form1.ClientWidth>=2*(Form1.ClientHeight-StatusBar1.Height) then
  Label4.Font.Height:=Round(Form1.ClientHeight/3)
  else Label4.Font.Height:=Round(Form1.ClientWidth/3.5);
Label4.Caption:=str;
Label4.Visible:=True;
Application.ProcessMessages;
If Vremja<>0 then
  Begin
  Application.ProcessMessages;
  Sleep(Vremja);
  Application.ProcessMessages;
  Label4.Visible:=False;
  Application.ProcessMessages;
  end
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
PodschetOchkov(-1);//Каждую секунду отнимаем 1 очко
//Прибавляем к времени 1 секунду и показываем
inc(sec);
If sec=60 then
  Begin
  inc(min);
  sec:=0;
  end;
If sec<10 then
  StatusBar1.Panels[0].Text:=IntToStr(min)+':0'+IntToStr(sec)
else
  StatusBar1.Panels[0].Text:=IntToStr(min)+':'+IntToStr(sec);
//-------------------------------
//Если прошло 5 секунду показываем подсказку
inc(pomosh);
If pomosh=5 then
  Begin
    VivodCifri (PomoshKletka.x, PomoshKletka.y, 5, Mas[PomoshKletka.x,PomoshKletka.y]);
  pomosh:=0;
  end;
//------------------------------
end;

procedure TForm1.PodschetOchkov(Kol:Integer);
Begin
Ochki:=Ochki+kol;
StatusBar1.Panels[1].Text:='Очки: '+IntToStr(Ochki);
end;

procedure TForm1.SohranitHod(ShX1,ShY1,ShZn1,Shx2,shY2,ShZn2:Integer);
Begin
N3.Enabled:=True;
otmena.Add(IntToStr(ShX1)+'+'+IntToStr(ShY1)+'+'+IntToStr(ShZn1)+'+'+
            IntToStr(ShX2)+'+'+IntToStr(ShY2)+'+'+IntToStr(ShZn2)+'+');
end;

Procedure TForm1.Konec;
Begin
N4.Enabled:=False;
game:='End';
Timer1.Enabled:=False;
If TekRecord<ochki then
	Begin
	ZamenitRecord(kolonki+1,stroki+1,ochki);
	PokazatTekst (4,0);
	exit;
	end
else PokazatTekst (2,0);	
end;

Function TForm1.PoiskRekorda(col,row:integer):String;
var i:integer; LX,LY:Integer; str,strX,strY:string;
Begin
strX:=IntToStr(col);
strY:=IntToStr(row);
LX:=length(strX);
LY:=length(strY);
For i:=0 to Recordi.Count-1 do
  Begin
  str:=Recordi.Strings[i];
  If copy(str,1,LX)=strX then
    If copy(str,1+LX+1,LY)=strY then
      Begin
      Result:=copy(str,1+LX+1+LY+1,length(str)-1+LX+1+LY+1);
      exit;
      end;
  end;
result:='net';
end;

Procedure Tform1.ZamenitRecord(col,row,zn:integer);
var i:integer; LX,LY:Integer; str,strX,strY:string;
Begin
strX:=IntToStr(col);
strY:=IntToStr(row);
LX:=length(strX);
LY:=length(strY);
For i:=0 to Recordi.Count-1 do
  Begin
  str:=Recordi.Strings[i];
  If copy(str,1,LX)=strX then
    If copy(str,1+LX+1,LY)=strY then
      Begin
      Recordi.Strings[i]:=strX+'/'+strY+'/'+IntToStr(zn);
      SohranitRekordi;
      exit;
      end;
  end;
Recordi.Add(strX+'/'+strY+'/'+IntToStr(zn));
SohranitRekordi;
end;

procedure TForm1.SohranitRekordi;
Begin
Recordi.SaveToFile('records');
end;

procedure TForm1.N2Click(Sender: TObject);//Новая игра
begin
If Game='Start' then N4Click(Sender);
MaxKol:=Round((Screen.WorkAreaWidth-25)/Kl);
MaxStrok:=Round((Screen.WorkAreaHeight-70)/Kl);
Form2.GroupBox1.Caption:='Количество ячеек ( от 5х5 до '+IntToStr(MaxKol)+'x'+IntToStr(MaxStrok)+')';
Form2.Colon.Text:=IntToStr(Kolonki+1);
Form2.Rows.Text:=IntToStr(Stroki+1);
Form2.RadioGroup1.ItemIndex:=TipSortirovki;
Form2.ShowModal;
end;

procedure TForm1.N3Click(Sender: TObject);//Отменить
var str:String; n,p:Integer; otX1,otY1,otZn1,otX2,otY2,otZn2:Integer;
begin
n:=otmena.Count-1;
If n=-1 then exit;
str:=otmena.Strings[n];
otmena.Delete(n);
If n-1=-1 then n3.Enabled:=False;

p:=Pos('+',str);
otx1:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);

p:=Pos('+',str);
oty1:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);

p:=Pos('+',str);
otzn1:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);

p:=Pos('+',str);
otx2:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);

p:=Pos('+',str);
oty2:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);

p:=Pos('+',str);
otzn2:=StrToInt(copy(str,0,p-1));
str:=copy(str,p+1,length(str)-p);


MasNaj[otx1,oty1]:=0;
MasNaj[otx2,oty2]:=0;
Mas[otx1,oty1]:=otzn1;
Mas[otx2,oty2]:=otzn2;
VivodCifri (otx1,oty1, 0, otzn1);
VivodCifri (otx2,oty2, 0, otzn2);
end;

procedure TForm1.N4Click(Sender: TObject);//Пауза
begin
If Game<>'Pause' Then
  Begin
  Game:='Pause';
  Timer1.Enabled:=False;
  N4.Caption:='Продолжить';
  Pole.Canvas.CopyRect(Pole.ClientRect,cveta.Canvas,Bounds(100,0,25,25));
  PokazatTekst(3,0);
  end
else
  Begin
  Otrisovka(2);
  Game:='Start';
  Timer1.Enabled:=True;
  N4.Caption:='Пауза';
  PokazatTekst(3,1);
  end;
end;

procedure TForm1.N5Click(Sender: TObject);//Настройка
begin
If Game='Start' then N4Click(Sender);//Вызываем паузу
Form3.Pererisovat;
Form3.ProverkaKnopok;
Form3.ShowModal;
end;

//Не нужный в данный момент код
Function TForm1.PoiskPodskazki :Tkletka;
var i,j:integer; Kletka:Tkletka;
Begin
Kletka:=Tkletka.Create;
//Исщем в вниз и вперед 
For i:=0 to stroki do
  For j:=0 to kolonki do
    Begin
    If Mas[j,i]<>0 then
    Begin
    Kletka:=poiskNiz(j,i);
    If (Kletka.x<>-1) and (Kletka.y<>-1) then
      If (Mas[j,i]=Mas[kletka.x,Kletka.y]) or (Mas[j,i]+Mas[kletka.x,Kletka.y]=10) then
        Begin
        Result:=Kletka;
        Exit;
        end;
    Kletka:=poiskVpered(j,i);
    If (Kletka.x<>-1) and (Kletka.y<>-1) then
      If (Mas[j,i]=Mas[kletka.x,Kletka.y]) or (Mas[j,i]+Mas[kletka.x,Kletka.y]=10) then
        Begin
        Result:=Kletka;
        Exit;
        end;
    end;
    end;
//--------------------
//Если нечего не нашли тогда перестройка
Kletka.x:=-1;
Kletka.y:=-1;
result:=Kletka;
//----------------------
end;

Function TForm1.poiskVerh (PoX,PoY:integer): Tkletka;
var n:integer; Kletka:Tkletka;
Begin
n:=0;
Kletka:=Tkletka.Create;
Repeat
inc(Poy);
If PoY=stroki+1 then
  Begin
  Kletka.x:=-1;
  Kletka.y:=-1;
  Result:=Kletka;
  Exit;
  end;
If Mas[PoX,PoY]<>0 then
  Begin
  Kletka.x:=PoX;
  kletka.y:=PoY;
  Result:=Kletka;
  n:=1;
  end;
until n=1;
end;

Function TForm1.poiskNazad (PoX,PoY:integer): Tkletka;
var n:integer; OldX,OldY:Integer; kletka,KletkaOld:Tkletka;
Begin
Kletka:=Tkletka.Create;
n:=0;
Oldx:=PoX;
Oldy:=PoY;
Repeat
dec(PoX);
If PoX=-1 then
  Begin
  PoX:=kolonki;
  dec(Poy);
  If PoY=-1 then
    Poy:=stroki;
  end;
If (Oldx=Pox) and (Oldy=PoY) then
  Begin
  Kletka.x:=-1;
  Kletka.y:=-1;
  Result:=Kletka;
  exit;
  end;
If Mas[PoX,PoY]<>0 then
  Begin
  Kletka.x:=PoX;
  kletka.y:=PoY;
  Result:=Kletka;
  Exit;
  end;
until n=1;
end;

end.
