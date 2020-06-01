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
    dtInicio: TDateEdit;
    dtFim: TDateEdit;
    lbDtInicio: TLabel;
    lbDtFim: TLabel;
    procedure sbConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CaregaStringGrid(vCodTurma, vCodMateria: Integer);

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
  try
    vConsulta.setTextosql('Select * from turma');
    vConsulta.getCarregaCB('turma','descricao',cbTurma);

    vConsulta.setTextosql('Select * from materia');
    vConsulta.getCarregaCB('materia','nome',cbMateria);
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_Chamada.CaregaStringGrid(vCodTurma, vCodMateria: Integer);
var
  i : Integer;
  aluno_diario : TFDQuery;
  utilitario   : TUtilitario;
begin
  utilitario := TUtilitario.Create;

  aluno_diario := TFDQuery.Create(nil);
  aluno_diario.Connection := dm_BancoDados.FDEscola;
  aluno_diario.Close;
  aluno_diario.SQL.Clear;
  aluno_diario.SQL.Add('  select *');
  aluno_diario.SQL.Add('    from aluno a');
  aluno_diario.SQL.Add('   inner join aluno_turma b');
  aluno_diario.SQL.Add('      on a.ID_ALUNO = b.ID_ALUNO');
  aluno_diario.SQL.Add('   inner join aluno_turma_materia c');
  aluno_diario.SQL.Add('      on b.ID_ALUNO_TURMA = c.ID_ALUNO_TURMA');
  aluno_diario.SQL.Add('   inner join materia d');
  aluno_diario.SQL.Add('      on c.ID_MATERIA = d.ID_MATERIA');
  aluno_diario.SQL.Add('   inner join turma e');
  aluno_diario.SQL.Add('      on b.ID_TURMA = e.ID_TURMA');
  aluno_diario.SQL.Add('   inner join pessoa f');
  aluno_diario.SQL.Add('      on a.ID_PESSOA = f.ID_PESSOA');
  aluno_diario.SQL.Add('   where e.ID_TURMA    = ' + IntToStr(Integer((cbTurma.Items.Objects[cbTurma.ItemIndex]))) +
                       '      and d.ID_MATERIA = ' + IntToStr(Integer((cbMateria.Items.Objects[cbMateria.ItemIndex]))));
  try
    aluno_diario.Open;

    if aluno_diario.IsEmpty then
       ShowMessage('Não há registros para esse filtro.');

    while not aluno_diario.Eof do
      begin
        utilitario.LimpaStringGrid(sgChamada);
        aluno_diario.First;

        while (not aluno_diario.Eof) do
          begin
           if (sgChamada.Cells[0,0] <> '') then
             sgChamada.RowCount := sgChamada.RowCount + 1;

           for i := 0 to aluno_diario.FieldCount -1 do
             sgChamada.Cells[i, sgChamada.RowCount -1] := aluno_diario.Fields[i].AsString;

              // sgChamada.Cells[aluno_diario.FieldCount, sgChamada.RowCount -1] := self.calculaFrequenciaGeral(StrToInt(dias_uteis_turma), aluno_diario.FieldByName('QTDE_FALTAS').AsInteger);

            aluno_diario.Next;
          end;
      end;
  except
    on e:exception do
      begin
        ShowMessage('Comando SQL não executado: ' + e.ToString);
        exit;
      end;
  end;
end;

procedure Tform_Chamada.sbConsultaClick(Sender: TObject);
begin
  CaregaStringGrid(cbTurma.ItemIndex, cbMateria.ItemIndex);
end;

end.
