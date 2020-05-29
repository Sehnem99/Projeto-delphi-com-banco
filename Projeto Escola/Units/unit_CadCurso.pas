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

  private
    { Private declarations }
    procedure CaregaStringGrid(vCodCurso: Integer);

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

procedure TForm_CadCurso.CaregaStringGrid(vCodCurso: Integer);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    gridMaterias.ClearColumns;
    vConsulta.setTextosql('select a.id_materia  ''codigo'','#13+
                          '       b.nome      ''nome'','#13+
                          '       c.periodo    ''periodo'' '#13+
                          'from curso_materia a, materia b,'#13+
                          '     periodo c              '#13+
                          'where a.id_materia = b.id_materia  '#13+
                          'and b.id_periodo = c.id_periodo    '#13+
                          'and a.id_curso = ' + Format('%s', [vCurso.getCampoFromListaValores(0)]));

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
end;

procedure TForm_CadCurso.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vCurso);
end;

procedure TForm_CadCurso.sbtnAdcExclMateriaClick(Sender: TObject);
var
  vForm_CadMateria : TForm_CadMateria;
begin
  if (StrToInt(vCurso.getCampoFromListaValores(0)) <> 0) then
    begin
      vForm_CadMateria :=  TForm_CadMateria.Create(Self);
      try
        vForm_CadMateria.PID_Curso := StrToInt(vCurso.getCampoFromListaValores(0));
        vForm_CadMateria.ShowModal;
      finally
        FreeAndNil(vForm_CadMateria);
      end;
    end
  else
    begin
      ShowMessage('Antes de inserir ou alterar alguma materia voce deve cadastrar ou'+
                  'selecionar algum curso');
    end;
   CaregaStringGrid(StrToInt(vCurso.getCampoFromListaValores(0)));
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
                    cbStatus.ItemIndex := StrToInt(vCurso.getCampoFromListaValores(2)) + 1;
                    vCurso.estado := 1;

                    vConsulta.setTextosql('select * '+#13+
                                          '  from curso_materia'+#13+
                                          ' where id_curso = '+
                                          Format('%s', [vCurso.getCampoFromListaValores(0)]));

                    vCadCurso_Materia.slCampos.Add('ID_CURSO_MATERIA');
                    vCadCurso_Materia.slCampos.Add('ID_CURSO');
                    vCadCurso_Materia.slCampos.Add('ID_MATERIA');
                    vCadCurso_Materia.slValores := vConsulta.getConsultaDados(vCadCurso_Materia.slCampos);


               end
             else
                 begin
                      vCurso.estado := 0;
                      edNome.Text := '';
                      cbStatus.ItemIndex := -1;
                 end;
       end;
     CaregaStringGrid(StrToInt(vCurso.getCampoFromListaValores(0)));
  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure TForm_CadCurso.sbtnExcluirClick(Sender: TObject);
var
  vConsulta : TConsulta;
  fExisteMateriaCadastrada : Boolean;
begin
  if (vCurso.getEstado = 0) then
    exit
  else
    begin
      vConsulta := TConsulta.create;

      try
        vConsulta.setTextosql('select *'+
                              '   from curso_materia a'+
                              '  where a.ID_CURSO = '+
                              Format('%s', [vCurso.getCampoFromListaValores(0)]) );
        vCadCurso_Materia.slCampos.Add('ID_CURSO_MATERIA');
        vCadCurso_Materia.slCampos.Add('ID_CURSO');
        vCadCurso_Materia.slCampos.Add('ID_MATERIA');

        vConsulta.getConsultaDados(vCadCurso_Materia.slCampos);
        fExisteMateriaCadastrada := vConsulta.getfTemRegistroConsulta;

        if (not fExisteMateriaCadastrada) then
          begin
            vCurso.delete;
            vCurso.utilitario.LimpaTela(self);
            edNome.SetFocus;
          end
        else
          ShowMessage('Ante de excluir o curso, devese excluir todas as'+
                      ' Matérias deste curso');
                            
      finally
        FreeAndNil(vConsulta);
      end;
    end;
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
     vCurso.slValores.Strings[2] := IntToStr(cbStatus.ItemIndex - 1);
   end
 else
   begin
     vCurso.slValores.Clear;
     vCurso.slValores.Add('0');
     vCurso.slValores.Add(edNome.Text);
     vCurso.slValores.Add(IntToStr(cbStatus.ItemIndex - 1));
   end;

 vCurso.insert(vCurso.slValores);
 CaregaStringGrid(StrToInt(vCurso.getCampoFromListaValores(0)));
 vCurso.utilitario.LimpaTela(self);
 edNome.SetFocus;
end;

end.
