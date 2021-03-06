unit uDataModulo;

interface

uses
  System.SysUtils, System.Classes, REST.Types, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  IdBaseComponent, IdMessage, Data.DB, Datasnap.DBClient;

type
  TDM = class(TDataModule)
    CDS: TClientDataSet;
    CDSNome: TStringField;
    CDSIdentidade: TStringField;
    CDSCPF: TStringField;
    CDSTelefone: TStringField;
    CDSEmail: TStringField;
    CDSCEP: TStringField;
    CDSLogradouro: TStringField;
    CDSNro: TIntegerField;
    CDSComplemento: TStringField;
    CDSBairro: TStringField;
    CDSLocalidade: TStringField;
    CDSUF: TStringField;
    CDSPais: TStringField;
    DS: TDataSource;
    IdMessage: TIdMessage;
    IdSMTP: TIdSMTP;
    rClient: TRESTClient;
    rResponse: TRESTResponse;
    rRequest: TRESTRequest;
    OpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  CDS.CreateDataSet;
  CDS.Open;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(CDS);
end;

end.
