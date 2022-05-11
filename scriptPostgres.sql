DROP USER IF EXISTS matheusf;
CREATE USER matheusf with
NOSUPERUSER
CREATEDB
CREATEROLE
ENCRYPTED PASSWORD '123123';

DROP DATABASE  IF EXISTS uvv;
CREATE database uvv  WITH
owner =  'matheusf'
template = template0
encoding = 'UTF-8'
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8';

\c "dbname=uvv user=matheusf password=123123"

create schema elmasri authorization 123123;

alter user matheusf
set search_path to elmasri, "$user", public;

set search_path to elmasri, "$user", public;

CREATE TABLE funcionario (
                cpf 						CHAR(11) 		NOT NULL,
                primeiro_nome 				VARCHAR(15) 	NOT NULL,
                nome_meio 					CHAR(1),
                ultimo_nome 				VARCHAR(15) 	NOT NULL,
                data_nascimento 			DATE,
                endereco 					VARCHAR(50),
                sexo 						CHAR(1),
                salario 					DECIMAL(10,2),
                cpf_supervisor 				CHAR(11) 		NOT NULL,
                numero_departamento 		INTEGER 		NOT NULL,
                CONSTRAINT funcionario_pk 					PRIMARY KEY (cpf)
);

COMMENT ON TABLE  funcionario 						IS 		'Tabela que armazena as informações dos funcionários.';
COMMENT ON COLUMN funcionario.cpf 					IS 		'CPF do funcionário. Será a PK da tabela.';
COMMENT ON COLUMN funcionario.primeiro_nome 		IS 		'Primeiro nome do funcionário.';
COMMENT ON COLUMN funcionario.nome_meio 			IS 		'Inicial do nome do meio.';
COMMENT ON COLUMN funcionario.ultimo_nome 			IS 		'Sobrenome do funcionário.';
COMMENT ON COLUMN funcionario.data_nascimento 		IS 		'Data de nascimento do funcionário.';
COMMENT ON COLUMN funcionario.endereco 				IS 		'Endereço do funcionário.';
COMMENT ON COLUMN funcionario.sexo 					IS 		'Sexo do funcionário.';
COMMENT ON COLUMN funcionario.salario 				IS 		'Salário do funcionário.';
COMMENT ON COLUMN funcionario.cpf_supervisor 		IS 		'CPF do supervisor. Será uma FK para a própria tabela (um auto-relacionamento).';
COMMENT ON COLUMN funcionario.numero_departamento 	IS 		'Número do departamento do funcionário.';


CREATE TABLE departamento (
                numero_departamento 		INTEGER 	NOT NULL,
                nome_departamento 			CHAR(15)  	NOT NULL,
                cpf_gerente 				CHAR(11) 	NOT NULL,
                data_inicio_gerente 		DATE,
                CONSTRAINT departamento_pk  			PRIMARY KEY (numero_departamento)
);

COMMENT ON TABLE  departamento 							IS 		'Tabela que armazena as informaçoẽs dos departamentos.';
COMMENT ON COLUMN departamento.numero_departamento  	IS 		'Número do departamento. É a PK desta tabela.';
COMMENT ON COLUMN departamento.nome_departamento 		IS 		'Nome do departamento. Deve ser único.';
COMMENT ON COLUMN departamento.cpf_gerente 				IS 		'CPF do gerente do departamento. É uma FK para a tabela funcionários.';
COMMENT ON COLUMN departamento.data_inicio_gerente  	IS 		'Data do início do gerente no departamento.';


CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE projeto (
                numero_projeto 			INTEGER 		NOT NULL,
                nome_projeto 			VARCHAR(15)     NOT NULL,
                local_projeto 			VARCHAR(15),
                numero_departamento 	INTEGER 		NOT NULL,
                CONSTRAINT projeto_pk 					PRIMARY KEY (numero_projeto)
);
COMMENT ON TABLE projeto 					  	IS 		'Tabela que armazena as informações sobre os projetos dos departamentos.';
COMMENT ON COLUMN projeto.numero_projeto 	  	IS 		'Número do projeto. É a PK desta tabela.';
COMMENT ON COLUMN projeto.nome_projeto 		  	IS 		'Nome do projeto. Deve ser único.';
COMMENT ON COLUMN projeto.local_projeto 	  	IS 		'Localização do projeto.';
COMMENT ON COLUMN projeto.numero_departamento 	IS 		'Número do departamento. É uma FK para a tabela departamento.';


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE localizacoes_departamento (
                numero_departamento 					INTEGER 				NOT NULL,
                local 									VARCHAR(15) 			NOT NULL,
                CONSTRAINT localizacoes_departamento_pk 						PRIMARY KEY (numero_departamento, local)
);

COMMENT ON TABLE localizacoes_departamento 							IS 		'Tabela que armazena as possíveis localizações dos departamentos.';
COMMENT ON COLUMN localizacoes_departamento.numero_departamento 	IS 		'Número do departamento. Faz parta da PK desta tabela e também é uma FK para a tabela departamento.';
COMMENT ON COLUMN localizacoes_departamento.local 					IS 		'Localização do departamento. Faz parte da PK desta tabela.';


CREATE TABLE trabalha_em (
                cpf_funcionario 			CHAR(11)  		NOT NULL,
                numero_projeto 				INTEGER 	  	NOT NULL,
                horas 						DECIMAL(3,1),
                CONSTRAINT trabalha_em_pk 					PRIMARY KEY (cpf_funcionario, numero_projeto)
);

COMMENT ON TABLE trabalha_em 				  	IS 		'Tabela para armazenar quais funcionários trabalham em quais projetos.';
COMMENT ON COLUMN trabalha_em.cpf_funcionario 	IS 		'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN trabalha_em.numero_projeto  	IS 		'Número do projeto. Faz parte da PK desta tabela e é uma FK para a tabela projeto.';
COMMENT ON COLUMN trabalha_em.horas 		  	IS 		'Horas trabalhadas pelo funcionário neste projeto.';


CREATE TABLE dependente (
                cpf_funcionario 			CHAR(11)		NOT NULL,
                nome_dependente 			VARCHAR(15) 	NOT NULL,
                sexo 						CHAR(1),
                data_nascimento 			DATE,
                parentesco 					VARCHAR(15),
                CONSTRAINT dependente_pk    				PRIMARY KEY (cpf_funcionario, nome_dependente)
);

COMMENT ON TABLE dependente 				 	IS 		'Tabela que armazena as informações dos dependentes dos funcionários.';
COMMENT ON COLUMN dependente.cpf_funcionario 	IS 		'CPF do funcionário. Faz parte da PK desta tabela e é uma FK para a tabela funcionário.';
COMMENT ON COLUMN dependente.nome_dependente 	IS 		'Nome do dependente. Faz parte da PK desta tabela.';
COMMENT ON COLUMN dependente.sexo 			 	IS 		'Sexo do dependente.';
COMMENT ON COLUMN dependente.data_nascimento 	IS 		'Data de nascimento do dependente.';
COMMENT ON COLUMN dependente.parentesco 	 	IS 		'Descrição do parentesco do dependente com o funcionário.';


ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

alter table funcionario                   add constraint c_MF
										check(sexo in ('F','M'))
;

alter table dependente                    add constraint c_MF 
                                        check(sexo in ('F','M'))
;

alter table funcionario                add constraint nd_negativo 
                                          check (salario >= 0)
;

alter table trabalha_em                add constraint hora_negativo 
                                          check (horas >= 0)
;

alter table funcionario          alter column cpf_supervisor drop not null
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
VALUES('12345678966', 'Michael', 'M', '1988-01-04', 'Filho');

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

