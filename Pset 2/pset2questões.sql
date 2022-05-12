-- PSET 2
-- 1- Questão

SELECT
AVG(f.salario) AS salario_media, d.nome_departamento
	FROM departamento d 
	JOIN funcionario f 
	ON (d.numero_departamento = f.numero_departamento) 
	GROUP BY d.nome_departamento
	ORDER BY AVG(f.salario) DESC;

-- 2- Questão 

SELECT
AVG(f.salario) AS salario_media, f.sexo
	FROM funcionario f
	GROUP BY f.sexo;

-- 3- Questão  

 SELECT 
  d.nome_departamento AS nome_departamento,
  CONCAT(f.primeiro_nome,' ', f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
  data_nascimento,
  DATE_PART('year', AGE('2022-01-01', data_nascimento)) AS idade,
  f.salario AS salario
	FROM departamento d 
	JOIN funcionario f 
	ON d.numero_departamento = f.numero_departamento
	ORDER BY d.nome_departamento, DATE_PART('year', AGE('2022-01-01', data_nascimento)) DESC;

-- 4- Questão  

SELECT 
  CONCAT(f.primeiro_nome, ' ', f.nome_meio, ' ', f.ultimo_nome) AS nome_funcionario,
  f.data_nascimento, DATE_PART('year', AGE('2022-01-01', data_nascimento)) AS idade,
  f.salario AS salario_atual,
  (CASE
	WHEN (f.salario < 35) THEN 20
	ELSE 15
	END) AS taxa_reajuste,
(CASE
	WHEN (f.salario < 35) THEN f.salario + (f.salario * 0.2)
	ELSE f.salario + (f.salario * 0.15)
	END) AS novo_salario
	FROM funcionario f;

-- 5- Questão

SELECT 
  CONCAT(func.primeiro_nome, func.nome_meio, func.ultimo_nome) AS nome_supervisor
, CONCAT(f.primeiro_nome, f.nome_meio, f.ultimo_nome) AS nome_funcionario, nome_departamento, f.salario AS salario_funcionarios
	FROM funcionario  AS f
	JOIN departamento AS dept ON f.numero_departamento = dept.numero_departamento
	JOIN funcionario  AS func ON dept.cpf_gerente = func.cpf
	GROUP BY nome_departamento, nome_funcionario, nome_supervisor, salario_funcionarios
	ORDER BY nome_departamento ASC, salario_funcionarios DESC;

-- 6- Questão 

SELECT 
	CONCAT(f.primeiro_nome,' ', f.nome_meio,' ', f.ultimo_nome) AS nome_funcionario,
	dp.nome_departamento AS nome_departamento,
	CONCAT(d.nome_dependente, ' ', f.nome_meio, ' ', f.ultimo_nome) AS dependente, DATE_PART('year', AGE('2022-01-01', d.data_nascimento))
  	AS "Idade do Dependente",
  CASE d.sexo
    WHEN 'M' THEN 'Masculino'
    WHEN 'F' THEN 'Feminino'
    END AS "Sexo do dependente"
	FROM funcionario f
	INNER JOIN dependente d 
	ON (d.cpf_funcionario = f.cpf)
	INNER JOIN departamento dp 
	ON (dp.numero_departamento = f.numero_departamento);

-- 7- Questão 

SELECT
	CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
	dt.nome_departamento AS nome_departamento,
	CASE 
  	WHEN d.nome_dependente IS NULL 
  	THEN f.salario
  	END salario
	FROM funcionario f
	JOIN departamento dt
	ON (f.numero_departamento = dt.numero_departamento)
	LEFT JOIN dependente d 
	ON (f.cpf = d.cpf_funcionario)
	WHERE d.nome_dependente IS NULL;

-- 8- Questão 

SELECT
  t.horas AS horas_trabalhadas,
  CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
  p.nome_projeto 	  AS nome_projeto,
  d.nome_departamento AS nome_departamento
	FROM trabalha_em t
	JOIN projeto p 
	ON t.numero_projeto = p.numero_projeto
	JOIN departamento d
	ON p.numero_departamento = d.numero_departamento
	JOIN funcionario f
	ON f.cpf = t.cpf_funcionario
	ORDER BY d.nome_departamento, p.nome_projeto, CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome);

-- 9- Questão 

SELECT 
	SUM(t.horas) 		AS horas_totais,
	p.nome_projeto 		AS nome_projeto,
	d.nome_departamento AS nome_departamento
	FROM trabalha_em t
	JOIN projeto p
	ON (p.numero_projeto = t.numero_projeto)
	JOIN departamento d
	ON (d.numero_departamento = p.numero_departamento)
	WHERE t.numero_projeto = t.numero_projeto 
	GROUP BY t.numero_projeto, p.nome_projeto, d.nome_departamento;

-- 10- Questão 

SELECT
	AVG(f.salario) AS media_salarial,
	d.nome_departamento AS nome_departamento
	FROM funcionario f
	INNER JOIN departamento d
	ON d.numero_departamento = f.numero_departamento
	GROUP BY d.nome_departamento;

-- 11- Questão 

SELECT
	CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
	p.nome_projeto AS nome_projeto,
	t.horas AS horas_trabalhadas,
CASE
  	WHEN t.horas > 0
  	THEN t.horas*50
  	END AS valor_recebido
	FROM trabalha_em t 
	JOIN funcionario f
	ON (f.cpf = t.cpf_funcionario)
	JOIN projeto p
	ON (p.numero_projeto = t.numero_projeto)
	ORDER BY t.horas DESC;

-- 12- Questão 

SELECT
dpt.nome_departamento 	AS 		nome_departamento,
p.nome_projeto 		  	AS 		nome_projeto,
f.primeiro_nome 	  	AS 		nome_funcionario,
t.horas 			  	AS 		horas_trabalhadas
	FROM funcionario f 
	INNER JOIN departamento dpt
	ON f.numero_departamento = dpt.numero_departamento
	INNER JOIN projeto p
	ON dpt.numero_departamento = p.numero_departamento
	INNER JOIN trabalha_em t
	ON p.numero_projeto = t.numero_projeto
	WHERE t.horas = 0;

-- 13- Questão

SELECT
	CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
CASE f.sexo
	WHEN 'M' THEN 'Masculino'
	WHEN 'F' THEN 'Feminino'
  	END AS sexo,
  	DATE_PART('year', AGE('2022-01-01', data_nascimento)) AS idade
	FROM funcionario f 
	UNION
SELECT
 	d.nome_dependente AS nome_funcionario,
 CASE d.sexo
	WHEN 'M' THEN 'Masculino'
	WHEN 'F' THEN 'Feminino'
	END AS sexo,
	DATE_PART('year', AGE('2022-01-01', data_nascimento)) AS idade
	FROM dependente d
	ORDER BY idade DESC;

-- 14- Questão

SELECT
	dpt.nome_departamento 		 AS nome_departamento,
	COUNT(f.numero_departamento) AS funcionarios_trabalhando
	FROM funcionario f
	INNER JOIN departamento dpt
	ON f.numero_departamento = dpt.numero_departamento
	GROUP BY dpt.nome_departamento;

-- 15- Questão

SELECT
	CONCAT(f.primeiro_nome,' ',f.nome_meio,' ',f.ultimo_nome) AS nome_funcionario,
	d.nome_departamento AS nome_departamento,
	p.nome_projeto 		AS nome_projeto
	FROM trabalha_em t
	JOIN funcionario f
	ON (t.cpf_funcionario = f.cpf)
	JOIN projeto p
	ON (p.numero_projeto = t.numero_projeto)
	JOIN departamento d
	ON (d.numero_departamento = p.numero_departamento)
	WHERE p.numero_departamento = f.numero_departamento
	ORDER BY p.nome_projeto DESC;









