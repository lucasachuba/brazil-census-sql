SELECT 
	-- selecting regions
	e.NO_REGIAO  as regions,	
	-- counting each row
	count(*) AS schools_without_internet
FROM Escolas e
-- filtering only schools that were working actively when the census was made
WHERE e.TP_SITUACAO_FUNCIONAMENTO = 1 AND e.IN_INTERNET_ALUNOS  = 0
-- grouping by situation of network to count the total per case and grouping by region
GROUP BY e.IN_INTERNET_ALUNOS,
		e.NO_REGIAO 
-- ordering by highest numbers in descending order
ORDER BY count(*) DESC;