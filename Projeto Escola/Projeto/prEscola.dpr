program prEscola;

uses
  System.StartUpCopy,
  FMX.Forms,
  unit_Principal in '..\Units\unit_Principal.pas' {form_Principal},
  unit_BancoDados in '..\Units\unit_BancoDados.pas' {dm_BancoDados: TDataModule},
  Cadastro in '..\Classes\Cadastro.pas',
  Aluno in '..\Classes\Aluno.pas',
  Pessoa in '..\Classes\Pessoa.pas',
  Utilitario in '..\Classes\Utilitario.pas',
  Consulta in '..\Classes\Consulta.pas',
  unit_CadPessoal in '..\Units\unit_CadPessoal.pas' {frm_Consulta},
  unit_Consulta in '..\Units\unit_Consulta.pas' {frm_Consulta},
  Curso in '..\Classes\Curso.pas',
  unit_CadCurso in '..\Units\unit_CadCurso.pas' {Form_CadCurso},
  unit_CadPeriodo in '..\Units\unit_CadPeriodo.pas' {Form_CadPeriodo},
  Periodo in '..\Classes\Periodo.pas',
  Professor in '..\Professor.pas',
  Unit_CadTurma in '..\Units\Unit_CadTurma.pas' {Form_CadTurma},
  Turma in '..\Classes\Turma.pas',
  Unit_CadMateria in '..\Units\Unit_CadMateria.pas' {Form_CadMateria},
  Materia in '..\Classes\Materia.pas',
  Unit_CadTurmaAlunos in '..\Units\Unit_CadTurmaAlunos.pas' {Form_CadTurmaAlunos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_BancoDados, dm_BancoDados);
  Application.CreateForm(Tform_Principal, form_Principal);
  Application.CreateForm(TForm_CadTurma, Form_CadTurma);
  Application.CreateForm(TForm_CadMateria, Form_CadMateria);
  Application.CreateForm(TForm_CadTurmaAlunos, Form_CadTurmaAlunos);
  Application.Run;
end.
