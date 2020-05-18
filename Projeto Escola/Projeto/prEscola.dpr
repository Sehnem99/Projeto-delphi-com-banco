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
  Periodo in '..\Classes\Periodo.pas' {/  Professor in '..\Classes\Professor.pas';},
  Professor in '..\Classes\Professor.pas',
  unit_Chamada in '..\Units\unit_Chamada.pas' {frm_Chamada},
  unit_CadTurma in '..\Units\unit_CadTurma.pas' {form_CadTurma},
  Turma in '..\Classes\Turma.pas',
  unit_CadMateria in '..\Units\unit_CadMateria.pas' {form_CadMateria},
  Materia in '..\Classes\Materia.pas',
  unit_CadContato in '..\Units\unit_CadContato.pas' {form_CadContato},
  Contato in '..\Classes\Contato.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm_BancoDados, dm_BancoDados);
  Application.CreateForm(Tform_Principal, form_Principal);
  Application.CreateForm(Tform_CadMateria, form_CadMateria);
  Application.CreateForm(Tform_CadContato, form_CadContato);
  Application.Run;
end.
