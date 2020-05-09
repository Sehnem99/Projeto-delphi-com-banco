unit Unit_CadMateria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, Materia;

type
  TForm_CadMateria = class(TForm)
    Label1: TLabel;
    edNome: TEdit;
    lbPeriodo: TLabel;
    cbPeriodo: TComboBox;
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    sbtnBusca: TSpeedButton;
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadMateria: TForm_CadMateria;
  vMateria: TMateria;

implementation

{$R *.fmx}

Uses Consulta;

procedure TForm_CadMateria.FormCreate(Sender: TObject);
var
  vConsulta : TConsulta;
begin
   vMateria := TMateria.Create('MATERIA');
   vConsulta := TConsulta.create;
   try
     vConsulta.setTextosql('Select * from periodo');
     vConsulta.getCarregaCB(cbPeriodo,'PERIODO');
   finally
     FreeAndNil(vConsulta);
   end;
end;

procedure TForm_CadMateria.FormDestroy(Sender: TObject);
begin
   FreeAndNil(vMateria);
end;

procedure TForm_CadMateria.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Materia');
    vConsulta.setTextosql('select m.id_materia ''Código'',' +
                          '       m.nome ''Nome'',' +
                          '       m.id_periodo''codigo periodo,'+
                          '       p.periodo ''Nome do Periodo'' '+
                          '  from materia m,periodo p'+
                          ' whete m.id_periodo = p.id_periodo'+
                          ' order by periodo');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vMateria.select(0,vConsulta.getRetorno);

             if (vMateria.isExiteSlvalores) then
               begin
                 edNome.Text := vMateria.getCampoFromListaValores(1);
                 cbPeriodo.ItemIndex := StrToInt(vMateria.getCampoFromListaValores(2));
                 vMateria.estado := 1;
               end
             else
               begin
                 vMateria.estado := 0;
                 edNome.Text := '';
                 cbPeriodo.ItemIndex := -1;
               end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadMateria.sbtnExcluirClick(Sender: TObject);
begin
  if (vMateria.getEstado = 0) then
    exit;
  vMateria.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure TForm_CadMateria.sbtnNovoClick(Sender: TObject);
begin
  vMateria.utilitario.LimpaTela(self);
  edNome.SetFocus;
  vMateria.estado := 0;
end;

procedure TForm_CadMateria.sbtnSalvarClick(Sender: TObject);
begin
  if (vMateria.getEstado = 1) then
   begin
     vMateria.slValores.Strings[1] := edNome.Text;
     vMateria.slValores.Strings[2] := IntToStr(cbPeriodo.ItemIndex);
   end
 else
   begin
     vMateria.slValores.Clear;
     vMateria.slValores.Add(edNome.Text);
     vMateria.slValores.Add(IntToStr(cbPeriodo.ItemIndex));

   end;

 vMateria.insert(vMateria.slValores);
 vMateria.utilitario.LimpaTela(self);
 edNome.SetFocus;
end;

end.
