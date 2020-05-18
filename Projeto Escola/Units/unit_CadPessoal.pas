unit unit_CadPessoal;

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
   , FMX.StdCtrls
   , FMX.ListBox
   , FMX.DateTimeCtrls
   , FMX.Controls.Presentation
   , FMX.Edit
   , Pessoa
   , Professor
   , Aluno
   , Turma
   , Curso
   , Cadastro
   ;
{$ENDREGION}

type
  TForm_CadPessoa = class(TForm)
    lbICadastro: TListBoxItem;
    edNome: TEdit;
    lbNome: TLabel;
    lbCPF: TLabel;
    edCpf: TEdit;
    lbDataNasc: TLabel;
    dtDataNasc: TDateEdit;
    lbTipo: TLabel;
    cbTipo: TComboBox;
    sbtnSalvar: TSpeedButton;
    sbtnBusca: TSpeedButton;
    sbtnNovo: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    IgFotoPerfil: TImageControl;
    Label2: TLabel;
    Label4: TLabel;
    edMatricula: TEdit;
    cbTurma: TComboBox;
    lbTurma: TLabel;
    lbCurso: TLabel;
    cbCurso: TComboBox;
    procedure edCpfExit(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure setCadAluno(sEstado:Integer);
    procedure setCadProfessor(sEstado:Integer);
    procedure habilitaTurmaCurso(ativo:Boolean);
  end;

var
  form_CadPessoa : TForm_CadPessoa;
  vPessoa        : TPessoa;
  vProfessor     : TProfessor;
  vAluno         : TAluno;
  vTurma         : TTurma;
  vCurso         : TCurso;
  vAluno_Turma   : TAluno_Turma;
  FCadastro      : TCadastro;

implementation

{$R *.fmx}

uses unit_BancoDados, Consulta;

procedure TForm_CadPessoa.cbTipoChange(Sender: TObject);
begin
  If cbTipo.ItemIndex <> 2 then
     habilitaTurmaCurso(True)
  Else
     habilitaTurmaCurso(False);
end;

procedure Tform_CadPessoa.edCpfExit(Sender: TObject);
begin
  //Procedure para buscar com CPF
end;

procedure Tform_CadPessoa.FormCreate(Sender: TObject);
var
  vConsulta : TConsulta;

begin
  vPessoa := TPessoa.Create('pessoa');
  vPessoa.estado := 0;

  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('Select * from turma');
    vConsulta.getCarregaCB(cbTurma,'descricao');

    vConsulta.setTextosql('Select * from curso');
    vConsulta.getCarregaCB(cbCurso,'nome');
  finally
    FreeAndNil(vConsulta);
  end;

  habilitaTurmaCurso(True);
end;

procedure Tform_CadPessoa.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vPessoa);
  FreeAndNil(vTurma);
  FreeAndNil(vCurso);
  FreeAndNil(vAluno_Turma);
end;

procedure Tform_CadPessoa.habilitaTurmaCurso(ativo:Boolean);
begin
  lbCurso.Visible := not ativo;
  lbTurma.Visible   := not ativo;
  cbTurma.Visible   := not ativo;
  cbCurso.Visible := not ativo;
end;

procedure Tform_CadPessoa.setCadAluno(sEstado:Integer);
begin
  vAluno := TAluno.Create('aluno');
  vAluno.estado := sEstado;
  try
    //Estado = 0 - Inserir
    //Estado = 1 - Atualizar
    if (vAluno.estado = 1) then
        begin
          //Se existir, atualizar.

          //vAluno.slValores.Add(vPessoa.getCampoFromListaValores(0));
          //vAluno.slValores.Add(vPessoa.slValores.Strings[0]);
          //vAluno.insert(vAluno.slValores);
        end
    else
        begin
          vAluno.slValores.Add('0');
          vAluno.slValores.Add(vPessoa.slValores.Strings[0]);
          vAluno.insert(vAluno.slValores);
        end;

  finally
    FreeAndNil(vAluno);
  end;
end;

procedure Tform_CadPessoa.setCadProfessor(sEstado:Integer);

begin
  vProfessor := TProfessor.Create('professor');
  vProfessor.estado := sEstado;
  try
    //Estado = 0 - Inserir
    //Estado = 1 - Atualizar
    if (vProfessor.estado = 1) then
        begin
          //Se existir, atualizar.
        end
    else
        begin
          vProfessor.slValores.Add('0');
          vProfessor.slValores.Add(vPessoa.slValores.Strings[0]);
      end;

    vProfessor.insert(vProfessor.slValores);

  finally
    FreeAndNil(vProfessor);
  end;
end;

procedure Tform_CadPessoa.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Pessoas');
    vConsulta.setTextosql('Select id_pessoa ''Código'',' +
                          'Nome Nome, Cpf Cpf, dt_nasc ''dt.Nasc.'' '+
                          'from pessoa order by nome');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
         vPessoa.select(0,vConsulta.getRetorno);

             if vPessoa.isExiteSlvalores then
                begin
                  edMatricula.Text := vPessoa.getCampoFromListaValores(0);
                  edNome.Text      := vPessoa.getCampoFromListaValores(1);
                  edCpf.Text       := vPessoa.getCampoFromListaValores(2);
                  dtDataNasc.Date  := StrToDate(vPessoa.getCampoFromListaValores(3));
                  cbTipo.ItemIndex := StrToInt(vPessoa.getCampoFromListaValores(4));
                  vPessoa.estado   := 1;
                end
             else
                begin
                  vPessoa.estado := 0;
                  edMatricula.Text := '';
                  edNome.Text := '';
                  edCpf.Text := '';
                  dtDataNasc.Date := Date;
                  cbTipo.Index := 0;
                end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_CadPessoa.sbtnExcluirClick(Sender: TObject);
begin
  if (vPessoa.getEstado = 0) then
      exit;
  vPessoa.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure Tform_CadPessoa.sbtnNovoClick(Sender: TObject);
begin
  vPessoa.utilitario.LimpaTela(self);
  edCpf.SetFocus;
  vPessoa.estado := 0;
end;

procedure Tform_CadPessoa.sbtnSalvarClick(Sender: TObject);
begin
  if (vPessoa.getEstado = 1) then
      begin
        vPessoa.slValores.Strings[0] := edNome.Text;
        vPessoa.slValores.Strings[1] := edCpf.Text;
        vPessoa.slValores.Strings[2] := DateToStr(dtDataNasc.Date);
        vPessoa.slValores.Strings[3] := IntToStr(cbTipo.ItemIndex);
      end
  else
      begin
        vPessoa.slValores.Clear;
        vPessoa.slValores.Add('0');
        vPessoa.slValores.Add(edNome.Text);
        vPessoa.slValores.Add(edCpf.Text);
        vPessoa.slValores.Add(DateToStr(dtDataNasc.Date));
        vPessoa.slValores.Add(IntToStr(cbTipo.ItemIndex));
      end;

  vPessoa.insert(vPessoa.slValores);

  if (StrToInt(vPessoa.slValores.Strings[4]) = 1) then
      setCadProfessor(vPessoa.getEstado)
  else
      begin
        vTurma       := TTurma.Create('turma');
        vCurso       := TCurso.Create('curso');
        vAluno_Turma := TAluno_Turma.Create('aluno_turma');

        setCadAluno(vPessoa.getEstado);

        vAluno_Turma.slValores.Add('0');
        vAluno_Turma.slValores.Add(vAluno.slValores(FCadastro.getIdMaxTabela));
        vAluno_Turma.slValores.Add(IntToStr(cbTurma.ItemIndex));
        vAluno_Turma.slValores.Add(IntToStr(cbCurso.ItemIndex));
        // Implementar para inserir em aluno_turma
      end;

  vPessoa.utilitario.LimpaTela(self);
  edNome.SetFocus;
end;

end.
