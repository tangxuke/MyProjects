select convert(varchar,交费日期,112) as 交费日期,sum(交费金额) from 税务_收据 
where 校区名称='光明校区' and year(交费日期)=2018 and month(交费日期)=6
group by convert(varchar,交费日期,112)

select convert(varchar,交费日期2,112) as 交费日期,sum(交费金额) from 税务_收据 
where 校区名称='光明校区' and year(交费日期)=2018 and month(交费日期)=6
group by convert(varchar,交费日期2,112)