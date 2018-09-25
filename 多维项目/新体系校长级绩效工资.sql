select 任课老师
,MAX(新绩效工资) as 新体系每节课最高绩效
,MAX(旧绩效工资) as 旧体系每节课最高绩效
from
(
select 任课老师,课程名称,班别,CONVERT(varchar,考勤日期,112)+' '+考勤时间 as 考勤时间
,SUM(考勤状态) as 人次
,SUM(收入) as 收入
,50+5*SUM(考勤状态)+SUM(收入)*0.15 as 新绩效工资
,40+(case when 年级 IN ('高一','高二','高三') then 5 else 2.5 end)*SUM(考勤状态)+SUM(收入)*0.1 as 旧绩效工资
from 月份考勤表
where 任课老师 in (select 职员姓名
from 人事字典 
where isnull(OKR_员工薪级,'')<>''
and OKR_管理级别 in ('区域校长/项目校长/资深校长','中心主任')
)
group by 任课老师,课程名称,班别,CONVERT(varchar,考勤日期,112)+' '+考勤时间,年级
) a
group by 任课老师