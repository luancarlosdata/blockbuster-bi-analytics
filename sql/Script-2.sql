-- ====================================================================
-- PROJETO: Blockbuster Video BI Analytics
-- BANCO DE DADOS DE ORIGEM: dvdrental (PostgreSQL - 3NF)
-- OBJETIVO: Modelagem Dimensional Star Schema para consumo no Power BI
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. Dimensão Filme (Catálogo de Títulos, Categorias e Custos)
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dim_filme AS
SELECT 
    f.film_id,
    f.title AS titulo,
    COALESCE(c.name, 'Não Informado') AS categoria,
    f.rating::text AS classificacao,
    f.rental_rate AS taxa_aluguel,
    f.replacement_cost AS custo_reposicao,
    f.rental_duration AS duracao_aluguel_dias
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category c ON fc.category_id = c.category_id;


-- --------------------------------------------------------------------
-- 2. Dimensão Cliente (Cadastro e Localização Geográfica)
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW v_dim_cliente AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS nome_cliente,
    ci.city AS cidade,
    co.country AS pais,
    c.activebool AS ativo
FROM customer c
LEFT JOIN address a ON c.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id
LEFT JOIN country co ON ci.country_id = co.country_id;


-- --------------------------------------------------------------------
-- 3. Fato Locação (Métricas de Aluguel, Receita e SLA de Devolução)
-- --------------------------------------------------------------------
CREATE OR REPLACE VIEW v_fato_locacao AS
SELECT 
    r.rental_id,
    r.customer_id,
    i.film_id,
    r.rental_date AS data_aluguel,
    r.return_date AS data_devolucao,
    COALESCE(p.amount, 0) AS valor_pago,
    CASE 
        WHEN r.return_date IS NULL THEN 'Pendente'
        WHEN (r.return_date::date - r.rental_date::date) > f.rental_duration THEN 'Com Atraso'
        ELSE 'No Prazo'
    END AS status_devolucao
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LEFT JOIN payment p ON r.rental_id = p.rental_id;