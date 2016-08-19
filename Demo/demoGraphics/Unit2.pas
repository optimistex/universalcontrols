unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UcButtons, ExtCtrls, ucExtCtrls, pngimage, ucFunctions, jpeg, ucGraphics, ucTypes,
  StdCtrls, ImgList, ComCtrls, VirtualTrees, ActnList, ucSkin, ucWindows;

type
  TForm2 = class(TForm)
    UcPanel1: TUcPanel;
    Image1: TImage;
    Memo1: TMemo;
    UcSkinManager1: TUcSkinManager;
    UcPanel2: TUcPanel;
    procedure UcPanel1DrawBackground(Sender: TObject; Canvas: TCanvas);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure UcPanel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UcPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    SkinPainter: TUcSkinPainter;
    procedure TestPaint(Cnv: TCanvas);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation


{$R *.dfm}


procedure TForm2.FormCreate(Sender: TObject);
begin
  SkinPainter := TUcSkinPainter.Create;
  SkinPainter.SourceIMG    := Image1.Picture.Graphic;
  SkinPainter.BaseSrcRect  := Rect(0, 0, Image1.Picture.Graphic.Width, Image1.Picture.Graphic.Height);
  SkinPainter.BaseDestRect := UcPanel1.ClientRect;

  SkinPainter.PaintInfo :=
    '{sl: 0; st: 0; sw: 10; sh: 10; dl: 8; dt: 9; dw: 20; dh: 20; style: stretch}'#13#10 +
    '{sl: 0; sb: 0; sw: 10; sh: 10; dl: 8; db: 9; dw: 20; dh: 20; style: stretch}'#13#10 +
    '{sr: 0; st: 0; sw: 10; sh: 10; dr: 8; dt: 9; dw: 20; dh: 20; style: stretch}'#13#10 +
    '{sr: 0; sb: 0; sw: 10; sh: 10; dr: 8; db: 9; dw: 20; dh: 20; style: stretch}'#13#10 +

    '{sl: 10; st: 0; sw: 10; sh: 10; dl: 28; dt: 9; dr: 28; dh: 20; style: repeat-x-stretch-y}'#13#10 +
    '{sl: 0; st: 10; sw: 10; sh: 10; dl: 8; dt: 29; dw: 20; db: 29; style: repeat-y-stretch-x}'#13#10 +
    '{sl: 10; sb: 0; sw: 10; sh: 10; dl: 28; db: 9; dr: 28; dh: 20; style: repeat-x-stretch-y}'#13#10 +
    '{sr: 0; sb: 10; sw: 10; sh: 10; dr: 8; db: 29; dw: 20; dt: 29; style: repeat-y-stretch-x}'#13#10 +

    '{sl: 10; st: 10; sw: 10; sh: 10; dl: 28; dt: 29; dr: 28; db: 29; style: repeat}';

  Memo1.Lines.Text := SkinPainter.PaintInfo;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  SkinPainter.Free;
end;

procedure TForm2.Memo1Change(Sender: TObject);
begin
  SkinPainter.PaintInfo := TMemo(Sender).Text;
  UcPanel1.Invalidate;
end;

procedure TForm2.TestPaint(Cnv: TCanvas);
begin
  SkinPainter.BaseDestRect := UcPanel1.ClientRect;
  SkinPainter.Draw(Cnv);
end;

procedure TForm2.UcPanel1DrawBackground(Sender: TObject; Canvas: TCanvas);
begin
  TestPaint(Canvas);
end;

procedure TForm2.UcPanel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UC_WinSysControlCMD(TWinControl(Sender), 4, 4, 4, 4, True);
end;

procedure TForm2.UcPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  UC_WinSysControlCMD(TWinControl(Sender), 4, 4, 4, 4, False);
end;

end.

