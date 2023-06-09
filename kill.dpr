program kill;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Tlhelp32;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot
                     (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,
                                 FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
         UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(
                        PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,
                                  FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    if ParamCount >0 then
    begin
      KillTask(ParamStr(1));
    end
    else
    Writeln('Kill.exe <application.exe>');

//    Writeln(ParamCount);
//    Writeln(ParamStr(0));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
