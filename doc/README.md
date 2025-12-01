** Projeto de Modelagem e Scripts SQL para E-commerce **

Este repositório contém os scripts SQL criados a partir de um modelo lógico de banco de dados para um sistema de E-commerce de maquiagem. O objetivo é demonstrar a manipulação de dados através de consultas e comandos. Contém Script SQL com comandos de INSERT para povoar as tabelas principais, Script SQL com duas a cinco consultas usando SELECT (com WHERE, ORDER BY, LIMIT, JOIN etc.) e Script com ao menos três comandos de UPDATE e três de DELETE com condições.

1. Modelo Lógico 

O projeto foi baseado no modelo lógico de E-commerce de maquiagem, com a se

• Cliente: id_cliente (PK), nome, telefone, data_nascimento.

• Categoria: id_categoria (PK), nome_categoria (UNIQUE).

• Produto: id_produto (PK), nome, preco, quantidade_minima, id_categoria (FK).

• Estoque: id_estoque (PK), quantidade_atual, id_produto (FK).

• Venda: id_venda (PK), data_venda, valor_total, id_cliente (FK).

• Item_venda: id_item_venda (PK), quantidade, preco_unitario, id_venda (FK), id_produto (FK).

• Feedback: id_feedback (PK), nota, comentario, data_feedback, id_cliente (FK), id_produto (FK).

2. Estrutura do Repositório

Os scripts SQL estão organizados na seguinte ordem de execução:

1. Schemas: Contém os comandos CREATE TABLE para a criação de todas as tabelas e suas respectivas chaves primárias (PK) e estrangeiras (FK).

2. Inserts: Contém os comandos INSERT INTO para popular as tabelas principais com dados de exemplo.

3. Selects: Contém exemplos de consultas avançadas (SELECT) utilizando JOIN, WHERE, ORDER BY, GROUP BY, HAVING e LIMIT.

4. Update/Delete: Contém exemplos de comandos de manipulação de dados (UPDATE e DELETE) com condições.

3. Instruções de Execução

Para executar os scripts, siga os passos abaixo em um ambiente de banco de dados compatível com SQL padrão (preferencialmente PostgreSQL, MySQL ou SQL Server, com pequenas adaptações se necessário).

1. Crie o Banco de Dados: Crie um novo banco de dados vazio no seu SGBD (Sistema Gerenciador de Banco de Dados).

2. Crie o Esquema: Execute o script schemas para criar todas as tabelas.

3. Popule os Dados: Execute o script de inserts para inserir os dados de exemplo nas tabelas.

4. Execute as Consultas: Execute o script de selects para testar as consultas e visualizar os resultados.

5. Manipule os Dados: Execute o script de update/delete para aplicar as atualizações e exclusões de dados.


4. Scripts SQL Solicitados

Script SQL com comandos de INSERT para povoar as tabelas principais:

-- Inserção de Clientes
INSERT INTO Cliente (nome, telefone, data_nascimento) VALUES
('Ana Silva', '11987654321', '1990-05-15'),
('Bruno Costa', '21998765432', '1985-11-20'),
('Carla Souza', '31976543210', '2000-01-01'),
('Daniel Pereira', '41965432109', '1978-03-25');

-- Inserção de Categorias
INSERT INTO Categoria (nome_categoria) VALUES
('Eletrônicos'), -- id_categoria = 1
('Vestuário'),   -- id_categoria = 2
('Calçados'),    -- id_categoria = 3
('Livros');      -- id_categoria = 4

-- Inserção de Produtos (agora com id_categoria)
INSERT INTO Produto (nome, preco, quantidade_minima, id_categoria) VALUES
('Smartphone X', 1500.00, 5, 1), -- Eletrônicos
('Notebook Pro', 4500.00, 2, 1), -- Eletrônicos
('Camiseta Algodão', 50.00, 20, 2), -- Vestuário
('Tênis Esportivo', 250.00, 10, 3), -- Calçados
('Livro SQL Avançado', 80.00, 15, 4); -- Livros

-- Inserção de Estoque
INSERT INTO Estoque (id_produto, quantidade_atual) VALUES
(1, 50),
(2, 15),
(3, 100),
(4, 40),
(5, 75);

-- Inserção de Vendas
INSERT INTO Venda (data_venda, valor_total, id_cliente) VALUES
('2025-11-28', 1500.00, 1),
('2025-11-29', 4550.00, 2),
('2025-11-30', 100.00, 3);

-- Inserção de Itens de Venda
INSERT INTO Item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1500.00),
(2, 2, 1, 4500.00),
(2, 3, 1, 50.00),
(3, 3, 2, 50.00);

-- Inserção de Feedback
INSERT INTO Feedback (id_cliente, id_produto, nota, comentario, data_feedback) VALUES
(1, 1, 4.5, 'Ótimo celular, muito rápido!', '2025-11-29'),
(2, 2, 5.0, 'Melhor notebook que já tive. Recomendo!', '2025-11-30'),
(3, 3, 3.0, 'A camiseta é boa, mas a cor não é exatamente como na foto.', '2025-12-01'),
(1, 3, 4.0, 'Confortável e bom preço.', '2025-12-01');


Script SQL com duas a cinco consultas usando SELECT (com WHERE, ORDER BY, LIMIT, JOIN etc.):

-- 1. Listar o nome do cliente, a data da venda e o valor total das vendas realizadas no último mês,
-- ordenadas do maior para o menor valor.
SELECT
    C.nome AS nome_cliente,
    V.data_venda,
    V.valor_total
FROM
    Venda V
JOIN
    Cliente C ON V.id_cliente = C.id_cliente
WHERE
    V.data_venda >= '2025-11-01'
ORDER BY
    V.valor_total DESC;

-- 2. Listar o nome da categoria e a quantidade total vendida para cada categoria,
-- mostrando apenas as categorias que venderam mais de 1 unidade.
SELECT
    CAT.nome_categoria,
    SUM(IV.quantidade) AS quantidade_total_vendida
FROM
    Item_venda IV
JOIN
    Produto P ON IV.id_produto = P.id_produto
JOIN
    Categoria CAT ON P.id_categoria = CAT.id_categoria
GROUP BY
    CAT.nome_categoria
HAVING
    SUM(IV.quantidade) > 1
ORDER BY
    quantidade_total_vendida DESC;

-- 3. Encontrar os 2 produtos com a pior avaliação média (nota) e listar seus nomes e a nota média.
SELECT
    P.nome AS nome_produto,
    AVG(F.nota) AS nota_media
FROM
    Feedback F
JOIN
    Produto P ON F.id_produto = P.id_produto
GROUP BY
    P.nome
ORDER BY
    nota_media ASC
LIMIT 2;

-- 4. Listar o nome do cliente e o total de itens que ele comprou.
SELECT
    C.nome AS nome_cliente,
    SUM(IV.quantidade) AS total_itens_comprados
FROM
    Cliente C
JOIN
    Venda V ON C.id_cliente = V.id_cliente
JOIN
    Item_venda IV ON V.id_venda = IV.id_venda
GROUP BY
    C.nome
ORDER BY
    total_itens_comprados DESC;


Script com ao menos três comandos de UPDATE e três de DELETE com condições:

-- Comandos update (3 exemplos)

-- 1. Atualizar o telefone de um cliente específico (id_cliente = 4)
UPDATE Cliente
SET telefone = '999998888'
WHERE id_cliente = 4;

-- 2. Aumentar o preço de todos os produtos da categoria 'Eletrônicos' em 10%
UPDATE Produto
SET preco = preco * 1.10
WHERE id_categoria = (SELECT id_categoria FROM Categoria WHERE nome_categoria = 'Eletrônicos');

-- 3. Atualizar o comentário de um feedback específico (id_feedback = 3)
UPDATE Feedback
SET comentario = 'A camiseta é boa, mas a cor não é exatamente como na foto. A qualidade é excelente, no entanto.'
WHERE id_feedback = 3;

-- Comandos delete (3 exemplos)

-- 1. Excluir um cliente que nunca fez uma compra (id_cliente = 4 - Daniel Pereira)
DELETE FROM Cliente
WHERE id_cliente = 4;

-- 2. Excluir todos os feedbacks com nota abaixo de 3.5
DELETE FROM Feedback
WHERE nota < 3.5;

-- 3. Excluir um produto específico (id_produto = 5 - Livro SQL Avançado) e seu respectivo estoque.
-- Primeiro, remove o registro de Estoque (devido à FK)
DELETE FROM Estoque
WHERE id_produto = 5;

-- Segundo, remove o registro de Produto
DELETE FROM Produto
WHERE id_produto = 5;




