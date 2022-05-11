DROP USER IF EXISTS 'matheusf'@'localhost';
CREATE USER 'matheusf'@'localhost' IDENTIFIED BY '123123';
GRANT ALL ON DATABASE uvv TO 'matheusf'@'localhost';


DROP DATABASE  IF EXISTS uvv;
CREATE database uvv;

use uvv;


CREATE TABLE funcionario (
                cpf 				CHAR(11) 		NOT NULL, 			COMMENT 	'CPF do funcionário. Será a PK da tabela.'
                primeiro_nome 		VARCHAR(15) 	NOT NULL,			COMMENT 	'Primeiro nome do funcionário.'
                nome_meio 			CHAR(1),							COMMENT 	'Inicial do nome do meio.'
                ultimo_nome 		VARCHAR(15) 	NOT NULL,			COMMENT 	'Sobrenome do funcionário.'
                data_nascimento 	DATE,								COMMENT 	'data de nascimento do funcionário.'
                endereco 			VARCHAR(50),						COMMENT 	'Endereço do funcionário.'
                sexo 				CHAR(1),							COMMENT 	'Sexo do funcionário.'
                salario 			DECIMAL(10,2), 						COMMENT 	'Salário do funcionário.'
                cpf_supervisor 		CHAR(11) 		NOT NULL,			COMMENT 	'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).'
                numero_departamento INTEGER 		NOT NULL,			COMMENT 	'Número do departamento do funcionário.'
                CONSTRAINT funcionario_pk 			PRIMARY KEY (cpf)
) COMMENT 'Tabela que armazena as informações dos funcionários.';

CREATE TABLE departamento (
                numero_departamento 		INTEGER 	NOT NULL, 		COMMENT 	'Número do departamento. É a PK desta tabela.'
                nome_departamento 			CHAR(15) 	NOT NULL, 		COMMENT 	'Nome do departamento. Deve ser único.'
                cpf_gerente 				CHAR(11) 	NOT NULL, 		COMMENT 	'CPF do gerente do departamento. É uma FK para a tabela funcionários.'
                data_inicio_gerente 		DATE, 						COMMENT 	'Data do início do gerente no departamento.'
                CONSTRAINT departamento_pk 				PRIMARY KEY (numero_departamento)
) COMMENT 'Tabela que armazena as informaçoẽs dos departamentos.';


CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE projeto (
                numero_projeto 				INTEGER 		NOT NULL,		COMMENT 	'Número do projeto. É a PK desta tabela.'
                nome_projeto 				VARCHAR(15) 	NOT NULL, 		COMMENT 	'Nome do projeto. Deve ser único.'
                local_projeto 				VARCHAR(15), 					COMMENT 	'Localização do projeto.'
                numero_departamento 		INTEGER 		NOT NULL, 		COMMENT 	'Número do departamento. É uma FK para a tabela departamento.'
                CONSTRAINT projeto_pk 						PRIMARY KEY (numero_projeto)
) COMMENT 'Tabela que armazena as informações sobre os projetos dos departamentos.';


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE localizacoes_departamento (
                numero_departamento 					INTEGER 		NOT NULL, 		COMMENT 	'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.'
                local 									VARCHAR(15) 	NOT NULL, 		COMMENT 	'Localização do departamento. Faz parte da PK desta tabela.'
                CONSTRAINT localizacoes_departamento_pk 				PRIMARY KEY (numero_departamento, local)
) COMMENT 'Tabela que armazena as possíveis localizações dos departamentos.';


CREATE TABLE trabalha_em (
                cpf_funcionario 		CHAR(11) 		NOT NULL,
                numero_projeto 			INTEGER 		NOT NULL,
                horas 					DECIMAL(3,1),
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON TABLE trabalha_em 					IS 		'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN trabalha_em.cpf_funcionario 	IS 		'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN trabalha_em.numero_projeto 	IS 		'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';
COMMENT ON COLUMN trabalha_em.horas 			IS 		'Horas trabalhadas pelo funcionário neste projeto.';


CREATE TABLE dependente (
                cpf_funcionario 		CHAR(11) 			NOT NULL,		COMMENT 'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.'
                nome_dependente 		VARCHAR(15) 		NOT NULL, 		COMMENT 'Nome do dependente. Faz parte da PK desta tabela.'
                sexo 					CHAR(1), 							COMMENT 'Sexo do dependente.'
                data_nascimento 		DATE,								COMMENT 'Data de nascimento do dependente.'
                parentesco 				VARCHAR(15), 						COMMENT 'Descrição do parentesco do dependente com o funcionário.'
                CONSTRAINT dependente_pk 					PRIMARY KEY (cpf_funcionario, nome_dependente)
) COMMENT 'Tabela que armazena as informações dos dependentes dos funcionários.';


ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
;

alter table funcionario                         add constraint c_MF
												check(sexo in ('F','M'))
;

alter table dependente                          add constraint c_MF 
                                                check(sexo in ('F','M'))
;

alter table funcionario                         add constraint nd_negativo 
                                                check (salario >= 0)
;

alter table trabalha_em                         add constraint hora_negativo 
                                                check (horas >= 0)
;

alter table funcionario                         alter column cpf_supervisor drop not null
;


INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('88866555576', 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto,35, São Paulo,SP', 'M', null, 55.000, 1);

INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('98765432168', 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av. Arthur de Lima,54,Santo André,SP', 'F', '88866555576',43.000, 4);

INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('33344555587', 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa,34, São Paulo,SP', 'M', '88866555576', 40.000, 5);

INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('98798798733', 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira,35,São Paulo,SP', 'M', '98765432168', 25.000, 4);

INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('99988777767', 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima,35,São Paulo,SP', 'F', '98765432168', 25.000, 4);


INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('66688444476', 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças,65,Piraciaba,SP', 'M', '33344555587', 38.000, 5);

INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('45345345376', 'Joice', 'A', 'Leite', '1972-07-31', 'Av.Lucas Obes,74,São Paulo,SP', 'F', '33344555587', 25.000, 5);


INSERT INTO funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, cpf_supervisor, salario, numero_departamento)
VALUES('12345678966', 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores,751,São Paulo,SP', 'M', '33344555587', 30.000, 5);

INSERT into departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(5, 'Pesquisa', '33344555587', '1988-05-22');

INSERT INTO departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(4, 'Administração', '98765432168', '1955-01-01');

INSERT INTO departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(1, 'Matriz', '88866555576', '1981-06-19');

INSERT INTO localizacoes_departamento
(numero_departamento, "local")
VALUES(1, 'São Paulo');

INSERT INTO localizacoes_departamento
(numero_departamento, "local")
VALUES(4, 'Mauá');

INSERT INTO localizacoes_departamento
(numero_departamento, "local")
VALUES(5, 'Santo André');

INSERT INTO localizacoes_departamento
(numero_departamento, "local")
VALUES(5, 'Itu');

INSERT INTO localizacoes_departamento
(numero_departamento, "local")
VALUES(5, 'São Paulo');

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(1, 'ProdutoX', 'Santo André', 5);

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(2, 'ProdutoY', 'Itu', 5);

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(3, 'ProdutoZ', 'São Paulo', 5);

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(10, 'Informatização', 'Mauá', 4);

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(20, 'Reorganização', 'São Paulo', 1);

INSERT INTO projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(30, 'Novosbenefícios', 'Mauá', 4);

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Tiago', 'M', '1983-10-25', 'Filho');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Janaína', 'F', '1958-05-03', 'Esposa');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Michael', 'M', '04-01-1988', 'Filho');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Alicia', 'F', '1988-12-30', 'Filha');

INSERT INTO dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('12345678966', 1, 32.5);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('12345678966', 2, 7.5);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('66688444476', 3, 40.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('45345345376', 1, 20.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('45345345376', 2, 20.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 2, 10.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 3, 10.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 10, 10.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 20, 10.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('99988777767', 30, 30.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('99988777767', 10, 10.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98798798733', 10, 35.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98798798733', 30, 5.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98765432168', 30, 20.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98765432168', 20, 15.0);

INSERT INTO trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('88866555576', 20, '0');

