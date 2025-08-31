USE `Universidade`;
DROP SCHEMA IF EXISTS `Universidade`;
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0; -- tira foto do estado atual
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Program Data Base: Universidade
-- Programmer: Lorran KAíque
-- Date: 29/08
-- Create schema Universidade
CREATE SCHEMA IF NOT EXISTS `Universidade` DEFAULT CHARACTER SET utf8;
USE `Universidade`;
-- Como base do código, utilizei a funcao 'Forward Engineer'(criar a partir do modelo relacional)
-- obs: A primeira versao não havia o 'Diretores' como heranca de professor, acabei fazendo e depois 
-- corrigindo, talvez tenha alguma inconsistencia 
-- -----------------------------------------------------
-- Table `Universidade`.`Faculdade`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Faculdade` (
  `siglaFaculdade` VARCHAR(24) NOT NULL,
  `bloco` VARCHAR(50) NULL,
  `orcamento` DOUBLE NULL,
  `diretor` INT NULL,
  PRIMARY KEY (`siglaFaculdade`))
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Universidade`.`Professores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Professores` (
  `idProfessor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(122) NULL,
  `dtNasc` DATE NULL,
  `salario` DOUBLE NULL,
  `faculdade` VARCHAR(24) NOT NULL,
  PRIMARY KEY (`idProfessor`),
  INDEX `idx_professores_faculdade` (`faculdade` ASC) VISIBLE,
  CONSTRAINT `fk_professores_faculdade`
    FOREIGN KEY (`faculdade`)
    REFERENCES `Universidade`.`Faculdade` (`siglaFaculdade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
-- -----------------------------------------------------
-- Table `Universidade`.`Diretores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Diretores` (
  `id_professor` INT NOT NULL,
  PRIMARY KEY (`id_professor`),
  CONSTRAINT `fk_diretores_HERDA_professores`
    FOREIGN KEY (`id_professor`)
    REFERENCES `Universidade`.`Professores` (`idProfessor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
-- criando o atributo diretor e referenciando a chave estrangeira diretor de Faculdade em Diretores
ALTER TABLE `Universidade`.`Faculdade` 
ADD INDEX `idx_faculdade_diretor` (`diretor` ASC) VISIBLE,
ADD CONSTRAINT `fk_faculdade_diretor`
  FOREIGN KEY (`diretor`)
  REFERENCES `Universidade`.`Diretores` (`id_Professor`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
-- -----------------------------------------------------
-- Table `Universidade`.`Alunos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Alunos` (
  `idAlunos` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(122) NULL,
  `dtNasc` DATE NULL,
  `CRA` FLOAT NULL,
  `faculdade` VARCHAR(24) NOT NULL,
  PRIMARY KEY (`idAlunos`),
  INDEX `idx_alunos_faculdade` (`faculdade` ASC) VISIBLE,
  CONSTRAINT `fk_alunos_faculdade`
    FOREIGN KEY (`faculdade`)
    REFERENCES `Universidade`.`Faculdade` (`siglaFaculdade`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Disciplinas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Disciplinas` (
  `siglaDisciplina` VARCHAR(24) NOT NULL,
  `nome` VARCHAR(122) NULL,
  `nCredito` INT NULL,
  PRIMARY KEY (`siglaDisciplina`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Salas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Salas` (
  `numeroSala` INT NOT NULL,
  `bloco` VARCHAR(10) NOT NULL,
  `capacidade` INT NULL,
  PRIMARY KEY (`numeroSala`, `bloco`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Turma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Turma` (
  `idTurma` INT NOT NULL AUTO_INCREMENT,
  `semestre` INT NULL,
  `ano` SMALLINT UNSIGNED NULL,
  `sala_numero` INT NOT NULL,
  `sala_bloco` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idTurma`),
  INDEX `idx_turma_sala` (`sala_numero` ASC, `sala_bloco` ASC) VISIBLE,
  CONSTRAINT `fk_turma_sala`
    FOREIGN KEY (`sala_numero` , `sala_bloco`)
    REFERENCES `Universidade`.`Salas` (`numeroSala` , `bloco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Telefone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Telefone` (
  `aluno` INT NOT NULL,
  `numero` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`aluno`, `numero`),
  CONSTRAINT `fk_telefone_aluno`
    FOREIGN KEY (`aluno`)
    REFERENCES `Universidade`.`Alunos` (`idAlunos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Aluno_Turma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Aluno_Turma` (
  `aluno` INT NOT NULL,
  `turma` INT NOT NULL,
  `notas` FLOAT NULL,
  `faltas` INT NULL,
  PRIMARY KEY (`aluno`, `turma`),
  INDEX `idx_aluno_turma_turma` (`turma` ASC) VISIBLE,
  CONSTRAINT `fk_aluno_turma_aluno`
    FOREIGN KEY (`aluno`)
    REFERENCES `Universidade`.`Alunos` (`idAlunos`),
  CONSTRAINT `fk_aluno_turma_turma`
    FOREIGN KEY (`turma`)
    REFERENCES `Universidade`.`Turma` (`idTurma`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Professor_Turma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Professor_Turma` (
  `professor` INT NOT NULL,
  `turma` INT NOT NULL,
  PRIMARY KEY (`professor`, `turma`),
  INDEX `idx_professor_turma_turma` (`turma` ASC) VISIBLE,
  CONSTRAINT `fk_professor_turma_professor`
    FOREIGN KEY (`professor`)
    REFERENCES `Universidade`.`Professores` (`idProfessor`),
  CONSTRAINT `fk_professor_turma_turma`
    FOREIGN KEY (`turma`)
    REFERENCES `Universidade`.`Turma` (`idTurma`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Disciplina_Turma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Disciplina_Turma` (
  `disciplina` VARCHAR(24) NOT NULL,
  `turma` INT NOT NULL,
  PRIMARY KEY (`disciplina`, `turma`),
  INDEX `idx_disciplina_turma_turma` (`turma` ASC) VISIBLE,
  CONSTRAINT `fk_disciplina_turma_disciplina`
    FOREIGN KEY (`disciplina`)
    REFERENCES `Universidade`.`Disciplinas` (`siglaDisciplina`),
  CONSTRAINT `fk_disciplina_turma_turma`
    FOREIGN KEY (`turma`)
    REFERENCES `Universidade`.`Turma` (`idTurma`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`Faculdade_Disciplina`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`Faculdade_Disciplina` (
  `faculdade` VARCHAR(24) NOT NULL,
  `disciplina` VARCHAR(24) NOT NULL,
  PRIMARY KEY (`faculdade`, `disciplina`),
  INDEX `idx_faculdade_disciplina_disciplina` (`disciplina` ASC) VISIBLE,
  CONSTRAINT `fk_faculdade_disciplina_faculdade`
    FOREIGN KEY (`faculdade`)
    REFERENCES `Universidade`.`Faculdade` (`siglaFaculdade`),
  CONSTRAINT `fk_faculdade_disciplina_disciplina`
    FOREIGN KEY (`disciplina`)
    REFERENCES `Universidade`.`Disciplinas` (`siglaDisciplina`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `Universidade`.`preRequisitos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Universidade`.`preRequisitos` (
  `disciplina` VARCHAR(24) NOT NULL,
  `preRequisito` VARCHAR(24) NOT NULL,
  PRIMARY KEY (`disciplina`, `preRequisito`),
  INDEX `idx_prerequisitos_prerequisito` (`preRequisito` ASC) VISIBLE,
  CONSTRAINT `fk_prerequisitos_disciplina`
    FOREIGN KEY (`disciplina`)
    REFERENCES `Universidade`.`Disciplinas` (`siglaDisciplina`),
  CONSTRAINT `fk_prerequisitos_prerequisito`
    FOREIGN KEY (`preRequisito`)
    REFERENCES `Universidade`.`Disciplinas` (`siglaDisciplina`)
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE; -- guarda o estado inicial/atual da conf
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS; -- zera as conf(ignora as regras de FK)
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS; -- garante q o script se comporte da mesma forma em qualquer servidor
