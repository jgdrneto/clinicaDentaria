--TABELAS

----------------------------------------------------------------------------------------------

CREATE TABLE cargo (
  idcargo SERIAL NOT NULL ,
  nome VARCHAR(140) NOT NULL,
  salario numeric(10,2),
  descricao VARCHAR(140) NULL,
  PRIMARY KEY(idcargo)
);

CREATE TABLE clinica (
  idclinica SERIAL NOT NULL,
  nome_fantasia VARCHAR(140) NOT NULL,
  razao_social VARCHAR(140) NOT NULL,
  endereço VARCHAR(140) NOT NULL,
  bairro VARCHAR(100) NOT NULL,
  numero INTEGER NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  estado VARCHAR(2) NOT NULL,
  complemento VARCHAR(255) NULL,
  cnpj INTEGER  NOT NULL,
  logomarca VARCHAR(140) NOT NULL,
  telefone VARCHAR(100) NOT NULL,
  PRIMARY KEY(idclinica)
);

CREATE TABLE pessoa (
  idpessoa SERIAL NOT NULL,
  nome VARCHAR(140) NOT NULL,
  endereco VARCHAR(140) NOT NULL,
  numero INTEGER  NOT NULL,
  bairro VARCHAR(140) NOT NULL,
  cidade VARCHAR(140) NOT NULL,
  estado VARCHAR(2) NOT NULL,
  cpf INTEGER  NOT NULL,
  telefone VARCHAR(140) NOT NULL,
  sexo INTEGER  NOT NULL,
  data_cadastro DATE NOT NULL,
  PRIMARY KEY(idpessoa)
);

CREATE TABLE status_reserva (
  idstatus_reserva SERIAL NOT NULL,
  nome VARCHAR(140) NULL,
  PRIMARY KEY(idstatus_reserva)
);

CREATE TABLE tipo_consulta (
  idtipo_consulta SERIAL NOT NULL,
  nome VARCHAR(140) NULL,
  PRIMARY KEY(idtipo_consulta)
);

CREATE TABLE tipo_exame (
  idtipo_exame SERIAL NOT NULL,
  nome VARCHAR(140) NULL,
  descricao VARCHAR(140) NULL,
  PRIMARY KEY(idtipo_exame)
);

CREATE TABLE tipo_plano (
  idtipo_plano SERIAL NOT NULL,
  nome VARCHAR(140) NOT NULL,
  descricao VARCHAR(140) NULL,
  PRIMARY KEY(idtipo_plano)
);

CREATE TABLE tipo_servicos
(
  idtipo_servicos serial NOT NULL,
  nome character varying(140) NOT NULL,
  CONSTRAINT tipo_servicos_pkey PRIMARY KEY (idtipo_servicos)
);

CREATE TABLE servicos
(
  idservicos serial NOT NULL,
  nome character varying(140),
  descricao character varying(140),
  preco numeric(10,2),
  tipo_servicos_idtipo_servicos integer,
  CONSTRAINT servicos_pkey PRIMARY KEY (idservicos),
  CONSTRAINT "servicos_FKIndextipo_servicos" FOREIGN KEY (tipo_servicos_idtipo_servicos)
      REFERENCES tipo_servicos (idtipo_servicos) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE cliente
(
  idcliente serial NOT NULL,
  pessoa_idpessoa integer NOT NULL,
  tipo_plano_idtipo_plano integer NOT NULL,
  numero_contrato integer NOT NULL,
  CONSTRAINT cliente_pkey PRIMARY KEY (idcliente, pessoa_idpessoa),
  CONSTRAINT "cliente_FKIndexpessoa" FOREIGN KEY (pessoa_idpessoa)
      REFERENCES pessoa (idpessoa) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "cliente_FKIndextiop_plano" FOREIGN KEY (tipo_plano_idtipo_plano)
      REFERENCES tipo_plano (idtipo_plano) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE funcionario
(
  idfuncionario serial NOT NULL,
  pessoa_idpessoa integer NOT NULL,
  cargo_idcargo integer NOT NULL,
  clinica_idclinica integer NOT NULL,
  numero_pis integer NOT NULL,
  CONSTRAINT funcionario_pkey PRIMARY KEY (idfuncionario, pessoa_idpessoa),
  CONSTRAINT "funcionario_FKIndexcargo" FOREIGN KEY (cargo_idcargo)
      REFERENCES cargo (idcargo) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "funcionario_FKIndexclinica" FOREIGN KEY (clinica_idclinica)
      REFERENCES clinica (idclinica) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "funcionario_FKIndexpessoa" FOREIGN KEY (pessoa_idpessoa)
      REFERENCES pessoa (idpessoa) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE reserva
(
  idreserva serial NOT NULL,
  status_reserva_idstatus_reserva integer NOT NULL,
  funcionario_pessoa_idpessoa integer NOT NULL,
  funcionario_idfuncionario integer NOT NULL,
  cliente_pessoa_idpessoa integer NOT NULL,
  cliente_idcliente integer NOT NULL,
  data_reserva date,
  hora_reserva time without time zone,
  CONSTRAINT reserva_pkey PRIMARY KEY (idreserva),
  CONSTRAINT "reserva_FKIndexcliente" FOREIGN KEY (cliente_idcliente, cliente_pessoa_idpessoa)
      REFERENCES cliente (idcliente, pessoa_idpessoa) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "reserva_FKIndexfuncionario" FOREIGN KEY (funcionario_idfuncionario, funcionario_pessoa_idpessoa)
      REFERENCES funcionario (idfuncionario, pessoa_idpessoa) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "reserva_FKIndextipo_reserva" FOREIGN KEY (status_reserva_idstatus_reserva)
      REFERENCES status_reserva (idstatus_reserva) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE consulta
(
  idconsulta serial NOT NULL,
  reserva_idreserva integer NOT NULL,
  tipo_consulta_idtipo_consulta integer NOT NULL,
  CONSTRAINT consulta_pkey PRIMARY KEY (idconsulta, reserva_idreserva),
  CONSTRAINT "consulta_FKIndexreserva" FOREIGN KEY (reserva_idreserva)
      REFERENCES reserva (idreserva) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "consulta_FKIndextipo_consulta" FOREIGN KEY (tipo_consulta_idtipo_consulta)
      REFERENCES tipo_consulta (idtipo_consulta) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE exame
(
  idexame serial NOT NULL,
  reserva_idreserva integer NOT NULL,
  tipo_exame_idtipo_exame integer NOT NULL,
  CONSTRAINT exame_pkey PRIMARY KEY (idexame, reserva_idreserva),
  CONSTRAINT "exame_FKIndexreserva" FOREIGN KEY (reserva_idreserva)
      REFERENCES reserva (idreserva) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "exame_FKIndextipo_exame" FOREIGN KEY (tipo_exame_idtipo_exame)
      REFERENCES tipo_exame (idtipo_exame) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE venda
(
  idvenda serial NOT NULL,
  reserva_idreserva integer NOT NULL,
  data_venda date,
  CONSTRAINT venda_pkey PRIMARY KEY (idvenda),
  CONSTRAINT "venda_FKIndexreserva" FOREIGN KEY (reserva_idreserva)
      REFERENCES reserva (idreserva) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE itens_servico
(
  servicos_idservicos integer NOT NULL,
  venda_idvenda integer NOT NULL,
  valor numeric(10,2),
  CONSTRAINT itens_servico_pkey PRIMARY KEY (servicos_idservicos, venda_idvenda),
  CONSTRAINT "itens_servicoFKIndexvenda" FOREIGN KEY (venda_idvenda)
      REFERENCES venda (idvenda) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "itens_servicosFKIndexservico" FOREIGN KEY (servicos_idservicos)
      REFERENCES servicos (idservicos) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

----------------------------------------------------------------------------------------------

--INDICES

----------------------------------------------------------------------------------------------

CREATE INDEX idcargo_idx ON cargo (idcargo);

CREATE INDEX idcliente_idx ON cliente (idcliente, pessoa_idpessoa);

CREATE INDEX idclinica_idx ON clinica (idclinica);

CREATE INDEX idconsulta_idx ON consulta (idconsulta, reserva_idreserva);

CREATE INDEX idexame_idx ON exame (idexame, reserva_idreserva);

CREATE INDEX idfuncionario_idx ON funcionario (idfuncionario, pessoa_idpessoa);

CREATE INDEX iditens_servico_idx ON itens_servico (servicos_idservicos, venda_idvenda);

CREATE INDEX idpessoa_idx ON pessoa (idpessoa);

CREATE INDEX idreserva_idx ON reserva (idreserva);

CREATE INDEX idservicos_idx ON servicos (idservicos);

CREATE INDEX idstatus_reserva_idx ON status_reserva (idstatus_reserva);

CREATE INDEX idtipo_consulta_idx ON tipo_consulta (idtipo_consulta);

CREATE INDEX idtipo_exame_idx ON tipo_exame (idtipo_exame);

CREATE INDEX idtipo_plano_idx ON tipo_plano (idtipo_plano);

CREATE INDEX idtipo_servicos_idx ON tipo_servicos (idtipo_servicos);

CREATE INDEX idvenda_idx ON venda (idvenda);

----------------------------------------------------------------------------------------------

--FUNCOES

----------------------------------------------------------------------------------------------

--Verifica se tentasse inserir/atualizar o salário para um valor negativo
CREATE FUNCTION cargo_salario() RETURNS trigger AS $cargo_salario$
BEGIN 
IF NEW.salario < 0 THEN
RAISE EXCEPTION 'O salário não pode ser negativo!';
END IF;
RETURN NEW;
END;
$cargo_salario$ LANGUAGE plpgsql;

CREATE TRIGGER cargo_salario BEFORE INSERT OR UPDATE
ON cargo
FOR EACH ROW EXECUTE
PROCEDURE cargo_salario();


--Verifica se tentasse inserir/atualizar o contrato para um valor negativo 
CREATE FUNCTION cliente_numerocontrato() RETURNS trigger AS $cliente_numerocontrato$
BEGIN 
IF NEW.numero_contrato < 0 THEN
RAISE EXCEPTION 'O número do contrato não pode ser negativo!';
END IF;
RETURN NEW;
END;
$cliente_numerocontrato$ LANGUAGE plpgsql;

CREATE TRIGGER cliente_numerocontrato BEFORE INSERT OR UPDATE
ON cliente
FOR EACH ROW EXECUTE
PROCEDURE cliente_numerocontrato();


--Verfica se tentasse inserir/atualizar o número de contrato para um valor negativo
CREATE FUNCTION clinica_numero() RETURNS trigger AS $clinica_numero$
BEGIN 
IF NEW.numero < 0 THEN
RAISE EXCEPTION 'O número não pode ser negativo!';
END IF;
RETURN NEW;
END;
$clinica_numero$ LANGUAGE plpgsql;

CREATE TRIGGER clinica_numero BEFORE INSERT OR UPDATE
ON clinica
FOR EACH ROW EXECUTE
PROCEDURE clinica_numero();


--Verfica se tentasse inserir/atualizar o número de PIS para um valor negativo
CREATE FUNCTION funcionario_numeropis() RETURNS trigger AS $funcionario_numeropis$
BEGIN 
IF NEW.numero_pis <= 0 THEN
RAISE EXCEPTION 'O numero de pis não pode ser negativo!';
END IF;
RETURN NEW;
END;
$funcionario_numeropis$ LANGUAGE plpgsql;

CREATE TRIGGER funcionario_numeropis BEFORE INSERT OR UPDATE
ON funcionario
FOR EACH ROW EXECUTE
PROCEDURE funcionario_numeropis();


--Verfica se tentasse inserir/atualizar o número de item de serviço para um valor negativo
CREATE FUNCTION itensservico_valor() RETURNS trigger AS $itensservico_valor$
BEGIN 
IF NEW.valor < 0 THEN
RAISE EXCEPTION 'O valor do item não pode ser negativo!';
END IF;
RETURN NEW;
END;
$itensservico_valor$ LANGUAGE plpgsql;

CREATE TRIGGER itensservico_valor BEFORE INSERT OR UPDATE
ON itens_servico
FOR EACH ROW EXECUTE
PROCEDURE itensservico_valor();


--Verfica se tentasse inserir/atualizar o número do id da pessoa para um valor negativo
CREATE FUNCTION pessoa_numero() RETURNS trigger AS $pessoa_numero$
BEGIN 
IF NEW.numero < 0 THEN
RAISE EXCEPTION 'O numero não pode ser negativo!';
END IF;
RETURN NEW;
END;
$pessoa_numero$ LANGUAGE plpgsql;

CREATE TRIGGER pessoa_numero BEFORE INSERT OR UPDATE
ON pessoa
FOR EACH ROW EXECUTE
PROCEDURE pessoa_numero();


--Verfica se tentasse inserir/atualizar o preço do serviço para um valor negativo
CREATE FUNCTION servicos_preco() RETURNS trigger AS $servicos_preco$
BEGIN 
IF NEW.preco < 0 THEN
RAISE EXCEPTION 'O preço não pode ser negativo!';
END IF;
RETURN NEW;
END;
$servicos_preco$ LANGUAGE plpgsql;

CREATE TRIGGER servicos_preco BEFORE INSERT OR UPDATE
ON servicos
FOR EACH ROW EXECUTE
PROCEDURE servicos_preco();


--Verfica se tentasse inserir/atualizar a data de venda para uma data maior do que o dia atual
CREATE FUNCTION venda_data() RETURNS trigger AS $venda_data$
BEGIN 
IF NEW.data_venda > current_timestamp::date THEN
RAISE EXCEPTION 'A data da venda não pode ser maior que a data de hoje';
END IF;
RETURN NEW;
END;
$venda_data$ LANGUAGE plpgsql;

CREATE TRIGGER venda_data BEFORE INSERT OR UPDATE
ON venda
FOR EACH ROW EXECUTE
PROCEDURE venda_data();


--Verfica se tentasse inserir/atualizar a data de venda para uma data menor do que o dia atual
CREATE FUNCTION reserva_data() RETURNS trigger AS $reserva_data$
BEGIN 
IF NEW.data_reserva <= current_timestamp::date THEN
RAISE EXCEPTION 'A data da reserva não pode ser menor ou igual a data de hoje';
END IF;
RETURN NEW;
END;
$reserva_data$ LANGUAGE plpgsql;

CREATE TRIGGER reserva_data BEFORE INSERT OR UPDATE
ON reserva
FOR EACH ROW EXECUTE
PROCEDURE reserva_data();


--Verfica se tentasse inserir/atualizar um número de cpf que tenha número menor ou maior que 11 digitos
CREATE FUNCTION pessoa_cpf() RETURNS trigger AS $pessoa_cpf$
BEGIN 
IF length(NEW.cpf::character varying) <> 11 THEN
RAISE EXCEPTION 'O cpf tem que ter 11 numeros';
END IF;
RETURN NEW;
END;
$pessoa_cpf$ LANGUAGE plpgsql;

CREATE TRIGGER pessoa_cpf BEFORE INSERT OR UPDATE
ON pessoa
FOR EACH ROW EXECUTE
PROCEDURE pessoa_cpf();


--Verfica se tentasse inserir/atualizar um número de cnpj que tenha número menor ou maior que 14 digitos
CREATE FUNCTION clinica_cnpj() RETURNS trigger AS $clinica_cnpj$
BEGIN 
IF length(NEW.cnpj::character varying) <> 14 THEN
RAISE EXCEPTION 'O cnpj tem que ter 14 numeros';
END IF;
RETURN NEW;
END;
$clinica_cnpj$ LANGUAGE plpgsql;

CREATE TRIGGER clinica_cnpj BEFORE INSERT OR UPDATE
ON clinica
FOR EACH ROW EXECUTE
PROCEDURE clinica_cnpj();
