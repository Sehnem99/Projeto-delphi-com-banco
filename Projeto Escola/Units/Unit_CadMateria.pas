unit Unit_CadMateria;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox, Materia, Curso;

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
    Label2: TLabel;
    cbProfessor: TComboBox;
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
     FID_Curso   : Integer;
     FID_Materia : Integer;
  public
    { Public declarations }
    Property PID_Curso   : Integer read FID_Curso   write FID_Curso;
    Property PID_Materia : Integer read FID_Materia write FID_Materia;
    procedure getCadCursoMateria;
  end;

var
  Form_CadMateria: TForm_CadMateria;
  vMateria: TMateria;
  vCadCurso_Materia: TCurso_Materia;

implementation

{$R *.fmx}

Uses Consulta;

procedure TForm_CadMateria.FormCreate(Sender: TObject);
var
  vConsulta : TConsulta;
begin
   vMateria := TMateria.Create('MATERIA');

   vConsulta := TConsulta.create;

   vCadCurso_Materia := TCurso_Materia.Create('curso_materia');
   vCadCurso_Materia.slValores.Clear;
   vCadCurso_Materia.slValores.Add(IntToStr(FID_Curso));

   try
     vConsulta.getCarregaCB('periodo','periodo',cbPeriodo);
     vConsulta.setTextosql( 'select a.id_professor,        '+#13+
	                        '         b.nome                 '+#13+
                          '  from professor a, pessoa b    '+#13+
                          ' where a.id_pessoa = b.id_pessoa');
     vConsulta.getCarregaCB('professor','nome',cbProfessor, True);
   finally
     FreeAndNil(vConsulta);
   end;
end;

procedure TForm_CadMateria.FormDestroy(Sender: TObject);
begin
   FreeAndNil(vMateria);
end;

procedure TForm_CadMateria.FormShow(Sender: TObject);
var
  vConsulta : TConsulta;

begin
  vConsulta := TConsulta.create;
  try
    if (FID_Materia <> 0) then
      begin
        vConsulta.setTextosql('select * '+#13+
                              '  from materia'+#13+
                              ' where id_materia = '+
                              Format('%s', [FID_Materia]));

       vMateria.slCampos.Add('ID_MATERIA');
       vMateria.slCampos.Add('ID_PERIODO');
       vMateria.slCampos.Add('NOME');
       vMateria.slValores := vConsulta.getConsultaDados(vMateria.slCampos);

       vConsulta.setTextosql('select * '+#13+
                           '  from curso_materia'+#13+
                           ' where id_materia = '+
                              Format('%s', [FID_Materia])+#13+
                           '   and id_curso   = '+
                              Format('%s', [FID_Curso]));



       vCadCurso_Materia.slValores.Add(vMateria.getCampoFromListaValores(0));
       edNome.Text := vMateria.getCampoFromListaValores(1);
       cbPeriodo.ItemIndex := StrToInt(vMateria.getCampoFromListaValores(2));
      end;
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadMateria.getCadCursoMateria;
begin
  try
    if (vCadCurso_Materia.getEstado = 0) then
      begin
        vCadCurso_Materia.slValores.Clear;
        vCadCurso_Materia.slValores.Add('0');
        vCadCurso_Materia.slValores.Add(IntToStr(FID_Curso));
        vCadCurso_Materia.slValores.Add(vMateria.getCampoFromListaValores(0));

        vCadCurso_Materia.insert(vCadCurso_Materia.slValores);
      end
  finally
  end;
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
                          '       m.id_periodo ''Codigo Periodo'','+
                          '       p.periodo ''Nome do Periodo'','+
                          '       m.id_professor ''Codigo Professor'','+
                          '       pe.nome ''Nome Professor'''+
                          '  from materia m,periodo p, curso_materia cm, professor pr, pessoa pe'+
                          ' where m.id_periodo = p.id_periodo'+
                          '   and m.id_materia = cm.id_Materia'+
                          '   and m.ID_PROFESSOR = pr.ID_PROFESSOR'+
                          '   and pr.ID_PESSOA = pe.ID_PESSOA'+
                          '   and cm.id_curso = '+ Format('%s',[IntToStr(FID_Curso)])+
                          ' order by Nome');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vMateria.select(0,vConsulta.getRetorno);

             if (vMateria.isExiteSlvalores) then
               begin
                 edNome.Text := vMateria.getCampoFromListaValores(3);

                 cbPeriodo.ItemIndex :=  Integer(cbPeriodo.Items.Objects[
                                         StrToInt(vMateria.getCampoFromListaValores(1))]);

                 cbProfessor.ItemIndex := Integer(cbProfessor.Items.Objects[
                                          StrToInt(vMateria.getCampoFromListaValores(2))]);




                 vMateria.estado := 1;

                 vConsulta.setTextosql('select * '+#13+
                                      '  from curso_materia'+#13+
                                      ' where id_materia = '+
                                      Format('%s', [vMateria.getCampoFromListaValores(0)])+
                                      ' and id_curso = '+
                                      Format('%s', [IntToStr(FID_Curso)]));

                 vCadCurso_Materia.slCampos.Add('ID_CURSO_MATERIA');
                 vCadCurso_Materia.slCampos.Add('ID_CURSO');
                 vCadCurso_Materia.slCampos.Add('ID_MATERIA');
                 vCadCurso_Materia.slValores := vConsulta.getConsultaDados(vCadCurso_Materia.slCampos);

                 vCadCurso_Materia.estado := vMateria.estado;
               end
             else
               begin
                 vMateria.estado := 0;
                 vCadCurso_Materia.estado := vMateria.estado;
                 edNome.Text := '';
                 cbPeriodo.ItemIndex := 1;
                 cbProfessor.ItemIndex := 1;
               end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadMateria.sbtnExcluirClick(Sender: TObject);
begin
  if (vMateria.getEstado = 0 ) and
     (vCadCurso_Materia.estado = 0) then
    exit;

  vCadCurso_Materia.delete;
  vMateria.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure TForm_CadMateria.sbtnNovoClick(Sender: TObject);
begin
  vMateria.utilitario.LimpaTela(self);
  edNome.SetFocus;
  vMateria.estado := 0;
  vCadCurso_Materia.estado := vMateria.getEstado;
end;

procedure TForm_CadMateria.sbtnSalvarClick(Sender: TObject);
begin
  if (vMateria.getEstado = 1) then
   begin
     vMateria.slValores.Strings[1] := IntToStr(Integer(cbPeriodo.Items.Objects[cbPeriodo.ItemIndex]));
     vMateria.slValores.Strings[2] := IntToStr(Integer(cbProfessor.Items.Objects[cbProfessor.ItemIndex]));
     vMateria.slValores.Strings[3] := edNome.Text;

   end
 else
   begin
     vMateria.slValores.Clear;
     vMateria.slValores.Add('0');
     vMateria.slValores.Add(IntToStr(Integer(cbPeriodo.Items.Objects[cbPeriodo.ItemIndex])));
     vMateria.slValores.Add(IntToStr(Integer(cbProfessor.Items.Objects[cbPeriodo.ItemIndex])));
     vMateria.slValores.Add(edNome.Text);
   end;

 vMateria.insert(vMateria.slValores);
 vMateria.utilitario.LimpaTela(self);
 getCadCursoMateria;
 edNome.SetFocus;
end;

end.
