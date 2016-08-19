unit ucSkin;

interface

uses Windows, SysUtils, Classes, Controls, Graphics, Math, StrUtils, Contnrs,
     ucGraphics, ucTypes, ucFunctions, ucClasses, pngimage;

type
  TUcSkinCollectionItem = class(TCollectionItem)
  private
    FName: string;
    fPaintInfo: TUcPaintInfoStr;
    procedure SetName(const Value: string);
    procedure SetPaintInfo(const Value: TUcPaintInfoStr);
    function GetImage: TPicture;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    property Image: TPicture read GetImage;
  published
    property Name: string read FName write SetName;
    property PaintInfo: TUcPaintInfoStr read fPaintInfo write SetPaintInfo;
  end;

  TUcSkinManager = class;

  TUcSkinCollection = class(TCollection)
  private
    fSkinManager: TUcSkinManager;
    function GetItem(Index: Integer): TUcSkinCollectionItem;
    procedure SetItem(Index: Integer; const Value: TUcSkinCollectionItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(ItemClass: TCollectionItemClass; OwnSkinManager: TUcSkinManager);
    property Items[Index: Integer]: TUcSkinCollectionItem read GetItem write SetItem;
    property SkinManager: TUcSkinManager read fSkinManager;
  end;

  TUcSkinManager = class(TComponent)
  private
    fPainters: TUcSkinCollection;
    fImage: Pointer;
    fNotifyHelper: TUcNotifyHelper;
    fChangedItem: TCollectionItem;
    fChangeInfo: TUcSkinChangeInfo;
    procedure SetPainters(const Value: TUcSkinCollection);
    function GetImage: TPicture;
    procedure SetImage(const Value: TPicture);
    function GetVersion: TCaption;
    procedure SetVersion(const Value: TCaption);
  protected
    procedure Notify;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CreateSkinPainterByStyleName(SkinName: string): TUcSkinPainter;
    procedure RegisterNotify(NotifyEvent: TNotifyEvent);
    procedure UnregisterNotify(NotifyEvent: TNotifyEvent);
    property ChangedItem: TCollectionItem read fChangedItem;
    property ChangeInfo: TUcSkinChangeInfo read fChangeInfo;
  published
    property Version: TCaption read GetVersion write SetVersion stored False;
    property Painters: TUcSkinCollection read fPainters write SetPainters;
    property Image: TPicture  read GetImage write SetImage;
  end;

procedure Register;

implementation

{$R *.dcr}
{$Include ..\Versions.ucver}

procedure Register;
begin
  RegisterComponents('UControls', [TUcSkinManager]);
end;

{ TUcSkinManager }

constructor TUcSkinManager.Create(AOwner: TComponent);
begin
  inherited;
  fChangedItem := nil;
  fChangeInfo  := sciNone;

  fNotifyHelper := TUcNotifyHelper.Create(Self);
  fImage    := TPicture.Create;
  fPainters := TUcSkinCollection.Create(TUcSkinCollectionItem, Self);
end;

destructor TUcSkinManager.Destroy;
begin
  fPainters.Free;
  TPicture(fImage).Free;
  fNotifyHelper.DisableNotification;
  fNotifyHelper.Free;
  inherited;
end;

function TUcSkinManager.CreateSkinPainterByStyleName(
  SkinName: string): TUcSkinPainter;
var i: Integer;
begin
  Result := nil;
  if Assigned(Painters) and Assigned(Image.Graphic) then
  begin
    for i := 0 to Painters.Count - 1 do
      if CompareText(Painters.Items[i].Name, SkinName) = 0 then
      begin
        Result := TUcSkinPainter.Create;
        Result.SourceIMG := Image.Graphic;
        Result.PaintInfo := Painters.Items[i].PaintInfo;
        Break;
      end;
  end;
end;

function TUcSkinManager.GetImage: TPicture;
begin
  Result:= TPicture(fImage);
end;

function TUcSkinManager.GetVersion: TCaption;
begin
  Result:= UcSkinVersion;
end;

procedure TUcSkinManager.Notify;
begin
  fNotifyHelper.Notify;
end;

procedure TUcSkinManager.RegisterNotify(NotifyEvent: TNotifyEvent);
begin
  fNotifyHelper.RegisterNotify(NotifyEvent);
end;

procedure TUcSkinManager.SetImage(const Value: TPicture);
begin
  TPicture(fImage).Assign(Value);
  try
    fChangeInfo := sciImage;
    Notify;
  finally
    fChangeInfo := sciNone;
  end;
end;

procedure TUcSkinManager.SetPainters(const Value: TUcSkinCollection);
begin
  fPainters.Assign(Value);
end;

procedure TUcSkinManager.SetVersion(const Value: TCaption);
begin
  //--
end;

procedure TUcSkinManager.UnregisterNotify(NotifyEvent: TNotifyEvent);
begin
  fNotifyHelper.UnregisterNotify(NotifyEvent);
end;

{ TUcSkinCollectionItem }

constructor TUcSkinCollectionItem.Create(Collection: TCollection);
begin
  inherited;
  fPaintInfo := '';
end;

function TUcSkinCollectionItem.GetDisplayName: string;
begin
  Result := FName;
end;

function TUcSkinCollectionItem.GetImage: TPicture;
begin
  if (Collection is TUcSkinCollection) and
     Assigned((Collection as TUcSkinCollection).SkinManager) then
    Result := (Collection as TUcSkinCollection).SkinManager.Image
    else
    Result := nil;
end;

procedure TUcSkinCollectionItem.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    Changed(False);
  end;
end;

procedure TUcSkinCollectionItem.SetPaintInfo(const Value: TUcPaintInfoStr);
begin
  if fPaintInfo <> Value then
  begin
    fPaintInfo := Value;
    Changed(False);
  end;
end;

{ TUcSkinCollection }

constructor TUcSkinCollection.Create(ItemClass: TCollectionItemClass;
                                     OwnSkinManager: TUcSkinManager);
begin
  inherited Create(ItemClass);
  fSkinManager := OwnSkinManager;
end;

function TUcSkinCollection.GetItem(Index: Integer): TUcSkinCollectionItem;
begin
  Result := TUcSkinCollectionItem(inherited GetItem(Index));
end;

procedure TUcSkinCollection.SetItem(Index: Integer;
  const Value: TUcSkinCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TUcSkinCollection.Update(Item: TCollectionItem);
begin
  inherited;
  try
    fSkinManager.fChangedItem := Item;
    fSkinManager.fChangeInfo  := sciStyle;
    fSkinManager.Notify;
  finally
    fSkinManager.fChangeInfo  := sciNone;
    fSkinManager.fChangedItem := nil;
  end;
end;

end.
