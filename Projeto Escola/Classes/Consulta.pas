unit Consulta;

interface
uses
    System.SysUtils, System.Types, System.UITypes,
    System.Classes, System.Variants,
    FMX.Grid, Utilitario, FireDAC.Comp.Client,
    unit_BancoDados, FMX.Dialogs, FMX.ListBox;

type TConsulta = class
  private
         titulo:string; //caption da tela
         textosql:string; //comando de seleção
         retorno: string; //coluna do comando de seleção a ser retornada
         colunaRetorno:integer; //se fro -1 retorna coluna selecionada caso contrario retorna a coluna da variavel
         utilitario : Tutilitario;


         fTemRegistroConsulta: Boolean; //Treu tem consulta a mostra, false não tem a mostrar
  public
        constructor create;
        destructor destroi;
        procedure setTitulo(titulo:string);
        function getTitulo:string;
        procedure setTextosql(textosql:string);
        function getTextosql:string;
        procedure setRetorno(retorno:string);
        function getRetorno:string;
        procedure getConsulta;
        procedure getConsultaToSg(var sgConsulta:TStringGrid);
        procedure setcolunaRetorno(colunaRetorno:integer);
        function getcolunaRetorno:integer;
        procedure getCarregaCB(sTabela, sCuluna: String;vComboBox: TComboBox;vUltSQL:Boolean = False);
        function getConsultaDados(slCampos:TStringList): TStringList;
        function getfTemRegistroConsulta: Boolean;

end;

implementation

{ TConsulta }

uses unit_Consulta;

constructor TConsulta.create;
begin
     Utilitario := Tutilitario.Create;
end;

destructor TConsulta.destroi;
begin
     FreeAndNil(utilitario);
end;

procedure TConsulta.getConsultaToSg(var sgConsulta:TStringGrid);
var
   qrConsulta: TFDQuery;
   coluna:TColumn;
   i:integer;
begin
     qrConsulta := TFDQuery.Create(nil);
     qrConsulta.Connection := dm_BancoDados.FDEscola;
     qrConsulta.Close;
     qrConsulta.SQL.Clear;
     qrConsulta.SQL.Add(self.getTextosql);

     try
        qrConsulta.Open;

        if (not qrConsulta.IsEmpty) then
          begin
                for i := 0 to qrConsulta.FieldCount - 1 do
                  begin
                       coluna := TColumn.Create(nil);
                       coluna.Parent := sgConsulta;
                       coluna.Header := qrConsulta.Fields[i].FieldName;
                  end;

                utilitario.LimpaStringGrid(sgConsulta);
                qrConsulta.First;

                while (not qrConsulta.Eof) do
                    begin
                         if (sgConsulta.Cells[0,0] <> '') then
                           sgConsulta.RowCount := sgConsulta.RowCount + 1;

                         for i := 0 to qrConsulta.FieldCount - 1 do
                            sgConsulta.Cells[i, sgConsulta.RowCount - 1] := qrConsulta.Fields[i].AsString;

                         qrConsulta.Next;
                    end;
            fTemRegistroConsulta := True;
          end
        else
          fTemRegistroConsulta := False;
     except
           on e:exception do
             begin
                  ShowMessage('Comando SQL não executado: ' + e.ToString);
                  exit;
             end;
     end;

     qrConsulta.Close;
     FreeAndNil(qrConsulta);
end;

function TConsulta.getfTemRegistroConsulta: Boolean;
begin
  Result := Self.fTemRegistroConsulta;
end;

procedure TConsulta.getCarregaCB(sTabela, sCuluna: String;vComboBox: TComboBox; vUltSQL:Boolean = false);
var
  id: Integer;
  s: string;
  qrConsulta: TFDQuery;
  vSQL : String;
begin
  qrConsulta := TFDQuery.Create(nil);
  try
    qrConsulta.Connection := dm_BancoDados.FDEscola;
    qrConsulta.Close;
    qrConsulta.SQL.Clear;
    //True Utiliza o texto passado.
    if vUltSQL then
      vSQL := self.getTextosql
    else
      vSQL := 'Select * from '+ Format('%s', [sTabela]);
    qrConsulta.SQL.Add(vSQL);
    qrConsulta.Open;

    with qrConsulta do
    begin
      First;
      while not Eof do
      begin
        id := FieldByName('ID_'+ Format('%s', [sTabela])).AsInteger;
        s := FieldByName(sCuluna).AsString;
        vComboBox.Items.AddObject(s, TObject(id)); // typecast necessário
        Next;
      end;
    end;
  finally
    FreeAndNil(qrConsulta);
  end;
end;

function TConsulta.getcolunaRetorno: integer;
begin
     result := self.colunaRetorno;
end;

procedure TConsulta.getConsulta;
begin
     if (frm_Consulta = nil) then
       frm_Consulta := Tfrm_Consulta.Create(nil);

     frm_Consulta.Caption := self.getTitulo;

     //start da consulta
     self.getConsultaToSg(frm_Consulta.sgConsulta);
     frm_Consulta.lbNroReg.Text := FormatFloat('###,##0', frm_Consulta.sgConsulta.RowCount);
     frm_Consulta.edPesquisa.Text := '';
     frm_Consulta.sgConsulta.Col := 0;

     if (fTemRegistroConsulta) then
       frm_Consulta.sgConsultaHeaderClick(frm_Consulta.sgConsulta.ColumnByIndex(0));

     frm_Consulta.edPesquisaChangeTracking(frm_Consulta.edPesquisa);
     frm_Consulta.edPesquisa.SetFocus;
     Utilitario.ajustaTamnhosg(frm_Consulta.sgConsulta);

     //..retorno
     if (frm_Consulta.ShowModal = mrOk) then
       begin
           if (self.getcolunaRetorno < 0) then //-1 --> retorna coluna selecionada
             self.setRetorno(frm_Consulta.sgConsulta.Cells[frm_Consulta.sgConsulta.Col, frm_Consulta.sgConsulta.Row])
           else
             self.setRetorno(frm_Consulta.sgConsulta.Cells[self.getcolunaRetorno, frm_Consulta.sgConsulta.Row]);
       end
     else
         self.setRetorno('');

     FreeAndNil(frm_Consulta);
end;

function TConsulta.getConsultaDados(slCampos: TStringList): TStringList;
var
   qrConsulta: TFDQuery;
   i:integer;
   slValores : TStringList;
begin
     qrConsulta := TFDQuery.Create(nil);
     i := 0;
     slValores := TStringList.Create;
     qrConsulta.Connection := dm_BancoDados.FDEscola;
     qrConsulta.Close;
     qrConsulta.SQL.Clear;
     qrConsulta.SQL.Add(self.getTextosql);

     try
       qrConsulta.Open;
       if (not qrConsulta.IsEmpty) then
        begin
          fTemRegistroConsulta := true;
          for i := 0 to qrConsulta.FieldCount - 1 do
            begin
             slValores.Add( qrConsulta.FieldByName(slCampos[i]).AsString );
             qrConsulta.Next;
            end;
        end
       else
         fTemRegistroConsulta := False;
     finally
       Result := slValores;
       FreeAndNil(qrConsulta);
     end;
end;

function TConsulta.getRetorno: string;
begin
     result := self.retorno;
end;

function TConsulta.getTextosql: string;
begin
     result := self.textosql;
end;

function TConsulta.getTitulo: string;
begin
     result := self.titulo;
end;

procedure TConsulta.setcolunaRetorno(colunaRetorno: integer);
begin
     self.colunaRetorno := colunaRetorno;
end;

procedure TConsulta.setRetorno(retorno: string);
begin
     self.retorno := retorno;
end;

procedure TConsulta.setTextosql(textosql: string);
begin
     self.textosql := textosql;
end;

procedure TConsulta.setTitulo(titulo: string);
begin
     self.titulo := titulo;
end;

end.
