CREATE TRIGGER [dbo].[T_up_FlowTitle]
   ON   [dbo].[FLowExecuteMain]
   AFTER  INSERT,update
AS 
BEGIN

/**************01.ְ������ҵ��**********************/

--��н/��н��������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��н/��н��������'
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


--������Ա��ְ
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'������Ա��ְ'
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

--������Ա��Ƹ
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'������Ա��Ƹ'
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


--������������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'������������'
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

--��ְ��������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��ְ��������'
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

--ת����������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'ת����������'
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

--��Ա����ְ�����ƻ�
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ա����ְ�����ƻ�'
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

--�����������¼������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'�����������¼������'
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

--Ա����ְ�Ǽ�����
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'Ա����ְ�Ǽ�����'
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



/**************02.��Ӫ����ҵ��**********************/

--��Ӫ��Ա��ְ����
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Ա��ְ����'
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

--��Ӫ��Ա��н/��н����
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Ա��н/��н����'
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

--��Ӫ��Ա��Ƹ����
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Ա��Ƹ����'
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

--��Ӫ��Ա��������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Ա��������'
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

--��Ӫ��Ա��ְ����
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Ա��ְ����'
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

--��Ӫ��Աת������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��Ӫ��Աת������'
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


/**************03.����ҵ��**********************/

--���
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'��ͨ��������'+CONVERT(CHAR(10),K2006,111)+'��'+CONVERT(CHAR(10),K2007,111)+cast(K2005 As char(10))+rtrim(CAST(k2011 as CHAR))+'Сʱ'
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
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'�����������'+CONVERT(CHAR(10),K2006,111)+'��'+CONVERT(CHAR(10),K2007,111)+cast(K2005 As char(10))+rtrim(CAST(k2011 as CHAR))+'Сʱ'
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


--�Ӱ�
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'�Ӱ�����'+isnull(CONVERT(CHAR(10),k1906,111),'')+isnull(cast(K1905 As varchar(12)),'')+isnull(rtrim(CAST(K1913 as CHAR)),'')+'Сʱ'
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

--�򿨲�¼���� 
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+'�򿨲�¼����_'+isnull(CONVERT(CHAR(10),K071003,111),'')
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
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+'�籣'+case when isnull(BX_TYPE,'')='�α�' then '�α�' when isnull(BX_TYPE,'')='ͣ��' then 'ͣ��' else '�α�/ͣ��'+'��������' end +'_'+'��'+'_'+rtrim(a01.a0101)+'_'+'��'+'_'+CONVERT(CHAR(10),OPDATE,111)+'_'+'�ύ'
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
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+'������'+case when isnull(BX_TYPE,'')='�α�' then '�α�' when isnull(BX_TYPE,'')='ͣ��' then 'ͣ��' else '�α�/ͣ��' end+'��������'+'_'+'��'+'_'+rtrim(a01.a0101)+'_'+'��'+'_'+CONVERT(CHAR(10),OPDATE,111)+'_'+'�ύ'
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



--�Ӱ�/�������
update  FLowExecuteMain
set FlowTitle=rtrim(deptcode.CONTENT)+'_'+rtrim(a01.A0190)+'_'+rtrim(a01.a0101)+'_'+rtrim(C073005) +'��������_'+case when isnull(C073005,'')='�Ӱ�' then rtrim(GZ_YM1) else rtrim(END_YEAR) end
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