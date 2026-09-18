# 🎬 Blockbuster Video BI — Relatório Executivo de Performance

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=sql&logoColor=white)
![UI/UX](https://img.shields.io/badge/UI%2FUX-Corporate_Theme-0B2265?style=for-the-badge)

Dashboard executivo desenvolvido para monitoramento analítico de faturamento, volume de locações, giro de catálogo e eficiência operacional de devolução (SLA), contextualizado na operação histórica da rede **Blockbuster**.

---

## 📌 Visão Geral do Painel

<!-- Adicione o print oficial do dashboard nesta pasta e aponte o caminho abaixo -->
![Dashboard Preview]([docs/dashboard_overview.png](https://github.com/luancarlosdata/blockbuster-bi-analytics/blob/main/docs/dashboard_overviews.png))

### 🎯 Principais Perguntas de Negócio Respondidas:
1. Qual é o faturamento total acumulado e o comportamento da receita ao longo dos ciclos de locação?
2. Qual o ticket médio por filme e como ele varia entre os diferentes mercados?
3. Quais são os 10 títulos com maior tração e giro de inventário?
4. Qual a taxa de devolução dentro do prazo vs. devoluções com atraso (impacto direto na disponibilidade de estoque)?
5. Quais gêneros cinematográficos concentram a maior fatia da receita bruta?

---

## 🏗️ Arquitetura e Engenharia de Dados

O projeto foi construído a partir do banco de dados relacional transacional `dvdrental` (PostgreSQL em 3NF). Para otimizar a performance analítica e o consumo no Power BI, os dados foram transformados em um modelo dimensional **Star Schema** por meio de SQL Views.

### 📐 Modelo Dimensional (Star Schema)

```text
       [v_dim_cliente] ──┐
                         │ (1:N)
                         ├──► [v_fato_locacao] ◄── [v_dim_filme]
                         │                         (1:N)
     [Calendario (DAX)] ──┘
