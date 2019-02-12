CREATE TRIGGER [dbo].[T_up_FlowTitle]
   ON   [dbo].[FLowExecuteMain]
   AFTER  INSERT,update
AS 
BEGIN

/**************01.职能人事业务**********************/

--定薪/调薪审批流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'定薪/调薪审批流程'
from CHG014,a01,inserted,deptcode
where 
CHG014.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG014.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG014'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


--管理人员辞职
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'管理人员辞职'
from CHG017,a01,inserted,deptcode
where 
CHG017.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG017.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG017'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--管理人员解聘
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'管理人员解聘'
from CHG015,a01,inserted,deptcode
where 
CHG015.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG015.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG015'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


--晋升审批流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'晋升审批流程'
from CHG013,a01,inserted,deptcode
where 
CHG013.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG013.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG013'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--调职审批流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'调职审批流程'
from CHG011,a01,inserted,deptcode
where 
CHG011.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG011.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG011'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--转正审批流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'转正审批流程'
from CHG010,a01,inserted,deptcode
where 
CHG010.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG010.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG010'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--新员工入职提升计划
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'新员工入职提升计划'
from CHG012,a01,inserted,deptcode
where 
CHG012.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG012.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG012'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--邮箱局域网登录名申请
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'邮箱局域网登录名申请'
from CHG007,a01,inserted,deptcode
where 
CHG007.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG007.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG007'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--员工入职登记流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'员工入职登记流程'
from CHG026,a01,inserted,deptcode
where 
CHG026.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG026.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG026'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID



/**************02.运营人事业务**********************/

--运营人员辞职流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员辞职流程'
from CHG019,a01,inserted,deptcode
where 
CHG019.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG019.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG019'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--运营人员定薪/调薪申请
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员定薪/调薪申请'
from CHG020,a01,inserted,deptcode
where 
CHG020.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG020.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG020'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--运营人员解聘流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员解聘流程'
from CHG021,a01,inserted,deptcode
where 
CHG021.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG021.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG021'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--运营人员晋升流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员晋升流程'
from CHG022,a01,inserted,deptcode
where 
CHG022.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG022.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG022'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--运营人员调职流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员调职流程'
from CHG023,a01,inserted,deptcode
where 
CHG023.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG023.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG023'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--运营人员转正流程
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'运营人员转正流程'
from CHG024,a01,inserted,deptcode
where 
CHG024.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
CHG024.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='CHG024'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


/**************03.考勤业务**********************/

--请假
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'普通假期申请'+CONVERT(CHAR(10),K2006,111)+'至'+CONVERT(CHAR(10),K2007,111)+cast(K2005 As char(10))+rtrim(CAST(k2011 as CHAR))+'小时'
from k20,a01,inserted,deptcode
where 
k20.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
k20.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='K20'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'特殊假期申请'+CONVERT(CHAR(10),K2006,111)+'至'+CONVERT(CHAR(10),K2007,111)+cast(K2005 As char(10))+rtrim(CAST(k2011 as CHAR))+'小时'
from K20_TS,a01,inserted,deptcode
where 
K20_TS.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
K20_TS.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='K20_TS'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


--加班
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'加班申请'+isnull(CONVERT(CHAR(10),k1906,111),'')+isnull(cast(K1905 As varchar(12)),'')+isnull(rtrim(CAST(K1913 as CHAR)),'')+'小时'
from K19,a01,inserted,deptcode
where 
K19.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
K19.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='K19'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID

--打卡补录申请 
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'打卡补录申请_'+isnull(CONVERT(CHAR(10),K071003,111),'')
from K071,a01,inserted,deptcode
where 
K071.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
K071.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='K071'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+'社保'+case when isnull(BX_TYPE,'')='参保' then '参保' when isnull(BX_TYPE,'')='停保' then '停保' else '参保/停保'+'申请流程' end +'_'+'由'+'_'+rtrim(a01.a0101)+'_'+'于'+'_'+CONVERT(CHAR(10),OPDATE,111)+'_'+'提交'
from MCHG003,A01,inserted,deptcode
where 
MCHG003.a0188=a01.a0188
and
MCHG003.DEPT_ID=deptcode.DEPT_ID
and
MCHG003.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='MCHG003'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID


update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+'公积金'+case when isnull(BX_TYPE,'')='参保' then '参保' when isnull(BX_TYPE,'')='停保' then '停保' else '参保/停保' end+'申请流程'+'_'+'由'+'_'+rtrim(a01.a0101)+'_'+'于'+'_'+CONVERT(CHAR(10),OPDATE,111)+'_'+'提交'
from MCHG004,A01,inserted,deptcode
where 
MCHG004.a0188=a01.a0188
and
MCHG004.DEPT_ID=deptcode.DEPT_ID
and
MCHG004.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='MCHG004'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID



--加班/年假延期
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+rtrim(C073005) +'延期申请_'+case when isnull(C073005,'')='加班' then rtrim(GZ_YM1) else rtrim(END_YEAR) end
from C073,a01,inserted,deptcode
where 
C073.A0188=a01.A0188
and
a01.DEPT_ID=deptcode.DEPT_ID
and
C073.Kguid=FLowExecuteMain.KeyFieldValue
and
FLowExecuteMain.flowtable='C073'
and
FLowExecuteMain.PROJ_ID=inserted.PROJ_ID




end
GO