unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UcButtons, StdCtrls, ucStdCtrls, pngimage, ucSkin, ExtCtrls,
  ucExtCtrls, ucFunctions, ActnList, UcTimer;

type
  TForm2 = class(TForm)
    UcButton1: TUcButton;
    UcWinButton1: TUcWinButton;
    UcPanel1: TUcPanel;
    UcPanel2: TUcPanel;
    UcPanel3: TUcPanel;
    UcSkinManager: TUcSkinManager;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
