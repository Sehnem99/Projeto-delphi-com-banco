unit Cadastro;

interface
uses
    system.SysUtils, system.Classes, FireDAC.Comp.Client, unit_BancoDados,
    utilitario, Vcl.imaging.jpeg, Data.DB, FMX.Objects;

type TCadastro = class
   private
      function getTextoInsert:String;
      function getTextoInsertAlunoTumaMateria(pIdAlunoTurma, pIdCurso:String):String;
      function getTextoUpdate:String;
      function getTextoIdMax(sTabela: String):String;

   public
     id: integer; //deve conter sempre o valor correspondente a última chave primária
     estado: byte; //o valor 0 --> cadastrar (insert), o valor 1 --> alterar (update)
     Retorno: boolean; //retorno da operção true ok e false não ok
     sTabela:String; //nome da tabela
     qrCadastro: TFDQuery; // query
     slValores, //lista para guardar os valores do registro
     slCampos, //lista para guardar as colunas  da tabela
     slTipos: TStringList; //lista para guardar os tipos das colunas
     utilitario:Tutilitario; //agregar

     Constructor Create (sTabela: string); overload; virtual;
     Destructor Destroy; Override;
     function getTabela:String;
     function getCampoFromLista(i:integer):string;
     procedure getCamposTipos;
     function getCampoFromListaValores(i:integer):string;
     function isExiteSlvalores:boolean;
     function getEstado:byte;
     function getIdMaxTabela:String;

     procedure insert(var slDados:TStringList);
     procedure insertAlunoTurmaMateria(pCodigoCurso:String; var slDados:TStringList);
     procedure select(icampo:integer; svalor:string);
     procedure delete;
     procedure deleteAlunoTurmaMateria(vIDCurso:String);
     procedure getImagem(icod:Integer; imagem:TImage);
     procedure setImgFoto(iCodPessoa: Integer; sCaminho: string);
end;


implementation

{ TCadastro }

constructor TCadastro.Create(sTabela: string);
begin
     qrCadastro := TFDQuery.Create(dm_BancoDados);
     qrCadastro.Connection := dm_BancoDados.FDEscola;
     self.sTabela := sTabela;
     Retorno := false;
     slCampos := TStringList.Create;
     slTipos := TStringList.Create;
     slValores := TStringList.Create;
     self.getCamposTipos;
     utilitario := Tutilitario.Create;
end;

destructor TCadastro.Destroy;
begin
     inherited;
     qrCadastro.Close;
     qrCadastro.Free;
     FreeAndNil(slCampos);
     FreeAndNil(slTipos);
     FreeAndNil(slValores);
     FreeAndNil(utilitario);
end;

//método para carregar a lista de colunas e campos do DD
function TCadastro.getCampoFromLista(i: integer): string;
begin
     result := self.slCampos.Strings[i];
end;

function TCadastro.getCampoFromListaValores(i: integer): string;
begin
     result := self.slValores.Strings[i];
end;

procedure TCadastro.getCamposTipos;
begin
     slCampos.Clear;
     slTipos.Clear;
     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(Format('desc %s', [self.sTabela]));

     try
        qrCadastro.Open;
     except
          on E:Exception do
            raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;

     if not qrCadastro.IsEmpty then
       begin
            qrCadastro.First;
            while (not qrCadastro.Eof) do
                 begin
                      slCampos.Add(qrCadastro.Fields[0].AsString); //nome da coluna
                      slTipos.Add(qrCadastro.Fields[1].AsString); //tipo da coluna

                      qrCadastro.Next;
                 end;
       end;
end;

function TCadastro.getEstado: byte;
begin
     result := Self.estado;
end;

function TCadastro.getIdMaxTabela: String;
var
  qrConsulta: TFDQuery;
begin
  qrConsulta := TFDQuery.Create(nil);
  qrConsulta.Connection := dm_BancoDados.FDEscola;
  qrConsulta.Close;
  qrConsulta.SQL.Clear;
  qrConsulta.SQL.Add(self.getTextoIdMax(format('%s',[self.sTabela])));
  try
    qrConsulta.Open;

    result := qrConsulta.FieldByName('ID').AsString;

  except
    on E:Exception do
       raise Exception.CreateFmt('Não foi possível executar operação no Banco.'
                                 + #10#13 + '%s', [E.Message]);
  end;


end;

procedure TCadastro.getImagem(icod: Integer; imagem: TImage);
var
  logo: TStream;
begin
  qrCadastro.Close;
  qrCadastro.SQL.Clear;
  qrCadastro.SQL.Add('select foto ');
  qrCadastro.SQL.Add('from foto ');
  qrCadastro.SQL.Add(Format('where (id_pessoa = %d)',[icod]));

  try
     qrCadastro.Open;

     if (not qrCadastro.IsEmpty) then
       begin
            logo := qrCadastro.CreateBlobStream(qrCadastro.Fields[0], bmRead);
            imagem.Bitmap.LoadFromStream(logo);
            logo.Free;
       end;
  except
      on e:exception do
         begin
              raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
         end;
  end;
end;

function TCadastro.getTabela: String;
begin
     result := self.sTabela;
end;

function TCadastro.getTextoIdMax(sTabela :String): String;
begin
  Result := format('select max(ID_'+format('%s',[self.sTabela])+') ID from '+
                   '%s',[self.sTabela]);
end;

function TCadastro.getTextoInsert: String;
var
   i:integer;
begin
     //considerar que o campo zero de cada tabela é auto increment
     result := format ('insert into %s values (0, ', [self.sTabela]);

     for i := 1 to self.slCampos.Count - 1 do
        begin
             result := result + ':' + slCampos.Strings[i];

             if (i < self.slCampos.Count - 1) then
               result := result + ','
             else
                 result := result + ')';
        end;
end;

function TCadastro.getTextoInsertAlunoTumaMateria(pIdAlunoTurma, pIdCurso:String): String;
var
   vSQL: String;
begin
     //considerar que o campo zero de cada tabela é auto increment
     vSQL := format ('insert into %s  ', [self.sTabela])+
                     'select ''0'','+ format('%s',[pIdAlunoTurma])+','+
                     '       a.id_materia '+
                     '  from curso_materia a' +
                     ' where a.id_curso = '+ format('%s',[pIdCurso])+';';
     result := vSQL;
end;

function TCadastro.getTextoUpdate: String;
var
   i: integer;
begin
     result := format ('update %s set ', [self.sTabela]);

     for i := 1 to self.slCampos.Count - 1 do
        begin
             result := result + slCampos.Strings[i] + ' = :' + slCampos.Strings[i];

             if (i < self.slCampos.Count - 1) then
               result := result + ',';
        end;
end;

procedure TCadastro.insert(var slDados:TStringList);
var
   i:integer;
   sSql:String;
begin
     if (self.estado = 0) then
       sSql := self.getTextoInsert
     else
       sSql := self.getTextoUpdate +
       Format(' where (' + slCampos.Strings[0] + ' =  %s)', [slDados.Strings[0]]);

     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(sSql);

     for i := 1 to self.slTipos.Count - 1 do
        begin
             if (pos('int' , self.slTipos.Strings[i]) > 0) or
                (pos('tinvint' , self.slTipos.Strings[i]) > 0) then
               qrCadastro.Params[i-1].AsInteger := StrToInt(slDados.Strings[i])
             else
             if (pos('varchar' , self.slTipos.Strings[i]) > 0) then
               qrCadastro.Params[i-1].AsString := slDados.Strings[i]
             else
             if (pos('date' , self.slTipos.Strings[i]) > 0) then
               qrCadastro.Params[i-1].AsDate := StrToDate(slDados.Strings[i]);
             //..
             //..
        end;

     try
        qrCadastro.ExecSQL;

        //se estado for zero
        //carregar slValores  .Strings[0] := chave  (criar método que retorne a última chave gerada para a tabela
        if (StrToInt(slDados.Strings[0]) = 0) then
         slDados.Strings[0] :=  getIdMaxTabela;
       //Limpar a Query e passatr o insert na professor
     except
          on E:Exception do
            raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;
end;

procedure TCadastro.insertAlunoTurmaMateria(pCodigoCurso: String;
  var slDados: TStringList);
var
   i:integer;
   sSql:String;
begin
     if (self.estado = 0) then
       sSql := self.getTextoInsertAlunoTumaMateria(slValores.Strings[1],pCodigoCurso)
     else
         sSql := self.getTextoUpdate +
         Format(' where (' + slCampos.Strings[0] + ' =  %s)', [slDados.Strings[0]]);

     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(sSql);

     try
       qrCadastro.ExecSQL;
     except
          on E:Exception do
            raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;
end;

function TCadastro.isExiteSlvalores: boolean;
begin
     result := self.slValores.Count > 0;
end;

procedure TCadastro.select(icampo: integer; svalor: string);
var
   i:integer;
begin
     self.slValores.Clear;
     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(Format('select * from %s where (%s = :valor)', [self.getTabela, self.getCampoFromLista(icampo)]));
     qrCadastro.Params[0].Value := svalor;

     try
        qrCadastro.Open;
        if (not qrCadastro.IsEmpty) then
          begin
               for i := 0 to qrCadastro.FieldCount - 1 do
                 self.slValores.Add(qrCadastro.Fields[i].AsString);
          end;
     except
          on E:Exception do
            raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;
end;

procedure TCadastro.setImgFoto(iCodPessoa: Integer; sCaminho: string);
var
   img: TStream;
   iCodImg:Integer;
   iTipo:Byte;
begin
     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(format('Select id_foto from foto where (id_pessoa = %d)', [iCodPessoa]));
     try
        qrCadastro.Open;

        if (not qrCadastro.IsEmpty) then
          begin
               iCodImg := qrCadastro.Fields[0].AsInteger;
               iTipo := 2;
          end
          else
              iTipo:= 1;
     except
           iTipo := 1;
     end;

     if (sCaminho <> '') then
       img := TFileStream.Create(sCaminho, fmOpenRead);

     qrCadastro.Close;
     qrCadastro.SQL.Clear;

     if (iTipo = 1) then
       begin
            qrCadastro.SQL.Add('insert into foto values  ');
            qrCadastro.SQL.Add('(0, :pessoa, :imagem) ');

            qrCadastro.Params[0].AsInteger := iCodPessoa;
            qrCadastro.Params[1].LoadFromStream(img, ftBlob);
       end
     else
     if (iTipo = 2) then
       begin
            qrCadastro.SQL.Add('update foto   ');
            qrCadastro.SQL.Add('set foto = :foto where (id_foto = :id_foto) ');

            qrCadastro.Params[0].LoadFromStream(img, ftBlob);
            qrCadastro.Params[1].AsInteger := iCodImg;
         end;

     try
        qrCadastro.ExecSQL;
     except
           on e:exception do
              raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;

     if (sCaminho <> '') then
       img.Free;
end;

procedure TCadastro.delete;
begin
     qrCadastro.Close;
     qrCadastro.SQL.Clear;
     qrCadastro.SQL.Add(Format('delete from %s where (%s = :valor)', [self.getTabela, self.getCampoFromLista(0)]));
     qrCadastro.Params[0].Value := self.getCampoFromListaValores(0);

     try
        qrCadastro.ExecSQL;
     except
          on E:Exception do
            raise Exception.CreateFmt('Não foi possível executar operação no Banco.' + #10#13 + '%s', [E.Message]);
     end;
end;

procedure TCadastro.deleteAlunoTurmaMateria(vIDCurso: String);
begin
//
end;

end.
