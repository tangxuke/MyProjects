--select * from 人事字典
GO
create function dbo.季度离职人数(@起始日期 datetime,@结束日期 datetime)
returns int
as
begin
	declare @人数 int
	select @人数=COUNT(*)
	from 人事字典
	where 离职否=1 
	and CONVERT(varchar,离职日期,112)>=CONVERT(varchar,@起始日期,112)
	and CONVERT(varchar,离职日期,112)<=CONVERT(varchar,@结束日期,112)
	
	return @人数
end
GO

USE [DuoweiEdu_Salary_New]
GO

/****** Object:  UserDefinedFunction [dbo].[季度总收入]    Script Date: 09/24/2018 12:13:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter function [dbo].[季度总收入](@季度 varchar(50))
returns int
as
begin
	declare @收入 int
	select @收入=SUM(isnull(实际收入,收入))
	from 月份课时人次收入表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	
	return @收入
end

GO



alter function dbo.季度总人次(@季度 varchar(50))
returns int
as
begin
	declare @人次 int
	select @人次=SUM(人次)
	from 月份课时人次收入表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	
	return @人次
end
GO

alter function dbo.季度续读人次(@季度 varchar(50))
returns int
as
begin
	declare @人次 int,@上个季度 varchar(50)
	set @上个季度=dbo.上个季度(@季度)
	
	select @人次=SUM(考勤状态)
	from 月份考勤表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	and 学生编号 in (select 学生编号 from 月份考勤表 where (LTRIM(rtrim(str(年份)))+'年'+季度=@上个季度 or 季度=@上个季度))
						
	return @人次
end
GO

alter function dbo.季度学生数(@季度 varchar(50))
returns int
as
begin
	declare @人数 int
	select @人数=COUNT(*)
	from 
	(select 学生编号 
	from 月份考勤表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	group by 学生编号
	) a
	
	return @人数
end
GO

alter function dbo.季度续读学生数(@季度 varchar(50))
returns int
as
begin
	declare @人数 int,@上个季度 varchar(50)
	set @上个季度=dbo.上个季度(@季度)
	
	select @人数=COUNT(*)
	from 
	(select 学生编号
	from 月份考勤表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	and 学生编号 in (select 学生编号 from 月份考勤表 where (LTRIM(rtrim(str(年份)))+'年'+季度=@上个季度 or 季度=@上个季度))
	group by 学生编号
	) a
						
	return @人数
end
GO


alter function dbo.季度新生人次(@季度 varchar(50))
returns int
as
begin
	declare @人次 int,@上个季度 varchar(50)
	set @上个季度=dbo.上个季度(@季度)
	
	select @人次=SUM(考勤状态)
	from 月份考勤表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	and 学生编号 not in (select 学生编号 from 月份考勤表 where (LTRIM(rtrim(str(年份)))+'年'+季度=@上个季度 or 季度=@上个季度))
						
	return @人次
end
GO

create function dbo.上个季度(@季度 varchar(50))
returns varchar(50)
as
begin
	declare @上个季度 varchar(50)
	set @上个季度=(case when @季度='2017年秋季班' then '2017年暑假班'
						when @季度='2018年寒假班' then '2017年秋季班'
						when @季度='2018年春季班' then '2018年寒假班'
						when @季度='2018年暑假班' then '2018年春季班'
						when @季度='2018年秋季班' then '2018年暑假班'
						else '' end)
	return @上个季度
end
GO

alter function dbo.季度新生人数(@季度 varchar(50))
returns int
as
begin
	declare @人数 int,@上个季度 varchar(50)
	set @上个季度=dbo.上个季度(@季度)
	
	select @人数=COUNT(*)
	from
	(select 学生编号
	from 月份考勤表
	where (LTRIM(rtrim(str(年份)))+'年'+季度=@季度 or 季度=@季度)
	and 学生编号 not in (select 学生编号 from 月份考勤表 where (LTRIM(rtrim(str(年份)))+'年'+季度=@上个季度 or 季度=@上个季度))
	group by 学生编号
	) a
						
	return @人数
end
GO

create function dbo.上个同比季度(@季度 varchar(50))
returns varchar(50)
as
begin
	declare @上个季度 varchar(50)
	set @上个季度=(case when @季度='2017年秋季班' then '2016年秋季班'
						when @季度='2018年寒假班' then '2017年寒假班'
						when @季度='2018年春季班' then '2017年春季班'
						when @季度='2018年暑假班' then '2017年暑假班'
						when @季度='2018年秋季班' then '2017年秋季班'
						else '' end)
	return @上个季度
end
GO

GO
select *
,dbo.季度在职人数(起始日期,结束日期) as 在职人数
,dbo.季度离职人数(起始日期,结束日期) as 离职人数
,1.000*dbo.季度离职人数(起始日期,结束日期)/dbo.季度在职人数(起始日期,结束日期) as 员工流失率
,dbo.季度总收入(季度) as 总收入
,dbo.季度总收入(季度)/dbo.季度在职人数(起始日期,结束日期) as 人均创收
,dbo.季度总人次(季度) as 总人次
,dbo.季度学生数(季度) as 学生数
,dbo.季度续读人次(季度) as 续读人次
,dbo.季度续读学生数(季度) as 续读学生数
,1.000*dbo.季度续读人次(季度)/dbo.季度总人次(季度) as 人次续读率
,1.000*dbo.季度续读学生数(季度)/dbo.季度学生数(季度) as 人头续读率
,dbo.季度新生人次(季度) as 新生人次
,dbo.季度新生人数(季度) as 新生人数
,dbo.季度新生人次(dbo.上个季度(季度)) as 上季新生人次
,dbo.季度新生人数(dbo.上个季度(季度)) as 上季新生人数
,1.000*dbo.季度新生人次(季度)/dbo.季度新生人次(dbo.上个季度(季度)) as 新生人次增长率
,1.000*dbo.季度新生人数(季度)/dbo.季度新生人数(dbo.上个季度(季度)) as 新生人头增长率
,dbo.季度总收入(dbo.上个季度(季度)) as 上季收入
,1.000*dbo.季度总收入(季度)/dbo.季度总收入(dbo.上个季度(季度)) as 季度收入增长率
,dbo.季度总收入(dbo.上个同比季度(季度)) as 上季同比收入
,1.000*dbo.季度总收入(季度)/dbo.季度总收入(dbo.上个同比季度(季度)) as 季度同比收入增长率
from 季度表
order by 起始日期