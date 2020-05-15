unit Unit_CadTurma;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.DateTimeCtrls, FMX.ListBox, FMX.Edit, FMX.Controls.Presentation, Turma,
  Data.DB, Datasnap.DBClient;

type
  TForm_CadTurma = class(TForm)
    lbDsc: TLabel;
    edDsc: TEdit;
    cbSemestre: TComboBox;
    deInic: TDateEdit;
    deFim: TDateEdit;
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    Label1: TLabel;
    lbDtInic: TLabel;
    Label2: TLabel;
    sbtnBusca: TSpeedButton;
    procedure sbtnBuscaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadTurma: TForm_CadTurma;
  vTurma : TTurma;

implementation

{$R *.fmx}

uses unit_BancoDados, Consulta;

procedure TForm_CadTurma.FormCreate(Sender: TObject);
begin
  vTurma := TTurma.Create('TURMA');
end;

procedure TForm_CadTurma.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vTurma);
end;

procedure TForm_CadTurma.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo('Consulta Turma');
    vConsulta.setTextosql('Select id_turma ''Código'',' +
                          'descricao ''Descricao'', DT_INI ''Data Inicial'', DT_FIM ''Data Fim'', '+
                          'semestre ''Semestre'''+
                          'from turma order by id_turma');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
       begin
             vTurma.select(0,vConsulta.getRetorno);

             if (vTurma.isExiteSlvalores) then
               begin
                    edDsc.Text := vTurma.getCampoFromListaValores(1);
                    deInic.Date := StrToDate(vTurma.getCampoFromListaValores(2));
                    deFim.Date := StrToDate(vTurma.getCampoFromListaValores(3));
                    cbSemestre.ItemIndex := StrToInt(vTurma.getCampoFromListaValores(4));
                    vTurma.estado := 1;
               end
             else
                 begin
                    vTurma.estado := 0;
                    edDsc.Text := '';
                    deInic.Date := Date;
                    deFim.Date := Date;
                    cbSemestre.ItemIndex := 0;
                 end;
       end;

  finally
    FreeAndNil(vConsulta);
  end;
end;


procedure TForm_CadTurma.sbtnExcluirClick(Sender: TObject);
begin
  if (vTurma.getEstado = 0) then
       exit;
  vTurma.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure TForm_CadTurma.sbtnNovoClick(Sender: TObject);
begin
 vTurma.utilitario.LimpaTela(self);
 edDsc.SetFocus;
 vTurma.estado := 0;
end;

procedure TForm_CadTurma.sbtnSalvarClick(Sender: TObject);
begin
  if (vTurma.getEstado = 1) then
   begin
    vTurma.slValores.Strings[1] := edDsc.Text;
    vTurma.slValores.Strings[2] := DateToStr(deInic.Date);
    vTurma.slValores.Strings[3] := DateToStr(deFim.Date);
    vTurma.slValores.Strings[4] := IntToStr(cbSemestre.ItemIndex);
   end
  else
   begin
     vTurma.slValores.Clear;
     vTurma.slValores.Add('0');
     vTurma.slValores.Add(edDsc.Text);
     vTurma.slValores.Add(DateToStr(deInic.Date));
     vTurma.slValores.Add(DateToStr(deFim.Date));
     vTurma.slValores.Add(IntToStr(cbSemestre.ItemIndex));
   end;

  vTurma.insert(vTurma.slValores);

  vTurma.utilitario.LimpaTela(self);
  edDsc.SetFocus;
end;

end.

