	Section "ImportAIM" SEC_ExImportAIM
	  AddSize 638
	  Push "ExImportAIM"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExImportAIM.dll"
	SectionEnd
	
	Section "Aspell" SEC_ExAspell
	  AddSize 539
	  Push "ExAspell"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExAspell.dll"
	SectionEnd
	
	Section "ImportICQ" SEC_ExImportICQ
	  AddSize 691
	  Push "ExImportICQ"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExImportICQ.dll"
	SectionEnd
	
	Section "JabberStats" SEC_ExJabberStats
	  AddSize 702
	  Push "ExJabberStats"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExJabberStats.dll"
	SectionEnd
	
	Section "NetMeeting" SEC_ExNetMeeting
	  AddSize 551
	  Push "ExNetMeeting"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExNetMeeting.dll"
	SectionEnd
	
	Section "RosterTools" SEC_ExRosterTools
	  AddSize 758
	  Push "ExRosterTools"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExRosterTools.dll"
	SectionEnd
	
