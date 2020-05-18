unit unit_CadTurma;

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
   , FMX.EditBox
   , FMX.SpinBox
   , FMX.DateTimeCtrls
   , FMX.StdCtrls
   , FMX.Edit
   , FMX.Controls.Presentation
   , Turma
   ;
{$ENDREGION}

type
  Tform_CadTurma = class(TForm)
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    edTurma: TEdit;
    lbTurma: TLabel;
    sbtnBusca: TSpeedButton;
    lbDtInicio: TLabel;
    lbDtFim: TLabel;
    dtInicio: TDateEdit;
    dtFim: TDateEdit;
    lbSemestre: TLabel;
    spSemestre: TSpinBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure spSemestreChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_CadTurma : Tform_CadTurma;
  vTurma        : TTurma;

implementation

{$R *.fmx}

uses Consulta;

procedure Tform_CadTurma.FormCreate(Sender: TObject);
begin
  vTurma := TTurma.Create('turma');
  vTurma.estado   := 0;
  edTurma.Text    := '';
  dtInicio.Date   := Date();
  dtFim.Date      := IncMonth(dtInicio.Date, 6);
  spSemestre.Text := IntToStr(1);
end;

procedure Tform_CadTurma.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vTurma);
end;

procedure Tform_CadTurma.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Turmas');
    vConsulta.setTextosql('Select id_turma ''Código'',' +
                          'descricao Turma, dt_ini ''dt.Início'', dt_fim ''dt.Fim.'', semestre ''Semestre'' '+
                          'from turma order by descricao');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vTurma.select(0,vConsulta.getRetorno);

             if vTurma.isExiteSlvalores then
                begin
                  edTurma.Text     := vTurma.getCampoFromListaValores(1);
                  dtInicio.Date    := StrToDate(vTurma.getCampoFromListaValores(2));
                  dtFim.Date       := StrToDate(vTurma.getCampoFromListaValores(3));
                  spSemestre.Value := StrToInt(vTurma.getCampoFromListaValores(4));
                  vTurma.estado    := 1;
                end
             else
                begin
                  vTurma.estado := 0;
                  edTurma.Text    := '';
                  dtInicio.Date   := Date();
                  dtFim.Date      := IncMonth(dtInicio.Date, 6);
                  spSemestre.Text := IntToStr(1);
                end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_CadTurma.sbtnExcluirClick(Sender: TObject);
begin
  if (vTurma.getEstado = 0) then
      exit;
  vTurma.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure Tform_CadTurma.sbtnNovoClick(Sender: TObject);
begin
  vTurma.utilitario.LimpaTela(self);
  edTurma.SetFocus;
  vTurma.estado := 0;
end;

procedure Tform_CadTurma.sbtnSalvarClick(Sender: TObject);
begin
  if (vTurma.getEstado = 1) then
      begin
        vTurma.slValores.Strings[1] := edTurma.Text;
        vTurma.slValores.Strings[2] := DateToStr(dtInicio.Date);
        vTurma.slValores.Strings[3] := DateToStr(dtFim.Date);
        vTurma.slValores.Strings[4] := spSemestre.Text;
      end
  else
      begin
        vTurma.slValores.Clear;
        vTurma.slValores.Add('0');
        vTurma.slValores.Add(edTurma.Text);
        vTurma.slValores.Add(DateToStr(dtInicio.Date));
        vTurma.slValores.Add(DateToStr(dtFim.Date));
        vTurma.slValores.Add(spSemestre.Text);
      end;

  vTurma.insert(vTurma.slValores);
  vTurma.utilitario.LimpaTela(self);
  edTurma.SetFocus;
end;

procedure Tform_CadTurma.spSemestreChange(Sender: TObject);
begin
  if spSemestre.Value = 1 then
     dtFim.Date := IncMonth(dtInicio.Date, 6)
  else
  if spSemestre.Value = 2 then
     dtFim.Date := IncMonth(dtInicio.Date, 12)
  else
  if spSemestre.Value = 3 then
     dtFim.Date := IncMonth(dtInicio.Date, 18)
  else
  if spSemestre.Value = 4 then
     dtFim.Date := IncMonth(dtInicio.Date, 24)
  else
  if spSemestre.Value = 5 then
     dtFim.Date := IncMonth(dtInicio.Date, 30);
end;

end.
