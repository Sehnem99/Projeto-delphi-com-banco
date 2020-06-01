unit unit_Principal;

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
   , FMX.Controls.Presentation
   , FMX.Layouts
   , FMX.DateTimeCtrls
   , FMX.Edit
   , FMX.Menus
   , FMX.ExtCtrls
   , FMX.Objects
   ;
{$ENDREGION}

type
  Tform_Principal = class(TForm)
    MainMenu: TMainMenu;
    mnCadastro: TMenuItem;
    mnChamada: TMenuItem;
    MenuItem3: TMenuItem;
    mnCurso: TMenuItem;
    mnPeriodo: TMenuItem;
    imgPrincipal: TImage;
    mnTurma: TMenuItem;
    procedure MenuItem3Click(Sender: TObject);
    procedure mnCursoClick(Sender: TObject);
    procedure mnPeriodoClick(Sender: TObject);
    procedure mnChamadaClick(Sender: TObject);
    procedure mnTurmaClick(Sender: TObject);
    procedure mnMateriaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_Principal: Tform_Principal;

implementation

{$R *.fmx}

uses unit_BancoDados
   , unit_CadCurso
   , unit_CadTurma
   , unit_CadPessoal
   , unit_CadMateria
   , unit_CadPeriodo
   , unit_CadContato
   , unit_Chamada
   ;

procedure Tform_Principal.MenuItem3Click(Sender: TObject);
var
  vForm_CadPessoa : TForm_CadPessoa;
begin
  vForm_CadPessoa := Tform_CadPessoa.Create(Self);
  try
    vForm_CadPessoa.ShowModal;
  finally
    FreeAndNil(vForm_CadPessoa);
  end;
end;

procedure Tform_Principal.mnChamadaClick(Sender: TObject);
var
  vForm_Chamada : TForm_Chamada;
begin
  vForm_Chamada := TForm_Chamada.Create(Self);
  try
    vForm_Chamada.ShowModal;
  finally
    FreeAndNil(vForm_Chamada);
  end;
end;

procedure Tform_Principal.mnCursoClick(Sender: TObject);
var
  vForm_CadCurso : Tform_CadCurso;
begin
  vForm_CadCurso := Tform_CadCurso.Create(Self);
  try
    vForm_CadCurso.ShowModal;
  finally
    FreeAndNil(vForm_CadCurso);
  end;
end;

procedure Tform_Principal.mnMateriaClick(Sender: TObject);
var
  vForm_CadMateria : Tform_CadMateria;
begin
  vForm_CadMateria := Tform_CadMateria.Create(Self);
  try
    vForm_CadMateria.ShowModal;
  finally
    FreeAndNil(vForm_CadMateria);
  end;
end;

procedure Tform_Principal.mnPeriodoClick(Sender: TObject);
var
  vForm_CadPeriodo : Tform_CadPeriodo;
begin
  vForm_CadPeriodo := Tform_CadPeriodo.Create(Self);
  try
    vForm_CadPeriodo.ShowModal;
  finally
    FreeAndNil(vForm_CadPeriodo);
  end;
end;

procedure Tform_Principal.mnTurmaClick(Sender: TObject);
var
  vForm_CadTurma : Tform_CadTurma;
begin
  vForm_CadTurma := Tform_CadTurma.Create(Self);
  try
    vForm_CadTurma.ShowModal;
  finally
    FreeAndNil(vForm_CadTurma);
  end;
end;

end.
