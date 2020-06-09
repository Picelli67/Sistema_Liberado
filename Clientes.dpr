program Clientes;

uses
  Vcl.Forms,
  uClientes in 'uClientes.pas' {FrmClientes},
  uDataModulo in 'uDataModulo.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmClientes, FrmClientes);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
