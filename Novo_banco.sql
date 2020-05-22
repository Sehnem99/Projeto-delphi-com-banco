-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
drop DATABASE IF EXISTS escola_teste;
CREATE SCHEMA IF NOT EXISTS escola_teste DEFAULT CHARACTER SET utf8 ;
USE escola_teste;


SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- Table PESSOA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PESSOA (
  ID_PESSOA INT NOT NULL AUTO_INCREMENT,
  NOME VARCHAR(45) NOT NULL,
  CPF VARCHAR(45) NOT NULL,
  DT_NASC DATE NOT NULL,
  TIPO_PESSOA TINYINT(2) NOT NULL,
  ATIVO  tinyint(2) default 1,
  PRIMARY KEY (ID_PESSOA))
ENGINE = InnoDB;

insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (1, 'Ginny', '458143853589', '2019-10-01', 1);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (2, 'Russ',  '458153960015', '2019-09-03', 2);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (3, 'Winnah','458469761211', '2020-03-10', 1);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (4, 'Buckie','458691088072', '2019-10-12', 2);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (5, 'Haily', '458200520274', '2020-02-15', 1);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (6, 'Mickey','458708020936', '2019-07-28', 2);
insert into pessoa (id_pessoa, nome, cpf, dt_nasc, tipo_pessoa) values (7, 'Fania', '458533853774', '2019-09-02', 1);

-- -----------------------------------------------------
-- Table ALUNO Tipo 2 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ALUNO (
  ID_ALUNO INT NOT NULL AUTO_INCREMENT,
  ID_PESSOA INT NOT NULL,
  PRIMARY KEY (ID_ALUNO),
    CONSTRAINT fk_ALUNO_PESSOA1  FOREIGN KEY (ID_PESSOA)
    REFERENCES PESSOA (ID_PESSOA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

insert into aluno (id_aluno, id_pessoa) values (1, 2);
insert into aluno (id_aluno, id_pessoa) values (2, 4);
insert into aluno (id_aluno, id_pessoa) values (3, 6);

-- -----------------------------------------------------
-- Table PROFESSOR Tipo 1
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PROFESSOR (
  ID_PROFESSOR INT NOT NULL AUTO_INCREMENT,
  ID_PESSOA INT NOT NULL,
  PRIMARY KEY (ID_PROFESSOR),
  CONSTRAINT fk_PROFESSOR_PESSOA1
    FOREIGN KEY (ID_PESSOA)
    REFERENCES PESSOA (ID_PESSOA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

insert into professor (id_professor, id_pessoa) values (1, 1);
insert into professor (id_professor, id_pessoa) values (2, 3);
insert into professor (id_professor, id_pessoa) values (3, 5);
insert into professor (id_professor, id_pessoa) values (4, 7);

-- -----------------------------------------------------
-- Table TURMA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS TURMA (
  ID_TURMA INT NOT NULL AUTO_INCREMENT,
  DESCRICAO VARCHAR(45) NOT NULL,
  DT_INI DATE NOT NULL,
  DT_FIM DATE NOT NULL,
  SEMESTRE INT NOT NULL,
  PRIMARY KEY (ID_TURMA))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table CURSO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CURSO (
  ID_CURSO INT NOT NULL AUTO_INCREMENT,
  NOME VARCHAR(45) NOT NULL,
  ATIVO TINYINT(2) NULL,
  PRIMARY KEY (ID_CURSO))
ENGINE = InnoDB;

insert into curso (id_curso, nome, ativo) values (1, 'Analise e Desenvolvimento de sistemas',1);
insert into curso (id_curso, nome, ativo) values (2, 'Tecnologia da desinformação',1);
insert into curso (id_curso, nome, ativo) values (3, 'Estética e cosmética',1);


-- -----------------------------------------------------
-- Table ALUNO_TURMA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ALUNO_TURMA (
  ID_ALUNO_TURMA INT NOT NULL AUTO_INCREMENT,
  ID_ALUNO INT NOT NULL,
  ID_TURMA INT NOT NULL,
  ID_CURSO INT NOT NULL,
  PRIMARY KEY (ID_ALUNO_TURMA),
  CONSTRAINT fk_ALUNO_has_TURMA_ALUNO
    FOREIGN KEY (ID_ALUNO)
    REFERENCES ALUNO (ID_ALUNO)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ALUNO_has_TURMA_TURMA1
    FOREIGN KEY (ID_TURMA)
    REFERENCES TURMA (ID_TURMA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ALUNO_TURMA_CURSO1
    FOREIGN KEY (ID_CURSO)
    REFERENCES CURSO (ID_CURSO)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table PERIODO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PERIODO (
  ID_PERIODO INT NOT NULL AUTO_INCREMENT,
  PERIODO VARCHAR(45) NOT NULL,
  PRIMARY KEY (ID_PERIODO))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table MATERIA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS MATERIA (
  ID_MATERIA INT NOT NULL AUTO_INCREMENT,
  ID_PERIODO INT NOT NULL,
  ID_PROFESSOR INT NOT NULL,
  NOME VARCHAR(45) NOT NULL,
  PRIMARY KEY (ID_MATERIA),
  CONSTRAINT fk_MATERIA_PERIODO1
    FOREIGN KEY (ID_PERIODO)
    REFERENCES PERIODO (ID_PERIODO)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    CONSTRAINT fk_MATERIA_PROFESSOR1
    FOREIGN KEY (ID_PROFESSOR)
    REFERENCES PROFESSOR (ID_PROFESSOR)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table ALUNO_TURMA_MATERIA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ALUNO_TURMA_MATERIA (
  ID_TURMA_MATERIA INT NOT NULL AUTO_INCREMENT,
  ID_ALUNO_TURMA INT NOT NULL,
  ID_MATERIA INT NOT NULL,
  PRIMARY KEY (ID_TURMA_MATERIA),
  CONSTRAINT fk_ALUNO_TURMA_has_MATERIA_ALUNO_TURMA1
    FOREIGN KEY (ID_ALUNO_TURMA)
    REFERENCES ALUNO_TURMA (ID_ALUNO_TURMA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ALUNO_TURMA_has_MATERIA_MATERIA1
    FOREIGN KEY (ID_MATERIA)
    REFERENCES MATERIA (ID_MATERIA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table DIARIO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS DIARIO (
  ID_DIARIO INT NOT NULL, 
  ID_TURMA_MATERIA INT NOT NULL,
  ID_PROFESSOR INT NOT NULL,
  DATA DATE NOT NULL,
  QTDE_AULAS_DIA INT(11) NOT NULL,
  QTDE_FALTAS INT(11) NOT NULL,
  PRIMARY KEY (ID_DIARIO),
  CONSTRAINT fk_ALUNO_TURMA_has_MATERIA_has_PROFESSOR_ALUNO_TURMA_has_MATE1
    FOREIGN KEY (ID_TURMA_MATERIA)
    REFERENCES ALUNO_TURMA_MATERIA (ID_TURMA_MATERIA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ALUNO_TURMA_has_MATERIA_has_PROFESSOR_PROFESSOR1
    FOREIGN KEY (ID_PROFESSOR)
    REFERENCES PROFESSOR (ID_PROFESSOR)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table CURSO_MATERIA
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CURSO_MATERIA (
  ID_CURSO_MATERIA INT NOT NULL AUTO_INCREMENT,
  ID_CURSO INT NOT NULL,
  ID_MATERIA INT NOT NULL,
  PRIMARY KEY (ID_CURSO_MATERIA),
  CONSTRAINT fk_CURSO_has_MATERIA_CURSO1
    FOREIGN KEY (ID_CURSO)
    REFERENCES CURSO (ID_CURSO)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_CURSO_has_MATERIA_MATERIA1
    FOREIGN KEY (ID_MATERIA)
    REFERENCES MATERIA (ID_MATERIA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table CONTATO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS CONTATO (
  ID_CONTATO INT NOT NULL AUTO_INCREMENT,
  ID_PESSOA INT NOT NULL,
  EMAIL VARCHAR(45) NULL,
  TELEFONE VARCHAR(45) NULL,
  CELULAR VARCHAR(45) NOT NULL,
  PRIMARY KEY (ID_CONTATO),
  CONSTRAINT fk_CONTATO_PESSOA1
    FOREIGN KEY (ID_PESSOA)
    REFERENCES PESSOA (ID_PESSOA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table FOTO
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS FOTO (
  ID_FOTO INT NOT NULL AUTO_INCREMENT,
  ID_PESSOA INT NOT NULL,
  FOTO BLOB NOT NULL,
  PRIMARY KEY (ID_FOTO),
  CONSTRAINT fk_FOTO_PESSOA1
    FOREIGN KEY (ID_PESSOA)
    REFERENCES PESSOA (ID_PESSOA)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SET FOREIGN_KEY_CHECKS = 1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
