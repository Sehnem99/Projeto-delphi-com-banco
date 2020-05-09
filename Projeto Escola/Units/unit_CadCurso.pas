unit unit_CadCurso;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Edit, Curso;

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
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadCurso: TForm_CadCurso;
  vCurso: TCurso;

implementation

Uses Consulta  ;

{$R *.fmx}

procedure TForm_CadCurso.FormCreate(Sender: TObject);
begin
  vCurso := TCurso.Create('curso');
  vCurso.estado := 0;
end;

procedure TForm_CadCurso.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vCurso);
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
                    edNome.Text := vCurso.getCampoFromListaValores(0);
                    cbStatus.Index := StrToInt(vCurso.getCampoFromListaValores(1));
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
