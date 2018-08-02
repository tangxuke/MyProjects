declare @校区名称 varchar(50),@年份 int,@月份 int
set @校区名称='光明校区'
set @年份=2018
set @月份=6

if object_id('tempdb..#tb')>0
	drop table #tb

create table #tb(日期 datetime,金额 numeric(11,2))
insert into #tb(日期,金额) values ('2018-06-03',17604)
insert into #tb(日期,金额) values ('2018-06-07',4400)
insert into #tb(日期,金额) values ('2018-06-10',1040)
insert into #tb(日期,金额) values ('2018-06-11',3120)
insert into #tb(日期,金额) values ('2018-06-17',5790)
insert into #tb(日期,金额) values ('2018-06-21',5120)
insert into #tb(日期,金额) values ('2018-06-24',8367.5)
insert into #tb(日期,金额) values ('2018-06-30',31126.5)

update 税务_收据 set 交费日期2=null where 校区名称=@校区名称 and year(交费日期)=@年份 and month(交费日期)=@月份


declare @交费日期 datetime,@金额 numeric(11,2),@交费金额 numeric(11,2),@收据号 varchar(50)

while exists(select * from #tb where 金额>0)
begin
	select top 1 @交费日期=日期,@金额=金额 from #tb where 金额>0 order by 金额 desc

	select top 1 @收据号=收据号,@交费金额=交费金额
	from 税务_收据
	where 校区名称=@校区名称 and year(交费日期)=@年份 and month(交费日期)=@月份 and 交费日期2 is null
	order by abs(@金额-交费金额)

	if @金额>=@交费金额
	begin
		update 税务_收据 set 交费日期2=@交费日期 where 收据号=@收据号
		update #tb set 金额=金额-@交费金额 where convert(varchar,日期,112)=convert(varchar,@交费日期,112)
	end
	else
	begin
		update 税务_收据 set 交费日期2=@交费日期,交费金额=@金额,现金=@金额 where 收据号=@收据号
		update #tb set 金额=0 where convert(varchar,日期,112)=convert(varchar,@交费日期,112)
	end
	
end


