;    Copyright 2003, Joe Hildebrand
;
;    This file is part of Exodus.
;
;    Exodus is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    Exodus is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with Exodus; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

; If you are trying to create a branded version of Exodus, search for
; BRANDING in this file.

; exodus.nsi
;
!define MUI_MANUALVERBOSE

!define SF_SELECTED   1
!define SF_SUBSEC     2
!define SF_SUBSECEND  4
!define SF_BOLD       8
!define SF_RO         16
!define SF_EXPAND     32
!define SECTION_OFF   0xFFFFFFFE

; The name of the installer
!define MUI_PRODUCT "Exodus" ;Define your own software name here
!include version.nsi
!include "${NSISDIR}\Contrib\Modern UI\System.nsh"

; BRANDING: change this URL
!define HOME_URL "http://exodus.jabberstudio.org"

; The file to write
OutFile "setup.exe"
ShowInstDetails show
ShowUninstDetails show

; The default installation directory
InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"
; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "SOFTWARE\Jabber\${MUI_PRODUCT}" "Install_Dir"

!define MUI_INNERTEXT_LICENSE_TOP "Exodus is licensed under the GPL.  Press Page Down to see the rest of the agreement."
;!define MUI_CHECKBITMAP "checks.bmp"
!define MUI_ICON "exodus.ico"
!define MUI_UNICON "exodus.ico"
!define MUI_LICENSEPAGE
!define MUI_COMPONENTSPAGE
!define MUI_DIRECTORYPAGE
!define MUI_STARTMENUPAGE
  !define MUI_STARTMENU_DEFAULTFOLDER "${MUI_PRODUCT}"

!define MUI_FINISHPAGE
  !define MUI_FINISHPAGE_RUN "$INSTDIR\Exodus.exe"  
;  !define MUI_FINISHPAGE_RUN_NOTCHECKED
  !define MUI_FINISHPAGE_NOAUTOCLOSE

; !define MUI_ABORTWARNING
  
!define MUI_UNINSTALLER
!define MUI_UNCONFIRMPAGE
  
;Modern UI System
!define MUI_BRANDINGTEXT " "
!insertmacro MUI_SYSTEM
!insertmacro MUI_LANGUAGE "English"


; The stuff to install
Section "!${MUI_PRODUCT} (Required)" SEC_Exodus
        ; this one is required
        SectionIn 1 RO

        ; shut down running instances
        call NotifyInstances

        ; Set output path to the installation directory.
        SetOutPath $INSTDIR
        File "Exodus.exe"
        ; BRANDING: Uncomment if you are doing a branded setup.
        ; SetOverwrite off ; only if you don't want to overwrite existing file.
        ; File "branding.xml"
        ; SetOverwrite on

        ; install idlehooks on non-nt
        Call GetWindowsVersion
        Pop $0
        StrCmp $0 "2000" lbl_noIdle

        IfFileExists IdleHooks.dll lbl_noIdle

!ifndef NO_NETWORK
        ; BRANDING: change this URL.
        NSISdl::download "${HOME_URL}/daily/extras/IdleHooks.dll" \
                         $INSTDIR\IdleHooks.dll
        StrCmp $0 "success" lbl_noIdle
            Abort "Error downloading IdleHooks library"
!else
	File IdleHooks.dll
!endif

  lbl_noIdle:
        ; version(riched20) >= 5.30
        GetDLLVersion "$SYSDIR\riched20.dll" $R0 $R1
        IntOp $R1 $R0 / 65536
        IntOp $R2 $R0 & 0x00FF
        DetailPrint "Richedit version: $R1.$R2"

        IntCmp 327710 $R0 lbl_reportVer lbl_reportVer

        DetailPrint "Old version of richedit controls.  Upgrading."
!ifndef NO_NETWORK
        ; BRANDING: change this URL
        NSISdl::download "${HOME_URL}/richupd.exe" $INSTDIR\richupd.exe
        StrCmp $0 "success" lbl_execrich
            Abort "Error downloading richtext library"
  lbl_execrich:
!else
	File richupd.exe
!endif
        WriteRegStr HKCU Software\Microsoft\Windows\CurrentVersion\Runonce \
          "Exodus-Setup" "$CMDLINE"
        Exec $INSTDIR\richupd.exe
        Quit
  lbl_reportVer:
        DetailPrint "Richedit version ok."

        ; delete any leftover richupd.exe file.  This should not error
        ; if the file doesn't exist.
        Delete $INSTDIR\richupd.exe

        ; Write the installation path into the registry
        WriteRegStr HKLM SOFTWARE\Jabber\Exodus "Install_Dir" "$INSTDIR"

        ; Write the uninstall keys for Windows
        WriteRegStr HKLM \
          "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" \
          "DisplayName" "Exodus Jabber Client (remove only)"
        WriteRegStr HKLM \
          "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" \
          "UninstallString" '"$INSTDIR\uninstall.exe"'
        WriteUninstaller "uninstall.exe"

        StrCpy $0 0

  outer_loop:

    EnumRegKey $1 HKLM "Software\Jabber\Exodus\Restart" $0
    StrCmp $1 "" abort

    ReadRegStr $2 HKLM "Software\Jabber\Exodus\Restart\$1" "cwd"
    StrCmp $2 "" done
        SetOutPath $2

    ReadRegStr $2 HKLM "Software\Jabber\Exodus\Restart\$1" "cmdline"

    ReadRegDWORD $3 HKLM "Software\Jabber\Exodus\Restart\$1" "priority"
    StrCmp $3 "" done

    ReadRegStr $4 HKLM "Software\Jabber\Exodus\Restart\$1" "profile"
    StrCmp $4 "" show
        StrCpy $4 '-f "$4"'

  show:
    ReadRegStr $5 HKLM "Software\Jabber\Exodus\Restart\$1" "show"
        StrCmp $5 "" status
        StrCpy $5 '-w "$5"'

  status:
    ReadRegStr $6 HKLM "Software\Jabber\Exodus\Restart\$1" "status"    
        StrCmp $6 "" exec
        StrCpy $6 '-s "$6"'

  exec:
        DetailPrint '"$INSTDIR\Exodus.exe" $2 -i $3 $4 $5 $6'
        Exec '"$INSTDIR\Exodus.exe" $2 -i $3 -f "$4" $5 $6'
        SetAutoClose "true"

  done:
        DeleteRegKey HKLM "Software\Jabber\Exodus\Restart\$1"

;    IntOp $0 $0 + 1
        Goto outer_loop
  abort:

SectionEnd ; end the section

Section "SSL Support" SEC_SSL
!ifndef NO_NETWORK
        AddSize 824
!endif
        IfFileExists $INSTDIR\ssleay32.dll libea need_ssl
  libea:
        IfFileExists $INSTDIR\libeay32.dll no_ssl
  need_ssl:

!ifndef NO_NETWORK
        ; BRANDING: Change this URL
        NSISdl::download "${HOME_URL}/indy_openssl096g.zip" \
                         $INSTDIR\indy_openssl096.zip
        StrCmp $0 "success" ssl
            Abort "Error downloading ssl libraries"
  ssl:
        ZipDLL::extractall $INSTDIR $INSTDIR\indy_openssl096.zip
        Delete $INSTDIR\indy_openssl096.zip
	Delete $INSTDIR\readme.txt
!else
	File libeay32.dll  
	File ssleay32.dll
!endif
        goto ssl_done
  no_ssl:
        DetailPrint "SSL libraries already installed."
        ssl_done:
SectionEnd

SubSection /e "Plugins" SEC_Plugins
	Section "AIM Importer" SEC_AIM
	  AddSize 610
	  Push "AIMImport"
	  Call DownloadPlugin
	SectionEnd

	Section "ICQ Importer" SEC_ICQ
	  AddSize 670
	  Push "ICQImport"
	  Call DownloadPlugin
	SectionEnd

	Section "MS Word Speller" SEC_Word
	  AddSize 450
	  Push "WordSpeller"
	  Call DownloadPlugin
	SectionEnd

SubSectionEnd

; Start menu shortcuts
Section "" SEC_Menu
  	; register all of the plugin .dll's
  	ClearErrors
  	FindFirst $0 $1 "$INSTDIR\plugins\*.dll"
  	IfErrors nodlls
  nextdll:

  	ClearErrors
  	RegDll $INSTDIR\plugins\$1
  	IfErrors regerror findnextdll
  regerror:
    DetailPrint "Error trying to register $INSTDIR\plugins\$1"
    
  findnextdll:
  	ClearErrors
  	FindNext $0 $1
  	IfErrors dllregdone nextdll

  dllregdone:
  	FindClose $0
  	goto pluginend
  
  nodlls:
  	DetailPrint "$0 $1 No dlls found in $INSTDIR\plugins"

  pluginend:

    ; if in silent mode, don't do any of the menu stuff, ever
    Push $CMDLINE
    Push "/S"
    Call StrStr
    Pop $0

    StrCmp $0 "/S" silent
    !insertmacro MUI_STARTMENU_WRITE_BEGIN
      CreateDirectory "$SMPROGRAMS\${MUI_STARTMENU_VARIABLE}"
      CreateShortCut "$SMPROGRAMS\${MUI_STARTMENU_VARIABLE}\Uninstall.lnk" \
        "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
      CreateShortCut "$SMPROGRAMS\${MUI_STARTMENU_VARIABLE}\Exodus.lnk" \
        "$INSTDIR\Exodus.exe" "" "$INSTDIR\Exodus.exe" 0

      ; BRANDING: Change this URL
      CreateShortCut \
        "$SMPROGRAMS\${MUI_STARTMENU_VARIABLE}\Exodus Homepage.lnk" \
        "${HOME_URL}"
      WriteRegStr HKLM SOFTWARE\Jabber\Exodus "StartMenu" \
        "${MUI_STARTMENU_VARIABLE}"

    !insertmacro MUI_STARTMENU_WRITE_END

  silent:

SectionEnd

; BRANDING: Remove this section
Section "Daily updates" SEC_Bleed
        SetOverwrite off
        File "branding.xml"     
        SetOverwrite on
SectionEnd


; special uninstall section.
;UninstallText "This will uninstall Exodus.  Click Uninstall to continue."
Section "Uninstall"
  ; remove shortcuts
  ReadRegStr $0 HKLM "SOFTWARE\Jabber\Exodus" "StartMenu"
  StrCmp $0 "" noshortcuts
    Delete "$SMPROGRAMS\$0\Uninstall.lnk"
    Delete "$SMPROGRAMS\$0\Exodus.lnk"
    Delete "$SMPROGRAMS\$0\Exodus Homepage.lnk"
    RMDir "$SMPROGRAMS\$0"
  noshortcuts:

  ; unregister all of the plugin .dll's
  ClearErrors
  FindFirst $0 $1 "$INSTDIR\plugins\*.dll"
  IfErrors dllregdone

  nextdll:
  UnRegDll "$INSTDIR\plugins\$1"

  ClearErrors
  FindNext $0 $1
  IfErrors dllregdone nextdll

  dllregdone:
  FindClose $0

  ; remove plugins
  Delete "$INSTDIR\plugins\*.dll"
  RMDir "$INSTDIR\plugins"

  ; remove files
  Delete $INSTDIR\Exodus.exe
  Delete $INSTDIR\IdleHooks.dll
  Delete $INSTDIR\branding.xml
  Delete $INSTDIR\libeay32.dll
  Delete $INSTDIR\ssleay32.dll

  ; MUST REMOVE UNINSTALLER, too
  Delete $INSTDIR\uninstall.exe
  RMDir "$INSTDIR"

  ; remove registry keys
  DeleteRegKey HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus"

  DeleteRegKey HKLM SOFTWARE\Jabber\Exodus\Restart
  DeleteRegKey HKLM SOFTWARE\Jabber\Exodus

SectionEnd

;--------------------------------
;Descriptions

;--------------------------------
;Language Strings

;Description
LangString DESC_Exodus ${LANG_ENGLISH} \
"The main exodus program."

LangString DESC_SSL ${LANG_ENGLISH} \
"You will need these libraries to use SSL connections.  These will be retrieved via the Internet, using your IE proxy settings."

LangString DESC_Bleed ${LANG_ENGLISH} \
"Exodus will check for new versions of the latest development build whenever you login.  These sometimes happen several times a day."

LangString DESC_Plugins ${LANG_ENGLISH} \
"Download Exodus plugins via the Internet, using your IE proxy settings."

LangString DESC_AIM ${LANG_ENGLISH} \
"Import contacts from AOL Instant Messenger"

LangString DESC_ICQ ${LANG_ENGLISH} \
"Import contacts from ICQ"

LangString DESC_Word ${LANG_ENGLISH} \
"Check spelling using Microsoft Word"

; BRANDING: YOU MUST NOT REMOVE THE GPL!
LicenseData GPL-LICENSE.TXT
SubCaption 3 ": Exit running Exodus versions!"

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Exodus} $(DESC_Exodus)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_SSL} $(DESC_SSL)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Bleed} $(DESC_Bleed)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Plugins} $(DESC_Plugins)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_AIM} $(DESC_AIM)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_ICQ} $(DESC_ICQ)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Word} $(DESC_Word)
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END


!insertmacro MUI_SECTIONS_FINISHHEADER

; eof

;------------------------------------------------------------------------------
; GetWindowsVersion
;
; Based on Yazno's function, http://yazno.tripod.com/powerpimpit/
; Returns on top of stack
;
; Windows Version (95, 98, ME, NT x.x, 2000)
; or
; '' (Unknown Windows Version)
;
; Usage:
;   Call GetWindowsVersion
;   Pop $0
;   ; at this point $0 is "NT 4.0" or whatnot

Function GetWindowsVersion
  Push $0
  Push $8
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp $0 "" 0 lbl_winnt
  ; we are not NT.
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion VersionNumber
 
  StrCpy $8 $0 1
  StrCmp $8 '4' 0 lbl_error

  StrCpy $8 $0 3

  StrCmp $8 '4.0' lbl_win32_95
  StrCmp $8 '4.9' lbl_win32_ME lbl_win32_98

  lbl_win32_95:
    StrCpy $0 '95'
  Goto lbl_done

  lbl_win32_98:
    StrCpy $0 '98'
  Goto lbl_done

  lbl_win32_ME:
    StrCpy $0 'ME'
  Goto lbl_done

  lbl_winnt: 

    StrCpy $8 $0 1
    StrCmp $8 '3' lbl_winnt_x
    StrCmp $8 '4' lbl_winnt_x
    StrCmp $8 '5' lbl_winnt_5 lbl_error

    lbl_winnt_x:
      StrCpy $0 "NT $0" 6
    Goto lbl_done

    lbl_winnt_5:
      Strcpy $0 '2000'
    Goto lbl_done

  lbl_error:
    Strcpy $0 ''
  lbl_done:
  Pop $8
  Exch $0
FunctionEnd

;------------------------------------------------------------------------------
; NotifyInstances
; 
; Closes all running instances of Exodus
Function NotifyInstances
        Push $0
        Push $1

start:
        StrCpy $1 0 
loop:
    FindWindow $0 "TfrmExodus" "" 0
    IntCmp $0 0 done
        SendMessage $0 6374 0 0
        Sleep 100
    IntOp $1 $1 + 1
    IntCmp $1 30 prompt
        Goto loop

prompt:
        MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "You must exit all running copies of Exodus to continue!" IDRETRY start
        ; cancel
        Quit

done:
        ; wait for shutdowns to complete
        Sleep 1000
        Pop $1
        Pop $0
FunctionEnd

;------------------------------------------------------------------------------
; StrStr
; input, top of stack = string to search for
;        top of stack-1 = string to search in
; output, top of stack (replaces with the portion of the string remaining)
; modifies no other variables.
;
; Usage:
;   Push "this is a long ass string"
;   Push "ass"
;   Call StrStr
;   Pop $0
;  ($0 at this point is "ass string")

Function StrStr
  Exch $1 ; st=haystack,old$1, $1=needle
  Exch    ; st=old$1,haystack
  Exch $2 ; st=old$1,old$2, $2=haystack
  Push $3
  Push $4
  Push $5
  StrLen $3 $1
  StrCpy $4 0
  ; $1=needle
  ; $2=haystack
  ; $3=len(needle)
  ; $4=cnt
  ; $5=tmp
  loop:
    StrCpy $5 $2 $3 $4
    StrCmp $5 $1 done
    StrCmp $5 "" done
    IntOp $4 $4 + 1
    Goto loop
  done:
  StrCpy $1 $2 "" $4
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Exch $1
FunctionEnd

Function DownloadPlugin
	Exch $1

  	CreateDirectory "$INSTDIR\plugins"
  	; BRANDING: Change this URL
  	NSISdl::download "${HOME_URL}/plugins/$1.zip" \
                     "$INSTDIR\plugins\$1.zip"

	StrCmp $0 "success" unzip
    Abort "Error downloading $1 plugin"

  unzip:
  	ZipDLL::extractall "$INSTDIR\plugins" "$INSTDIR\plugins\$1.zip" 
  	Delete "$INSTDIR\plugins\$1.zip"
FunctionEnd

Function TurnOff
	Exch $0
	Push $1
	SectionGetFlags $0 $1
	IntOp $1 $1 & ${SECTION_OFF}
	SectionSetFlags $0 $1
	Pop $1
FunctionEnd


Function .onInit
	Push ${SEC_AIM}
	Call TurnOff

	Push ${SEC_ICQ}
	Call TurnOff

	Push ${SEC_Word}
	Call TurnOff

	Push ${SEC_Plugins}
	Call TurnOff

	Push ${SEC_Bleed}
	Call TurnOff

!ifndef NO_NETWORK
	Push ${SEC_SSL}
	Call TurnOff
!endif
FunctionEnd
