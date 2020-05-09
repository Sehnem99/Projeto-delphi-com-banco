unit unit_CadPessoal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.DateTimeCtrls, FMX.Controls.Presentation, FMX.Edit,
  Pessoa, Professor, Aluno;

type
  Tform_CadPessoa = class(TForm)
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
    procedure edCpfExit(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure setCadAluno(sEstado:Integer);
    procedure setCadProfessor(sEstado:Integer);
  end;

var
  form_CadPessoa: Tform_CadPessoa;
  vPessoa   : TPessoa;
  vProfessor : TProfessor;
  vAluno : TAluno;
implementation

{$R *.fmx}

uses unit_BancoDados, Consulta;

procedure Tform_CadPessoa.edCpfExit(Sender: TObject);
begin
  //Procedure para buscar com CPF
end;

procedure Tform_CadPessoa.FormCreate(Sender: TObject);
begin
   vPessoa := TPessoa.Create('pessoa');
   vPessoa.estado := 0;
end;

procedure Tform_CadPessoa.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vPessoa);
  FreeAndNil(vAluno);
  FreeAndNil(vProfessor);
end;

procedure Tform_CadPessoa.setCadAluno(sEstado:Integer);
begin
  vAluno := TAluno.Create('aluno');
  vAluno.estado := sEstado;
  try
    //o valor 0 --> cadastrar (insert), o valor 1 --> alterar (update)
    if (vAluno.estado = 1) then
      begin
        {vAluno.slValores.Strings[1] := vPessoa.slValores.Strings[0];
        vAluno.insert(vAluno.slValores); }
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
    //o valor 0 --> cadastrar (insert), o valor 1 --> alterar (update)
    if (vProfessor.estado = 1) then
      begin
        {vProfessor.slValores.Add('0');
        vProfessor.slValores.Add(vPessoa.slValores.Strings[0]); }
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

             if (vPessoa.isExiteSlvalores) then
               begin
                    edMatricula.Text := vPessoa.getCampoFromListaValores(0);
                    edNome.Text := vPessoa.getCampoFromListaValores(1);
                    edCpf.Text := vPessoa.getCampoFromListaValores(2);
                    dtDataNasc.Date := StrToDate(vPessoa.getCampoFromListaValores(3));
                    cbTipo.ItemIndex := StrToInt(vPessoa.getCampoFromListaValores(4));
                    vPessoa.estado := 1;
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
  edNome.SetFocus;
  vPessoa.estado := 0;
end;

procedure Tform_CadPessoa.sbtnSalvarClick(Sender: TObject);

begin
  if (vPessoa.getEstado = 1) then
   begin
    vPessoa.slValores.Strings[0] := edMatricula.Text;
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
   end;

  vPessoa.insert(vPessoa.slValores);

  if (StrToInt(vPessoa.slValores.Strings[4]) = 1) then
    setCadProfessor(vPessoa.getEstado)
  else
    setCadAluno(vPessoa.getEstado);

  vPessoa.utilitario.LimpaTela(self);
  edNome.SetFocus;
end;

end.
