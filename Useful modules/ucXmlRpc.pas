// Версия - 15.08.2012
unit ucXmlRpc;
{$include ..\delphi_ver.inc}

interface

uses Classes, SysUtils, xmldom, XMLDoc, XMLIntf, Variants, DateUtils,
     ucBase64, ucTypes, ucFunctions;

type
  IUcXMLRpcBaseType     = interface;
  IUcXMLRpcCallType     = interface;
  IUcXMLRpcResponseType = interface;
  IUcXMLParamsType      = interface;
  IUcXMLParamType       = interface;
  IUcXMLValueType       = interface;
  IUcXMLAsArrayType     = interface;
  IUcXMLDataType        = interface;
  IUcXMLFaultType       = interface;

  TUcXmlRpcBase = class	// Базовый класс XML-RPC
  protected
    fXmlRpc: IUcXMLRpcBaseType; // Базовый XML документ
    function XmlRpcTag: string; virtual; abstract;
    function XmlRpcClass: TClass; virtual;

    function NewBSXmlRpc: IUcXMLRpcBaseType;
    function LoadBSXmlRpc(XMLStr: WideString): IUcXMLRpcBaseType;

    function GetXML: string;
    procedure SetXML(const Value: string);
    function GetParams: IUcXMLParamsType;
  public
    constructor Create(XMLStr: string = '');
    procedure Clear;
    property XML: string read GetXML write SetXML;
    property Params: IUcXMLParamsType read GetParams;
  end;

  TUcXmlRpcCall = class (TUcXmlRpcBase) // Класс построения/разбора запросов
  private
    function GetMetodName: string;
    procedure SetMetodName(Value: string);
    function GetXmlRpc: IUcXMLRpcCallType;
  protected
    function XmlRpcTag: string; override;
    function XmlRpcClass: TClass; override;
  public
    property XmlRpc: IUcXMLRpcCallType read GetXmlRpc; // Базовый XML документ
    property MetodName: string read GetMetodName write SetMetodName;
  end;

  TUcXmlRpcResponse = class (TUcXmlRpcBase) // Класс построения/разбора ответов
  private
    function GetFault: IUcXMLFaultType;
    function GetXmlRpc: IUcXMLRpcResponseType;
    function GetIsFault: Boolean;
  protected
    function XmlRpcTag: string; override;
    function XmlRpcClass: TClass; override;
  public
    procedure SetAsFault(FaultCode: Integer; FaultString: string);
    property XmlRpc: IUcXMLRpcResponseType read GetXmlRpc; // Базовый XML документ
    property Fault: IUcXMLFaultType read GetFault;
    property IsFault: Boolean read GetIsFault;
  end;

  //----------------------------------------------------------------------------
  IUcXMLParamsType = interface (IXMLNodeCollection)
    ['{BBB8BC02-0B5C-4404-9B73-22C5D5E06D27}']
    function Add: IUcXMLParamType;
    function AddValue: IUcXMLValueType;
    function Get_Param(Index: Integer): IUcXMLParamType;
    function Get_Value(Index: Integer): IUcXMLValueType;
    property Param[Index: Integer]: IUcXMLParamType read Get_Param;
    property Value[Index: Integer]: IUcXMLValueType read Get_Value; default;
  end;

  TUcXMLParamsType = class (TXMLNodeCollection, IUcXMLParamsType)
  protected
    function Add: IUcXMLParamType;
    function AddValue: IUcXMLValueType;
    function Get_Param(Index: Integer): IUcXMLParamType;
    function Get_Value(Index: Integer): IUcXMLValueType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------
  IUcXMLParamType = interface (IXMLNodeCollection)
    ['{BBB8BC02-0B5C-4404-9B73-22C5D5E06D27}']
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
    property Value[Index: Integer]: IUcXMLValueType read Get_Value;
  end;

  TUcXMLParamType = class (TXMLNodeCollection, IUcXMLParamType)
  protected
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------
  IXMLUcMemberType = interface (IXMLNode)
    ['{687DB7E5-AE47-4820-A284-DE1BA66AC741}']
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
    function Get_Value: IUcXMLValueType;
    property Name: WideString read Get_Name write Set_Name;
    property Value: IUcXMLValueType read Get_Value;
  end;

  TUcXMLMemberType = class (TXMLNode, IXMLUcMemberType)
  protected
    function Get_Value: IUcXMLValueType;
    function Get_Name: WideString;
    procedure Set_Name(Value: WideString);
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IXMLUcAsStructType = interface (IXMLNodeCollection)
    ['{273F95F7-4E62-4C6C-87C1-44D8CD6DAD99}']
    function Add: IXMLUcMemberType;
    function Get_Member(Index: Integer): IXMLUcMemberType;
    function Get_Value(Name: WideString): IUcXMLValueType;
    function FindMember(Name: WideString): IXMLUcMemberType;
    property Member[Index: Integer]: IXMLUcMemberType read Get_Member;
    property Value[Name: WideString]: IUcXMLValueType read Get_Value; default;
  end;

  TUcXMLAsStructType = class (TXMLNodeCollection, IXMLUcAsStructType)
  protected
    function Add: IXMLUcMemberType;
    function Get_Value(Name: WideString): IUcXMLValueType;
    function FindMember(Name: WideString): IXMLUcMemberType;
    function Get_Member(Index: Integer): IXMLUcMemberType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IUcXMLAsArrayType = interface (IXMLNode)
    ['{CBB826CD-DAFE-4739-8942-F3A34C2EF11C}']
    function Get_Data: IUcXMLDataType;
    function Get_Count: Integer;
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
    property Data: IUcXMLDataType read Get_Data;
    property Count: Integer read Get_Count;
    property Value[Index: Integer]: IUcXMLValueType read Get_Value; default;
  end;

  TUcXMLAsArrayType = class (TXMLNode, IUcXMLAsArrayType)
  protected
    function Get_Data: IUcXMLDataType;
    function Get_Count: Integer;
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IUcXMLDataType = interface (IXMLNodeCollection)
    ['{6C788454-74BC-4374-B272-0D4567E62298}']
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
    property Value[Index: Integer]: IUcXMLValueType read Get_Value; default;
  end;

  TUcXMLDataType = class (TXMLNodeCollection, IUcXMLDataType)
  protected
    function Add: IUcXMLValueType;
    function Get_Value(Index: Integer): IUcXMLValueType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IUcXMLFaultType = interface(IXMLNode)
    ['{72DB0262-6481-486E-93C4-0740B524A186}']
    function  Get_FaultCode: Integer;
    function  Get_FaultString: WideString;
    procedure Set_FaultCode(Value: Integer);
    procedure Set_FaultString(Value: WideString);

    function Get_Value: IUcXMLValueType;
    procedure Clear;
    property Value: IUcXMLValueType read Get_Value;

    property FaultCode: Integer read Get_FaultCode write Set_FaultCode;
    property FaultString: WideString read Get_FaultString write Set_FaultString;
  end;

  TUcXMLFaultType = class (TXMLNode, IUcXMLFaultType)
  protected
    function  Get_FaultCode: Integer;
    function  Get_FaultString: WideString;
    procedure Set_FaultCode(Value: Integer);
    procedure Set_FaultString(Value: WideString);

    function Get_Value: IUcXMLValueType;
    procedure Clear;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IUcXMLValueType = interface (IXMLNode)
    ['{192FD93E-6A57-4209-B99B-31F253D7CC02}']
    function GetIsBase64: Boolean;
    function GetIsDateTime: Boolean;
    function GetType: string;
    function GetVarType: Word;
    function Get_AsBase64: WideString;
    function Get_AsBoolean: Boolean;
    function Get_AsDateTimeiso8601: TDateTime;
    function Get_AsDouble: Double;
    function Get_AsInt: Integer;
    function Get_AsInt64: Int64;
    function Get_AsString: WideString;
    function Get_AsStruct: IXMLUcAsStructType;
    function Get_AsArray: IUcXMLAsArrayType;
    procedure Set_AsBase64(Value: WideString);
    procedure Set_AsBoolean(Value: Boolean);
    procedure Set_AsDateTimeiso8601(Value: TDateTime);
    procedure Set_AsDouble(Value: Double);
    procedure Set_AsInt(Value: Integer);
    procedure Set_AsInt64(Value: Int64);
    procedure Set_AsString(Value: WideString);
    property AsBase64: WideString read Get_AsBase64 write Set_AsBase64;
    property AsBoolean: Boolean read Get_AsBoolean write Set_AsBoolean;
    property AsDateTime: TDateTime read Get_AsDateTimeiso8601 write
            Set_AsDateTimeiso8601;
    property AsDouble: Double read Get_AsDouble write Set_AsDouble;
    property AsInt: Integer read Get_AsInt write Set_AsInt;
    property AsInt64: Int64 read Get_AsInt64 write Set_AsInt64;
    property AsString: WideString read Get_AsString write Set_AsString;
    property AsStruct: IXMLUcAsStructType read Get_AsStruct;
    property AsArray: IUcXMLAsArrayType read Get_AsArray;

    property IsBase64: Boolean   read GetIsBase64;
    property IsDateTime: Boolean read GetIsDateTime;
  end;

  TUcXMLValueType = class (TXMLNode, IUcXMLValueType)
  protected
    function GetIsBase64: Boolean;
    function GetIsDateTime: Boolean;

    function GetType: string;
    function GetVarType: Word;

    function Get_AsArray: IUcXMLAsArrayType;
    function Get_AsStruct: IXMLUcAsStructType;

    function Get_Value(vType: string): OleVariant;
    function Get_AsBoolean: Boolean;
    function Get_AsString: WideString;
    function Get_AsBase64: WideString;
    function Get_AsDateTimeiso8601: TDateTime;
    function Get_AsDouble: Double;
    function Get_AsInt: Integer;
    function Get_AsInt64: Int64;

    procedure Set_Value(vType: string; Value: OleVariant);
    procedure Set_AsBoolean(Value: Boolean);
    procedure Set_AsString(Value: WideString);
    procedure Set_AsBase64(Value: WideString);
    procedure Set_AsDateTimeiso8601(Value: TDateTime);
    procedure Set_AsDouble(Value: Double);
    procedure Set_AsInt(Value: Integer);
    procedure Set_AsInt64(Value: Int64);
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------
  IUcXMLRpcBaseType = interface (IXMLNode) // Базовый узел methodCall или methodResponse
    ['{33DB63CD-E8AB-444B-9167-23A3DF714A49}']
    function Get_Params: IUcXMLParamsType;
    property Params: IUcXMLParamsType read Get_Params;
  end;

  TUcXMLRpcBaseType = class (TXMLNode, IUcXMLRpcBaseType)
  protected
    function Get_Params: IUcXMLParamsType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------

  IUcXMLRpcCallType = interface (IUcXMLRpcBaseType)
    ['{3ACF4174-E2A6-423E-A0DE-5B099CD0D505}']
  end;

  TUcXMLRpcCallType = class (TUcXMLRpcBaseType, IUcXMLRpcCallType);

  //----------------------------------------------------------------------------

  IUcXMLRpcResponseType = interface (IUcXMLRpcBaseType)
    ['{0583BFED-A9AA-4382-A163-B4616D8CF0B4}']
    function Get_Fault: IUcXMLFaultType;
    property Fault: IUcXMLFaultType read Get_Fault;
  end;

  TUcXMLRpcResponseType = class (TUcXMLRpcBaseType, IUcXMLRpcResponseType)
  protected
    function Get_Fault: IUcXMLFaultType;
  public
    procedure AfterConstruction; override;
  end;

  //----------------------------------------------------------------------------
  //****************************************************************************
  function EncodeDateTimeISO8601(DT: TDateTime): string;
  function DecodeDateTimeISO8601(DTs: string): TDateTime;

  function EncodeBoolean(Bi: Integer): Boolean;
  function DecodeBoolean(B: Boolean): Integer;

  function EnecodeDouble(Ds: string): Double;
  function DecodeDouble(D: Double): string;

const
  TargetNamespace = '';
  XML10Tag = '?xml version="1.0"?';

implementation

{ FUNCTIONS }

function EncodeDateTimeISO8601(DT: TDateTime): string;
begin
  Result := UC_EncodeDateTimeISO8601(DT);
//  Result := FormatDateTime('yyyymmdd"T"hh:nn:ss', DT);
end;

function DecodeDateTimeISO8601(DTs: string): TDateTime;
//var
//  DT: TDateTime;
begin
  Result := UC_DecodeDateTimeISO8601(DTs);
//  if (Copy(DTs, 9, 1) = 'T')
//      and (TryEncodeDateTime(StrToInt(Copy(DTs, 1, 4)), StrToInt(Copy(DTs, 5, 2)), StrToInt(Copy(DTs, 7, 2)),
//      StrToInt(Copy(DTs, 10, 2)), StrToInt(Copy(DTs, 13, 2)), StrToInt(Copy(DTs, 16, 2)), 0, DT)) then
//    Result := DT
//  else
//    raise Exception.CreateFmt('Invalid ISO-8601 date/time: %s.', [DTs]);
end;

function EncodeBoolean(Bi: Integer): Boolean;
begin
  Result := Bi = DecodeBoolean(True);
end;

function DecodeBoolean(B: Boolean): Integer;
begin
  Result := Ord(B);
end;

function EnecodeDouble(Ds: string): Double;
begin
  if (DecimalSeparator <> '.') then
    Ds := StringReplace(Ds, '.', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloat(Ds);
end;

function DecodeDouble(D: Double): string;
begin
  Result := FloatToStr(D);
  if (DecimalSeparator <> '.') then
    Result := StringReplace(Result, DecimalSeparator, '.', [rfReplaceAll]);
end;

{ TUcXmlRpc }
procedure TUcXmlRpcBase.Clear;
begin
  fXmlRpc.ChildNodes.Clear;
end;

constructor TUcXmlRpcBase.Create(XMLStr: string);
begin
  if (XMLStr <> '') then
    XML := XMLStr
  else
    fXmlRpc := NewBSXmlRpc;
end;

function TUcXmlRpcBase.GetParams: IUcXMLParamsType;
begin
  Result := fXmlRpc.Params;
end;

function TUcXmlRpcBase.GetXML: string;
var ss: TStringStream;
begin
//  Result := '<' + XML10Tag + '>' + fXmlRpc.XML;
//  Result := fXmlRpc.OwnerDocument.XML.Text;
  {$IFDEF DELPHI_2009_UP}
  ss := TStringStream.Create('', TUTF8Encoding.Create);
  {$ELSE}
  ss := TStringStream.Create('');
  {$ENDIF}
  try
    fXmlRpc.OwnerDocument.SaveToStream(ss);
    Result := ss.DataString;
  finally
    ss.Free;
  end;
end;

function TUcXmlRpcBase.LoadBSXmlRpc(XMLStr: WideString): IUcXMLRpcBaseType;
begin
//  XMLStr := StringReplace(XMLStr, '<' + XML10Tag + '>', '', [rfReplaceAll]);
  Result := LoadXMLData(XMLStr).GetDocBinding(XmlRpcTag, XmlRpcClass, TargetNamespace) as IUcXMLRpcBaseType;
  Result.OwnerDocument.Encoding := 'UTF-8';
end;

function TUcXmlRpcBase.NewBSXmlRpc: IUcXMLRpcBaseType;
//var doc: IXMLDocument;
begin
//  doc := NewXMLDocument;
//  doc.Encoding := 'UTF-8';
  Result := NewXMLDocument.GetDocBinding(XmlRpcTag, XmlRpcClass, TargetNamespace) as IUcXMLRpcBaseType;
  Result.OwnerDocument.Encoding := 'UTF-8';
end;

procedure TUcXmlRpcBase.SetXML(const Value: string);
begin
  fXmlRpc := LoadBSXmlRpc(Value);
end;

function TUcXmlRpcBase.XmlRpcClass: TClass;
begin
  Result := TUcXMLRpcBaseType;
end;

{ TUcXmlRpcCall }

function TUcXmlRpcCall.GetMetodName: string;
begin
  if Assigned(XmlRpc.ChildNodes.FindNode('methodName')) then
    Result := XmlRpc.ChildNodes['methodName'].Text
    else
    Result := '';
end;

function TUcXmlRpcCall.GetXmlRpc: IUcXMLRpcCallType;
begin
  Result := fXmlRpc as IUcXMLRpcCallType;
end;

procedure TUcXmlRpcCall.SetMetodName(Value: string);
begin
  XmlRpc.ChildNodes['methodName'].Text := Value;
end;

function TUcXmlRpcCall.XmlRpcClass: TClass;
begin
  Result := TUcXMLRpcCallType;
end;

function TUcXmlRpcCall.XmlRpcTag: string;
begin
  Result := 'methodCall';
end;

{ TXMLUcXmlRpcType }

procedure TUcXMLRpcBaseType.AfterConstruction;
begin
  RegisterChildNode('params', TUcXMLParamsType);
  inherited;
end;

function TUcXMLRpcBaseType.Get_Params: IUcXMLParamsType;
begin
  Result := ChildNodes['params'] as IUcXMLParamsType;
end;

{ TXMLUcParamsType }

function TUcXMLParamsType.Add: IUcXMLParamType;
begin
  Result := AddItem(-1) as IUcXMLParamType;
end;

function TUcXMLParamsType.AddValue: IUcXMLValueType;
var NewCount: Integer;
begin
  NewCount := Count + 1;
  while Count < NewCount do Add;

  if Get_Param(Count - 1).Count = 0 then
    Result := Get_Param(Count - 1).Add
    else
    Result := Get_Param(Count - 1).Value[0];
end;

procedure TUcXMLParamsType.AfterConstruction;
begin
  RegisterChildNode('param', TUcXMLParamType);
  ItemTag := 'param';
  ItemInterface := IUcXMLParamType;
  inherited;
end;

function TUcXMLParamsType.Get_Param(Index: Integer): IUcXMLParamType;
begin
  Result := List[Index] as IUcXMLParamType;
end;

function TUcXMLParamsType.Get_Value(Index: Integer): IUcXMLValueType;
begin
  while Count <= Index do Add;

  if Get_Param(Index).Count = 0 then
    Result := Get_Param(Index).Add
    else
    Result := Get_Param(Index).Value[0];
end;

{ TXMLUcParamType }

function TUcXMLParamType.Add: IUcXMLValueType;
begin
  Result := AddItem(-1) as IUcXMLValueType;
end;

procedure TUcXMLParamType.AfterConstruction;
begin
  RegisterChildNode('value', TUcXMLValueType);
  ItemTag := 'value';
  ItemInterface := IUcXMLValueType;
  inherited;
end;

function TUcXMLParamType.Get_Value(Index: Integer): IUcXMLValueType;
begin
  Result := List[Index] as IUcXMLValueType;
end;

{ TXMLUcValueType }

procedure TUcXMLValueType.AfterConstruction;
begin
  RegisterChildNode('array', TUcXMLAsArrayType);
  RegisterChildNode('struct', TUcXMLAsStructType);
  inherited;
end;

function TUcXMLValueType.GetIsBase64: Boolean;
begin
  Result := GetType = 'base64';
end;

function TUcXMLValueType.GetIsDateTime: Boolean;
begin
  Result := GetType = 'dateTime.iso8601';
end;

function TUcXMLValueType.GetType: string;
begin
  if GetIsTextElement or (ChildNodes.Count = 0) then
    Result := 'unknown'
    else
    Result := ChildNodes[0].NodeName;
end;

function TUcXMLValueType.GetVarType: Word;
var SelfType: string;
begin
  SelfType := GetType;

  if SelfType = 'boolean'               then Result := varBoolean
  else if SelfType = 'dateTime.iso8601' then Result := varDate
  else if SelfType = 'double'           then Result := varDouble
  else if SelfType = 'i4'               then Result := varInteger
  else if SelfType = 'int'              then Result := varInt64
  else if SelfType = 'string'           then Result := varString
  else if SelfType = 'base64'           then Result := varString
  else if SelfType = 'struct'           then Result := varVariant
  else if SelfType = 'array'            then Result := varArray
  else Result := varUnknown; // if vType = 'unknown'
end;

function TUcXMLValueType.Get_AsArray: IUcXMLAsArrayType;
begin
  if GetType <> 'array' then ChildNodes.Clear;
  Result := ChildNodes['array'] as IUcXMLAsArrayType;
end;

function TUcXMLValueType.Get_AsBase64: WideString;
begin
  Result := Get_Value('base64'); //ChildNodes['base64'].Text;
end;

function TUcXMLValueType.Get_AsBoolean: Boolean;
begin
  Result := Get_Value('boolean');
end;

function TUcXMLValueType.Get_AsDateTimeiso8601: TDateTime;
begin
  Result := Get_Value('dateTime.iso8601'); //ChildNodes['dateTime.iso8601'].Text;
end;

function TUcXMLValueType.Get_AsDouble: Double;
begin
  Result := Get_Value('double'); //ChildNodes['double'].Text;
end;

function TUcXMLValueType.Get_AsInt: Integer;
begin
  Result := Get_Value('i4'); //ChildNodes['i4'].NodeValue;
end;

function TUcXMLValueType.Get_AsInt64: Int64;
begin
  Result := Get_Value('int'); //ChildNodes['int'].NodeValue;
end;

function TUcXMLValueType.Get_AsString: WideString;
begin
  Result := Get_Value('string');
end;

function TUcXMLValueType.Get_AsStruct: IXMLUcAsStructType;
begin
  if GetType <> 'struct' then ChildNodes.Clear;
  Result := ChildNodes['struct'] as IXMLUcAsStructType;
end;

function TUcXMLValueType.Get_Value(vType: string): OleVariant;
var Node: IXMLNode;
    SelfType: string;
begin
  SelfType := GetType;
  if SelfType = 'unknown' then
    Node := Self
  else
    Node := ChildNodes[GetType];

  if Node.IsTextElement then
  begin
    if vType = 'boolean'               then Result := StrToBoolDef(Node.Text, False)
    else if vType = 'dateTime.iso8601' then Result := DecodeDateTimeISO8601(Node.Text)
    else if vType = 'double'           then Result := StrToFloatDef(Node.Text, 0)
    else if vType = 'i4'               then Result := StrToIntDef(Node.Text, 0)
    else if vType = 'int'              then Result := StrToInt64Def(Node.Text, 0)
    else if vType = 'string'           then Result := Node.Text
    else if vType = 'base64'           then Result := string(base64_decode(Node.Text))
    else Result := Node; // if vType = 'unknown'
  end else
  begin
    if vType = 'boolean'               then Result := False
    else if vType = 'dateTime.iso8601' then Result := 0
    else if vType = 'double'           then Result := 0
    else if vType = 'i4'               then Result := 0
    else if vType = 'int'              then Result := 0
    else if vType = 'string'           then Result := ''
    else if vType = 'base64'           then Result := ''
    else Result := Node; // if vType = 'unknown'
  end;
end;

procedure TUcXMLValueType.Set_AsBase64(Value: WideString);
begin
  Set_Value('base64', Value);
end;

procedure TUcXMLValueType.Set_AsBoolean(Value: Boolean);
begin
  Set_Value('boolean', Value);
end;

procedure TUcXMLValueType.Set_AsDateTimeiso8601(Value: TDateTime);
begin
  Set_Value('dateTime.iso8601', Value);
end;

procedure TUcXMLValueType.Set_AsDouble(Value: Double);
begin
  Set_Value('double', Value);
end;

procedure TUcXMLValueType.Set_AsInt(Value: Integer);
begin
  Set_Value('i4', Value);
end;

procedure TUcXMLValueType.Set_AsInt64(Value: Int64);
begin
  Set_Value('int', Value);
end;

procedure TUcXMLValueType.Set_AsString(Value: WideString);
begin
  Set_Value('string', Value);
end;

procedure TUcXMLValueType.Set_Value(vType: string; Value: OleVariant);
begin
  if GetType <> vType then ChildNodes.Clear;

  if vType = 'boolean'               then ChildNodes[vType].NodeValue := integer(Boolean(Value))
  else if vType = 'dateTime.iso8601' then ChildNodes[vType].NodeValue := EncodeDateTimeISO8601(Value)
  else if vType = 'double'           then ChildNodes[vType].NodeValue := Value
  else if vType = 'i4'               then ChildNodes[vType].NodeValue := Value
  else if vType = 'int'              then ChildNodes[vType].NodeValue := Value
  else if vType = 'string'           then ChildNodes[vType].NodeValue := Value
  else if vType = 'base64'           then ChildNodes[vType].NodeValue := base64_encode(RawByteString(Value))
  else ChildNodes[vType].NodeValue := Value; // if vType = 'unknown'
end;

{ TXMLUcAsStructType }

function TUcXMLAsStructType.Add: IXMLUcMemberType;
begin
  Result := AddItem(-1) as IXMLUcMemberType;
end;

procedure TUcXMLAsStructType.AfterConstruction;
begin
  RegisterChildNode('member', TUcXMLMemberType);
  ItemTag := 'member';
  ItemInterface := IXMLUcMemberType;
  inherited;
end;

function TUcXMLAsStructType.FindMember(Name: WideString): IXMLUcMemberType;
var i: integer;
begin
  for i := 0 to Count - 1 do
    if AnsiUpperCase(Get_Member(i).Name) = AnsiUpperCase(Name) then
    begin
      Result := Get_Member(i);
      Exit;
    end;
  Result := nil;
end;

function TUcXMLAsStructType.Get_Member(Index: Integer): IXMLUcMemberType;
begin
  Result := List[Index] as IXMLUcMemberType;
end;

function TUcXMLAsStructType.Get_Value(Name: WideString): IUcXMLValueType;
var vMember: IXMLUcMemberType;
begin
  vMember := FindMember(Name);
  if not Assigned(vMember) then
  begin
    vMember := Add;
    vMember.Name := Name;
  end;
  Result := vMember.Value;
end;

{ TXMLUcMemberType }

procedure TUcXMLMemberType.AfterConstruction;
begin
  RegisterChildNode('value', TUcXMLValueType);
  inherited;
end;

function TUcXMLMemberType.Get_Name: WideString;
begin
  Result := ChildNodes['name'].Text;
end;

function TUcXMLMemberType.Get_Value: IUcXMLValueType;
begin
  Result := ChildNodes['value'] as IUcXMLValueType;
end;

procedure TUcXMLMemberType.Set_Name(Value: WideString);
begin
  ChildNodes['name'].Text := Value;
end;

{ TXMLAsArrayType }

function TUcXMLAsArrayType.Add: IUcXMLValueType;
begin
  Result := Get_Data.Add;
end;

procedure TUcXMLAsArrayType.AfterConstruction;
begin
  inherited;
  RegisterChildNode('data', TUcXMLDataType);
end;

function TUcXMLAsArrayType.Get_Count: Integer;
begin
  Result := Get_Data.Count;
end;

function TUcXMLAsArrayType.Get_Data: IUcXMLDataType;
begin
  Result := ChildNodes['data'] as IUcXMLDataType;
end;

function TUcXMLAsArrayType.Get_Value(Index: Integer): IUcXMLValueType;
begin
  while Get_Count <= Index do Add;

  Result := Get_Data.Value[Index];
end;

{ TXMLUcDataType }

function TUcXMLDataType.Add: IUcXMLValueType;
begin
  Result := AddItem(-1) as IUcXMLValueType;
end;

procedure TUcXMLDataType.AfterConstruction;
begin
  RegisterChildNode('value', TUcXMLValueType);
  ItemTag := 'value';
  ItemInterface := IUcXMLValueType;
  inherited;
end;

function TUcXMLDataType.Get_Value(Index: Integer): IUcXMLValueType;
begin
  Result := List[Index] as IUcXMLValueType;
end;

{ TUcXmlRpcResponse }

function TUcXmlRpcResponse.GetFault: IUcXMLFaultType;
begin
  Result := XmlRpc.Fault;
end;

function TUcXmlRpcResponse.GetIsFault: Boolean;
begin
  Result := Assigned(XmlRpc.ChildNodes.FindNode('fault')) and
            Assigned(Fault.ChildNodes.FindNode('value')) and
            (Fault.FaultCode > 0);
end;

function TUcXmlRpcResponse.GetXmlRpc: IUcXMLRpcResponseType;
begin
  Result := fXmlRpc as IUcXMLRpcResponseType;
end;

procedure TUcXmlRpcResponse.SetAsFault(FaultCode: Integer; FaultString: string);
begin
  Fault.FaultCode := FaultCode;
  Fault.FaultString     := FaultString;
end;

function TUcXmlRpcResponse.XmlRpcClass: TClass;
begin
  Result := TUcXMLRpcResponseType;
end;

function TUcXmlRpcResponse.XmlRpcTag: string;
begin
  Result := 'methodResponse';
end;

{ TUcXMLFaultType }

procedure TUcXMLFaultType.AfterConstruction;
begin
  RegisterChildNode('value', TUcXMLValueType);
  inherited;
end;

procedure TUcXMLFaultType.Clear;
begin
  ChildNodes.Clear;
end;

function TUcXMLFaultType.Get_FaultCode: Integer;
begin
  Result := Get_Value.AsStruct['faultCode'].AsInt;
end;

function TUcXMLFaultType.Get_FaultString: WideString;
begin
  Result := Get_Value.AsStruct['faultString'].AsString;
end;

function TUcXMLFaultType.Get_Value: IUcXMLValueType;
begin
  Result := ChildNodes['value'] as IUcXMLValueType;
end;

procedure TUcXMLFaultType.Set_FaultCode(Value: Integer);
begin
  Get_Value.AsStruct['faultCode'].AsInt := Value;
end;

procedure TUcXMLFaultType.Set_FaultString(Value: WideString);
begin
  Get_Value.AsStruct['faultString'].AsString := Value;
end;

{ TUcXMLRpcResponseType }

procedure TUcXMLRpcResponseType.AfterConstruction;
begin
  RegisterChildNode('fault', TUcXMLFaultType);
  inherited;
end;

function TUcXMLRpcResponseType.Get_Fault: IUcXMLFaultType;
begin
  Result := ChildNodes['fault'] as IUcXMLFaultType;
end;

end.
