;; -*- tab-width: 4; -*-
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
!define MUI_PRODUCT "Exodus"

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
InstallDirRegKey HKCU "SOFTWARE\Jabber\${MUI_PRODUCT}" "Install_Dir"

!define MUI_INNERTEXT_LICENSE_TOP \
    "Exodus is licensed under the GPL.  Press Page Down to see the rest of the agreement."

!define MUI_ICON "exodus.ico"
!define MUI_UNICON "exodus.ico"

!define MUI_CUSTOMPAGECOMMANDS

!define MUI_LICENSEPAGE
!define MUI_COMPONENTSPAGE
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_DIRECTORYPAGE
!define MUI_STARTMENUPAGE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${MUI_PRODUCT}"

!define MUI_FINISHPAGE
!define MUI_FINISHPAGE_RUN "$INSTDIR\Exodus.exe"
;!define MUI_FINISHPAGE_RUN_NOTCHECKED
!define MUI_FINISHPAGE_NOAUTOCLOSE

!insertmacro MUI_PAGECOMMAND_LICENSE
!insertmacro MUI_PAGECOMMAND_COMPONENTS
!insertmacro MUI_PAGECOMMAND_DIRECTORY
!insertmacro MUI_PAGECOMMAND_STARTMENU
Page custom SetCustomShell ;Custom page
!insertmacro MUI_PAGECOMMAND_INSTFILES
!insertmacro MUI_PAGECOMMAND_FINISH

!define MUI_ABORTWARNING
!define MUI_UNINSTALLER
!define MUI_UNCONFIRMPAGE

;Modern UI System
!define MUI_BRANDINGTEXT " "
;!insertmacro MUI_SYSTEM
!define MUI_HEADERBITMAP "exodus-installer.bmp"
!insertmacro MUI_LANGUAGE "English"

ReserveFile "notify.ini"
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; The stuff to install
Section "!${MUI_PRODUCT}" SEC_Exodus
    ; this one is required
    SectionIn 1 RO

    ; shut down running instances
    call NotifyInstances

    ; Set output path to the installation directory.
    SetOutPath $INSTDIR
    File "Exodus.exe"
    File "IdleHooks.dll"

    ; BRANDING: Uncomment if you are doing a branded setup.
    ; SetOverwrite off ; only if you don't want to overwrite existing file.
    ; File "branding.xml"
    ; SetOverwrite on
    
    ; version(riched20) >= 5.30
    GetDLLVersion "$SYSDIR\riched20.dll" $R0 $R1
    IntOp $R1 $R0 / 65536
    IntOp $R2 $R0 & 0x00FF
    DetailPrint "Richedit version: $R1.$R2"
    
	; if the installed version is >= to 5.30, skip ahead.
    IntCmp 327710 $R0 lbl_reportVer lbl_reportVer
    
    DetailPrint "Old version of richedit controls.  Upgrading."
!ifndef NO_NETWORK
    ; BRANDING: change this URL
    NSISdl::download "${HOME_URL}/richupd.exe" $INSTDIR\richupd.exe
    Pop $R0
    StrCmp $R0 "success" lbl_execrich
    Abort "Error downloading richtext library"
  lbl_execrich:
!else
    File ..\richupd.exe
!endif
    ;WriteRegStr HKCU Software\Microsoft\Windows\CurrentVersion\Runonce \
    ;    "Exodus-Setup" "$CMDLINE"
    MessageBox MB_OK "When prompted to reboot your computer after this update runs, answer NO. This installer will reboot when it finishes."

    ExecWait "$INSTDIR\richupd.exe /Q"
    SetRebootFlag true
    
  lbl_reportVer:
    DetailPrint "Richedit version ok."
    
    ; delete any leftover richupd.exe file.  This should not error
    ; if the file doesn't exist.
    Delete $INSTDIR\richupd.exe
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; Update common controls, if needed 5.80
    GetDLLVersion "$SYSDIR\comctl32.dll" $R0 $R1
    IntOp $R1 $R0 / 65536
    IntOp $R2 $R0 & 0x00FF
    DetailPrint "Comctl version: $R1.$R2"
    
    ; (5 << 16) + 80 w00t!
	; if the installed version is >= to 5.80, skip ahead.
    IntCmp 327760 $R0 com_reportVer com_reportVer
    
    DetailPrint "Old version of COM controls.  Upgrading."
!ifndef NO_NETWORK
    ; BRANDING: change this URL
    NSISdl::download "${HOME_URL}/50comupd.exe" $INSTDIR\50comupd.exe
    Pop $R0
    StrCmp $R0 "success" lbl_exec_com
    Abort "Error downloading com control library"
  lbl_exec_com:
!else
    File ..\50comupd.exe
!endif
    ;WriteRegStr HKCU Software\Microsoft\Windows\CurrentVersion\Runonce \
    ;    "Exodus-Setup" "$CMDLINE"
    MessageBox MB_OK "When prompted to reboot your computer after this update runs, answer NO. This installer will reboot when it finishes."
    ExecWait "$INSTDIR\50comupd.exe /Q"
    SetRebootFlag true

  com_reportVer:
    DetailPrint "COM control version ok."
    
    ; delete any leftover 50comupd.exe file.  This should not error
    ; if the file doesn't exist.
    Delete $INSTDIR\50comupd.exe
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Check for Win95, and no Winsock2
    Call GetWindowsVersion
    Pop $R0
    ; at this point $R0 is "95" or "NT 4.0"
    StrCmp $R0 "95" win95 winsock_done
  win95:
    IfFileExists $SYSDIR\WS2_32.DLL winsock_done 
    DetailPrint "Running Windows 95 without Winsock2.  Upgrading."
!ifndef NO_NETWORK
    ; BRANDING: change this URL
    NSISdl::download "${HOME_URL}/W95ws2setup.exe" $INSTDIR\W95ws2setup.exe
    Pop $R0
    StrCmp $R0 "success" lbl_exec_winsock2
    Abort "Error downloading com control library"
  lbl_exec_winsock2:
!else
    File ..\W95ws2setup.exe
!endif
    ;WriteRegStr HKCU Software\Microsoft\Windows\CurrentVersion\Runonce \
    ;    "Exodus-Setup" "$CMDLINE"
    MessageBox MB_OK "When prompted to reboot your computer after this update runs, answer NO. This installer will reboot when it finishes."
    ExecWait "$INSTDIR\W95ws2setup.exe /Q"
    SetRebootFlag true
        
  winsock_done:
    DetailPrint "Winsock version ok."
    Delete $INSTDIR\W95ws2setup.exe
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
    ; Setup stuff based on custom Shell page
    Push $CMDLINE
    Push "/S"
    Call StrStr
    Pop $0
    StrCmp $0 "/S" noshell

    !insertmacro MUI_INSTALLOPTIONS_READ $R0 "notify.ini" "Field 2" "State"
    StrCmp $R0 "1" "" +2
    ;Checked
    CreateShortcut "$DESKTOP\Exodus.lnk" "$INSTDIR\Exodus.exe"

    !insertmacro MUI_INSTALLOPTIONS_READ $R0 "notify.ini" "Field 3" "State"
    StrCmp $R0 "1" "" +2
    ;Checked
    CreateShortcut "$QUICKLAUNCH\Exodus.lnk" "$INSTDIR\Exodus.exe"
    !insertmacro MUI_INSTALLOPTIONS_READ $R0 "notify.ini" "Field 4" "State"
    StrCmp $R0 "1" "" noshell
    ;Checked
    WriteRegStr HKCU Software\Microsoft\Windows\CurrentVersion\Run \
        "Exodus" "$INSTDIR\Exodus.exe"  

  noshell:
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Write the installation path into the registry
    WriteRegStr HKCU SOFTWARE\Jabber\Exodus "Install_Dir" "$INSTDIR"
    
    ; Write the uninstall keys for Windows
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" \
        "DisplayName" "Exodus Jabber Client (remove only)"
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" \
        "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteUninstaller "uninstall.exe"
    
    ; register file associations.  TODO: figure this out for real, and
    ; remove these semi-bogus ones.
    WriteRegStr HKCR .xmpp "" XMPPfile
    WriteRegStr HKCR .xmpp "Content Type" "application/xmpp"
    WriteRegStr HKCR XMPPfile "" "eXtensible Messaging and Presence Protocol"
    WriteRegDword HKCR XMPPfile "EditFlags" 0x10000
    WriteRegDword HKCR XMPPfile "BrowserFlags" 0x8
    WriteRegStr HKCR "XMPPfile\shell" "" "Open"
    WriteRegStr HKCR "XMPPfile\shell\Open\command" "" \
        '"$INSTDIR\Exodus.exe" -o "%1"'
	WriteRegStr HKCR "XMPPfile\shell\Open\ddeexec" "" 'open "%1"'
	WriteRegStr HKCR "XMPPfile\shell\Open\ddeexec\Application" "" "Exodus"
	WriteRegStr HKCR "XMPPfile\shell\Open\ddeexec\IfExec" "" "ignore"
	WriteRegStr HKCR "XMPPfile\shell\Open\ddeexec\Topic" "" "XMPPAction"

    WriteRegStr HKCR "MIME\Database\Content Type\application/xmpp" \
        "Extension" ".xmpp"
    
    StrCpy $0 0
  outer_loop:

    EnumRegKey $1 HKCU "Software\Jabber\Exodus\Restart" $0
    StrCmp $1 "" abort
    
    ReadRegStr $2 HKCU "Software\Jabber\Exodus\Restart\$1" "cwd"
    StrCmp $2 "" done
    SetOutPath $2
    
    ReadRegStr $2 HKCU "Software\Jabber\Exodus\Restart\$1" "cmdline"
    
    ReadRegDWORD $3 HKCU "Software\Jabber\Exodus\Restart\$1" "priority"
    StrCmp $3 "" profile
	StrCpy $3 '-i "$3"'

  profile:
    ReadRegStr $4 HKCU "Software\Jabber\Exodus\Restart\$1" "profile"
    StrCmp $4 "" show
    StrCpy $4 '-f "$4"'

  show:
    ReadRegStr $5 HKCU "Software\Jabber\Exodus\Restart\$1" "show"
    StrCmp $5 "" status
    StrCpy $5 '-w "$5"'
    
  status:
    ReadRegStr $6 HKCU "Software\Jabber\Exodus\Restart\$1" "status"
    StrCmp $6 "" exec
    StrCpy $6 '-s "$6"'

  exec:
    DetailPrint '"$INSTDIR\Exodus.exe" $2 $3 $4 $5 $6'
    Exec '"$INSTDIR\Exodus.exe" $2 $3 $4 $5 $6'
    SetAutoClose "true"

  done:
    DeleteRegKey HKCU "Software\Jabber\Exodus\Restart\$1"

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
    Pop $R0
    StrCmp $R0 "success" ssl
    Abort "Error downloading ssl libraries"
  ssl:
    ZipDLL::extractall "$INSTDIR\indy_openssl096.zip" "$INSTDIR"
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

; BRANDING: Make sure to rename/copy the following files in
; the plugin directory and modify them to match the set
; of plugins you wish to distribute:
;   example-plugin-sections.nsi --> plugin-sections.nsi
;   example-plugin-desc.nsi     --> plugin-desc.nsi
;   example-plugin-en.nsi       --> plugin-en.nsi
;   example-plugin-off.nsi      --> plugin-off.nsi
SubSection  "Plugins" SEC_Plugins
    !include plugins\plugin-sections.nsi
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
    CreateDirectory "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}"
    CreateShortCut "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\Uninstall.lnk" \
        "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
    CreateShortCut "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\Exodus.lnk" \
        "$INSTDIR\Exodus.exe" "" "$INSTDIR\Exodus.exe" 0

    ; BRANDING: Change this URL
    CreateShortCut \
        "$SMPROGRAMS\${MUI_STARTMENUPAGE_VARIABLE}\Exodus Homepage.lnk" \
        "${HOME_URL}"
    WriteRegStr HKCU SOFTWARE\Jabber\Exodus "StartMenu" \
        "${MUI_STARTMENUPAGE_VARIABLE}"

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
    ReadRegStr $0 HKCU "SOFTWARE\Jabber\Exodus" "StartMenu"
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
    
	; remove shell hooks
	Delete "$DESKTOP\Exodus.lnk"
	Delete "$QUICKLAUNCH\Exodus.lnk"

    ; MUST REMOVE UNINSTALLER, too
    Delete $INSTDIR\uninstall.exe
    RMDir "$INSTDIR"

	ReadRegStr $0 HKCU "Software\Jabber\Exodus" "prefs_file"
	Delete $0
	DeleteRegValue HKCU "Software\Jabber\Exodus" "prefs_file"

    ; TODO: Remove logs, if user says so

    ; remove registry keys
    DeleteRegKey HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus"

    DeleteRegKey HKCU SOFTWARE\Jabber\Exodus\Restart
    DeleteRegKey HKCU SOFTWARE\Jabber\Exodus

    DeleteRegValue HKCU Software\Microsoft\Windows\CurrentVersion\Run \
        "Exodus"

SectionEnd

;--------------------------------
;Descriptions

;--------------------------------
;Language Strings

;Description
LangString DESC_Exodus ${LANG_ENGLISH} \
    "The main exodus program."

LangString DESC_SSL ${LANG_ENGLISH} \
    "Download libraries for SSL connections via the Internet. Some proxies may not work correctly."

LangString DESC_Bleed ${LANG_ENGLISH} \
    "Check for the latest development build whenever you login. This can happen more than once a day."

LangString DESC_Plugins ${LANG_ENGLISH} \
    "Download plugins via the Internet using your IE proxy settings. Will not work with auto-configured proxies."

LangString DESC_Desktop ${LANG_ENGLISH} \
    "Put a shortcut to Exodus on your desktop."

LangString DESC_QuickLaunch ${LANG_ENGLISH} \
    "Put a shortcut to Exodus in the Quick-Launch bar."

LangString CUSTOMSHELL_TITLE ${LANG_ENGLISH} \
    "Windows Dekstop and Shell Options"
LangString CUSTOMSHELL_SUBTITLE ${LANG_ENGLISH} \
    "Select options to install other shortcuts for Exodus."

;LangString FINISH_TITLE ${LANG_ENGLISH} "Finished Installing Exodus"
;LangString FINISH_SUBTITLE ${LANG_ENGLISH} "Final options"

!include plugins\plugin-en.nsi

; BRANDING: YOU MUST NOT REMOVE THE GPL!
LicenseData GPL-LICENSE.TXT
SubCaption 3 ": Exit running Exodus versions!"

!insertmacro MUI_FUNCTIONS_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Exodus} $(DESC_Exodus)
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC_SSL} $(DESC_SSL)
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Bleed} $(DESC_Bleed)
    !insertmacro MUI_DESCRIPTION_TEXT ${SEC_Plugins} $(DESC_Plugins)
    !include plugins\plugin-desc.nsi
!insertmacro MUI_FUNCTIONS_DESCRIPTION_END

!insertmacro MUI_SECTIONS_FINISHHEADER

; eof

;------------------------------------------------------------------------------
; NotifyInstances
;
; Closes all running instances of Exodus
Function NotifyInstances
    Push $0
    Push $1

  start:
    StrCpy $1 0

    ; check to see if we have any instances
    ; if we do, show a warning..
    FindWindow $0 "TfrmExodus" "" 0
    IntCmp $0 0 done
    ; cancel
    ; Quit
  loop:
    FindWindow $0 "TfrmExodus" "" 0
    IntCmp $0 0 done
    SendMessage $0 6374 0 0
    Sleep 100
    IntOp $1 $1 + 1
    IntCmp $1 30 prompt
    Goto loop

  prompt:
    MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION \
        "You must exit all running copies of Exodus to continue!" \
        IDRETRY start
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

; GetWindowsVersion
 ;
 ; Based on Yazno's function, http://yazno.tripod.com/powerpimpit/
 ; Returns on top of stack
 ;
 ; Windows Version (95, 98, ME, NT x.x, 2000, XP, .NET Server)
 ; or
 ; '' (Unknown Windows Version)
 ;
 ; Usage:
 ;   Call GetWindowsVersion
 ;   Pop $R0
 ;   ; at this point $R0 is "NT 4.0" or whatnot

 Function GetWindowsVersion
   Push $R0
   Push $R1
   ReadRegStr $R0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
   StrCmp $R0 "" 0 lbl_winnt
   ; we are not NT.
   ReadRegStr $R0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion VersionNumber

   StrCpy $R1 $R0 1
   StrCmp $R1 '4' 0 lbl_error

   StrCpy $R1 $R0 3

   StrCmp $R1 '4.0' lbl_win32_95
   StrCmp $R1 '4.9' lbl_win32_ME lbl_win32_98

   lbl_win32_95:
     StrCpy $R0 '95'
   Goto lbl_done

   lbl_win32_98:
     StrCpy $R0 '98'
   Goto lbl_done

   lbl_win32_ME:
     StrCpy $R0 'ME'
   Goto lbl_done

   lbl_winnt:

     StrCpy $R1 $R0 1

     StrCmp $R1 '3' lbl_winnt_x
     StrCmp $R1 '4' lbl_winnt_x

     StrCpy $R1 $R0 3

     StrCmp $R1 '5.0' lbl_winnt_2000
     StrCmp $R1 '5.1' lbl_winnt_XP
     StrCmp $R1 '5.2' lbl_winnt_dotNET lbl_error

     lbl_winnt_x:
       StrCpy $R0 "NT $R0" 6
     Goto lbl_done

     lbl_winnt_2000:
       Strcpy $R0 '2000'
     Goto lbl_done

     lbl_winnt_XP:
       Strcpy $R0 'XP'
     Goto lbl_done

     lbl_winnt_dotNET:
       Strcpy $R0 '.NET Server'
     Goto lbl_done

   lbl_error:
     Strcpy $R0 ''
   lbl_done:
   Pop $R1
   Exch $R0
 FunctionEnd

Function DownloadPlugin
    Exch $1

    CreateDirectory "$INSTDIR\plugins"
    ; BRANDING: Change this URL
    NSISdl::download "${HOME_URL}/plugins/$1.zip" \
        "$INSTDIR\plugins\$1.zip"
    Pop $R0  
    StrCmp $R0 "success" unzip
    Abort "Error downloading $1 plugin"

  unzip:
    ZipDLL::extractall "$INSTDIR\plugins\$1.zip" "$INSTDIR\plugins"
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
    !insertmacro MUI_INSTALLOPTIONS_EXTRACT "notify.ini"
    !include plugins\plugin-off.nsi
    Push ${SEC_Plugins}
    Call TurnOff

    ; BRANDING: To turn off bleeding edge updates,
    ; Comment these 2 lines out.
    Push ${SEC_Bleed}
    Call TurnOff
    
!ifndef NO_NETWORK
    Push ${SEC_SSL}
    Call TurnOff
!endif

FunctionEnd

Function SetCustomShell
    !insertmacro MUI_HEADER_TEXT "$(CUSTOMSHELL_TITLE)" \
        "$(CUSTOMSHELL_SUBTITLE)"

    Push $R0
    Push $R1
    Push $R2

    !insertmacro MUI_INSTALLOPTIONS_INITDIALOG "notify.ini"
    Pop $R0

    GetDlgItem $R1 $R0 1200

    ;$R1 contains the HWND of the first field
    CreateFont $R2 "Tahoma" 10 700
    SendMessage $R1 ${WM_SETFONT} $R2 0

    GetDlgItem $R1 $R0 1204

    ;$R1 contains the HWND of the first field
    CreateFont $R2 "Tahoma" 10 700 /ITALIC
    SendMessage $R1 ${WM_SETFONT} $R2 0

    !insertmacro MUI_INSTALLOPTIONS_SHOW

    Pop $R1
    Pop $R1
    Pop $R0

FunctionEnd

