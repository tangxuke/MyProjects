select 年份,月份,任课老师,OKR_教师级别,系数,SUM(课时) as 课时,SUM(人次) as 人次,SUM(收入) as 收入
,SUM(绩效工资) as 新绩效工资
,(select top 1 实际绩效工资+isnull(培优全日制津贴,0) from DuoweiEdu_Salary_New.dbo.工资表 where 年份=cc.年份 and 月份=cc.月份 and 职员姓名=cc.任课老师) as [原绩效工资(含培优全日制)]
,SUM(绩效工资)-(select top 1 实际绩效工资+isnull(培优全日制津贴,0) from DuoweiEdu_Salary_New.dbo.工资表 where 年份=cc.年份 and 月份=cc.月份 and 职员姓名=cc.任课老师) as 绩效差额
from
(
select 年份,月份,任课老师,OKR_教师级别,系数,班别,课程名称,课时,人次,收入,绩效工资,排名
from
(
select 年份,月份,任课老师,OKR_教师级别,系数,班别,课程名称,COUNT(*) as 课时,SUM(人次) as 人次,SUM(收入) as 收入,SUM(绩效工资) as 绩效工资
,ROW_NUMBER() over (partition by 年份,月份,任课老师 order by sum(绩效工资) desc) as 排名
from
(
select 年份,月份,任课老师,OKR_教师级别,班级类型,班别,课程名称,a.年级
,CONVERT(varchar,a.考勤日期,112)+' '+a.考勤时间 as 考勤时间
,'课时费：'+LTRIM(RTRIM(str(isnull(c.达标课时工资,c.基本课时工资))))
+'，人次费：'+LTRIM(RTRIM(str(isnull(c.达标人次工资,c.基本人次工资))))
+'，收入提成：'+LTRIM(RTRIM(str(isnull(c.达标收入系数,c.基本收入系数),11,2))) as 系数
,sum(a.考勤状态) as 人次
,sum(a.收入) as 收入
--,40+(case when a.年级 IN ('高一','高二','高三') then 5 else 2.5 end)*SUM(考勤状态)+SUM(收入)*0.1 as 绩效工资
,isnull(c.达标课时工资,c.基本课时工资)+sum(a.考勤状态)*isnull(c.达标人次工资,c.基本人次工资)+sum(a.收入)*isnull(c.达标收入系数,c.基本收入系数) as 绩效工资
from 月份考勤表 a
	inner join 人事字典 b on a.任课老师=b.职员姓名
	inner join OKR绩效参数表 c on b.OKR_教师级别=c.教师级别
where b.OKR_管理级别='区域校长/项目校长/资深校长'
group by 年份,月份,任课老师,OKR_教师级别,班级类型,班别,课程名称,a.年级,c.达标课时工资,c.基本课时工资,c.达标人次工资,c.基本人次工资,c.达标收入系数,c.基本收入系数
,CONVERT(varchar,a.考勤日期,112)+' '+a.考勤时间
,'课时费：'+LTRIM(RTRIM(str(isnull(c.达标课时工资,c.基本课时工资))))
+'，人次费：'+LTRIM(RTRIM(str(isnull(c.达标人次工资,c.基本人次工资))))
+'，收入提成：'+LTRIM(RTRIM(str(isnull(c.达标收入系数,c.基本收入系数),11,2)))
) aa
group by 年份,月份,任课老师,OKR_教师级别,系数,班别,课程名称
) bb
where 排名<=4
) cc
group by 年份,月份,任课老师,OKR_教师级别,系数
order by 任课老师,年份,月份