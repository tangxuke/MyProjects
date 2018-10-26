
alter function dbo.人员状态(@年份 int,@月份 int,@校区 varchar(50),@职员代码 varchar(50),@查询码 int)
returns bit
as
begin
	/**
	* 根据查询码，查询人员状态
	* 查询码=1，返回是否月初在职人员
	* 查询码=2，返回是否新招人员
	* 查询码=3，返回是否离职人员
	* 查询码=4，返回是否调出人员
	* 查询码=5，返回是否调入人员
	* 查询码=6，返回是否月底在职人员
	* 查询码=7，返回是否试用期离职人员
	*/
	declare @状态码 bit,@上月年份 int,@上月月份 int
	select top 1 @上月年份=年份,@上月月份=月份 from 工资表 where 年份*12+月份<@年份*12+@月份 order by 年份*12+月份 desc
	
	
	set @状态码=(case
				--查询码=1，返回是否月初在职人员
				when @查询码=1 then (case when exists(select * from 工资表 where 校区=@校区 and 年份=@上月年份 and 月份=@上月月份 and 职员代码=@职员代码 and isnull(离职否,0)=0) then 1 else 0 end)
				--查询码=2，返回是否新招人员
				when @查询码=2 then (case when exists(select * from 工资表 where 校区=@校区 and 年份=@年份 and 月份=@月份 and 职员代码=@职员代码 and year(入职时间)=@年份 and MONTH(入职时间)=@月份) then 1 else 0 end)
				--查询码=3，返回是否离职人员
				when @查询码=3 then (case when exists(select * from 工资表 where 校区=@校区 and 年份=@年份 and 月份=@月份 and 职员代码=@职员代码 and isnull(离职否,0)=1 and year(离职日期)=@年份 and MONTH(离职日期)=@月份) then 1 else 0 end)
				--查询码=4，返回是否调出人员
				when @查询码=4 then (case when exists(select * from 工资表 where 校区<>@校区 and 年份=@年份 and 月份=@月份 and 职员代码=@职员代码) 
											and exists(select * from 工资表 where 校区=@校区 and 年份=@上月年份 and 月份=@上月月份 and 职员代码=@职员代码)
									then 1 else 0 end)
				--查询码=5，返回是否调入人员
				when @查询码=5 then (case when exists(select * from 工资表 where 校区=@校区 and 年份=@年份 and 月份=@月份 and 职员代码=@职员代码) 
											and exists(select * from 工资表 where 校区<>@校区 and 年份=@上月年份 and 月份=@上月月份 and 职员代码=@职员代码)
									then 1 else 0 end)
				--查询码=6，返回是否月底在职人员
				when @查询码=6 then (case when exists(select * from 工资表 where 校区=@校区 and 年份=@年份 and 月份=@月份 and 职员代码=@职员代码 and isnull(离职否,0)=0) then 1 else 0 end)
				--查询码=7，返回是否试用期离职人员，试用期为2个月
				when @查询码=7 then 
							(case when exists(
														select * 
														from 工资表 
														where 校区=@校区 
														and 年份=@年份 
														and 月份=@月份 
														and 职员代码=@职员代码 
														and isnull(离职否,0)=1 
														and year(离职日期)=@年份 
														and MONTH(离职日期)=@月份
														and datediff(dd,入职时间,离职日期)<=60
														) 
														then 1 else 0 end)
				else 0
				end)
	
	
	return @状态码
end

GO

alter function dbo.上个年月(@年月 varchar(6))
returns varchar(6)
as
begin
	declare @上个年月 varchar(6)
	select top 1 @上个年月=年月
	from 工资表
	where 年月<@年月
	order by 年月 desc
	
	return @上个年月
end
GO