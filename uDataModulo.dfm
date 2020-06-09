object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 185
  Width = 334
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 33
    Top = 25
    object CDSNome: TStringField
      FieldName = 'Nome'
      Size = 50
    end
    object CDSIdentidade: TStringField
      FieldName = 'Identidade'
    end
    object CDSCPF: TStringField
      FieldName = 'CPF'
      EditMask = '000.000.000-00;0;_'
      Size = 11
    end
    object CDSTelefone: TStringField
      FieldName = 'Telefone'
      EditMask = '(00)00000-0000;0;_'
      Size = 11
    end
    object CDSEmail: TStringField
      FieldName = 'Email'
      Size = 50
    end
    object CDSCEP: TStringField
      FieldName = 'CEP'
      EditMask = '00.000-000;0;_'
      Size = 8
    end
    object CDSLogradouro: TStringField
      DisplayLabel = 'logradouro'
      FieldName = 'Logradouro'
      Size = 50
    end
    object CDSNro: TIntegerField
      FieldName = 'Nro'
    end
    object CDSComplemento: TStringField
      DisplayLabel = 'complemento'
      FieldName = 'Complemento'
    end
    object CDSBairro: TStringField
      DisplayLabel = 'bairro'
      FieldName = 'Bairro'
    end
    object CDSLocalidade: TStringField
      DisplayLabel = 'localidade'
      FieldName = 'Localidade'
      Size = 30
    end
    object CDSUF: TStringField
      DisplayLabel = 'uf'
      FieldName = 'UF'
      Size = 2
    end
    object CDSPais: TStringField
      FieldName = 'Pais'
    end
  end
  object DS: TDataSource
    AutoEdit = False
    DataSet = CDS
    Left = 32
    Top = 73
  end
  object IdMessage: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
        Address = 'picelli67@gmail.com'
        Name = 'Picelli'
        Text = 'Picelli <picelli67@gmail.com>'
        Domain = 'gmail.com'
        User = 'picelli67'
      end>
    From.Address = 'picelli67@gmail.com'
    From.Name = 'Picelli'
    From.Text = 'Picelli <picelli67@gmail.com>'
    From.Domain = 'gmail.com'
    From.User = 'picelli67'
    Recipients = <>
    ReplyTo = <>
    Subject = 'Novo Cliente cadastrado'
    ConvertPreamble = True
    Left = 105
    Top = 121
  end
  object IdSMTP: TIdSMTP
    IOHandler = OpenSSL
    Host = 'smtp.gmail.com'
    Password = 'jlp42566'
    Port = 587
    SASLMechanisms = <>
    UseTLS = utUseRequireTLS
    Username = 'picelli67@gmail.com'
    Left = 32
    Top = 121
  end
  object rClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    Params = <>
    Left = 96
    Top = 25
  end
  object rResponse: TRESTResponse
    Left = 232
    Top = 25
  end
  object rRequest: TRESTRequest
    Client = rClient
    Params = <>
    Response = rResponse
    SynchronizedEvents = False
    Left = 160
    Top = 25
  end
  object OpenSSL: TIdSSLIOHandlerSocketOpenSSL
    Destination = 'smtp.gmail.com:587'
    Host = 'smtp.gmail.com'
    MaxLineAction = maException
    Port = 587
    DefaultPort = 0
    SSLOptions.Mode = sslmClient
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 174
    Top = 121
  end
end
