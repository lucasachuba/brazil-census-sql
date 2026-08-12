-- creating cte
WITH SUB_SCORE AS (
    SELECT 
        -- separating the schools
        e.CO_ENTIDADE,
        -- getting their location
        e.NO_MUNICIPIO,
        e.TP_SITUACAO_FUNCIONAMENTO,
        e.SG_UF,
        -- summing up all the criteria that make a 'well-resourced school'
        (e.IN_AGUA_POTAVEL +
         e.IN_ENERGIA_REDE_PUBLICA +
         e.IN_ENERGIA_RENOVAVEL +
         e.IN_ESGOTO_REDE_PUBLICA +
         e.IN_ESGOTO_FOSSA_SEPTICA +
         e.IN_LIXO_SERVICO_COLETA +
         e.IN_AREA_VERDE +
         e.IN_BANHEIRO +
         e.IN_BANHEIRO_EI +
         e.IN_BANHEIRO_PNE +
         e.IN_BANHEIRO_FUNCIONARIOS +
         e.IN_PATIO_COBERTO +
         e.IN_PATIO_DESCOBERTO +
         e.IN_QUADRA_ESPORTES +
         e.IN_SALA_ATENDIMENTO_ESPECIAL +
         e.IN_ACESSIBILIDADE_CORRIMAO +
         e.IN_ACESSIBILIDADE_ELEVADOR +
         e.IN_ACESSIBILIDADE_PISOS_TATEIS +
         e.IN_ACESSIBILIDADE_VAO_LIVRE +
         e.IN_ACESSIBILIDADE_RAMPAS +
         e.IN_ACESSIBILIDADE_SINAL_SONORO +
         e.IN_ACESSIBILIDADE_SINAL_TATIL +
         e.IN_ACESSIBILIDADE_SINAL_VISUAL +
         e.IN_INTERNET +
         e.IN_ALIMENTACAO) AS SCHOOL_SCORE
    FROM Escolas e
),

-- second cte to get all the infos for school_rating
SUB_SCHOOL AS (
    SELECT
        CO_ENTIDADE,
        NO_MUNICIPIO,
        SCHOOL_SCORE,
        CASE
            -- titling the conditions of the schools
            WHEN SCHOOL_SCORE > 20 THEN 'ADEQUATE'
            WHEN SCHOOL_SCORE BETWEEN 15 AND 20 THEN 'PARTIALLY_ADEQUATE'
            WHEN SCHOOL_SCORE BETWEEN 10 AND 14 THEN 'LIMITED'
            WHEN SCHOOL_SCORE BETWEEN 5 AND 9 THEN 'PRECARIOUS'
            WHEN SCHOOL_SCORE BETWEEN 1 AND 4 THEN 'CRITICAL'
            ELSE 'NO_DATA'
        END AS SCHOOL_RATING
    FROM SUB_SCORE 
    -- selecting only schools that are in activity and are located in the state of SP, our target
    WHERE TP_SITUACAO_FUNCIONAMENTO = 1 AND SG_UF = 'SP'
)

-- using school_rating as our main base and getting pct of each category
SELECT 
    NO_MUNICIPIO, 
    ROUND(100.0 * SUM(CASE WHEN SCHOOL_RATING = 'ADEQUATE' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PCT_ADEQUATE,
    ROUND(100.0 * SUM(CASE WHEN SCHOOL_RATING = 'PARTIALLY_ADEQUATE' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PCT_PART_ADEQUATE,
    ROUND(100.0 * SUM(CASE WHEN SCHOOL_RATING = 'LIMITED' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PCT_LIMITED,
    ROUND(100.0 * SUM(CASE WHEN SCHOOL_RATING = 'PRECARIOUS' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PCT_PRECARIOUS,
	ROUND(100.0 * SUM(CASE WHEN SCHOOL_RATING = 'CRITICAL' THEN 1 ELSE 0 END) / COUNT(*), 2) AS PCT_CRITICAL
FROM SUB_SCHOOL
GROUP BY NO_MUNICIPIO
ORDER BY PCT_CRITICAL DESC;
LIMIT 15;