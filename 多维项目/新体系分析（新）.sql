

--初始化人员名单
if OBJECT_ID('tempdb..#tb1')>0
	drop table #tb1
GO
select 年份,月份,a.校区,a.职员代码,职员姓名,入职时间,离职否,离职日期
into #tb1
from
(
select 职员代码,校区
from 工资表
group by 职员代码,校区
) a
inner join
(select 校区,年份,月份 from 工资表 group by 校区,年份,月份) b
on a.校区=b.校区
inner join 人事字典 c on a.职员代码=c.职员代码
GO

--人员情况原始数据
if OBJECT_ID('tempdb..#tb2')>0
	drop table #tb2
GO
select 年份,月份,校区,职员代码,职员姓名,入职时间,离职否,离职日期
,dbo.人员状态(年份,月份,校区,职员代码,1) as 月初在职人员
,dbo.人员状态(年份,月份,校区,职员代码,2) as 新招人员
,dbo.人员状态(年份,月份,校区,职员代码,3) as 离职人员
,dbo.人员状态(年份,月份,校区,职员代码,4) as 本集团内调动人员
,dbo.人员状态(年份,月份,校区,职员代码,5) as 本集团内调入人员
,dbo.人员状态(年份,月份,校区,职员代码,6) as 月底在职人员
,dbo.人员状态(年份,月份,校区,职员代码,7) as 试用期离职人员
into #tb2
from #tb1
order by 年份,月份,校区,职员代码

--输出结果
if OBJECT_ID('tempdb..#tb3')>0
	drop table #tb3
GO
select * 
into #tb3
from #tb2 
where not (月初在职人员=0 and 新招人员=0 and 离职人员=0 and 本集团内调动人员=0 and 本集团内调入人员=0 and 月底在职人员=0)

select * from #tb3
GO


--统计离职率（按月）
if OBJECT_ID('tempdb..#tb4')>0
	drop table #tb4
GO
if OBJECT_ID('tempdb..#tb4_1')>0
	drop table #tb4_1
GO
select 年份,月份,校区
,SUM(cast(月初在职人员 as tinyint)) as 月初在职人员
,SUM(cast(新招人员 as tinyint)) as 新招人员
,SUM(cast(离职人员 as tinyint)) as 离职人员
,SUM(cast(试用期离职人员 as tinyint)) as 试用期离职人员
,SUM(cast(本集团内调动人员 as tinyint)) as 本集团内调动人员
,SUM(cast(本集团内调入人员 as tinyint)) as 本集团内调入人员
,SUM(cast(月底在职人员 as tinyint)) as 月底在职人员
into #tb4
from #tb3
group by 年份,月份,校区
order by 年份,月份,校区

--按照季度新定义：1-3月=寒假班，4-6月=春季班，7-9月=暑假班，10-12月=秋季班
select *
,ltrim(rtrim(str(年份)))+'年'+(case	when 月份 between 1 and 3 then '寒假班'
			when 月份 between 4 and 6 then '春季班'
			when 月份 between 7 and 9 then '暑假班'
			else '秋季班' end) as 季度
,ltrim(rtrim(str(年份)))+(case when 月份<10 then '0' else '' end)+ltrim(rtrim(str(月份))) as 年月
into #tb4_1
from #tb4

/*
-------------------------------------------------------------------------------------------------------
if OBJECT_ID('tempdb..#t1')>0
	drop table #t1
GO
if OBJECT_ID('tempdb..#t2')>0
	drop table #t2
GO

select 年份,月份,校区,季度,课程名称 into #t1 from 月份考勤表 group by 年份,月份,校区,季度,课程名称
update #t1 set 课程名称=LEFT(课程名称,4)+'年'+SUBSTRING(课程名称,5,len(课程名称)-4) where 课程名称 like '201%' and SUBSTRING(课程名称,5,1)<>'年'

select 年份,月份,校区,季度1 as 季度
into #t2
from 
(
select  *,
(case when 课程名称 like '201_年%' then LEFT(课程名称,7)+'班' else 季度 end) as 季度1 
from #t1
where (case when 课程名称 like '201_年%' then LEFT(课程名称,7)+'班' else 季度 end) like '201_年__班'
) a
group by 年份,月份,校区,季度1
order by 校区,季度
--校区、季度、月份对应表
select * from #t2
*/
select * from #tb4_1
--校区、季度人员变动表
if OBJECT_ID('tempdb..#tb5')>0
	drop table #tb5
GO
select 校区,季度
,SUM(新招人员) as 新招人员
,SUM(离职人员) as 离职人员
,SUM(试用期离职人员) as 试用期离职人员
,SUM(本集团内调动人员) as 本集团内调动人员
,SUM(本集团内调入人员) as 本集团内调入人员
,COUNT(*) as 月份数
,MAX(ltrim(rtrim(str(年份)))+(case when 月份<10 then '0' else '' end)+ltrim(rtrim(str(月份)))) as 季末月份
into #tb5
from #tb4_1
group by 校区,季度

/*
select 校区,季度
,SUM(新招人员) as 新招人员
,SUM(离职人员) as 离职人员
,SUM(本集团内调动人员) as 本集团内调动人员
,SUM(本集团内调入人员) as 本集团内调入人员
,MIN(年月) as 起始年月
,MAX(年月) as 截止年月
,COUNT(*) as 月份数
into #tb5
from
(
select a.*,b.季度,LTRIM(rtrim(str(a.年份)))+(case when a.月份<10 then '0' else '' end)+LTRIM(rtrim(str(a.月份))) as 年月
from #tb4 a
	inner join #t2 b on a.校区=b.校区 and a.年份=b.年份 and a.月份=b.月份
) a
group by 校区,季度
*/

if OBJECT_ID('tempdb..#tb6')>0
	drop table #tb6
GO
/*
select *,
(select COUNT(*) 
	from 人事字典 
	where exists(select * 
				from 工资表 
				where 职员代码=人事字典.职员代码 and 校区=a.校区
				and (年月 between a.起始年月 and a.截止年月) 
				and isnull(离职否,0)=0
				)
		and not exists(select * 
				from 工资表 
				where 职员代码=人事字典.职员代码  and 校区=a.校区
				and (年月 between a.起始年月 and a.截止年月) 
				and isnull(离职否,0)=1
				)
) as 季度末在职人数
into #tb6
from #tb5 a
order by 校区,季度
*/

select *
,(select 月底在职人员 from #tb4_1 where 校区=a.校区 and 季度=a.季度 and 年月=a.季末月份) as 季度末在职人员
into #tb6
from #tb5 a

--#tb6的一个备份，用于查询季初在职人员
if OBJECT_ID('tempdb..#tb6_1')>0
	drop table #tb6_1
GO
select * into #tb6_1
from #tb6

select *
,(select 季度末在职人员 from #tb6_1 where 校区=a.校区 and 季度=dbo.上个季度(a.季度)) as 季初在职人员
from #tb6 a 
order by 校区,季末月份

--按季度总收入
if OBJECT_ID('tempdb..#t3')>0
	drop table #t3
GO
select 年份,月份,校区,季度,课程名称,SUM(isnull(isnull(实际收入,收入),0)) as 收入,SUM(考勤状态) as 人次
into #t3
from 月份考勤表
group by 年份,月份,校区,季度,课程名称

select * from #t3
update #t1 set 课程名称=LEFT(课程名称,4)+'年'+SUBSTRING(课程名称,5,len(课程名称)-4) where 课程名称 like '201%' and SUBSTRING(课程名称,5,1)<>'年'

--校区季度课程收入统计原始数据
if OBJECT_ID('tempdb..#tb7')>0
	drop table #tb7
GO
select *
,(case when 课程名称 like '201_年%' then LEFT(课程名称,7)+'班' else (case when 季度 not like '201_年__班' then '其他' else 季度 end) end) as 季度1 
into #tb7
from #t3

select * from #tb7

if OBJECT_ID('tempdb..#tb8')>0
	drop table #tb8
GO
select 校区,季度1 as 季度,SUM(收入) as 收入,SUM(人次) as 人次
into #tb8
from #tb7
group by 校区,季度1
order by 校区,季度

--校区季度人均创收
select a.校区,a.季度,a.收入 as 总收入,b.季度末在职人数 as 季度末人数,a.收入/b.季度末在职人数 as 人均创值
from #tb8 a
	inner join #tb6 b on a.校区=b.校区 and a.季度=b.季度
	
--季度学生数
if OBJECT_ID('tempdb..#t4')>0
	drop table #t4
GO
--按照季度新定义：1-3月=寒假班，4-6月=春季班，7-9月=暑假班，10-12月=秋季班			
select 年份,月份,校区,季度,课程名称,学生编号,学生姓名,SUM(isnull(isnull(实际收入,收入),0)) as 收入,SUM(考勤状态) as 人次
/*,ltrim(rtrim(str(年份)))+'年'+(case	when 月份 between 1 and 3 then '寒假班'
			when 月份 between 4 and 6 then '春季班'
			when 月份 between 7 and 9 then '暑假班'
			else '秋季班' end) as 季度*/
,(case when 课程名称 like '201_年%' then LEFT(课程名称,7)+'班' else 季度 end) as 季度1 
into #t4
from 月份考勤表
where ISNULL(补课,0)=0
group by 年份,月份,校区,季度,课程名称,学生编号,学生姓名

update #t4 set 课程名称=LEFT(课程名称,4)+'年'+SUBSTRING(课程名称,5,len(课程名称)-4) where 课程名称 like '201%' and SUBSTRING(课程名称,5,1)<>'年'




select * from #t4

if OBJECT_ID('tempdb..#t5')>0
	drop table #t5
GO
if OBJECT_ID('tempdb..#t5_1')>0
	drop table #t5_1
GO
if OBJECT_ID('tempdb..#t5_2')>0
	drop table #t5_2
GO
if OBJECT_ID('tempdb..#t5_3')>0
	drop table #t5_3
GO
select 校区,季度1 as 季度,学生编号,学生姓名,课程名称,SUM(收入) as 收入,SUM(人次) as 人次
into #t5
from #t4
group by 校区,季度1,学生编号,学生姓名,课程名称

select * from #t5

select 校区,季度,课程名称,MAX(人次) as 标准人次,MIN(人次) as 最低人次,COUNT(*) as 学生数
into #t5_1
from #t5
group by 校区,季度,课程名称

select * from #t5_1

select a.*
,b.标准人次
,(case when b.标准人次-a.人次>=3 then 1 else 0 end) as 流失学生
,(case when b.标准人次-a.人次>=3 and a.人次<=2 then 1 else 0 end) as 流失试听学生
into #t5_2
from #t5 a
	inner join #t5_1 b on a.校区=b.校区 and a.季度=b.季度 and a.课程名称=b.课程名称
order by b.标准人次-a.人次

select * from 月份考勤表 where 学生编号='S18861' and 课程名称='2018年春季幼升小数学思维中班'  and 季度='2018年春季班' and 课程名称='2018年春季幼升小数学思维中班' and 校区='茶山贝米'

select 校区,季度,学生编号,学生姓名,SUM(收入) as 收入,SUM(人次) as 人次,SUM(标准人次) as 标准人次
,MIN(流失学生) as 流失学生
,MIN(流失试听学生) as 流失试听学生
into #t5_3
from #t5_2
group by 校区,季度,学生编号,学生姓名


select * from #t5_2 where 校区='东城校区' and 季度='2016年秋季班' and 课程名称='物理' and 学生编号='DC00920'
select * from 月份考勤表 where 校区='东城校区' and 季度='2016年秋季班' and 学生编号='DC00920' order by 考勤日期

if OBJECT_ID('tempdb..#t6')>0
	drop table #t6
GO
select 校区,季度,COUNT(*) as 学生数,SUM(收入) as 收入,SUM(人次) as 人次,SUM(流失学生) as 流失学生数,SUM(流失试听学生) as 流失试听学生数
into #t6
from #t5_3
group by 校区,季度

--t6和t7是同一份数据，用于取上季数据
if OBJECT_ID('tempdb..#t7')>0
	drop table #t7
GO
select * into #t7 from #t6


select * from #t6 order by 校区,季度

select a.*,b.学生数 as 上季学生数
from #t6 a
	left join #t7 b on a.校区=b.校区 and dbo.上个季度(a.季度)=b.季度
order by a.校区,a.季度
	
--t5和t8是同一份数据，用于判断续读和新生
if OBJECT_ID('tempdb..#t8')>0
	drop table #t8
GO
select * from #t5_3
select * into #t8 from #t5_3
select * into #t9 from #t5_3

select * from #t5_3

if OBJECT_ID('tempdb..#t9')>0
	drop table #t9
GO
if OBJECT_ID('tempdb..#t10')>0
	drop table #t10
GO

--上季及下季校区
select a.校区,a.季度,a.学生编号,a.学生姓名,a.人次,a.收入,a.流失学生,a.流失试听学生,a.标准人次
,b.校区 as 下季就读校区 
,c.校区 as 上季就读校区
,c.流失学生 as 上季流失学生
--into #t10
from #t5_3 a
	left join #t8 b on a.学生编号=b.学生编号 and dbo.上个季度(b.季度)=a.季度
	left join #t9 c on a.学生编号=c.学生编号 and dbo.上个季度(a.季度)=c.季度

GO

select* from #t5_3
	
--全息学生明细
if OBJECT_ID('tempdb..#t11')>0
	drop table #t11
GO
select *
--续读信息
,(case when ISNULL(上季就读校区,'')<>'' then 1 else 0 end) as 本季续读
,(case when ISNULL(上季就读校区,'')<>'' and ISNULL(上季就读校区,'')<>校区 then 1 else 0 end) as 本季他校转入续读
,(case when ISNULL(上季就读校区,'')<>'' and ISNULL(上季就读校区,'')=校区 then 1 else 0 end) as 本季本校续读
--新生信息
,(case when ISNULL(上季就读校区,'')<>校区 then 1 else 0 end) as 本季新生
,(case when ISNULL(上季就读校区,'')='' then 1 else 0 end) as 本季全新学员
,(case when ISNULL(上季就读校区,'')<>'' and ISNULL(上季就读校区,'')<>校区 then 1 else 0 end) as 本季他校转入新学员
into #t11
from #t10 a

--季初在职学生人数	本季新招学生人数	本季学生流失人数	本季流失学生中试听学生人数	本季集团内流出学生人数	本季集团流入学生人数	本季末学生人数	流失率	流失率                              去掉试听学生人数
select * from #t11 where 校区='东城校区' and 学生编号='DC00011'

if OBJECT_ID('tempdb..#t12')>0
	drop table #t12
GO
--续读信息汇总
select 校区,季度
,SUM(人次) as 本季人次
,SUM(收入) as 本季收入
,COUNT(*) as 本季学生人数
,SUM(流失学生) as 流失学生人数
,SUM(人次*流失学生) as 流失学生人次
,SUM(收入*流失学生) as 流失学生收入
,SUM(流失试听学生) as 流失试听学生人数
,SUM(人次*流失试听学生) as 流失试听学生人次
,SUM(收入*流失试听学生) as 流失试听学生收入
--续读
,SUM(本季续读) as 本季续读人数
,SUM(本季本校续读) as 本季本校续读人数
,SUM(本季他校转入续读) as 本季他校转入续读人数
,SUM((case when 本季续读=1 then 人次 else 0 end)) as 本季续读人次
,SUM((case when 本季本校续读=1 then 人次 else 0 end)) as 本季本校续读人次
,SUM((case when 本季他校转入续读=1 then 人次 else 0 end)) as 本季他校转入续读人次
--新生
,SUM(本季新生) as 本季新生人数
,SUM(本季全新学员) as 本季全新学员人数
,SUM(本季他校转入新学员) as 本季他校转入新学员人数
,SUM((case when 本季新生=1 then 人次 else 0 end)) as 本季新生人次
,SUM((case when 本季全新学员=1 then 人次 else 0 end)) as 本季全新学员人次
,SUM((case when 本季他校转入新学员=1 then 人次 else 0 end)) as 本季他校转入新学员人次
into #t12
from #t11
group by 校区,季度

select * from #t11
--加入上季新生人数和人次
if OBJECT_ID('tempdb..#t13')>0
	drop table #t13
GO
if OBJECT_ID('tempdb..#t14')>0
	drop table #t14
GO
--拷贝两个个备份
select * into #t13 from #t12
select * into #t14 from #t12

--集团内流出学生数
select isnull(上季就读校区,'') as 校区,季度,COUNT(*) as 学生数,SUM(人次) as 人次
into #t11_1
from #t11
where isnull(上季就读校区,'')<>校区 and isnull(上季就读校区,'')<>''
group by isnull(上季就读校区,''),季度

select * from #t12


select a.*
,d.学生数 as 本季集团内流出学生数
,d.人次 as 本季集团内流出人次

,b.季度 as 上季季度
,b.本季人次 as 上季人次
,b.本季收入 as 上季收入
,b.本季学生人数 as 上季学生人数

,b.流失学生人数 as 上季流失学生人数
,b.流失学生人次 as 上季流失学生人次
,b.流失学生收入 as 上季流失学生收入
,b.流失试听学生人数 as 上季流失试听学生人数
,b.流失试听学生人次 as 上季流失试听学生人次
,b.流失试听学生收入 as 上季流失试听学生收入

,b.本季续读人数 as 上季续读人数
,b.本季本校续读人数 as 上季本校续读人数
,b.本季他校转入续读人数 as 上季他校转入续读人数
,b.本季续读人次 as 上季续读人次
,b.本季本校续读人次 as 上季本校续读人次
,b.本季他校转入续读人次 as 上季他校转入续读人次

,b.本季新生人数 as 上季新生人数
,b.本季全新学员人数 as 上季新入学人数
,b.本季他校转入新学员人数 as 上季他校转入新学员人数
,b.本季新生人次 as 上季新生人次
,b.本季全新学员人次 as 上季新入学人次
,b.本季他校转入新学员人次 as 上季他校转入新学员人次

,c.季度 as 上季同比季度
,c.本季人次 as 上季同比人次
,c.本季收入 as 上季同比收入
,c.本季学生人数 as 上季同比学生人数

,c.流失学生人数 as 上季同比流失学生人数
,c.流失学生人次 as 上季同比流失学生人次
,c.流失学生收入 as 上季同比流失学生收入
,c.流失试听学生人数 as 上季同比流失试听学生人数
,c.流失试听学生人次 as 上季同比流失试听学生人次
,c.流失试听学生收入 as 上季同比流失试听学生收入

,c.本季续读人数 as 上季同比续读人数
,c.本季本校续读人数 as 上季同比本校续读人数
,c.本季他校转入续读人数 as 上季同比他校转入续读人数
,c.本季续读人次 as 上季同比续读人次
,c.本季本校续读人次 as 上季同比本校续读人次
,c.本季他校转入续读人次 as 上季同比他校转入续读人次

,c.本季新生人数 as 上季同比新生人数
,c.本季全新学员人数 as 上季同比新入学人数
,c.本季他校转入新学员人数 as 上季同比他校转入新学员人数
,c.本季新生人次 as 上季同比新生人次
,c.本季全新学员人次 as 上季同比新入学人次
,c.本季他校转入新学员人次 as 上季同比他校转入新学员人次
from #t12 a
	left join #t13 b on a.校区=b.校区 and dbo.上个季度(a.季度)=b.季度
	left join #t13 c on a.校区=c.校区 and dbo.上个同比季度(a.季度)=c.季度
	left join #t11_1 d on a.校区=d.校区 and a.季度=d.季度
order by a.校区
,LEFT(a.季度,4)
,(case when charindex('春季班',a.季度)>0 then 1
	when charindex('暑假班',a.季度)>0 then 2
	when charindex('秋季班',a.季度)>0 then 3
	when charindex('寒假班',a.季度)>0 then 0
	else 5 end)