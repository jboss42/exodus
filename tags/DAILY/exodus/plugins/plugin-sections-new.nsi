
      Section /o "ExImportAIM" SEC_ImportAIM
	  AddSize 0
	  Push "ExImportAIM"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExImportAIM.dll"
      SectionEnd
    
      Section /o "ExAspell" SEC_Aspell
	  AddSize 0
	  Push "ExAspell"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExAspell.dll"
      SectionEnd
    
      Section /o "ExJabberStats" SEC_JabberStats
	  AddSize 0
	  Push "ExJabberStats"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExJabberStats.dll"
      SectionEnd
    
      Section /o "ExNetMeeting" SEC_NetMeeting
	  AddSize 0
	  Push "ExNetMeeting"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExNetMeeting.dll"
      SectionEnd
    
      Section /o "ExRosterTools" SEC_RosterTools
	  AddSize 0
	  Push "ExRosterTools"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExRosterTools.dll"
      SectionEnd
    
      Section /o "ExSQLLogger" SEC_SQLLogger
	  AddSize 0
	  Push "ExSQLLogger"
	  Call DownloadPlugin
	  RegDll "\$INSTDIR\\plugins\\ExSQLLogger.dll"
      SectionEnd
    