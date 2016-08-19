unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    XPManifest1: TXPManifest;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses RegExpr;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.Memo1Change(Sender: TObject);
var
  Count, i: Integer;
  RegExp: TRegExpr;
begin
  RegExp := TRegExpr.Create;

  // кол-во строк
  Label1.Caption := 'Строк: ' + IntToStr(Memo1.Lines.Count);

  // кол-во символов
  Label2.Caption := 'Символов: ' + IntToStr(Length(Memo1.Text));

  // кол-во символов, исключая пробельные
  RegExp.Expression := '\s';
  Count := 0;
  Count := Count + Length(RegExp.Replace(Memo1.Text, '', False));
  Label3.Caption := 'Непробельных символов: ' + IntToStr(Count);

  // кол-во слов
  Count := 0;
  RegExp.Expression := '\s*[^\s.-]+-?[^\s.-]*';
  if RegExp.Exec(Memo1.Text) then
  repeat
    Count := Count + 1;
  until not RegExp.ExecNext;
  Label4.Caption := 'Слов: ' + IntToStr(Count);

  // кол-во предложений
  Count := 0;
  RegExp.Expression := '[.!?]+(\s|$)';
  if RegExp.Exec(Memo1.Text) then
  repeat
    Count := Count + 1;
  until not RegExp.ExecNext;
  Label5.Caption := 'Предложений: ' + IntToStr(Count);  
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    Memo1.ScrollBars := ssVertical
  else
    Memo1.ScrollBars := ssBoth;
end;

end.
