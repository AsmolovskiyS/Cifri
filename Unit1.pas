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
    procedure Sortirovka (Tip:integer); //Tip 0-�� �������, 1-� ��������� �������
    procedure Otrisovka (Tip:integer);//Tip 1-������ ���������, 2 - ������ ��������� ����
    procedure VivodCifri (col, row, cvet, cifra:integer);
    procedure PoleMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure PoleClick(Sender: TObject);
	  Function proverka (Prx1,Pry1,Prx2,Pry2:integer):integer;
    Procedure proverkaHodov;
    procedure PojavilisHodi;//���� ��������� ����, � �� ����� ����� ������
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
    procedure N2Click(Sender: TObject);//����� ����
    procedure N3Click(Sender: TObject);//������
    procedure N4Click(Sender: TObject);//�����
    procedure N5Click(Sender: TObject);//���������
    //�� ������������
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
  Mas: array of array of integer; //������ � �������
  MasNaj: array of array of integer; //����� ������� ������ (0-������ �� ������, 1- ������, 2-������ �������)
  cveta:TBitMap;//�������
  BufCifra:TBitmap; //������� � ������
  MaxKol,MaxStrok:Integer;//������������ ���������� ������ � �����
  Kolonki,Stroki:Integer;//���������� ������� � ����� ����� 1.
  xold,yold:integer; //���������� ���������� ������� ������
  X1,Y1:integer;//���������� ������� ������
  najata:Boolean;//���� ������� ������ ��� ���
  Game:String; //Vkluchena,Start,Pause,End
  otstup:integer;
  min,sec:integer;
  MasKart:TBitmap; //������ ��������
  otmena:TStringList;//���� � ������ ��� ������
  pomosh:integer;//������ ������� ��� ������
  PomoshKletka:TKletka;//������ � ������������ ���������
  hodi:Boolean;//���� true-����  false-������
  ochki:Integer; //����
  Recordi:TStringList; //���� � ��������� �� �����
  TekRecord:Integer;  //������� ������ ��� ������� ����
  Kl:Integer;//������ ������������ ������
  KlStandart:Integer;//����������� ������ ������ ������� �� ������� �������� � �� ��������
  TipSortirovki:Integer; //��� ���������� 1-�� ������� ��� 1-� �������
implementation

uses Unit2, Unit3;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
KlStandart:=25; //����������� ������ ������ ������� �� ������� �������� � �� ��������
Kl:=Round(Screen.Width/41);//������������ ������ ������
Otmena:=TStringList.Create;//�������� ����� ��� ���������� �����
//�������� �������
Cveta:=TBitmap.Create;
Cveta.Width:=150;
Cveta.Height:=25;
Cveta.LoadFromFile('Cveta.bmp');
//--------------------
//�������� ������� ��� ������� ���������� � ������
BufCifra:=TBitmap.Create;
BufCifra.Width:=Kl;
BufCifra.Height:=Kl;
BufCifra.Canvas.Font.Height:=Kl+6;
BufCifra.Canvas.Font.Name:='Arial';
BufCifra.Canvas.Font.Style:=[fsBold,fsItalic];
BufCifra.Transparent := True;
MasKart:=TBitmap.Create;
//---------------------
//��������� ������� �� �����
try
  Recordi:=TStringList.Create;
  Recordi.LoadFromFile('records');
except
end;
//------------------
PomoshKletka:=TKletka.Create;//�������� ������ ��� �������� ���������. � ���������� �� ����� ���� �� ����.
SozdaqnieMasivaKartinok;//������� ������ ��������
NovajaIgra(10,10);//������ ����� ����
TipSortirovki:=0; //����� ������������ �� �������
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
//������������� ������ ������� ��� ��������
MasKart.Width:=6*Kl; // 6 ������
MasKart.Height:=10*Kl; // ����� �� 0 �� 9
//---------------------------------------
//C������ ����� ��������
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
Mas:=Nil; //�������� ������
SetLength(Mas,col,row); //������ ������� ������� � �������
SetLength(MasNaj,col,row); // ������ ������� ������� � ���������
Kolonki:=Col-1; //�������� ���������� �������
Stroki:=Row-1;  //�������� ���������� �����
Sortirovka(TipSortirovki); //��������� ������ �������
//����������� ���� � ������� ������� (��� �� ������)
For r:=0 to Stroki do
  For c:=0 to Kolonki do
    MasNaj[c,r]:=0;
//------------------------------
//��������� �������� �������� ����
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
N4.Caption:='�����';
N4.Enabled:=False;
ProverkaHodov;//������� ��������� ����� ��� ���������� ������ ��������� � �������� ���� ���� ��� ���
//-------------------------------
//����� ������� ��� �������� ����
rec:=PoiskRekorda(col,row);
If rec='net' then
  Begin
  TekRecord:=-99999999;
  Statusbar1.Panels[1].Text:='������� ���.'
  end
else
  Begin
  TekRecord:=StrToInt(rec);
  Statusbar1.Panels[1].Text:='������: '+IntToStr(TekRecord);
  end;
//------------------------
Application.ProcessMessages;
Otrisovka (1); //���������� ����
end;

procedure TForm1.Sortirovka (Tip:integer);
var c,r,x,i,cifra:integer;
Begin
If Tip=0 then
  Begin
  c:=0; //�������
  r:=0; //������
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
//��������������� ������� ��������
WidthPole:=(kolonki+1)*Kl;//������ ����
HeightPole:=(stroki+1)*Kl;//������ ����
VGOtstup:=Round(Kl/KlStandart);//������ �������������� � ������ ������������ ������
WidthGor:=WidthPole+VGOtstup;//������ �������������� ������
HeightVer:=HeightPole+VGOtstup;//������ ������������ ������
//-----------------------------
If Tip=1 then
	Begin
	//����������� ������� ���� b �������������� � ������������ �����
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
	//������ ������������ � �������������� ������
	GorPolosa.Canvas.Brush.Color:=$7B7B7B;
	GorPolosa.Canvas.FillRect(GorPolosa.ClientRect);
	VerPolosa.Canvas.Brush.Color:=$7B7B7B;
	VerPolosa.Canvas.FillRect(VerPolosa.ClientRect);
	//---------------------------------------------
	//��������� �������� �����
	Form1.ClientWidth:=WidthGor;
	Form1.ClientHeight:=HeightVer+StatusBar1.Height;
	Form1.Left:=Round((Screen.WorkAreaWidth-Form1.Width)/2);
	Form1.Top:=Round((Screen.WorkAreaHeight-Form1.Height)/2);
	//---------------------------------
	end;
//������� ����� ��� ����
BufPole:=TBitMap.Create;
BufPole.Width:=WidthPole;
BufPole.Height:=HeightPole;
//-------------------------
//������������ �� ������� ��� ������
For r:=0 to stroki do
	For c:=0 to kolonki do
		Begin
		BufPole.Canvas.CopyRect(Bounds(c*Kl,r*Kl,Kl,Kl), MasKart.Canvas,Bounds(0,Mas[c,r]*Kl,Kl,Kl));
		Application.ProcessMessages;
		end;
//----------------------
pole.Canvas.Draw(0,0,BufPole);//������������ ������ �� �����
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
If game='Pause' then exit; //���� ���� �� ������ (�����, �����) �������� �� ���� ������ �� ����
//���������� ������� ������
xnew:=x div Kl;
yNew:=y div Kl;
//--------------------------
If (xnew=xold) and (ynew=yold) then exit;//���� ������ �� ���������� ����� ������ �� ������
//���� ������ ���������� ����� ���������� ���� ������ ������	
if (xold<>-1) and (yold<>-1) and (MasNaj[xold,yold]=0) then 
	VivodCifri (xold, yold, 0, Mas[xold,yold]);
//-------------------------------------
//����  ������� ������ ������ ����� ������ �������� �����
If najata<>True  then
  Begin
  xold:=xnew;
  yold:=ynew;
  if MasNaj[xnew,ynew]=0 then VivodCifri (xnew, ynew, 1, Mas[xnew,ynew]);
  end;
//---------------------------
//���� ���� ������� ����� ����� ��� ����� ���������� ���� � ��������������
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
//���� ��� ������ ������� �� �������� ������ � ��������� �����
If Timer1.Enabled=False then
  Begin
  Game:='Start';//���� ��������
  N4.Enabled:=True;//���������� ������ �����
  Timer1.Enabled:=True;//������� �������
  end;
//-------------------------
//���� ������ ������ ������ ����� ������ �� ������
if MasNaj[xold,yold]>0 then exit;
//-------------------------
If najata=false then //���� ������ �� ���� ������� �����:
  Begin
  X1:=Xold;
  Y1:=YOld;
  VivodCifri (x1, y1, 2, Mas[x1,y1]);
  najata:=true;
  masNaj[x1,y1]:=1;
  exit;
  end
else//���� ���� ������ ���� ��� �������:
  Begin
  If proverka (x1,y1,xold,yold)<>2 then //���� ������� ������ �� �������� �� ���������� ��������� ������
    Begin
    najata:=True;
    MasNaj[x1,y1]:=0; //�������� ������ ������ � ������ �� ����
	  VivodCifri (x1, y1, 0, Mas[x1,y1]);
    MasNaj[xold,yold]:=1;//�������� ����� � ������ �� ����
    VivodCifri (xold, yold, 2, Mas[xold,yold]);
    x1:=xold;
    y1:=yold;
	  exit;
    end
  else// ���� ������� ����� �������� �����:
    Begin
    najata:=false;
    SohranitHod (x1,y1,Mas[x1,y1],xold,yold,Mas[xold,yold]);
    MasNaj[x1,y1]:=2;
    MasNaj[xold,yold]:=2;
    Mas[x1,y1]:=0;
    Mas[xold,yold]:=0;
    VivodCifri (x1, y1, 4, Mas[x1,y1]);
    VivodCifri (xold, yold, 4, Mas[xold,yold]);
    Pomosh:=0; //�������� ����� ������
    PodschetOchkov(+10); //����������� ���������� �����
	  proverkaHodov; //��������� �������� �� ��� ����
	  exit;
    end;
  end;
end;

Function TForm1.proverka (Prx1,Pry1,Prx2,Pry2:integer):integer;
var px1,px2,py1,py2:Integer;
Begin
If (Mas[Prx1,Pry1]=Mas[Prx2,Pry2]) or (Mas[Prx1,Pry1]+Mas[Prx2,Pry2]=10) then
  Begin
  //�������� �� ��������
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
  //�������� �� ���������� �������
  //�� ������ ������ �� ������
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
  //�� ������ � ������
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
//����� � ���� � ������ 
For r:=0 to stroki-1 do //��������� ������ �� ��������� ��� ��� ���� ��� ������ ���
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
//��������� ��� �� ���� ���� ������ ��� ��� ����� ����� ����
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
//���� ������ �� ����� ����� �������������
If hodi=true then //����  ���� ����� ���� ���� �� ������ �������������
	Begin
	hodi:=false;
	PokazatTekst(1,0);//������� �����
	Perestroyka;
	exit;
	end
else //����  ����� ����� ���� ������ �� ����������� ������ � ������� ����� ����������� ��� ���
	Begin
	inc(otstup);
	If kolonki+1-otstup*2>=2 then //���� �������� ������ ��� ��� ������ � ������ �� �������������
		Begin
		Perestroyka;
		exit;
		end
	else //���� �������� ������ ��� ��� ������ � ������ ����� ����� ����
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
PokazatTekst(1,800);//������� ����� � ������
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
//�������� ���� ������, ���������� ������ ������ �� ��������� ����
otmena.Clear;
N3.Enabled:=False;
//---------------------
//������� ������ ���� ���������� ����
str:=TStringList.Create;
For r:=0 to stroki do
  For c:=0 to kolonki do
    if Mas[c,r]<>0 then str.Add(IntToStr(Mas[c,r]));
//-----------------------------
col:=str.Count;//���������� ���������� ����+1
//��������� ������ ������ �������
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
        str:='����� ���!'
      else str:='�����'+#13+'���!';
  2: str:='�����!';
  3: str:='�����';
  4: str:='�����!'+#13+'������'
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
PodschetOchkov(-1);//������ ������� �������� 1 ����
//���������� � ������� 1 ������� � ����������
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
//���� ������ 5 ������� ���������� ���������
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
StatusBar1.Panels[1].Text:='����: '+IntToStr(Ochki);
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

procedure TForm1.N2Click(Sender: TObject);//����� ����
begin
If Game='Start' then N4Click(Sender);
MaxKol:=Round((Screen.WorkAreaWidth-25)/Kl);
MaxStrok:=Round((Screen.WorkAreaHeight-70)/Kl);
Form2.GroupBox1.Caption:='���������� ����� ( �� 5�5 �� '+IntToStr(MaxKol)+'x'+IntToStr(MaxStrok)+')';
Form2.Colon.Text:=IntToStr(Kolonki+1);
Form2.Rows.Text:=IntToStr(Stroki+1);
Form2.RadioGroup1.ItemIndex:=TipSortirovki;
Form2.ShowModal;
end;

procedure TForm1.N3Click(Sender: TObject);//��������
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

procedure TForm1.N4Click(Sender: TObject);//�����
begin
If Game<>'Pause' Then
  Begin
  Game:='Pause';
  Timer1.Enabled:=False;
  N4.Caption:='����������';
  Pole.Canvas.CopyRect(Pole.ClientRect,cveta.Canvas,Bounds(100,0,25,25));
  PokazatTekst(3,0);
  end
else
  Begin
  Otrisovka(2);
  Game:='Start';
  Timer1.Enabled:=True;
  N4.Caption:='�����';
  PokazatTekst(3,1);
  end;
end;

procedure TForm1.N5Click(Sender: TObject);//���������
begin
If Game='Start' then N4Click(Sender);//�������� �����
Form3.Pererisovat;
Form3.ProverkaKnopok;
Form3.ShowModal;
end;

//�� ������ � ������ ������ ���
Function TForm1.PoiskPodskazki :Tkletka;
var i,j:integer; Kletka:Tkletka;
Begin
Kletka:=Tkletka.Create;
//����� � ���� � ������ 
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
//���� ������ �� ����� ����� �����������
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
