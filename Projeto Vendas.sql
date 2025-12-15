-- ==========================================================
-- PROJETO: Sistema de Análise de Vendas
-- AUTOR: Jonathan Kauã (Seu Nome)
-- DESCRIÇÃO: Script para criação de banco de dados, inserção
-- de dados fictícios e queries analíticas para relatórios.
-- ==========================================================

-- 1. CRIAÇÃO DO BANCO E TABELAS
CREATE DATABASE IF NOT EXISTS loja_informatica;
USE loja_informatica;

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    cidade VARCHAR(50),
    estado CHAR(2)
);

CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(100),
    categoria VARCHAR(50),
    preco DECIMAL(10, 2)
);

CREATE TABLE Vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_venda DATE,
    total_venda DECIMAL(10, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Itens_Venda (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_venda INT,
    id_produto INT,
    quantidade INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (id_venda) REFERENCES Vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);

-- 2. POPULANDO DADOS (ETL SIMULADO)
INSERT INTO Clientes (nome, email, cidade, estado) VALUES
('Ana Silva', 'ana@email.com', 'São Paulo', 'SP'),
('Carlos Souza', 'carlos@email.com', 'Rio de Janeiro', 'RJ'),
('Maria Oliveira', 'maria@email.com', 'Belo Horizonte', 'MG'),
('João Pedro', 'joao@email.com', 'São Paulo', 'SP');

INSERT INTO Produtos (nome_produto, categoria, preco) VALUES
('Notebook Dell', 'Eletrônicos', 3500.00),
('Mouse Logitech', 'Periféricos', 150.00),
('Teclado Mecânico', 'Periféricos', 300.00),
('Monitor LG 24', 'Eletrônicos', 900.00),
('Headset Gamer', 'Periféricos', 250.00);

-- Criando Vendas
INSERT INTO Vendas (id_cliente, data_venda, total_venda) VALUES
(1, '2024-01-10', 3650.00), -- Ana comprou Notebook + Mouse
(2, '2024-01-12', 900.00),  -- Carlos comprou Monitor
(1, '2024-01-15', 300.00),  -- Ana voltou e comprou Teclado
(3, '2024-01-20', 1150.00), -- Maria comprou Monitor + Headset
(4, '2024-02-01', 3500.00); -- João comprou Notebook

-- Detalhando os itens das vendas
INSERT INTO Itens_Venda (id_venda, id_produto, quantidade, subtotal) VALUES
(1, 1, 1, 3500.00),
(1, 2, 1, 150.00),
(2, 4, 1, 900.00),
(3, 3, 1, 300.00),
(4, 4, 1, 900.00),
(4, 5, 1, 250.00),
(5, 1, 1, 3500.00);

-- ==========================================================
-- 3. QUERIES ANALÍTICAS (O QUE AS EMPRESAS PEDEM)
-- ==========================================================

-- A) Relatório de Faturamento Total por Cliente
-- Pergunta de Negócio: Quem são nossos melhores clientes?
SELECT 
    c.nome, 
    COUNT(v.id_venda) as total_compras, 
    SUM(v.total_venda) as valor_gasto_total
FROM Clientes c
JOIN Vendas v ON c.id_cliente = v.id_cliente
GROUP BY c.nome
ORDER BY valor_gasto_total DESC;

-- B) Ranking de Produtos Mais Vendidos
-- Pergunta de Negócio: Qual produto tem mais saída?
SELECT 
    p.nome_produto, 
    SUM(i.quantidade) as total_vendido,
    SUM(i.subtotal) as receita_gerada
FROM Produtos p
JOIN Itens_Venda i ON p.id_produto = i.id_produto
GROUP BY p.nome_produto
ORDER BY total_vendido DESC;

-- C) Ticket Médio por Mês (Análise Temporal)
-- Pergunta de Negócio: Estamos vendendo melhor em Janeiro ou Fevereiro?
SELECT 
    DATE_FORMAT(data_venda, '%Y-%m') as mes,
    COUNT(id_venda) as qtd_vendas,
    SUM(total_venda) as faturamento_mensal,
    AVG(total_venda) as ticket_medio
FROM Vendas
GROUP BY mes;