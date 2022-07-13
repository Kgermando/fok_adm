; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "FOKAD Admin"
#define MyAppVersion "1.0.0+2"
#define MyAppPublisher "Eventdrc Technology"
#define MyAppURL "https://eventdrc.com/"
#define MyAppExeName "fokad_admin.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{6A91739A-1157-4D52-9BA5-24EEFD365AA0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\licence.txt
InfoBeforeFile=C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\avant-installation.txt
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\installers
OutputBaseFilename=fokad
SetupIconFile=C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\windows\runner\resources\app_icon.ico
Password=fokad
Encryption=yes
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\flutter_secure_storage_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\pdfium.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\syncfusion_pdfviewer_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\K-GERMANDO\Documents\DEVELOPER\FLUTTER\PROJECT\fokad_admin\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

