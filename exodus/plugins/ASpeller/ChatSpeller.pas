unit ChatSpeller;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
    ASpellHeadersDyn, 
    ExodusCOM_TLB, RichEdit2, ExRichEdit,
    ComObj, ActiveX, ExASpell_TLB, StdVcl;

type
  TChatSpeller = class(TAutoObject, IExodusChatPlugin)
  protected
    function onAfterMessage(var Body: WideString): WideString; safecall;
    procedure onBeforeMessage(var Body: WideString); safecall;
    procedure onClose; safecall;
    procedure onContextMenu(const ID: WideString); safecall;
    procedure onKeyPress(const Key: WideString); safecall;
    procedure onMenu(const ID: WideString); safecall;
    procedure onNewWindow(HWND: Integer); safecall;
    procedure onRecvMessage(const Body, xml: WideString); safecall;
  private
    _chat: IExodusChat;
    _msgout: TExRichEdit;
    _speller: ASpellSpeller;

    function checkWord(w: Widestring): boolean;
  public
    reg_id: integer;
    constructor Create(Speller: ASpellSpeller; chat_controller: IExodusChat);
  end;

implementation

uses
    ComServ, Graphics, SysUtils;

const
    // space, tab, LF, CR, !, ,, .
    WhitespaceChars = [#32, #09, #10, #13, #33, #44, #46];

constructor TChatSpeller.Create(Speller: ASpellSpeller;
    chat_controller: IExodusChat);
begin
    //
    inherited Create();
    _speller := Speller;
    _chat := chat_controller;
    _msgout := nil;
end;


function TChatSpeller.onAfterMessage(var Body: WideString): WideString;
begin

end;

procedure TChatSpeller.onBeforeMessage(var Body: WideString);
begin

end;

procedure TChatSpeller.onClose;
begin
    _chat.UnRegister(reg_id);
end;

procedure TChatSpeller.onContextMenu(const ID: WideString);
begin

end;

procedure TChatSpeller.onKeyPress(const Key: WideString);
var
    adr: integer;
    tmps: String;
    k: Char;
    ok: boolean;
    last, cur: longint;
    word: WideString;
begin
    if (_MsgOut = nil) then begin
        adr := _chat.getMagicInt(Ptr_MsgInput);
        _MsgOut := TExRichEdit(Pointer(adr)^);
        end;

    tmps := Key;
    k := tmps[1];

    if ((k in WhitespaceChars) and (_MsgOut.SelStart > 0)) then begin
        // check spelling for this word
        cur := _MsgOut.SelStart;
        last := cur;

        // find the last word break..
        while ((last > 0) and ((_MsgOut.Text[last] in WhitespaceChars) = false)) do
            dec(last);

        word := Trim(Copy(_MsgOut.Text, last, (cur - last) + 1));
        ok := checkWord(word);
        with _MsgOut do begin
            SelStart := last;
            SelLength := (cur - last);
            if (ok) then begin
                SelAttributes.Color := clBlack;
                SelAttributes.Style := [];
            end
            else begin
                SelAttributes.Color := clRed;
                SelAttributes.UnderlineType := ultWave;
                SelAttributes.Style := [fsUnderline];
            end;
            SelStart := cur;
            SelLength := 0;
            SelAttributes.Color := clBlack;
            SelAttributes.Style := [];
        end;
    end;
end;

function TChatSpeller.checkWord(w: Widestring): boolean;
var
    tmps: String;
    res: integer;
    {
    suggestions: AspellWordList;
    elements: AspellStringEnumeration;
    word_: PChar;
    sWord: string;
    }
begin
    tmps := w;
    res := aspell_speller_check(_speller, PChar(tmps), length(tmps));
    Result := (res = 1);

    (*
    if (res <> 1) then begin
        suggestions := aspell_speller_suggest(spell_checker, PChar(sWord), length(sWord));
        elements := aspell_word_list_elements(suggestions);

        // InitSuggestionMenu(sWord);
        repeat
            word_ := aspell_string_enumeration_next(elements);
            if (word_ <> nil) then AddToSuggestionMenu(word_);
        until (word_ = NIL);

        delete_aspell_string_enumeration(elements);
        HighlightNextWord(true);
        case ShowSuggestionMenu of
        0 : break;   // Escape pressed
        1 : ;        // Ignore
        2 :          // Ignore all
            aspell_speller_add_to_session(spell_checker,
                   PChar(sWord), length(sWord));
//      3 : Beep;    // Replace
//      4 : Beep;    // Replace all
        5 :          // Add
            aspell_speller_add_to_personal(spell_checker,
                   PChar(sWord), length(sWord));
        6 :          // Add Lower
            aspell_speller_add_to_personal( spell_checker,
                   PChar(LowerCase(sWord)), length(sWord));
        7 : break ;  // Abort
        8 : break ;  // Exit
        100..MAXINT : begin // suggestion
            HighlightNextWord(false);
            ReplaceNextWord(SuggestionText);
            aspell_speller_store_replacement(spell_checker,
                PChar(sWord), length(sWord),
                PChar(SuggestionText), length(SuggestionText));
        end;
        end;
    end;
    *)
end;


procedure TChatSpeller.onMenu(const ID: WideString);
begin

end;

procedure TChatSpeller.onNewWindow(HWND: Integer);
begin
    _MsgOut := nil;
end;

procedure TChatSpeller.onRecvMessage(const Body, xml: WideString);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TChatSpeller, Class_ChatSpeller,
    ciMultiInstance, tmApartment);
end.
