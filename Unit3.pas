unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm3 = class(TForm)
    Image1: TImage;
    Plus: TSpeedButton;
    Min: TSpeedButton;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Button1: TButton;
    procedure PlusClick(Sender: TObject);
    procedure MinClick(Sender: TObject);
    procedure Pererisovat;
    procedure ProverkaKnopok;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  KlIshodnaja:integer;//’раним начальное значение клетки что бы знать перерисовывать окно или нет
implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.PlusClick(Sender: TObject);
begin
Kl:=Kl+2;
Pererisovat;
ProverkaKnopok;
end;

procedure TForm3.MinClick(Sender: TObject);
begin
Kl:=Kl-2;
Pererisovat;
ProverkaKnopok;
end;

procedure TForm3.Pererisovat;
Begin
//»змен€ем размер рисунка и выравниваем по центру
Image1.Picture.Bitmap.Width:=kl;
Image1.Picture.Bitmap.Height:=kl;
Image1.Width:=kl;
Image1.Height:=Kl;
Image1.Left:=Round((Panel1.Width-Image1.Width)/2);
Image1.Top:=Round((Panel1.Height-Image1.Height)/2);
//-----------------------------
//ћен€ем размеры буфирных рисунков
BufCifra.Width:=Kl;
BufCifra.Height:=Kl;
BufCifra.Canvas.Font.Height:=Kl+6;
//------------------------------
//ѕерерисовываем рисунок €чейки
Image1.Canvas.CopyRect(Bounds(0,0,Kl,Kl),cveta.Canvas,Bounds(0*25,0,25,25));
BufCifra.Canvas.TextRect(Bounds(0,0,Kl,Kl),Round((Kl-BufCifra.Canvas.TextWidth('8'))/2),Round((Kl-BufCifra.Canvas.TextHeight('8'))/2),'8');
Image1.Canvas.Draw(0,0,BufCifra);
//-------------------------------
end;

procedure TForm3.ProverkaKnopok;
Begin
If Kl<=Round(Screen.Width/40) then Min.Enabled:=False
  else Min.Enabled:=True;
If (Kl>=Round(Screen.Width/17)) or
  ((Form1.Width-Form1.ClientWidth+(kolonki+1)*(Kl+2))>=Screen.WorkAreaWidth) or
   ((Form1.Height-Form1.ClientHeight+(stroki+1)*(Kl+2))>=Screen.WorkAreaHeight) then
   Plus.Enabled:=False
else Plus.Enabled:=True;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
If KlIshodnaja<>Kl then
  Begin
  Form1.SozdaqnieMasivaKartinok;
  Form1.Otrisovka(1);
  end;
If Game='Pause' then Form1.N4Click(Sender);
end;

procedure TForm3.FormShow(Sender: TObject);
begin
KlIshodnaja:=Kl;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form3.Close;
end;

end.
