unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Colon: TLabeledEdit;
    Rows: TLabeledEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    RadioGroup1: TRadioGroup;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
If StrToInt(Colon.Text)<5 then Colon.Text:='5';
If StrToInt(Rows.Text)<5 then Rows.Text:='5';
If StrToInt(Colon.Text)>MaxKol then Colon.Text:=IntToStr(MaxKol);
If StrToInt(Rows.Text)>MaxStrok then Rows.Text:=IntToStr(MaxStrok);
TipSortirovki:=RadioGroup1.ItemIndex;
Application.ProcessMessages;
Form1.NovajaIgra(StrToInt(Colon.Text),StrToInt(Rows.Text));
Form2.Close;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
If Game='Pause' then Form1.N4Click(Sender);
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
Form2.Close;
end;

end.
