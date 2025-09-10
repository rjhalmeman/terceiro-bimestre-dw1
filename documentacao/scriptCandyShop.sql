-- CRIAÇÃO DO BANCO
-- CREATE DATABASE candyshop;
-- \c candyshop;

-- TABELAS PRINCIPAIS

CREATE TABLE Endereco (
    idEndereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    referencia VARCHAR(45),
    cep VARCHAR(9),
    cidadeIdCidade INT
);

CREATE TABLE Pessoa (
    cpfPessoa VARCHAR(20) PRIMARY KEY,
    nomePessoa VARCHAR(60),
    dataNascimentoPessoa DATE,
    EnderecoIdEndereco INT REFERENCES Endereco(idEndereco)
);

CREATE TABLE Cargo (
    idCargo SERIAL PRIMARY KEY,
    nomeCargo VARCHAR(45)
);

CREATE TABLE Funcionario (
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    salario DOUBLE PRECISION,
    CargoIdCargo INT REFERENCES Cargo(idCargo),
    porcentagemComissao DOUBLE PRECISION
);

CREATE TABLE Cliente (
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    rendaCliente DOUBLE PRECISION,
    dataDeCadastroCliente DATE
);

CREATE TABLE Produto (
    idProduto SERIAL PRIMARY KEY,
    nomeProduto VARCHAR(45),
    quantidadeEmEstoque INT,
    precoUnitario DOUBLE PRECISION
);

CREATE TABLE Pedido (
    idPedido SERIAL PRIMARY KEY,
    dataDoPedido DATE,
    ClientePessoaCpfPessoa VARCHAR(20) REFERENCES Cliente(PessoaCpfPessoa),
    FuncionarioPessoaCpfPessoa VARCHAR(20) REFERENCES Funcionario(PessoaCpfPessoa)
);

CREATE TABLE Pagamento (
    PedidoIdPedido INT PRIMARY KEY REFERENCES Pedido(idPedido),
    dataPagamento TIMESTAMP,
    valorTotalPagamento DOUBLE PRECISION
);

CREATE TABLE FormaDePagamento (
    idFormaPagamento SERIAL PRIMARY KEY,
    nomeFormaPagamento VARCHAR(100)
);

-- TABELAS RELACIONAIS

CREATE TABLE PedidoHasProduto (
    ProdutoIdProduto INT REFERENCES Produto(idProduto),
    PedidoIdPedido INT REFERENCES Pedido(idPedido),
    quantidade INT,
    precoUnitario DOUBLE PRECISION,
    PRIMARY KEY (ProdutoIdProduto, PedidoIdPedido)
);

CREATE TABLE PagamentoHasFormaPagamento (
    PagamentoIdPedido INT REFERENCES Pagamento(PedidoIdPedido),
    FormaPagamentoIdFormaPagamento INT REFERENCES FormaDePagamento(idFormaPagamento),
    valorPago DOUBLE PRECISION,
    PRIMARY KEY (PagamentoIdPedido, FormaPagamentoIdFormaPagamento)
);

-- ======================================
-- POPULAÇÃO DE DADOS
-- ======================================

-- Endereco (10 registros)
INSERT INTO Endereco (logradouro, numero, referencia, cep, cidadeIdCidade) VALUES
('Rua A', '10', 'Próx. padaria', '80000-000', 1),
('Rua B', '20', 'Em frente escola', '80000-001', 1),
('Rua C', '30', 'Ao lado mercado', '80000-002', 1),
('Rua D', '40', 'Próx. posto', '80000-003', 2),
('Rua E', '50', 'Centro', '80000-004', 2),
('Rua F', '60', 'Próx. igreja', '80000-005', 2),
('Rua G', '70', 'Zona norte', '80000-006', 3),
('Rua H', '80', 'Zona sul', '80000-007', 3),
('Rua I', '90', 'Zona leste', '80000-008', 3),
('Rua J', '100', 'Zona oeste', '80000-009', 4);

-- Pessoa (10 registros)
INSERT INTO Pessoa (cpfPessoa, nomePessoa, dataNascimentoPessoa, EnderecoIdEndereco) VALUES
('11111111111', 'João Silva', '1990-01-10', 1),
('22222222222', 'Maria Souza', '1985-02-15', 2),
('33333333333', 'Carlos Pereira', '1992-03-20', 3),
('44444444444', 'Ana Lima', '1995-04-25', 4),
('55555555555', 'Lucas Mendes', '1988-05-30', 5),
('66666666666', 'Fernanda Costa', '1993-06-05', 6),
('77777777777', 'Ricardo Alves', '1987-07-10', 7),
('88888888888', 'Patrícia Gomes', '1994-08-15', 8),
('99999999999', 'Marcos Rocha', '1991-09-20', 9),
('10101010101', 'Juliana Dias', '1989-10-25', 10);

-- Cargo (10 registros)
INSERT INTO Cargo (nomeCargo) VALUES
('Vendedor'),
('Gerente'),
('Caixa'),
('Supervisor'),
('Atendente'),
('Repositor'),
('Conferente'),
('Assistente'),
('Auxiliar'),
('Diretor');

-- Funcionario (10 registros)
INSERT INTO Funcionario (PessoaCpfPessoa, salario, CargoIdCargo, porcentagemComissao) VALUES
('11111111111', 2000.00, 1, 5),
('22222222222', 3000.00, 2, 10),
('33333333333', 1500.00, 3, 3),
('44444444444', 2500.00, 4, 6),
('55555555555', 1800.00, 5, 4),
('66666666666', 1600.00, 6, 2),
('77777777777', 2200.00, 7, 5),
('88888888888', 1900.00, 8, 3),
('99999999999', 2800.00, 9, 7),
('10101010101', 5000.00, 10, 15);

-- Cliente (10 registros)
INSERT INTO Cliente (PessoaCpfPessoa, rendaCliente, dataDeCadastroCliente) VALUES
('11111111111', 2500.00, '2024-01-01'),
('22222222222', 3200.00, '2024-01-02'),
('33333333333', 1800.00, '2024-01-03'),
('44444444444', 4000.00, '2024-01-04'),
('55555555555', 2100.00, '2024-01-05'),
('66666666666', 3500.00, '2024-01-06'),
('77777777777', 2700.00, '2024-01-07'),
('88888888888', 5000.00, '2024-01-08'),
('99999999999', 3800.00, '2024-01-09'),
('10101010101', 4500.00, '2024-01-10');

-- Produto (10 registros)
INSERT INTO Produto (nomeProduto, quantidadeEmEstoque, precoUnitario) VALUES
('Chocolate', 100, 5.50),
('Bala', 200, 0.50),
('Pirulito', 150, 1.00),
('Biscoito', 80, 3.20),
('Refrigerante', 50, 7.00),
('Suco', 60, 4.50),
('Chiclete', 300, 0.75),
('Pão de Mel', 40, 6.00),
('Doce de Leite', 30, 8.50),
('Sorvete', 20, 10.00);

-- Pedido (10 registros)
INSERT INTO Pedido (dataDoPedido, ClientePessoaCpfPessoa, FuncionarioPessoaCpfPessoa) VALUES
('2024-02-01', '11111111111', '22222222222'),
('2024-02-02', '33333333333', '44444444444'),
('2024-02-03', '55555555555', '66666666666'),
('2024-02-04', '77777777777', '88888888888'),
('2024-02-05', '99999999999', '10101010101'),
('2024-02-06', '22222222222', '11111111111'),
('2024-02-07', '44444444444', '33333333333'),
('2024-02-08', '66666666666', '55555555555'),
('2024-02-09', '88888888888', '77777777777'),
('2024-02-10', '10101010101', '99999999999');

-- Pagamento (10 registros)
INSERT INTO Pagamento (PedidoIdPedido, dataPagamento, valorTotalPagamento) VALUES
(1, '2024-02-01 10:00:00', 50.00),
(2, '2024-02-02 11:00:00', 30.00),
(3, '2024-02-03 12:00:00', 20.00),
(4, '2024-02-04 13:00:00', 70.00),
(5, '2024-02-05 14:00:00', 100.00),
(6, '2024-02-06 15:00:00', 80.00),
(7, '2024-02-07 16:00:00', 25.00),
(8, '2024-02-08 17:00:00', 45.00),
(9, '2024-02-09 18:00:00', 60.00),
(10, '2024-02-10 19:00:00', 90.00);

-- FormaDePagamento (10 registros)
INSERT INTO FormaDePagamento (nomeFormaPagamento) VALUES
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Pix'),
('Boleto'),
('Vale Alimentação'),
('Transferência Bancária'),
('Cheque'),
('Crédito Loja'),
('Gift Card');

-- PedidoHasProduto (5 registros)
INSERT INTO PedidoHasProduto (ProdutoIdProduto, PedidoIdPedido, quantidade, precoUnitario) VALUES
(1, 1, 2, 5.50),
(2, 2, 10, 0.50),
(3, 3, 5, 1.00),
(4, 4, 3, 3.20),
(5, 5, 2, 7.00);

-- PagamentoHasFormaPagamento (5 registros)
INSERT INTO PagamentoHasFormaPagamento (PagamentoIdPedido, FormaPagamentoIdFormaPagamento, valorPago) VALUES
(1, 1, 20.00),
(2, 2, 30.00),
(3, 3, 15.00),
(4, 4, 50.00),
(5, 5, 100.00);
