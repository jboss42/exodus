	Section /o "ImportAIM" SEC_ExImportAIM
	  AddSize 163
	  Push "ExImportAIM"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExImportAIM.dll"
	SectionEnd

	Section /o "Aspell" SEC_ExAspell
	  AddSize 120
	  Push "ExAspell"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExAspell.dll"
	SectionEnd

	Section /o "ImportICQ" SEC_ExImportICQ
	  AddSize 196
	  Push "ExImportICQ"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExImportICQ.dll"
	SectionEnd

	Section /o "JabberStats" SEC_ExJabberStats
	  AddSize 217
	  Push "ExJabberStats"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExJabberStats.dll"
	SectionEnd

	Section /o "NetMeeting" SEC_ExNetMeeting
	  AddSize 159
	  Push "ExNetMeeting"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExNetMeeting.dll"
	SectionEnd

	Section /o "RosterTools" SEC_ExRosterTools
	  AddSize 262
	  Push "ExRosterTools"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExRosterTools.dll"
	SectionEnd

	Section /o "SQLLogger" SEC_ExSQLLogger
	  AddSize 351
	  Push "ExSQLLogger"
	  Call DownloadPlugin
      RegDll "$INSTDIR\plugins\ExSQLLogger.dll"
	SectionEnd

