-- CRIAÇÃO DO BANCO
-- create database candyshop;
-- \c candyshop;

-- TABELAS PRINCIPAIS


create table pessoa (
    "cpf-pessoa" varchar(20) primary key,
    "nome-pessoa" varchar(60),
    "data-nascimento-pessoa" date,
    "endereco-pessoa" varchar(150)
);

create table cargo (
    "id-cargo" serial primary key,
    "nome-cargo" varchar(45)
);

create table funcionario (
    "pessoa-cpf-pessoa" varchar(20) primary key references pessoa("cpf-pessoa"),
    salario double precision,
    "cargo-id-cargo" int references cargo("id-cargo"),
    "porcentagem-comissao" double precision
);

create table cliente (
    "pessoa-cpf-pessoa" varchar(20) primary key references pessoa("cpf-pessoa"),
    "renda-cliente" double precision,
    "data-cadastro-cliente" date
);

create table produto (
    "id-produto" serial primary key,
    "nome-produto" varchar(45),
    "quantidade-estoque" int,
    "preco-unitario" double precision
);

create table pedido (
    "id-pedido" serial primary key,
    "data-pedido" date,
    "cliente-pessoa-cpf-pessoa" varchar(20) references cliente("pessoa-cpf-pessoa"),
    "funcionario-pessoa-cpf-pessoa" varchar(20) references funcionario("pessoa-cpf-pessoa")
);

create table pagamento (
    "pedido-id-pedido" int primary key references pedido("id-pedido"),
    "data-pagamento" timestamp,
    "valor-total-pagamento" double precision
);

create table "forma-pagamento" (
    "id-forma-pagamento" serial primary key,
    "nome-forma-pagamento" varchar(100)
);

-- TABELAS RELACIONAIS

create table "pedido-has-produto" (
    "produto-id-produto" int references produto("id-produto"),
    "pedido-id-pedido" int references pedido("id-pedido"),
    quantidade int,
    "preco-unitario" double precision,
    primary key ("produto-id-produto", "pedido-id-pedido")
);

create table "pagamento-has-forma-pagamento" (
    "pagamento-id-pedido" int references pagamento("pedido-id-pedido"),
    "forma-pagamento-id-forma-pagamento" int references "forma-pagamento"("id-forma-pagamento"),
    "valor-pago" double precision,
    primary key ("pagamento-id-pedido", "forma-pagamento-id-forma-pagamento")
);




-- Pessoa (10 registros)
insert into pessoa ("cpf-pessoa", "nome-pessoa", "data-nascimento-pessoa", "endereco-pessoa") values
('11111111111', 'João Silva', '1990-01-10', 'algum lugar'),
('22222222222', 'Maria Souza', '1985-02-15', 'lá longe, 1234'),
('33333333333', 'Carlos Pereira', '1992-03-20', 'Rua que Judas perdeu as botas, 234'),
('44444444444', 'Ana Lima', '1995-04-25', 'Alameda do medo, 4534 apto 13'),
('55555555555', 'Lucas Mendes', '1988-05-30', 'Rua sexta-feira, 13 - apto 666'),
('66666666666', 'Fernanda Costa', '1993-06-05', 'muito longe, 243'),
('77777777777', 'Ricardo Alves', '1987-07-10', 'far far faraway, 34'),
('88888888888', 'Patrícia Gomes', '1994-08-15', 'acolá, 54'),
('99999999999', 'Marcos Rocha', '1991-09-20', 'kaxa prego - ilha de itaparica'),
('10101010101', 'Juliana Dias', '1989-10-25', 'lins, 352');

-- Cargo (10 registros)
insert into cargo ("nome-cargo") values
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
insert into funcionario ("pessoa-cpf-pessoa", salario, "cargo-id-cargo", "porcentagem-comissao") values
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
insert into cliente ("pessoa-cpf-pessoa", "renda-cliente", "data-cadastro-cliente") values
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
insert into produto ("nome-produto", "quantidade-estoque", "preco-unitario") values
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
insert into pedido ("data-pedido", "cliente-pessoa-cpf-pessoa", "funcionario-pessoa-cpf-pessoa") values
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
insert into pagamento ("pedido-id-pedido", "data-pagamento", "valor-total-pagamento") values
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
insert into "forma-pagamento" ("nome-forma-pagamento") values
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
insert into "pedido-has-produto" ("produto-id-produto", "pedido-id-pedido", quantidade, "preco-unitario") values
(1, 1, 2, 5.50),
(2, 2, 10, 0.50),
(3, 3, 5, 1.00),
(4, 4, 3, 3.20),
(5, 5, 2, 7.00);

-- PagamentoHasFormaPagamento (5 registros)
insert into "pagamento-has-forma-pagamento" ("pagamento-id-pedido", "forma-pagamento-id-forma-pagamento", "valor-pago") values
(1, 1, 20.00),
(2, 2, 30.00),
(3, 3, 15.00),
(4, 4, 50.00),
(5, 5, 100.00);
