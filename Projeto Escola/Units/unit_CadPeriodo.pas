unit unit_CadPeriodo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, Periodo;

type
  TForm_CadPeriodo = class(TForm)
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    edNomePeriodo: TEdit;
    lbNomePeriodo: TLabel;
    sbtnBusca: TSpeedButton;
    procedure sbtnBuscaClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadPeriodo: TForm_CadPeriodo;
  vPeriodo : TPeriodo;

implementation

uses Consulta;


{$R *.fmx}

procedure TForm_CadPeriodo.FormCreate(Sender: TObject);
begin
  vPeriodo := TPeriodo.Create('periodo');
  vPeriodo.estado := 0;
end;

procedure TForm_CadPeriodo.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vPeriodo);
end;

procedure TForm_CadPeriodo.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Periodos');
    vConsulta.setTextosql('Select id_periodo ''Código'',' +
                          'Periodo Periodo from Periodo order by Periodo');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vPeriodo.select(0,vConsulta.getRetorno);

             if (vPeriodo.isExiteSlvalores) then
               begin
                 edNomePeriodo.Text := vPeriodo.getCampoFromListaValores(0);
                 vPeriodo.estado := 1;
               end
             else
               begin
                 vPeriodo.estado := 0;
                 edNomePeriodo.Text := '';
               end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadPeriodo.sbtnExcluirClick(Sender: TObject);
begin
  if (vPeriodo.getEstado = 0) then
    exit;
  vPeriodo.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure TForm_CadPeriodo.sbtnNovoClick(Sender: TObject);
begin
  vPeriodo.utilitario.LimpaTela(self);
  edNomePeriodo.SetFocus;
  vPeriodo.estado := 0;
end;

procedure TForm_CadPeriodo.sbtnSalvarClick(Sender: TObject);
begin
 if (vPeriodo.getEstado = 1) then
   begin
     vPeriodo.slValores.Strings[1] := edNomePeriodo.Text;
   end
 else
   begin
     vPeriodo.slValores.Clear;
     vPeriodo.slValores.Add('0');
     vPeriodo.slValores.Add(edNomePeriodo.Text);
   end;

 vPeriodo.insert(vPeriodo.slValores);
 vPeriodo.utilitario.LimpaTela(self);
 edNomePeriodo.SetFocus;
end;

end.
