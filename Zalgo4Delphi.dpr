program Zalgo4Delphi;

uses
  System.StartUpCopy,
  FMX.Forms,
  ZalgoMain in 'ZalgoMain.pas' {Form16};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm16, Form16);
  Application.Run;
end.
