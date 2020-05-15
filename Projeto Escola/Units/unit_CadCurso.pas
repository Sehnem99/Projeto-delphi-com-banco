unit unit_CadCurso;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, Curso, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Utilitario;

type
  TForm_CadCurso = class(TForm)
    edNome: TEdit;
    cbStatus: TComboBox;
    lbNome: TLabel;
    lbStatus: TLabel;
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    sbtnBusca: TSpeedButton;
    Panel1: TPanel;
    gridMaterias: TStringGrid;
    Panel2: TPanel;
    sbtnAdcExclMateria: TSpeedButton;
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnAdcExclMateriaClick(Sender: TObject);
    procedure gridMateriasCellDblClick(const Column: TColumn;
      const Row: Integer);

  private
    { Private declarations }
    FIDCurso : Integer;
    procedure CaregaStringGrid(vCodMateria: Integer);
  public
    { Public declarations }
  end;

var
  Form_CadCurso: TForm_CadCurso;
  vCurso: TCurso;
  vUtilitario : TUtilitario;

implementation

Uses Consulta, Unit_CadMateria;

{$R *.fmx}

procedure TForm_CadCurso.CaregaStringGrid(vCodMateria: Integer);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('SELECT A.ID_MATERIA  ''CODIGO'','#13+
                          '       B.NOME,      ''NOME'''#13+
                          '       C.PERIODO    ''PERIODO'''#13+
                          'FROM escola.curso_materia a, escola.materia b,'#13+
                          '     escola.periodo C              '#13+
                          'WHERE A.ID_MATERIA = B.ID_MATERIA  '#13+
                          'AND B.ID_PERIODO = C.ID_PERIODO    '#13+
                          'AND a.ID_CURSO =    ' );
    vConsulta.getConsultaToSg(gridMaterias);
    vUtilitario.ajustaTamnhosg(gridMaterias);




  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadCurso.FormCreate(Sender: TObject);
begin
  vCurso := TCurso.Create('curso');
  vCurso.estado := 0;
  FIDCurso := 0;
end;

procedure TForm_CadCurso.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vCurso);
end;

procedure TForm_CadCurso.gridMateriasCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
  //verifica id
  //caso tenh id, Pegar o id da materia selecionada e jogar para tela


end;

procedure TForm_CadCurso.sbtnAdcExclMateriaClick(Sender: TObject);
var
  vForm_CadMateria : TForm_CadMateria;
begin
  vForm_CadMateria :=  TForm_CadMateria.Create(Self);
  try
    vForm_CadMateria.ShowModal;
  finally
    FreeAndNil(vForm_CadMateria);
  end;
end;

procedure TForm_CadCurso.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Cursos');
    vConsulta.setTextosql('Select id_curso ''Código'',' +
                          'Nome Nome, Ativo ''Status'' '+
                          'from curso order by nome');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vCurso.select(0,vConsulta.getRetorno);

             if (vCurso.isExiteSlvalores) then
               begin
                    edNome.Text := vCurso.getCampoFromListaValores(1);
                    cbStatus.Index := StrToInt(vCurso.getCampoFromListaValores(2));
                    vCurso.estado := 1;
               end
             else
                 begin
                      vCurso.estado := 0;
                      edNome.Text := '';
                      cbStatus.Index := 0;
                 end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadCurso.sbtnExcluirClick(Sender: TObject);
begin
  if (vCurso.getEstado = 0) then
    exit;
  vCurso.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure TForm_CadCurso.sbtnNovoClick(Sender: TObject);
begin
  vCurso.utilitario.LimpaTela(self);
  edNome.SetFocus;
  vCurso.estado := 0;
end;

procedure TForm_CadCurso.sbtnSalvarClick(Sender: TObject);
begin
 if (vCurso.getEstado = 1) then
   begin
     vCurso.slValores.Strings[1] := edNome.Text;
     vCurso.slValores.Strings[2] := IntToStr(cbStatus.ItemIndex);
   end
 else
   begin
     vCurso.slValores.Clear;
     vCurso.slValores.Add('0');
     vCurso.slValores.Add(edNome.Text);
     vCurso.slValores.Add(IntToStr(cbStatus.ItemIndex));
   end;

 vCurso.insert(vCurso.slValores);
 vCurso.utilitario.LimpaTela(self);
 edNome.SetFocus;
end;

end.
