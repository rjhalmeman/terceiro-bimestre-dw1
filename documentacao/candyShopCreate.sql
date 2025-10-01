--
-- Tabela 'cargo'
--
CREATE TABLE cargo (
    id_cargo SERIAL PRIMARY KEY,
    nome_cargo VARCHAR(50) UNIQUE NOT NULL
);

--
-- Tabela 'pessoa'
--
CREATE TABLE pessoa (
    cpf_pessoa VARCHAR(11) PRIMARY KEY,
    nome_pessoa VARCHAR(100) NOT NULL,
    data_nascimento_pessoa DATE,
    endereco_pessoa VARCHAR(255)
);

--
-- Tabela 'cliente'
--
CREATE TABLE cliente (
    pessoa_cpf_pessoa VARCHAR(11) PRIMARY KEY REFERENCES pessoa(cpf_pessoa),
    renda_cliente DECIMAL(10, 2),
    data_cadastro_cliente DATE NOT NULL
);

--
-- Tabela 'funcionario'
--
CREATE TABLE funcionario (
    pessoa_cpf_pessoa VARCHAR(11) PRIMARY KEY REFERENCES pessoa(cpf_pessoa),
    salario DECIMAL(10, 2) NOT NULL,
    cargo_id_cargo INT REFERENCES cargo(id_cargo),
    porcentagem_comissao DECIMAL(5, 2)
);

--
-- Tabela 'forma_pagamento'
--
CREATE TABLE forma_pagamento (
    id_forma_pagamento SERIAL PRIMARY KEY,
    nome_forma_pagamento VARCHAR(50) UNIQUE NOT NULL
);

--
-- Tabela 'pedido'
--
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    cliente_pessoa_cpf_pessoa VARCHAR(11) REFERENCES cliente(pessoa_cpf_pessoa),
    funcionario_pessoa_cpf_pessoa VARCHAR(11) REFERENCES funcionario(pessoa_cpf_pessoa)
);

--
-- Tabela 'produto'
--
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome_produto VARCHAR(100) UNIQUE NOT NULL,
    quantidade_estoque INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL
);

--
-- Tabela de junção 'pedido_has_produto'
--
CREATE TABLE pedido_has_produto (
    id_pedido INT REFERENCES pedido(id_pedido),
    id_produto INT REFERENCES produto(id_produto),
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto)
);

--
-- Tabela 'pagamento'
--
CREATE TABLE pagamento (
    pedido_id_pedido INT PRIMARY KEY REFERENCES pedido(id_pedido),
    data_pagamento DATE NOT NULL,
    valor_total_pagamento DECIMAL(10, 2) NOT NULL
);

--
-- Tabela de junção 'pagamento_has_forma_pagamento'
--
CREATE TABLE pagamento_has_forma_pagamento (
    pagamento_id_pedido INT REFERENCES pagamento(pedido_id_pedido),
    forma_pagamento_id_forma_pagamento INT REFERENCES forma_pagamento(id_forma_pagamento),
    valor_pago DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (pagamento_id_pedido, forma_pagamento_id_forma_pagamento)
);
