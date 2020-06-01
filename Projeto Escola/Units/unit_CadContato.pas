unit unit_CadContato;

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
   , FMX.ListBox
   , FMX.StdCtrls
   , FMX.Edit
   , FMX.Controls.Presentation
   , Contato
   ;
{$ENDREGION}

type
  Tform_CadContato = class(TForm)
    sbtnNovo: TSpeedButton;
    sbtnSalvar: TSpeedButton;
    sbtnExcluir: TSpeedButton;
    edEmail: TEdit;
    lbPessoa: TLabel;
    sbtnBusca: TSpeedButton;
    lbEmail: TLabel;
    cbPessoa: TComboBox;
    lbTelefone: TLabel;
    edTelefone: TEdit;
    edCelular: TEdit;
    lbCelular: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnBuscaClick(Sender: TObject);
    procedure sbtnExcluirClick(Sender: TObject);
    procedure sbtnNovoClick(Sender: TObject);
    procedure sbtnSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_CadContato : Tform_CadContato;
  vContato        : TContato;

implementation

{$R *.fmx}

uses Consulta;

procedure Tform_CadContato.FormCreate(Sender: TObject);
var
  vConsulta : TConsulta;
begin
   vContato := TContato.Create('CONTATO');
   vConsulta := TConsulta.create;
   try
     vConsulta.getCarregaCB('pessoa','nome',cbPessoa);
   finally
     FreeAndNil(vConsulta);
   end;
end;

procedure Tform_CadContato.FormDestroy(Sender: TObject);
begin
  FreeAndNil(vContato);
end;

procedure Tform_CadContato.sbtnBuscaClick(Sender: TObject);
var
  vConsulta : TConsulta;
begin
  vConsulta := TConsulta.create;
  try
    vConsulta.setTitulo  ('Consulta Contato');
    vConsulta.setTextosql('select c.id_contato ''Código'',' +
                          '       p.id_pessoa ''Pessoa'',' +
                          '       p.nome ''Nome'', ' +
                          '       c.email ''email'',' +
                          '       c.telefone ''Telefone'',' +
                          '       c.celular ''Celular'' ' +
                          '  from contato c, pessoa p'+
                          ' where c.id_pessoa = p.id_pessoa'+
                          ' order by nome');
    vConsulta.getConsulta;

    if (vConsulta.getRetorno <> '') then
        begin
          vContato.select(0,vConsulta.getRetorno);

          if (vContato.isExiteSlvalores) then
              begin
                cbPessoa.ItemIndex := StrToInt(vContato.getCampoFromListaValores(1));
                edEmail.Text       := vContato.getCampoFromListaValores(2);
                edTelefone.Text    := vContato.getCampoFromListaValores(3);
                edCelular.Text     := vContato.getCampoFromListaValores(4);
                vContato.estado    := 1;
              end
          else
              begin
                vContato.estado := 0;
                cbPessoa.ItemIndex := -1;
                edEmail.Text := '';
                edTelefone.Text := '';
                edCelular.Text := '';
              end;
        end;

  finally
    FreeAndNil(vConsulta);
  end;
end;

procedure Tform_CadContato.sbtnExcluirClick(Sender: TObject);
begin
  if (vContato.getEstado = 0) then
      exit;
  vContato.delete;
  sbtnNovoClick(sbtnNovo);
end;

procedure Tform_CadContato.sbtnNovoClick(Sender: TObject);
begin
  vContato.utilitario.LimpaTela(self);
  cbPessoa.SetFocus;
  vContato.estado := 0;
end;

procedure Tform_CadContato.sbtnSalvarClick(Sender: TObject);
begin

  vContato.utilitario.LimpaTela(self);
  cbPessoa.SetFocus;
end;

end.
