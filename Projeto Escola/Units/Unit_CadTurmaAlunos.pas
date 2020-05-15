unit Unit_CadTurmaAlunos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TForm_CadTurmaAlunos = class(TForm)
    lbDsc: TLabel;
    edDsc: TEdit;
    sbtnBusca: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_CadTurmaAlunos: TForm_CadTurmaAlunos;

implementation

{$R *.fmx}

end.
