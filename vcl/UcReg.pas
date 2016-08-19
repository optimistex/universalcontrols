// Версия - 08.05.2013
unit UcReg;
{$include ..\delphi_ver.inc}

interface

uses
  Windows, SysUtils, Classes, Math, Graphics, ImgList, Forms, TypInfo, Controls,
  DesignEditors, DesignIntf, VCLEditors,
  UcButtons, ucSkin, ucGraphics, ucSkinEditor, ucTypes;

type
  TUcButtonImageIndexProperty = class(TIntegerProperty, ICustomPropertyListDrawing)
  protected
    function GetImages: TCustomImageList; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure SetValue(const Value: string); override;
    procedure GetValues(Proc: TGetStrProc); override;
    procedure ListMeasureWidth(const Value: string; ACanvas: TCanvas; var AWidth: integer);
    procedure ListMeasureHeight(const Value: string; ACanvas: TCanvas; var AHeight: integer);
    procedure ListDrawValue(const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: boolean);
  end;

  TUcPaintInfoProperty = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TUcSkinNameProperty = class(TPropertyEditor)
  protected
    function GetSkinManager: TUcSkinManager; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure SetValue(const Value: string); override;
    function GetValue: string; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  // TUcButtonImageIndexProperty
  RegisterPropertyEditor(TypeInfo(TImageIndex), TButtonImages, 'IndexImgUp',
                          TUcButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TButtonImages, 'IndexImgDisabled',
                          TUcButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TButtonImages, 'IndexImgDown',
                          TUcButtonImageIndexProperty);
  RegisterPropertyEditor(TypeInfo(TImageIndex), TButtonImages, 'IndexImgHot',
                          TUcButtonImageIndexProperty);
  // TUcPainterProperty
  RegisterPropertyEditor(TypeInfo(TUcPaintInfoStr), nil, '',
                          TUcPaintInfoProperty);
  // TUcSkinNameProperty
  RegisterPropertyEditor(TypeInfo(TUcSkinName), nil, 'SkinName',
                          TUcSkinNameProperty);
end;

{ TUcButtonImageIndexProperty }

function TUcButtonImageIndexProperty.GetImages: TCustomImageList;
var EditedComponent: TPersistent;
begin
  Result:=nil;
  try
    EditedComponent:=GetComponent(0) as TPersistent;
    if (EditedComponent <> nil)and(EditedComponent is TButtonImages) then
      Result := (EditedComponent as TButtonImages).BtnImages;
  except
  end;
end;

function TUcButtonImageIndexProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=[paMultiSelect, paValueList];
end;

procedure TUcButtonImageIndexProperty.SetValue(const Value: string);
begin
  if Value = '' then
    inherited SetValue('-1')
  else
    inherited SetValue(Value)
end;

procedure TUcButtonImageIndexProperty.GetValues(Proc: TGetStrProc);
var
  ImageList: TCustomImageList;
  i: integer;
begin
  Proc('-1');
  ImageList:=GetImages;
  if ImageList <> nil then
    for i:=0 to ImageList.Count-1 do
      Proc(inttostr(i));
end;

procedure TUcButtonImageIndexProperty.ListDrawValue(const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: boolean);
var
  ImageList: TCustomImageList;
  vRight, vTop: integer;
  ImageIndex: integer;
begin
  ImageList:=GetImages;
  if ImageList <> nil then
    begin
      if ImageList.Count = 0 then exit;
      vRight:=ARect.Left + ImageList.Width + 4;
      with ACanvas do
        begin
          ImageIndex:=StrToInt(Value);
          ACanvas.FillRect(ARect);
          if ImageIndex = -1 then exit;
            ImageList.Draw(ACanvas, ARect.Left + 2, ARect.Top + 2, ImageIndex, true);
          vTop:=ARect.Top + ((ARect.Bottom - ARect.Top - ACanvas.TextHeight(inttostr(ImageIndex))) div 2);
          ACanvas.TextOut(vRight, vTop, inttostr(ImageIndex))
        end
    end
end;

procedure TUcButtonImageIndexProperty.ListMeasureWidth(const Value: string; ACanvas: TCanvas; var AWidth: integer);
var
  ImageList: TCustomImageList;
begin
  ImageList:=GetImages;
  if ImageList <> nil then
    if ImageList.Count > 0 then
      AWidth:=AWidth + ImageList.Width + 4
end;

procedure TUcButtonImageIndexProperty.ListMeasureHeight(const Value: string; ACanvas: TCanvas; var AHeight: integer);
var
  ImageList: TCustomImageList;
begin
  ImageList:=GetImages;
  if ImageList <> nil then
    if ImageList.Count > 0 then
      if Value = '-1' then
        AHeight:=0
      else
        AHeight:=Max(AHeight, ImageList.Height + 4)
end;

{ TUcPainterProperty }

procedure TUcPaintInfoProperty.Edit;
var EditedComponent: TPersistent;
    sc: TUcSkinCollectionItem;
begin
  try
    EditedComponent := GetComponent(0) as TPersistent;
    if (EditedComponent <> nil) and (EditedComponent is TUcSkinCollectionItem) then
    begin
      sc := (EditedComponent as TUcSkinCollectionItem);
      with TPaintInfoEditor.Create(Application) do
      try
        Init(sc.Image.Graphic, sc.PaintInfo);
        if ShowModal = mrOk then
          sc.PaintInfo := Style;
      finally
        Free;
      end;
    end;
  except
  end
end;

function TUcPaintInfoProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paRevertable, paReadOnly];
end;

function TUcPaintInfoProperty.GetValue: string;
var EditedComponent: TPersistent;
begin
  try
    EditedComponent := GetComponent(0) as TPersistent;
    if (EditedComponent <> nil) and (EditedComponent is TUcSkinCollectionItem) then
      Result := (EditedComponent as TUcSkinCollectionItem).PaintInfo
      else
      Result := '';
  except
  end
end;

{ TUcSkinNameProperty }

function TUcSkinNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=[paMultiSelect, paValueList]
end;

function TUcSkinNameProperty.GetSkinManager: TUcSkinManager;
var EditedComponent: TPersistent;
begin
  Result := nil;
  try
    EditedComponent := GetComponent(0) as TPersistent;
    if Assigned(EditedComponent) then
    begin
      if EditedComponent is TButtonImages then
        Result := (EditedComponent as TButtonImages).SkinManager
        else
        Result := TUcSkinManager(GetObjectProp(EditedComponent, 'SkinManager', TUcSkinManager));
    end;
  except
  end;
end;

function TUcSkinNameProperty.GetValue: string;
begin
  Result := GetStrValueAt(0);
end;

procedure TUcSkinNameProperty.GetValues(Proc: TGetStrProc);
var i: integer;
    Sm: TUcSkinManager;
begin
  Sm := GetSkinManager;
  if Assigned(Sm) then
    for i := 0 to Sm.Painters.Count - 1 do
      Proc(Sm.Painters.Items[i].Name);
end;

procedure TUcSkinNameProperty.SetValue(const Value: string);
begin
  SetStrValue(Value);
end;

end.
