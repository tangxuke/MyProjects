select 年份,月份,任课老师,班别,课程名称,课时,人次,收入,绩效工资,排名
from
(
select 年份,月份,任课老师,班别,课程名称,COUNT(*) as 课时,SUM(人次) as 人次,SUM(收入) as 收入,SUM(绩效工资) as 绩效工资
,ROW_NUMBER() over (partition by 年份,月份,任课老师 order by sum(绩效工资) desc) as 排名
from
(
select 年份,月份,任课老师,班级类型,班别,课程名称,a.年级
,CONVERT(varchar,a.考勤日期,112)+' '+a.考勤时间 as 考勤时间
,sum(a.考勤状态) as 人次
,sum(a.收入) as 收入
--,40+(case when a.年级 IN ('高一','高二','高三') then 5 else 2.5 end)*SUM(考勤状态)+SUM(收入)*0.1 as 绩效工资
,isnull(c.达标课时工资,c.基本课时工资)+sum(a.考勤状态)*isnull(c.达标人次工资,c.基本人次工资)+sum(a.收入)*isnull(c.达标收入系数,c.基本收入系数) as 绩效工资
from 月份考勤表 a
	inner join 人事字典 b on a.任课老师=b.职员姓名
	inner join OKR绩效参数表 c on b.OKR_教师级别=c.教师级别
where b.OKR_管理级别 in ('区域校长/项目校长/资深校长','中心主任')
group by 年份,月份,任课老师,班级类型,班别,课程名称,a.年级,c.达标课时工资,c.基本课时工资,c.达标人次工资,c.基本人次工资,c.达标收入系数,c.基本收入系数
,CONVERT(varchar,a.考勤日期,112)+' '+a.考勤时间
) aa
group by 年份,月份,任课老师,班别,课程名称
) bb
where 排名<=4
order by 任课老师,年份,月份,排名