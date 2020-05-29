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
   , FMX.Objects
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
   , Data.DB
   , Datasnap.DBClient;
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
    Label4: TLabel;
    edMatricula: TEdit;
    cbTurma: TComboBox;
    lbTurma: TLabel;
    lbCurso: TLabel;
    cbCurso: TComboBox;
    imgFotoPerfil: TImage;
    btnAddFoto: TButton;
    odFotoPerfil: TOpenDialog;
    procedure edCpfExit(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
    procedure btnAddFotoClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    procedure setCadAluno(sEstado:Integer);
    procedure setCadProfessor(sEstado:Integer);
    procedure getCadAluno(pIdPessoa:String);
    procedure getCadAlunoTurma(pIdAluno:String);
    procedure getCadAlunoTurmaMateria(pIdAlunoTurma:String);
    procedure getCadProfessor(pIdCadPessoa:String);
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
  vAluno_Turma_Materia : TAluno_Turma_Materia;
  vFoto                : TCadastro;
  FCadastro            : TCadastro;

implementation

{$R *.fmx}

uses unit_BancoDados, Consulta;

procedure TForm_CadPessoa.btnAddFotoClick(Sender: TObject);
begin
  if (odFotoPerfil.Execute) then
      begin
        imgFotoPerfil.Bitmap.LoadFromFile(odFotoPerfil.FileName);
        imgFotoPerfil.Tag := 0;
      end;
end;

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

  vProfessor := TProfessor.Create('professor');
  vProfessor.estado := 0;

  vAluno       := TAluno.Create('aluno');
  vAluno_Turma := TAluno_Turma.Create('aluno_turma');
  vAluno_Turma_Materia := TAluno_Turma_Materia.Create('aluno_turma_materia');
  vFoto                       := TCadastro.Create('foto');
  vPessoa.estado := 0;
  vAluno.estado  := 0;
  vAluno_Turma.estado := 0;
  vAluno_Turma_Materia.estado := 0;

  vConsulta := TConsulta.create;
  try
    vConsulta.getCarregaCB('turma','descricao',cbTurma);
    vConsulta.getCarregaCB('curso','nome',cbCurso);
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
  FreeAndNil(vAluno);
  FreeAndNil(vAluno_Turma);
  FreeAndNil(vAluno_Turma_Materia)
end;

procedure TForm_CadPessoa.getCadAluno(pIdPessoa: String);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('select * '+#13+
                          '  from Aluno'+#13+
                          ' where id_pessoa = '+
                          Format('%s', [pIdPessoa]));

    vAluno.slCampos.Add('ID_ALUNO');
    vAluno.slCampos.Add('ID_PESSOA');
    vAluno.slValores := vConsulta.getConsultaDados(vAluno.slCampos);

    getCadAlunoTurma(vAluno.getCampoFromListaValores(0));

  finally
    FreeAndNil(vConsulta);
  end;

end;

procedure TForm_CadPessoa.getCadAlunoTurma(pIdAluno: String);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('select * '+#13+
                          '  from aluno_turma'+#13+
                          ' where id_aluno = '+
                          Format('%s', [pIdAluno]));

    vAluno_Turma.slCampos.Add('ID_ALUNO_TURMA');
    vAluno_Turma.slCampos.Add('ID_ALUNO');
    vAluno_Turma.slCampos.Add('ID_TURMA');
    vAluno_Turma.slCampos.Add('ID_CURSO');
    vAluno_Turma.slValores := vConsulta.getConsultaDados(vAluno_Turma.slCampos);

    getCadAlunoTurmaMateria(vAluno_Turma.getCampoFromListaValores(0));
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadPessoa.getCadAlunoTurmaMateria(pIdAlunoTurma: String);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('select * '+#13+
                          '  from aluno_turma_materia'+#13+
                          ' where id_aluno_turma = '+
                          Format('%s', [pIdAlunoTurma]));

    vAluno_Turma_Materia.slCampos.Add('ID_TURMA_MATERIA');
    vAluno_Turma_Materia.slCampos.Add('ID_ALUNO_TURMA');
    vAluno_Turma_Materia.slCampos.Add('ID_MATERIA');
    vAluno_Turma_Materia.slValores := vConsulta.getConsultaDados(vAluno_Turma_Materia.slCampos);
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadPessoa.getCadProfessor(pIdCadPessoa: String);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTextosql('select * '+#13+
                          '  from professor'+#13+
                          ' where id_professor = '+
                          Format('%s', [pIdCadPessoa]));


    vProfessor.slCampos.Clear;
    vProfessor.slCampos.Add('ID_PROFESSOR');
    vProfessor.slCampos.Add('ID_PESSOA');
    vProfessor.slValores := vConsulta.getConsultaDados(vProfessor.slCampos);
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_CadPessoa.habilitaTurmaCurso(ativo:Boolean);
begin
  lbCurso.Visible := not ativo;
  lbTurma.Visible := not ativo;
  cbTurma.Visible := not ativo;
  cbCurso.Visible := not ativo;
end;

procedure Tform_CadPessoa.setCadAluno(sEstado:Integer);
begin
  vAluno.estado := sEstado;
  try
    //Estado = 0 - Inserir
    //Estado = 1 - Atualizar
    if (vAluno.estado = 0) then
      begin
        vAluno.slValores.Add('0');
        vAluno.slValores.Add(vPessoa.slValores.Strings[0]);
        vAluno.insert(vAluno.slValores);

        vAluno_Turma.slValores.Add('0');
        vAluno_Turma.slValores.Add(vAluno.getCampoFromListaValores(0));
        vAluno_Turma.slValores.Add(IntToStr(Integer(cbTurma.Items.Objects[cbTurma.ItemIndex])));
        vAluno_Turma.slValores.Add(IntToStr(Integer(cbCurso.Items.Objects[cbCurso.ItemIndex])));
        vAluno_Turma.insert(vAluno_Turma.slValores);

        vAluno_Turma_Materia.slValores.Add('0');
        vAluno_Turma_Materia.slValores.Add(vAluno_Turma.getCampoFromListaValores(0));
        vAluno_Turma_Materia.slValores.Add('0');
        vAluno_Turma_Materia.insertAlunoTurmaMateria(vAluno_Turma.getCampoFromListaValores(3),
                                                     vAluno_Turma_Materia.slValores);
      end
    else
      begin
        vAluno_Turma_Materia.deleteAlunoTurmaMateria(vAluno_Turma_Materia.getCampoFromListaValores(3));

        vAluno_Turma.slValores.Clear;
        vAluno_Turma.slValores.Add('0');
        vAluno_Turma.slValores.Add(vAluno.getCampoFromListaValores(0));
        vAluno_Turma.slValores.Add(IntToStr(Integer(cbTurma.Items.Objects[cbTurma.ItemIndex])));
        vAluno_Turma.slValores.Add(IntToStr(Integer(cbCurso.Items.Objects[cbCurso.ItemIndex])));
        vAluno_Turma.insert(vAluno_Turma.slValores);

        vAluno_Turma_Materia.slValores.Clear;
        vAluno_Turma_Materia.slValores.Add('0');
        vAluno_Turma_Materia.slValores.Add(vAluno_Turma.getCampoFromListaValores(0));
        vAluno_Turma_Materia.slValores.Add('0');
        vAluno_Turma_Materia.insertAlunoTurmaMateria(vAluno_Turma.getCampoFromListaValores(3),
                                                     vAluno_Turma_Materia.slValores);
      end;

  finally


  end;
end;

procedure Tform_CadPessoa.setCadProfessor(sEstado:Integer);

begin
  try
    //Estado = 0 - Inserir
    //Estado = 1 - Atualizar
    if (vProfessor.estado = 0) then
     begin
       vProfessor.slValores.Add('0');
       vProfessor.slValores.Add(vPessoa.slValores.Strings[0]);
     end;
    vProfessor.insert(vProfessor.slValores);

  finally

  end;
end;

procedure Tform_CadPessoa.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Pessoas');
    vConsulta.setTextosql('Select a.id_pessoa Codigo,' +#13+
                          'a.nome Nome, a.cpf CPF, a.dt_nasc ''Dt.Nasc.'' '+#13+
                          'from pessoa a' +#13+
                          'where a.ativo <> 0 ' +#13+
                          'order by a.nome');
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
                  if (cbTipo.ItemIndex = 1) then
                    begin
                      getCadProfessor(vPessoa.getCampoFromListaValores(0));
                    end
                  else
                    begin
                      getCadAluno(vPessoa.getCampoFromListaValores(0));

                      cbCurso.ItemIndex := Integer(cbCurso.Items.Objects[
                                                   StrToInt(vAluno_Turma.getCampoFromListaValores(3))]);

                      cbTurma.ItemIndex := Integer(cbCurso.Items.Objects[
                                                   StrToInt(vAluno_Turma.getCampoFromListaValores(2))]);
                    end;

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
				  cbTurma.Index := 0;
				  cbCurso.Index := 0;
				  end;
			 
             if (odFotoPerfil.FileName = '') then
                 odFotoPerfil.FileName := GetCurrentDir +'\imagem.jpg';

             try
                 vFoto.getImagem(StrToInt(vPessoa.getCampoFromListaValores(0)), imgFotoPerfil);
                 imgFotoPerfil.Bitmap.SaveToFile(odFotoPerfil.FileName);
                 imgFotoPerfil.Repaint;
             except
                on e:exception do
                  begin
                       imgFotoPerfil.Bitmap := nil;
                  end;
             end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_CadPessoa.sbtnExcluirClick(Sender: TObject);
begin
  if (vPessoa.getEstado = 0) then
      exit
  else
    begin
      vPessoa.slValores.Strings[4] := IntToStr(0);
      vPessoa.insert(vPessoa.slValores);
    end;

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
        vPessoa.slValores.Strings[1] := edNome.Text;
        vPessoa.slValores.Strings[2] := edCpf.Text;
        vPessoa.slValores.Strings[3] := DateToStr(dtDataNasc.Date);
        vPessoa.slValores.Strings[4] := IntToStr(cbTipo.ItemIndex);
      end
  else
      begin
        vPessoa.slValores.Clear;
        vPessoa.slValores.Add('0');
        vPessoa.slValores.Add(edNome.Text);
        vPessoa.slValores.Add(edCpf.Text);
        vPessoa.slValores.Add(DateToStr(dtDataNasc.Date));
        vPessoa.slValores.Add(IntToStr(cbTipo.ItemIndex));
        vPessoa.slValores.Add('1');
      end;

  vPessoa.insert(vPessoa.slValores);
  vFoto.setImgFoto(StrToInt(vPessoa.getCampoFromListaValores(0)), odFotoPerfil.FileName);

  if (StrToInt(vPessoa.slValores.Strings[4]) = 1) then
    setCadProfessor(vPessoa.getEstado)
  else
    setCadAluno(vPessoa.getEstado);

  vPessoa.utilitario.LimpaTela(self);
  edNome.SetFocus;
end;

end.
