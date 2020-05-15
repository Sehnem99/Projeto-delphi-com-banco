unit Utilitario;

interface
uses
     FMX.Forms, FMX.Edit, FMX.Memo, FMX.ListBox,FMX.Grid,FMX.Types, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
     System.Classes, System.SysUtils,FMX.DateTimeCtrls;
type
    Tutilitario = class
      public
            procedure LimpaTela(var Form);
            function LimpaMascara(aStr: String; const aArrayStr: array of Char): String;
            function validaFloat(sValor: String): String;
            function retSoNumeros(stri: string): string;
            procedure LimpaStringGrid(var sgGrid: TStringGrid);
            procedure ajustaTamnhosg(var sg: TStringGrid);

    end;


implementation

{ Tutilitario }

procedure TUtilitario.ajustaTamnhosg(var sg: TStringGrid);
var
   i: Integer;
   slPercent: TStringList;
   saux: String;
   tmCol, tamanho:Real;
begin
     tamanho := sg.Width - 25;
     slPercent := TStringList.Create;
     slPercent.Clear;
     tmCol := 0;

     for i := 0 to sg.ColumnCount - 1 do
        if (sg.ColumnByIndex(i).Width > 0) then
          tmCol := tmCol + sg.ColumnByIndex(i).Width;

     for i := 0 to sg.ColumnCount - 1 do
       begin
            if (sg.ColumnByIndex(i).Width > 0) then
              slPercent.Add(FloatToStr((sg.ColumnByIndex(i).Width * 100) / tmCol))
            else
                slPercent.Add('0');
       end;

     for i := 0 to slPercent.Count - 1 do
        begin
             try
                if (StrToFloat(slPercent.Strings[i]) > 0) then
                  sg.ColumnByIndex(i).Width := (StrToFloat(slPercent.Strings[i]) * tamanho) / 100;
             except
             end;
        end;

     slPercent.Free;
end;

function TUtilitario.LimpaMascara(aStr: String; const aArrayStr: array of Char): String;
var
  i: Byte;
begin
  for i := 0 to High(aArrayStr) do
  begin
    while (Pos(aArrayStr[i], aStr) > 0) do
       Delete(aStr, Pos(aArrayStr[i], aStr), 1);
  end;
  Result := aStr;
end;

function Tutilitario.validaFloat(sValor: String): String;
var
   iAux:Integer;
   sAux:String;
begin
     if (sValor <> '') then
       begin
            try
               sAux := sValor;
               if (Pos(',', sAux) <= 0) then
                 begin
                      iAux := Pos('.', sAux);
                      if (iAux > 0) then
                        begin
                              sAux[iAux-1] := ',';
                              sValor := sAux;
                        end;
                 end;

               result := self.LimpaMascara(sValor, [' ', '.', '-']);
            except
                  result := sValor;
            end;
       end
     else
         result := sValor;
end;

function TUtilitario.retSoNumeros(stri: string): string;
var
   i: Integer;
   sAux: String;
begin
     sAux := '';

     for i := 0 to Length(stri) do
        if (stri[i] in ['0'..'9']) then
          sAux := sAux + stri[i];

     if (sAux = '') then
       sAux := '0';

     result := sAux;
end;

procedure TUtilitario.LimpaStringGrid(var sgGrid: TStringGrid);
var
 y,
 x:integer;
begin
        for y:=0 to sgGrid.rowCount-1 do
           for x:= 0 to sgGrid.ColumnCount-1 do
                sgGrid.cells[x,y]:='';

        sgGrid.rowCount:=1;
end;

procedure Tutilitario.LimpaTela(var Form);
var
  Temp:TCustomForm;
  i: integer;
begin
     Temp:=TCustomForm(form);
     for i := 0 to (Temp.ComponentCount - 1) do
         begin
              if (Temp.Components[i] is TEdit) then
                TEdit(Temp.Components[i]).Text := ''
              else
              if (Temp.Components[i] is TMemo) then
                TMemo(Temp.Components[i]).Text := ''
              else
              if (Temp.Components[i] is TComboBox) then
                TComboBox(Temp.Components[i]).ItemIndex := 0
              else
              if (Temp.Components[i] is TImageControl) then
                TImageControl(Temp.Components[i]).Bitmap := nil
              else
              if (Temp.Components[i] is TDateEdit) then
                TDateEdit(Temp.Components[i]).Data := Date;
         end;
end;

end.
