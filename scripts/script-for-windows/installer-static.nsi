!include MUI2.nsh
!include "FileAssociation.nsh"

;--------------------------------

; The name of the installer
Name "Hyokai"

; Icons
Icon  "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
UninstallIcon  "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"

; The file to write
OutFile "inst_Hyokai.exe"

; The default installation directory
InstallDir $PROGRAMFILES\Hyokai

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\info_informationsea_Hyokai" "Install_Dir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Compressor
SetCompressor lzma

; Version information
VIProductVersion "0.2.0.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Hyokai"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "Informationsea"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© 2013 Y.Okamura"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Hyokai"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "0.3"



!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp" ; optional
!define MUI_ABORTWARNING

;--------------------------------

; Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "License.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


; Language
!insertmacro MUI_LANGUAGE "English"

;--------------------------------

; The stuff to install
Section "Hyokai (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "release\Hyokai.exe"
  File "vcredist_x86.exe"
  File "License.txt"
  ExecWait '"$INSTDIR\vcredist_x86.exe" /passive /install'
  
  
  ;; Register Extension
  ${registerExtension} $INSTDIR\Hyokai.exe ".sqlite3" "SQLite3 Database"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\info_informationsea_Hyokai "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\info_informationsea_Hyokai" "DisplayName" "Hyokai"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\info_informationsea_Hyokai" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\info_informationsea_Hyokai" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\info_informationsea_Hyokai" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\Hyokai"
  CreateShortCut "$SMPROGRAMS\Hyokai\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Hyokai\Hyokai.lnk" "$INSTDIR\Hyokai.exe" "" "$INSTDIR\Hyokai.exe" 0
  
SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\info_informationsea_Hyokai"
  DeleteRegKey HKLM SOFTWARE\info_informationsea_Hyokai

  ; Remove files and uninstaller
  Delete $INSTDIR\vcredist_x86.exe
  Delete $INSTDIR\Hyokai.exe
  Delete $INSTDIR\License.txt
  Delete $INSTDIR\uninstall.exe
  
  ${unregisterExtension} ".sqlite3" "SQLite3 Database"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Hyokai\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Hyokai"
  RMDir "$INSTDIR"

SectionEnd
