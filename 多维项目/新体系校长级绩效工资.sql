select 任课老师,OKR_教师级别
,MAX(新绩效工资) as 新体系每节课最高绩效
,MAX(旧绩效工资) as 旧体系每节课最高绩效
from
(
select a.任课老师,b.OKR_教师级别,a.课程名称,a.班别,CONVERT(varchar,a.考勤日期,112)+' '+a.考勤时间 as 考勤时间
,sum(a.考勤状态) as 人次
,sum(a.收入) as 收入
,isnull(c.达标课时工资,c.基本课时工资)+sum(a.考勤状态)*isnull(c.达标人次工资,c.基本人次工资)+sum(a.收入)*isnull(c.达标收入系数,c.基本收入系数) as 新绩效工资
,40+(case when a.年级 IN ('高一','高二','高三') then 5 else 2.5 end)*SUM(考勤状态)+SUM(收入)*0.1 as 旧绩效工资
from 月份考勤表 a
	inner join 人事字典 b on a.任课老师=b.职员姓名
	inner join OKR绩效参数表 c on b.OKR_教师级别=c.教师级别
where isnull(b.OKR_员工薪级,'')<>''
		and b.OKR_管理级别 in ('区域校长/项目校长/资深校长','中心主任')
group by a.任课老师,b.OKR_教师级别,课程名称,班别,CONVERT(varchar,考勤日期,112)+' '+考勤时间,a.年级
,c.达标课时工资,c.基本课时工资,c.达标人次工资,c.基本人次工资,c.达标收入系数,c.基本收入系数
) a
group by 任课老师,OKR_教师级别