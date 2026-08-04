select 
	-- changing type to facilitate visualization
	case e.TP_DEPENDENCIA 
		when 1 then 'Federal'
		when 2 then 'Estadual'
		when 3 then 'Municipal'
		when 4 then 'Privada'
		else 'Outro'
	end as rede_ensino,
	-- counting number of schools
	count(*) as total_escolas,
	-- generating a percentage visualization
	round((count(*) *100.0 / SUM(count(*)) OVER()), 2) as pct_rede_ensino
from Escolas e 
-- grouping by type of school
group by rede_ensino ;