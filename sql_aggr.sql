-- Aggregates on dividends per stock and year: 

select 
	p."stock",
	p."date",
	round(p."dividends",2) as dividends,
	extract(year from p."date") as year,
	round(sum(p."dividends") over w, 2) as div_per_year,
	count(p."dividends") over w as num_of_pay_per_year,
	round(sum(p."dividends") over(partition by p."stock"), 2) as div_all_years
	from dashboarding.stock_price_hist p
where p."dividends" <> 0
window w as (partition by p."stock", extract(year from p."date")) 
order by 1,2 

-- Financial indicators:

select
	fi."stock",
	extract(year from fi."date") as "year",
	case 
		when fi."stock" like '%.ME%' then round(sum(fi."total_rev" / 70),0) else round(sum(fi."total_rev"),0)
	end as total_revenue_usd,
	round(sum(fi."cash"),0) as cash,
	round(sum(fi."n_income"),0) as net_income,
	round(sum((fi."n_income"/fi."total_rev" * 100)),2) as net_profit_margin
from dashboarding.financial_indicators fi
group by 1,2
order by 1,2

-- Stock price hist:

select 
	 extract(year from p."date") as "year",
	 p.*
from dashboarding.stock_price_hist p