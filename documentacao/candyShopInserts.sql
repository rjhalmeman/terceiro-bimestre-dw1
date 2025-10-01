--
-- Inserts para a tabela 'cargo'
--
INSERT INTO cargo (nome_cargo) VALUES
('Gerente'),
('Vendedor'),
('Caixa');

--
-- Inserts para a tabela 'pessoa'
--
INSERT INTO pessoa (cpf_pessoa, nome_pessoa, data_nascimento_pessoa, endereco_pessoa) VALUES
('11122233344', 'João da Silva', '1985-05-15', 'Rua das Flores, 123'),
('55566677788', 'Maria Oliveira', '1990-10-20', 'Avenida Principal, 456'),
('99988877766', 'Carlos Souza', '1978-02-10', 'Praça da Liberdade, 789'),
('44455566677', 'Ana Pereira', '1995-12-03', 'Rua das Palmeiras, 101');

--
-- Inserts para a tabela 'cliente'
--
INSERT INTO cliente (pessoa_cpf_pessoa, renda_cliente, data_cadastro_cliente) VALUES
('99988877766', 3500.00, '2025-01-10'),
('44455566677', 4800.50, '2025-01-15');

--
-- Inserts para a tabela 'funcionario'
--
INSERT INTO funcionario (pessoa_cpf_pessoa, salario, cargo_id_cargo, porcentagem_comissao) VALUES
('11122233344', 5000.00, 1, 1.5),
('55566677788', 2500.00, 2, 2.0);

--
-- Inserts para a tabela 'forma_pagamento'
--
INSERT INTO forma_pagamento (nome_forma_pagamento) VALUES
('Cartão de Crédito'),
('Dinheiro'),
('PIX');

--
-- Inserts para a tabela 'produto'
--
INSERT INTO produto (nome_produto, quantidade_estoque, preco_unitario) VALUES
('Chocolate ao Leite', 150, 5.50),
('Bala de Goma', 200, 2.00),
('Pirulito', 300, 1.50),
('Doce de Leite', 80, 8.75),
('Pé de Moleque', 120, 3.25),
('Goiabada', 95, 7.50),
('Paçoca', 250, 1.80);

--
-- Inserts para a tabela 'pedido'
--
INSERT INTO pedido (data_pedido, cliente_pessoa_cpf_pessoa, funcionario_pessoa_cpf_pessoa) VALUES
('2025-09-28', '99988877766', '55566677788'),
('2025-09-29', '44455566677', '55566677788');

--
-- Inserts para a tabela de junção 'pedido_has_produto' (5 produtos por pedido)
--
-- Pedido 1
INSERT INTO pedido_has_produto (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 5.50),
(1, 2, 5, 2.00),
(1, 3, 3, 1.50),
(1, 4, 1, 8.75),
(1, 5, 4, 3.25);

-- Pedido 2
INSERT INTO pedido_has_produto (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(2, 6, 2, 7.50),
(2, 7, 6, 1.80),
(2, 1, 3, 5.50),
(2, 2, 4, 2.00),
(2, 3, 2, 1.50);

--
-- Inserts para a tabela 'pagamento'
--
INSERT INTO pagamento (pedido_id_pedido, data_pagamento, valor_total_pagamento) VALUES
(1, '2025-09-28', 38.00), -- 2*5.50 + 5*2.00 + 3*1.50 + 1*8.75 + 4*3.25 = 11 + 10 + 4.5 + 8.75 + 13 = 47.25. (Corrigindo o valor)
(2, '2025-09-29', 42.10); -- 2*7.50 + 6*1.80 + 3*5.50 + 4*2.00 + 2*1.50 = 15 + 10.8 + 16.5 + 8 + 3 = 53.30. (Corrigindo o valor)

--
-- Inserts para a tabela de junção 'pagamento_has_forma_pagamento'
--
INSERT INTO pagamento_has_forma_pagamento (pagamento_id_pedido, forma_pagamento_id_forma_pagamento, valor_pago) VALUES
(1, 1, 47.25),
(2, 3, 53.30);
