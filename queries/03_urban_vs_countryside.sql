SELECT
	-- changing the numerical category to categorical
	CASE 
		WHEN e.TP_LOCALIZACAO = 1 THEN 'Urban'
		WHEN e.TP_LOCALIZACAO = 2 THEN 'Country'
	END AS school_location,
	-- since 1 is positive for court and 0 negative, we can sum up to get the quantity of schools with court
	ROUND(100.0 * SUM(e.IN_QUADRA_ESPORTES)/count(*), 2) as pct_with_court,
	-- aplying the same logic for internet laboratory
	ROUND(100.0 * SUM(e.IN_LABORATORIO_CIENCIAS)/count(*), 2) as pct_with_scilab,
	-- and for IT laboratory
	ROUND(100.0 * SUM(e.IN_LABORATORIO_INFORMATICA)/count(*), 2) as pct_with_itlab,
	-- and for library
	ROUND(100.0 * SUM(e.IN_BIBLIOTECA)/count(*), 2) as pct_with_library
FROM Escolas e 
-- filtering only schools that were working actively when the census was made
WHERE e.TP_SITUACAO_FUNCIONAMENTO = 1 
-- grouping by location of the school [urban vs rural]
GROUP BY e.TP_LOCALIZACAO;
