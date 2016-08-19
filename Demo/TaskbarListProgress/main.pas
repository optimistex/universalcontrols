unit main;

interface

uses
  Forms, ComCtrls, ucWindows, ExtCtrls, Classes, Controls, StdCtrls, ucStdCtrls,
  Windows ;

type
  TMainForm = class(TForm)
    RG_Style: TRadioGroup;
    ProgressTrack: TTrackBar;
    ProgressBar1: TProgressBar;
    RG_State: TRadioGroup;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    UcLabel1: TUcLabel;
    procedure FormCreate(Sender: TObject);
    procedure ProgressTrackChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RG_StyleClick(Sender: TObject);
    procedure RG_StateClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    fTBLP: TUcTaskbarListProgress;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fTBLP := TUcTaskbarListProgress.Create;
  fTBLP.Init(Handle, ProgressBar1);

  UC_SetupSystemCursors;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fTBLP.Free;
end;

procedure TMainForm.ProgressTrackChange(Sender: TObject);
begin
  fTBLP.Position := ProgressTrack.Position;
end;

procedure TMainForm.RG_StateClick(Sender: TObject);
begin
  case RG_State.ItemIndex of
    0: fTBLP.State := pbsNormal;
    1: fTBLP.State := pbsError;
    2: fTBLP.State := pbsPaused;
  end;
end;

procedure TMainForm.RG_StyleClick(Sender: TObject);
begin
  case RG_Style.ItemIndex of
    0: fTBLP.Style := pbstNormal;
    1: fTBLP.Style := pbstMarquee;
  end;
end;

procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  fTBLP.ShowProgressOnTaskbar := TCheckBox(Sender).Checked;
end;

end.
