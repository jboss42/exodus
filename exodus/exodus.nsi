; exodus.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The instalelr simply 
; prompts the user asking them where to install, and drops of notepad.exe
; there. If your Windows directory is not C:\windows, change it below.
;

; The name of the installer
Name "Exodus"

; The file to write
OutFile "setup.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Exodus
; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM SOFTWARE\Jabber\Exodus "Install_Dir"

Icon "exodus.ico"
WindowIcon on
CRCCheck on

ComponentText "This will install Exodus."
LicenseData GPL-LICENSE.TXT
LicenseText "Exodus is licensed under the GPL" "Groovy"
EnabledBitmap online.bmp
DisabledBitmap offline.bmp
SubCaption 3 ": Exit running Exodus versions!"

; The text to prompt the user to enter a directory
DirText "Which directory should Exodus be installed in?"

; The stuff to install
Section "Exodus (Required)"
	call NotifyInstances

	; Set output path to the installation directory.
  	SetOutPath $INSTDIR
  	; Put file there
  	File "Exodus.exe"
  	
	; install idlehooks on non-nt
	Call GetWindowsVersion
  	Pop $0
	StrCmp $0 "2000" lbl_noIdle
  	File "IdleHooks.dll"
lbl_noIdle:

	; Write the installation path into the registry
  	WriteRegStr HKLM SOFTWARE\Jabber\Exodus "Install_Dir" "$INSTDIR"

  	; Write the uninstall keys for Windows
  	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" "DisplayName" "Exodus Jabber Client (remove only)"
  	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus" "UninstallString" '"$INSTDIR\uninstall.exe"'
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

; optional section
Section "Start Menu Shortcuts"
	; if in silent mode, don't do any of this, ever
    Push $CMDLINE
    Push "/S"
    Call StrStr
    Pop $0

	StrCmp $0 "/S" silent
  	CreateDirectory "$SMPROGRAMS\Exodus"
  	CreateShortCut "$SMPROGRAMS\Exodus\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  	CreateShortCut "$SMPROGRAMS\Exodus\Exodus.lnk" "$INSTDIR\Exodus.exe" "" "$INSTDIR\Exodus.exe" 0
silent:

SectionEnd

; special uninstall section.
UninstallText "This will uninstall Exodus.  Click Uninstall to continue."
Section "Uninstall"
  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Exodus"
  DeleteRegKey HKLM SOFTWARE\Jabber\Exodus\Restart
  ; remove files
  Delete $INSTDIR\Exodus.exe
  Delete $INSTDIR\IdleHooks.dll
  ; remove shortcuts, if any.
  Delete "$SMPROGRAMS\Exodus\*.*"
  RMDir "$SMPROGRAMS\Exodus"
  ; MUST REMOVE UNINSTALLER, too
  Delete $INSTDIR\uninstall.exe
  RMDir "$INSTDIR"
SectionEnd

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
  Push $9
  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
  StrCmp $0 "" 0 lbl_winnt
  ; we are not NT.
  ReadRegStr $0 HKLM SOFTWARE\Microsoft\Windows\CurrentVersion VersionNumber
 
  StrCpy $9 $0 1
  StrCmp $9 '4' 0 lbl_error

  StrCpy $9 $0 3

  StrCmp $9 '4.0' lbl_win32_95
  StrCmp $9 '4.9' lbl_win32_ME lbl_win32_98

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

    StrCpy $9 $0 1
    StrCmp $9 '3' lbl_winnt_x
    StrCmp $9 '4' lbl_winnt_x
    StrCmp $9 '5' lbl_winnt_5 lbl_error

    lbl_winnt_x:
      StrCpy $0 "NT $0" 6
    Goto lbl_done

    lbl_winnt_5:
      Strcpy $0 '2000'
    Goto lbl_done

  lbl_error:
    Strcpy $0 ''
  lbl_done:
  Pop $9
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
