unit unit_Chamada;

interface

{$REGION 'Uses do Sistema'}
uses System.SysUtils
   , System.Types
   , System.UITypes
   , System.Classes
   , System.Variants
   , FMX.Types
   , FMX.Controls
   , FMX.Forms
   , FMX.Graphics
   , FMX.Dialogs
   , System.Rtti
   , FMX.Grid.Style
   , FMX.StdCtrls
   , FMX.ListBox
   , FMX.ScrollBox
   , FMX.Grid
   , FMX.Controls.Presentation
   , Utilitario
   , Turma
   , Materia
   , FireDAC.Comp.Client, FMX.DateTimeCtrls
   , Data.DB
   ;
{$ENDREGION}

type
  Tform_Chamada = class(TForm)
    pnInferior: TPanel;
    btnRegistrarDiario: TButton;
    pnPrincipal: TPanel;
    sgChamada: TStringGrid;
    pnSuperior: TPanel;
    cbTurma: TComboBox;
    cbMateria: TComboBox;
    lbTurma: TLabel;
    lbMateria: TLabel;
    sbConsulta: TSpeedButton;
    procedure sbConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnRegistrarDiarioClick(Sender: TObject);
  private
    { Private declarations }
    procedure CaregaStringGrid;

  public
    { Public declarations }
  end;

var
  form_Chamada : TForm_Chamada;
  vUtilitario  : TUtilitario;
  vTurma       : TTurma;
  vMateria     : TMateria;

implementation

{$R *.fmx}

uses unit_BancoDados, Consulta;

{ Tform_Chamada }

procedure Tform_Chamada.FormCreate(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  vTurma    := TTurma.Create('turma');
  vMateria  := TMateria.Create('materia');
  try
    vConsulta.setTextosql('Select * from turma');
    vConsulta.getCarregaCB('turma','descricao',cbTurma);

    vConsulta.setTextosql('Select * from materia');
    vConsulta.getCarregaCB('materia','nome',cbMateria);
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_Chamada.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vTurma);
  FreeAndNil(vMateria);
end;

procedure Tform_Chamada.btnRegistrarDiarioClick(Sender: TObject);
begin
  //Inserir na tabela diário.
end;

procedure Tform_Chamada.CaregaStringGrid;
var
  vConsulta : TConsulta;

begin
  vConsulta := TConsulta.create;

  try
    sgChamada.ClearColumns;
    vConsulta.setTextosql('select a.ID_ALUNO ''Matrícula''' +
                          '     , f.NOME ''Nome do Aluno''' +
                          '     , g.DATA ''Data''' +
                          '     , g.QTDE_AULAS_DIA ''Qtde de Aulas''' +
                          '     , g.QTDE_FALTAS ''Qtde de Faltas''' +
                          '  from aluno a' +
                          ' inner join aluno_turma b' +
                          '    on a.ID_ALUNO = b.ID_ALUNO' +
                          ' inner join aluno_turma_materia c' +
                          '    on b.ID_ALUNO_TURMA = c.ID_ALUNO_TURMA' +
                          ' inner join materia d' +
                          '    on c.ID_MATERIA = d.ID_MATERIA' +
                          ' inner join turma e' +
                          '    on b.ID_TURMA = e.ID_TURMA' +
                          ' inner join pessoa f' +
                          '    on a.ID_PESSOA = f.ID_PESSOA' +
                          '  left join diario g' +
	                         '    on c.ID_ALUNO_TURMA = g.ID_TURMA_MATERIA' +
                          ' where e.ID_TURMA = ' + IntToStr(Integer(cbTurma.Items.Objects[cbTurma.ItemIndex])) +
                          '   and d.ID_MATERIA = ' + IntToStr(Integer(cbMateria.Items.Objects[cbMateria.ItemIndex])));

    vConsulta.getConsultaToSg(sgChamada);
    vUtilitario.ajustaTamnhosg(sgChamada);
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_Chamada.sbConsultaClick(Sender: TObject);
begin
  CaregaStringGrid;
end;

end.
