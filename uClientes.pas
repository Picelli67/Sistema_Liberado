unit uClientes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, Vcl.StdCtrls, Vcl.Mask,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.Json,
  Vcl.Buttons, Vcl.ExtCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP, IdMessage, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, Data.DB, Datasnap.DBClient, Vcl.DBCtrls, IdAttachmentFile;

type
  TFrmClientes = class(TForm)
    pnlSuperior: TPanel;
    pnlBotoes: TPanel;
    sbNovo: TSpeedButton;
    sbAltera: TSpeedButton;
    sbDeleta: TSpeedButton;
    sbSalva: TSpeedButton;
    sbCancela: TSpeedButton;
    sbFecha: TSpeedButton;
    pnDados: TPanel;
    gbEnd: TGroupBox;
    lblCep: TLabel;
    lblLogr: TLabel;
    lblCompl: TLabel;
    lblNro: TLabel;
    lblBai: TLabel;
    lblLoc: TLabel;
    lblUF: TLabel;
    lblPais: TLabel;
    lblNome: TLabel;
    lblIdent: TLabel;
    lblCPF: TLabel;
    lblTel: TLabel;
    Label1: TLabel;
    Nome: TDBEdit;
    Identidade: TDBEdit;
    CPF: TDBEdit;
    Telefone: TDBEdit;
    Email: TDBEdit;
    CEP: TDBEdit;
    Logradouro: TDBEdit;
    Nro: TDBEdit;
    Complemento: TDBEdit;
    Bairro: TDBEdit;
    Localidade: TDBEdit;
    UF: TDBEdit;
    Pais: TDBEdit;
    pnlNavegacao: TPanel;
    sbAnterior: TSpeedButton;
    sbPrimeiro: TSpeedButton;
    sbProximo: TSpeedButton;
    sbUltimo: TSpeedButton;
    procedure HabilitaBotoes;
    procedure PreencheCEP;
    procedure PreencheEmail;
    procedure LimpaEnd;
    procedure CEPEnter(Sender: TObject);
    procedure sbFechaClick(Sender: TObject);
    procedure sbSalvaClick(Sender: TObject);
    procedure CEPExit(Sender: TObject);
    procedure sbNovoClick(Sender: TObject);
    procedure sbAlteraClick(Sender: TObject);
    procedure sbDeletaClick(Sender: TObject);
    procedure sbCancelaClick(Sender: TObject);
    procedure sbPrimeiroClick(Sender: TObject);
    procedure sbAnteriorClick(Sender: TObject);
    procedure sbProximoClick(Sender: TObject);
    procedure sbUltimoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function Valida(mail: String): Boolean;
    procedure EmailExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmClientes: TFrmClientes;

implementation

{$R *.dfm}

uses uDataModulo;

procedure TFrmClientes.CEPEnter(Sender: TObject);
begin
  LimpaEnd;
end;

procedure TFrmClientes.CEPExit(Sender: TObject);
begin
  if Length(Cep.Text) < 8 then
  begin
    MessageDlg('CEP inv�lido!!!', mtError, [mbOk],0);
    Cep.SetFocus;
  end
  else begin
    DM.rClient.BaseURL:='https://viacep.com.br/ws/'+Cep.Text+'/json';
    PreencheCEP;
  end;
end;

procedure TFrmClientes.EmailExit(Sender: TObject);
begin
  if not Valida(Email.Text) then
    Email.SetFocus;
end;

procedure TFrmClientes.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var mail: String;
begin
  if DM.CDS.RecordCount > 0 then
  begin
    InputQuery('Endere�o para Envio:','E-Mail:',mail);
    if Valida(mail) then
    begin
      DM.IdMessage.Recipients.EMailAddresses:=mail;
      DM.idSMTP.Connect;
      if DM.idSMTP.Authenticate then
      begin
        PreencheEmail;
        DM.idSMTP.Send(DM.IdMessage);
        MessageDlg('Email Enviado!', mtInformation,[mbOk],0);
      end;
      DM.idSMTP.Disconnect();
      DM.CDS.Close;
    end
    else begin
      MessageDlg('Informe um e-mail v�lido!', mtError, [mbOk],0);
      CanClose:=False;
    end;
  end;
end;

procedure TFrmClientes.FormShow(Sender: TObject);
begin
  HabilitaBotoes;
end;

procedure TFrmClientes.HabilitaBotoes;
begin
  sbNovo.Enabled:=DM.CDS.State = dsBrowse;
  sbAltera.Enabled:=(sbNovo.Enabled) and (DM.CDS.RecordCount > 0);
  sbDeleta.Enabled:=sbAltera.Enabled;
  sbSalva.Enabled:=not sbNovo.Enabled;
  sbCancela.Enabled:=sbSalva.Enabled;
  sbPrimeiro.Enabled:=not DM.CDS.Bof;
  sbAnterior.Enabled:=sbPrimeiro.Enabled;
  sbUltimo.Enabled:=not DM.CDS.Eof;
  sbProximo.Enabled:=sbUltimo.Enabled;
// Hints
  sbNovo.ShowHint:=sbNovo.Enabled;
  sbAltera.ShowHint:=sbAltera.Enabled;
  sbDeleta.ShowHint:=sbDeleta.Enabled;
  sbSalva.ShowHint:=sbSalva.Enabled;
  sbCancela.ShowHint:=sbCancela.Enabled;
  sbPrimeiro.ShowHint:=sbPrimeiro.Enabled;
  sbAnterior.ShowHint:=sbAnterior.Enabled;
  sbUltimo.ShowHint:=sbUltimo.Enabled;
  sbProximo.ShowHint:=sbProximo.Enabled;

end;

procedure TFrmClientes.LimpaEnd;
begin
  logradouro.Clear;
  Nro.Clear;
  complemento.Clear;
  bairro.Clear;
  localidade.Clear;
  uf.Clear;
  pais.Clear;
end;

procedure TFrmClientes.PreencheEmail;
var x: Integer;
begin
  DM.IdMessage.Body.Clear;
  DM.IdMessage.Subject:='Cadastro de Clientes';
  DM.IdMessage.Body.Add('Informa��es do Cliente');
  DM.IdMessage.Body.Add('---------------------------------------------------');
  DM.CDS.First;
  DM.CDS.SaveToFile('Cliente.xml', dfXMLUTF8);
  While not DM.CDS.Eof do
  begin
    for x := 0 to DM.CDS.FieldCount - 1 do
      DM.IdMessage.Body.Add(DM.CDS.Fields[x].FieldName+': '+DM.CDS.Fields[x].AsString);
    DM.IdMessage.Body.Add('---------------------------------------------------');
    DM.CDS.Next;
  end;
  TIdAttachmentFile.Create(DM.IdMessage.MessageParts,TFileName('Cliente.xml'));
end;

procedure TFrmClientes.PreencheCEP;
var ret: TJSONValue;
    x:Integer;
begin
  DM.rRequest.Execute;
  ret:=DM.rResponse.JSONValue;
  if ret.FindValue('erro') <> nil then
  begin
    MessageDlg('CEP n�o encontrado!', mtInformation,[mbOk],0);
    MessageDlg('Se o Cliente for Estrangeiro preencha todos os campos manualmente!', mtInformation,[mbOk],0);
    Exit;
  end;
  for x := 0 to DM.CDS.FieldCount - 1 do
  begin
    if ret.FindValue(DM.CDS.Fields[x].DisplayLabel) <> nil then
      DM.CDS.Fields[x].Value:=StringReplace(ret.FindValue(DM.CDS.Fields[x].DisplayLabel).ToString,'"','',[rfReplaceAll]);
  end;
end;

procedure TFrmClientes.sbAlteraClick(Sender: TObject);
begin
  DM.CDS.Edit;
  HabilitaBotoes;
  Nome.SetFocus;
end;

procedure TFrmClientes.sbAnteriorClick(Sender: TObject);
begin
  DM.CDS.Prior;
  HabilitaBotoes;
end;

procedure TFrmClientes.sbCancelaClick(Sender: TObject);
begin
  DM.CDS.Cancel;
  HabilitaBotoes;
end;

procedure TFrmClientes.sbDeletaClick(Sender: TObject);
begin
  if MessageDlg('Confirma Exclus�o?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DM.CDS.Delete;
    HabilitaBotoes;
  end;
end;

procedure TFrmClientes.sbFechaClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmClientes.sbNovoClick(Sender: TObject);
begin
  DM.CDS.Append;
  HabilitaBotoes;
  Nome.SetFocus;
end;

procedure TFrmClientes.sbPrimeiroClick(Sender: TObject);
begin
  DM.CDS.First;
  HabilitaBotoes;
end;

procedure TFrmClientes.sbProximoClick(Sender: TObject);
begin
  DM.CDS.Next;
  HabilitaBotoes;
end;

procedure TFrmClientes.sbSalvaClick(Sender: TObject);
begin
  DM.CDS.Post;
  HabilitaBotoes;
end;

procedure TFrmClientes.sbUltimoClick(Sender: TObject);
begin
  DM.CDS.Last;
  HabilitaBotoes;
end;

function TFrmClientes.Valida(mail: String): Boolean;
begin
  mail:=Trim(mail);
  if Pos('@', mail) > 1 then
  begin
    Delete(mail, 1, pos('@', mail));
    Result := (Length(mail) > 0) and (Pos('.', mail) >= 1);
   end
   else
     Result := False;
end;

end.
