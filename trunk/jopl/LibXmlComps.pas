(**
===============================================================================================
Name    : LibXmlComps
===============================================================================================
Project : All Projects processing XML documents
===============================================================================================
Subject : XML parser for Delphi's VCL toolbar
===============================================================================================
Dipl.-Ing. (FH) Stefan Heymann, Softwaresysteme, Tübingen, Germany
===============================================================================================
Date        Author Changes
-----------------------------------------------------------------------------------------------
2000-03-31  HeySt  1.0.0  Start
2000-07-27  HeySt  1.0.1  Added "TAttr" declaration
                          Moved GetNormalize/SetNormalize to PROTECTED section
2001-02-03  HeySt         Changed prototype for the TExternalEvent callback function type
                          so that C++Builder users should get it compiled better.

2001-02-28         1.0.2  Introduced the "StopParser" property. When you set this property to
                          TRUE in one of the Parser Events, parsing is stopped and the Execute
                          method returns.
                          Introduced Version numbers
*)

UNIT LibXmlComps;

INTERFACE

USES
    {$ifdef Win32}
    Windows,
    {$endif}
    SysUtils, Classes,
    LibXmlParser;

TYPE
  TXmlScanner     = CLASS;
  TAttr           = LibXmlParser.TAttr;
  TAttrList       = LibXmlParser.TAttrList;
  TElemDef        = LibXmlParser.TElemDef;
  TEntityDef      = LibXmlParser.TEntityDef;
  TNotationDef    = LibXmlParser.TNotationDef;
  TXmlParser      = LibXmlParser.TXmlParser;
  TXmlPrologEvent = PROCEDURE (Sender : TObject; XmlVersion, Encoding: STRING; Standalone : BOOLEAN) OF OBJECT;
  TCommentEvent   = PROCEDURE (Sender : TObject; Comment : STRING) OF OBJECT;
  TPIEvent        = PROCEDURE (Sender : TObject; Target, Content: STRING; Attributes : TAttrList) OF OBJECT;
  TDtdEvent       = PROCEDURE (Sender : TObject; RootElementName : STRING) OF OBJECT;
  TStartTagEvent  = PROCEDURE (Sender : TObject; TagName : STRING; Attributes : TAttrList) OF OBJECT;
  TEndTagEvent    = PROCEDURE (Sender : TObject; TagName : STRING) OF OBJECT;
  TContentEvent   = PROCEDURE (Sender : TObject; Content : STRING) OF OBJECT;
  TElementEvent   = PROCEDURE (Sender : TObject; ElemDef : TElemDef) OF OBJECT;
  TEntityEvent    = PROCEDURE (Sender : TObject; EntityDef : TEntityDef) OF OBJECT;
  TNotationEvent  = PROCEDURE (Sender : TObject; NotationDef : TNotationDef) OF OBJECT;
  TErrorEvent     = PROCEDURE (Sender : TObject; ErrorPos : PChar) OF OBJECT;
  TExternalEvent  = PROCEDURE (Sender : TObject; SystemId, PublicId, NotationId : STRING; VAR Result : TXmlParser) OF OBJECT;
  TEncodingEvent  = FUNCTION  (Sender : TObject; CurrentEncoding, Source : STRING) : STRING OF OBJECT;


  TXmlScanner = CLASS (TComponent)
                PROTECTED
                  FXmlParser           : TXmlParser;
                  FOnXmlProlog         : TXmlPrologEvent;
                  FOnComment           : TCommentEvent;
                  FOnPI                : TPIEvent;
                  FOnDtdRead           : TDtdEvent;
                  FOnStartTag          : TStartTagEvent;
                  FOnEmptyTag          : TStartTagEvent;
                  FOnEndTag            : TEndTagEvent;
                  FOnContent           : TContentEvent;
                  FOnCData             : TContentEvent;
                  FOnElement           : TElementEvent;
                  FOnAttList           : TElementEvent;
                  FOnEntity            : TEntityEvent;
                  FOnNotation          : TNotationEvent;
                  FOnDtdError          : TErrorEvent;
                  FOnLoadExternal      : TExternalEvent;
                  FOnTranslateEncoding : TEncodingEvent;
                  FStopParser          : BOOLEAN;
                  FUNCTION  GetNormalize : BOOLEAN;
                  PROCEDURE SetNormalize (Value : BOOLEAN);

                PUBLIC
                  CONSTRUCTOR Create (AOwner: TComponent); OVERRIDE;
                  DESTRUCTOR Destroy;                      OVERRIDE;

                  PROCEDURE LoadFromFile   (Filename : STRING);   // Load XML Document from file
                  PROCEDURE LoadFromBuffer (Buffer : PChar);      // Load XML Document from buffer
                  PROCEDURE SetBuffer      (Buffer : PChar);      // Refer to Buffer
                  FUNCTION  GetFilename : STRING;

                  PROCEDURE Execute;                              // Perform scanning
                  PROPERTY  XmlParser  : TXmlParser READ FXmlParser;
                  PROPERTY  StopParser : BOOLEAN    READ FStopParser  WRITE FStopParser;

                PUBLISHED
                  PROPERTY Filename            : STRING            READ GetFilename          WRITE LoadFromFile;
                  PROPERTY Normalize           : BOOLEAN           READ GetNormalize         WRITE SetNormalize;
                  PROPERTY OnXmlProlog         : TXmlPrologEvent   READ FOnXmlProlog         WRITE FOnXmlProlog;
                  PROPERTY OnComment           : TCommentEvent     READ FOnComment           WRITE FOnComment;
                  PROPERTY OnPI                : TPIEvent          READ FOnPI                WRITE FOnPI;
                  PROPERTY OnDtdRead           : TDtdEvent         READ FOnDtdRead           WRITE FOnDtdRead;
                  PROPERTY OnStartTag          : TStartTagEvent    READ FOnStartTag          WRITE FOnStartTag;
                  PROPERTY OnEmptyTag          : TStartTagEvent    READ FOnEmptyTag          WRITE FOnEmptyTag;
                  PROPERTY OnEndTag            : TEndTagEvent      READ FOnEndTag            WRITE FOnEndTag;
                  PROPERTY OnContent           : TContentEvent     READ FOnContent           WRITE FOnContent;
                  PROPERTY OnCData             : TContentEvent     READ FOnCData             WRITE FOnCData;
                  PROPERTY OnElement           : TElementEvent     READ FOnElement           WRITE FOnElement;
                  PROPERTY OnAttList           : TElementEvent     READ FOnAttList           WRITE FOnAttList;
                  PROPERTY OnEntity            : TEntityEvent      READ FOnEntity            WRITE FOnEntity;
                  PROPERTY OnNotation          : TNotationEvent    READ FOnNotation          WRITE FOnNotation;
                  PROPERTY OnDtdError          : TErrorEvent       READ FOnDtdError          WRITE FOnDtdError;
                  PROPERTY OnLoadExternal      : TExternalEvent    READ FOnLoadExternal      WRITE FOnLoadExternal;
                  PROPERTY OnTranslateEncoding : TEncodingEvent    READ FOnTranslateEncoding WRITE FOnTranslateEncoding;
                END;

PROCEDURE Register;

(*
===============================================================================================
IMPLEMENTATION
===============================================================================================
*)

IMPLEMENTATION


PROCEDURE Register;
BEGIN
  RegisterComponents ('XML', [TXmlScanner]);
END;

(*
===============================================================================================
TScannerXmlParser
===============================================================================================
*)

TYPE
  TScannerXmlParser = CLASS (TXmlParser)
                       Scanner : TXmlScanner;
                       CONSTRUCTOR Create (TheScanner : TXmlScanner);
                       FUNCTION  LoadExternalEntity (SystemId, PublicId,
                                                     Notation : STRING) : TXmlParser;  OVERRIDE;
                       FUNCTION  TranslateEncoding  (CONST Source : STRING) : STRING;  OVERRIDE;
                       PROCEDURE DtdElementFound (DtdElementRec : TDtdElementRec);     OVERRIDE;
                      END;

CONSTRUCTOR TScannerXmlParser.Create (TheScanner : TXmlScanner);
BEGIN
  INHERITED Create;
  Scanner := TheScanner;
END;


FUNCTION  TScannerXmlParser.LoadExternalEntity (SystemId, PublicId, Notation : STRING) : TXmlParser;
BEGIN
  IF Assigned (Scanner.FOnLoadExternal)
    THEN Scanner.FOnLoadExternal (Scanner, SystemId, PublicId, Notation, Result)
    ELSE Result := INHERITED LoadExternalEntity (SystemId, PublicId, Notation);
END;


FUNCTION  TScannerXmlParser.TranslateEncoding  (CONST Source : STRING) : STRING;
BEGIN
  IF Assigned (Scanner.FOnTranslateEncoding)
    THEN Result := Scanner.FOnTranslateEncoding (Scanner, CurEncoding, Source)
    ELSE Result := INHERITED TranslateEncoding (Source);
END;


PROCEDURE TScannerXmlParser.DtdElementFound (DtdElementRec : TDtdElementRec);
BEGIN
  WITH DtdElementRec DO
    CASE ElementType OF
      deElement,
      deAttList  : IF Assigned (Scanner.FOnElement) THEN
                     Scanner.FOnElement (Scanner, ElemDef);
      deEntity   : IF Assigned (Scanner.FOnEntity) THEN
                     Scanner.FOnEntity (Scanner, EntityDef);
      deNotation : IF Assigned (Scanner.FOnNotation) THEN
                     Scanner.FOnNotation (Scanner, NotationDef);
      dePI       : IF Assigned (Scanner.FOnPI) THEN
                     Scanner.FOnPI (Scanner, STRING (Target), STRING (Content), AttrList);
      deComment  : IF Assigned (Scanner.FOnComment) THEN
                     Scanner.FOnComment (Scanner, StrSFPas (Start, Final));
      deError    : IF Assigned (Scanner.FOnDtdError) THEN
                     Scanner.FOnDtdError (Scanner, Pos);
      END;
END;



(*
===============================================================================================
TXmlScanner
===============================================================================================
*)

CONSTRUCTOR TXmlScanner.Create (AOwner: TComponent);
BEGIN
  INHERITED;
  FXmlParser := TScannerXmlParser.Create (Self);
END;


DESTRUCTOR TXmlScanner.Destroy;
BEGIN
  FXmlParser.Free;
  INHERITED;
END;


PROCEDURE TXmlScanner.LoadFromFile   (Filename : STRING);
          // Load XML Document from file
BEGIN
  FXmlParser.LoadFromFile (Filename);
END;


PROCEDURE TXmlScanner.LoadFromBuffer (Buffer : PChar);
          // Load XML Document from buffer
BEGIN
  FXmlParser.LoadFromBuffer (Buffer);
END;


PROCEDURE TXmlScanner.SetBuffer (Buffer : PChar);
          // Refer to Buffer
BEGIN
  FXmlParser.SetBuffer (Buffer);
END;


FUNCTION  TXmlScanner.GetFilename : STRING;
BEGIN
  Result := FXmlParser.Source;
END;


FUNCTION  TXmlScanner.GetNormalize : BOOLEAN;
BEGIN
  Result := FXmlParser.Normalize;
END;


PROCEDURE TXmlScanner.SetNormalize (Value : BOOLEAN);
BEGIN
  FXmlParser.Normalize := Value;
END;


PROCEDURE TXmlScanner.Execute;
          // Perform scanning
BEGIN
  FStopParser := FALSE;
  FXmlParser.StartScan;
  WHILE FXmlParser.Scan AND (NOT FStopParser) DO
    CASE FXmlParser.CurPartType OF
      ptNone      : ;
      ptXmlProlog : IF Assigned (FOnXmlProlog) THEN
                      FOnXmlProlog (Self, FXmlParser.XmlVersion, FXmlParser.Encoding, FXmlParser.Standalone);
      ptComment   : IF Assigned (FOnComment) THEN
                      FOnComment (Self, StrSFPas (FXmlParser.CurStart, FXmlParser.CurFinal));
      ptPI        : IF Assigned (FOnPI) THEN
                      FOnPI (Self, FXmlParser.CurName, FXmlParser.CurContent, FXmlParser.CurAttr);
      ptDtdc      : IF Assigned (FOnDtdRead) THEN
                      FOnDtdRead (Self, FXmlParser.RootName);
      ptStartTag  : IF Assigned (FOnStartTag) THEN
                      FOnStartTag (Self, FXmlParser.CurName, FXmlParser.CurAttr);
      ptEmptyTag  : IF Assigned (FOnEmptyTag) THEN
                      FOnEmptyTag (Self, FXmlParser.CurName, FXmlParser.CurAttr);
      ptEndTag    : IF Assigned (FOnEndTag) THEN
                      FOnEndTag (Self, FXmlParser.CurName);
      ptContent   : IF Assigned (FOnContent) THEN
                      FOnContent (Self, FXmlParser.CurContent);
      ptCData     : IF Assigned (FOnCData) THEN
                      FOnCData (Self, FXmlParser.CurContent);
      END;
END;


END.

