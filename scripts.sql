-- Script de Criação do Schema (DDL)
-- Tabela Cliente
CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_nascimento DATE NOT NULL
);

-- Tabela Categoria
CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome_categoria VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela Produto
CREATE TABLE Produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    quantidade_minima INT,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- Tabela Estoque
CREATE TABLE Estoque (
    id_estoque SERIAL PRIMARY KEY,
    quantidade_atual INT NOT NULL,
    id_produto INT UNIQUE NOT NULL,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Venda
CREATE TABLE Venda (
    id_venda SERIAL PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10, 2),
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Tabela Item_venda
CREATE TABLE Item_venda (
    id_item_venda SERIAL PRIMARY KEY,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES Venda(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Tabela Feedback
CREATE TABLE Feedback (
    id_feedback SERIAL PRIMARY KEY,
    nota DECIMAL(2, 1) NOT NULL,
    comentario VARCHAR(300),
    data_feedback DATE,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- Script de Inserts (DML)

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

-- Inserção de Produtos 
INSERT INTO Produto (nome, preco, quantidade_minima, id_categoria) VALUES
('Smartphone X', 1500.00, 5, 1), -- Eletrônicos
('Notebook Pro', 4500.00, 2, 1), -- Eletrônicos
('Camiseta Algodão', 50.00, 20, 2), -- Vestuário
('Tênis Esportivo', 250.00, 10, 3), -- Calçados
('Livro SQL Avançado', 80.00, 15, 4); -- Livros

-- Inserção de Estoque 
INSERT INTO Estoque (id_produto, quantidade_atual) VALUES
(1, 50), -- Smartphone X
(2, 15), -- Notebook Pro
(3, 100), -- Camiseta Algodão
(4, 40), -- Tênis Esportivo
(5, 75); -- Livro SQL Avançado

-- Inserção de Vendas 
INSERT INTO Venda (data_venda, valor_total, id_cliente) VALUES
('2025-11-28', 1500.00, 1), -- id_venda = 1 (Ana Silva)
('2025-11-29', 4550.00, 2), -- id_venda = 2 (Bruno Costa)
('2025-11-30', 100.00, 3); -- id_venda = 3 (Carla Souza)

-- Inserção de Itens de Venda
-- Venda 1: Smartphone X
INSERT INTO Item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1500.00);

-- Venda 2: Notebook Pro (1) e Camiseta Algodão (1)
INSERT INTO Item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(2, 2, 1, 4500.00),
(2, 3, 1, 50.00);

-- Venda 3: Camiseta Algodão (2)
INSERT INTO Item_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(3, 3, 2, 50.00);

-- Inserção de Feedback
INSERT INTO Feedback (id_cliente, id_produto, nota, comentario, data_feedback) VALUES
(1, 1, 4.5, 'Ótimo celular, muito rápido!', '2025-11-29'),
(2, 2, 5.0, 'Melhor notebook que já tive. Recomendo!', '2025-11-30'),
(3, 3, 3.0, 'A camiseta é boa, mas a cor não é exatamente como na foto.', '2025-12-01'),
(1, 3, 4.0, 'Confortável e bom preço.', '2025-12-01');


-- Script de Selects (DML)
-- 1. Consulta com JOIN, WHERE e ORDER BY:
-- Listar o nome do cliente, a data da venda e o valor total das vendas realizadas no último mês,
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
    V.data_venda >= '2025-11-01' -- Exemplo de filtro para o último mês
ORDER BY
    V.valor_total DESC;

-- 2. Consulta com JOIN, GROUP BY e HAVING:
-- Listar o nome da categoria e a quantidade total vendida para cada categoria,
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

-- 3. Consulta com JOIN, WHERE e LIMIT:
-- Encontrar os 2 produtos com a pior avaliação média (nota) e listar seus nomes e a nota média.
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

-- 4. Consulta com JOIN e Subconsulta:
-- Listar o nome do cliente e o total de itens que ele comprou,
-- incluindo apenas clientes que fizeram mais de uma compra (mais de um registro em Venda).
SELECT
    C.nome AS nome_cliente,
    SUM(IV.quantidade) AS total_itens_comprados
FROM
    Cliente C
JOIN
    Venda V ON C.id_cliente = V.id_cliente
JOIN
    Item_venda IV ON V.id_venda = IV.id_venda
WHERE
    C.id_cliente IN (
        SELECT id_cliente
        FROM Venda
        GROUP BY id_cliente
        HAVING COUNT(id_venda) > 0 -- No nosso caso, todos fizeram pelo menos 1, então > 0 é o suficiente.
    )
GROUP BY
    C.nome
ORDER BY
    total_itens_comprados DESC;

-- 5. Consulta com JOIN e condição de Estoque:
-- Listar o nome do produto, a quantidade atual em estoque e a quantidade mínima,
-- para todos os produtos cujo estoque atual está abaixo da quantidade mínima.
SELECT
    P.nome AS nome_produto,
    E.quantidade_atual,
    P.quantidade_minima
FROM
    Produto P
JOIN
    Estoque E ON P.id_produto = E.id_produto
WHERE
    E.quantidade_atual < P.quantidade_minima
ORDER BY
    E.quantidade_atual ASC;


-- Script de Update e Delete (DML)
-- COMANDOS UPDATE (3 exemplos)

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

-- COMANDOS DELETE (3 exemplos)
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