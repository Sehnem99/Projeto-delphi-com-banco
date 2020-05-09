unit unit_BancoDados;

interface

uses
  System.SysUtils, System.Classes, Data.DBXMySQL, Data.FMTBcd, Data.DB,
  Data.SqlExpr, System.ImageList, FMX.ImgList, Data.DBXPool, Data.DBXTrace,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tdm_BancoDados = class(TDataModule)
    ImageList1: TImageList;
    FDEscola: TFDConnection;
    FDTransactionEscola: TFDTransaction;
    fdQrescola: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm_BancoDados: Tdm_BancoDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure Tdm_BancoDados.DataModuleCreate(Sender: TObject);
begin
     FDEscola.Connected := true;
end;

procedure Tdm_BancoDados.DataModuleDestroy(Sender: TObject);
begin
     FDEscola.Close;
end;

end.
