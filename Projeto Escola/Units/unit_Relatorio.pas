unit unit_Relatorio;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  Tfrm_Relatorio = class(TForm)
    Panel1: TPanel;
    spQtdeCurso: TSpeedButton;
    spQtdeMateria: TSpeedButton;
    StringGrid1: TStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Relatorio: Tfrm_Relatorio;

implementation

{$R *.fmx}

end.
