program labaGlobal;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Global};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGlobal, Global);
  Application.Run;
end.
