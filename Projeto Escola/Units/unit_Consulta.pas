unit unit_Consulta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FMX.StdCtrls, FMX.ListBox, FMX.Layouts,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Grid, FMX.Edit,
  System.StrUtils;

type
  Tfrm_Consulta = class(TForm)
    sgConsulta: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    lbNroReg: TLabel;
    Panel4: TPanel;
    edPesquisa: TEdit;
    Panel5: TPanel;
    Label2: TLabel;
    lbColPesq: TLabel;
    pnCarregar: TPanel;
    spCarregar: TSpeedButton;
    pnRetornar: TPanel;
    spRetornar: TSpeedButton;
    procedure sgConsultaHeaderClick(Column: TColumn);
    procedure edPesquisaChangeTracking(Sender: TObject);
    procedure spRetornarClick(Sender: TObject);
    procedure spCarregarClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sgConsultaCellDblClick(const Column: TColumn; const Row: Integer);
  private
    iColPesq:integer;
  public
        public
           procedure setiColPesq(iColPesq:integer);
           function getiColPesq:integer;
  end;

var
  frm_Consulta: Tfrm_Consulta;

implementation

{$R *.fmx}

uses unit_BancoDados, Utilitario, Consulta;

procedure Tfrm_Consulta.edPesquisaChangeTracking(Sender: TObject);
Var
   i: Integer;
begin
   if edPesquisa.Text <> '' then
   begin
       for i:= sgConsulta.RowCount - 1 downto 0 do
       begin
           if (AnsiStartsStr(AnsiUpperCase(edPesquisa.TexT), AnsiUpperCase(sgConsulta.Cells[self.getiColPesq,i]))) then
               sgConsulta.Row:= i;
       end;
   end
   else
      sgConsulta.Row:= 0;
end;

procedure Tfrm_Consulta.FormResize(Sender: TObject);
var
    utilitario: Tutilitario;
begin
     utilitario := Tutilitario.Create;
     utilitario.ajustaTamnhosg(sgConsulta);
     FreeAndNil(utilitario);
     pnCarregar.Width :=  self.Width / 2;
end;

function Tfrm_Consulta.getiColPesq: integer;
begin
     result := self.iColPesq;
end;

procedure Tfrm_Consulta.setiColPesq(iColPesq: integer);
begin
     self.iColPesq := iColPesq;
end;

procedure Tfrm_Consulta.sgConsultaCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
     spCarregarClick(spCarregar);
end;

procedure Tfrm_Consulta.sgConsultaHeaderClick(Column: TColumn);
begin
     self.setiColPesq(Column.Index);
     lbColPesq.Text := Column.Header;
     edPesquisa.Text := '';
     edPesquisa.SetFocus;
end;

procedure Tfrm_Consulta.spCarregarClick(Sender: TObject);
begin
     ModalResult := mrOk;
end;

procedure Tfrm_Consulta.spRetornarClick(Sender: TObject);
begin
     ModalResult := mrNo;
end;

end.
