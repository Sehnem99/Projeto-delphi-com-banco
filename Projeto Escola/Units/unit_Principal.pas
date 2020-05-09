unit unit_Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListBox, FMX.Controls.Presentation, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Edit, FMX.Menus;

type
  Tform_Principal = class(TForm)
    MainMenu: TMainMenu;
    mnCadastro: TMenuItem;
    MenuItem2: TMenuItem;
    mnPessoa: TMenuItem;
    mnCurso: TMenuItem;
    mnPeriodo: TMenuItem;
    ImageControl1: TImageControl;
    mnCadastroTurma: TMenuItem;
    mnMateria: TMenuItem;
    procedure mnPessoaClick(Sender: TObject);
    procedure mnCursoClick(Sender: TObject);
    procedure mnCadastroTurmaClick(Sender: TObject);
    procedure mnPeriodoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_Principal: Tform_Principal;

implementation

{$R *.fmx}

uses unit_BancoDados, unit_CadPessoal, unit_CadCurso, Unit_CadTurma, unit_CadPeriodo;

procedure Tform_Principal.mnPeriodoClick(Sender: TObject);
var
  vForm_CadPeriodo : TForm_CadPeriodo;
begin
  vForm_CadPeriodo := TForm_CadPeriodo.Create(Self);
  try
    vForm_CadPeriodo.ShowModal;
  finally
    FreeAndNil(vForm_CadPeriodo);
  end;
end;

procedure Tform_Principal.mnPessoaClick(Sender: TObject);
var
  vForm_CadPessoa : Tform_CadPessoa;
begin
  vForm_CadPessoa := Tform_CadPessoa.Create(Self);
  try
    vForm_CadPessoa.ShowModal;
  finally
    FreeAndNil(vForm_CadPessoa);
  end;
end;

procedure Tform_Principal.mnCadastroTurmaClick(Sender: TObject);
var
  vFrom_CadTurma : TForm_CadTurma;
begin
  vFrom_CadTurma := TForm_CadTurma.Create(Self);
  try
    vFrom_CadTurma.ShowModal;
  finally
    FreeAndNil(vFrom_CadTurma);
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

end.
