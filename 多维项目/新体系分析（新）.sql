

--��ʼ����Ա����
if OBJECT_ID('tempdb..#tb1')>0
	drop table #tb1
GO
select ���,�·�,a.У��,a.ְԱ����,ְԱ����,��ְʱ��,��ְ��,��ְ����
into #tb1
from
(
select ְԱ����,У��
from ���ʱ�
group by ְԱ����,У��
) a
inner join
(select У��,���,�·� from ���ʱ� group by У��,���,�·�) b
on a.У��=b.У��
inner join �����ֵ� c on a.ְԱ����=c.ְԱ����
GO

--��Ա���ԭʼ����
if OBJECT_ID('tempdb..#tb2')>0
	drop table #tb2
GO
select ���,�·�,У��,ְԱ����,ְԱ����,��ְʱ��,��ְ��,��ְ����
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,1) as �³���ְ��Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,2) as ������Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,3) as ��ְ��Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,4) as �������ڵ�����Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,5) as �������ڵ�����Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,6) as �µ���ְ��Ա
,dbo.��Ա״̬(���,�·�,У��,ְԱ����,7) as ��������ְ��Ա
into #tb2
from #tb1
order by ���,�·�,У��,ְԱ����

--������
if OBJECT_ID('tempdb..#tb3')>0
	drop table #tb3
GO
select * 
into #tb3
from #tb2 
where not (�³���ְ��Ա=0 and ������Ա=0 and ��ְ��Ա=0 and �������ڵ�����Ա=0 and �������ڵ�����Ա=0 and �µ���ְ��Ա=0)

select * from #tb3
GO


--ͳ����ְ�ʣ����£�
if OBJECT_ID('tempdb..#tb4')>0
	drop table #tb4
GO
if OBJECT_ID('tempdb..#tb4_1')>0
	drop table #tb4_1
GO
select ���,�·�,У��
,SUM(cast(�³���ְ��Ա as tinyint)) as �³���ְ��Ա
,SUM(cast(������Ա as tinyint)) as ������Ա
,SUM(cast(��ְ��Ա as tinyint)) as ��ְ��Ա
,SUM(cast(��������ְ��Ա as tinyint)) as ��������ְ��Ա
,SUM(cast(�������ڵ�����Ա as tinyint)) as �������ڵ�����Ա
,SUM(cast(�������ڵ�����Ա as tinyint)) as �������ڵ�����Ա
,SUM(cast(�µ���ְ��Ա as tinyint)) as �µ���ְ��Ա
into #tb4
from #tb3
group by ���,�·�,У��
order by ���,�·�,У��

--���ռ����¶��壺1-3��=���ٰ࣬4-6��=�����࣬7-9��=��ٰ࣬10-12��=�＾��
select *
,ltrim(rtrim(str(���)))+'��'+(case	when �·� between 1 and 3 then '���ٰ�'
			when �·� between 4 and 6 then '������'
			when �·� between 7 and 9 then '��ٰ�'
			else '�＾��' end) as ����
,ltrim(rtrim(str(���)))+(case when �·�<10 then '0' else '' end)+ltrim(rtrim(str(�·�))) as ����
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

select ���,�·�,У��,����,�γ����� into #t1 from �·ݿ��ڱ� group by ���,�·�,У��,����,�γ�����
update #t1 set �γ�����=LEFT(�γ�����,4)+'��'+SUBSTRING(�γ�����,5,len(�γ�����)-4) where �γ����� like '201%' and SUBSTRING(�γ�����,5,1)<>'��'

select ���,�·�,У��,����1 as ����
into #t2
from 
(
select  *,
(case when �γ����� like '201_��%' then LEFT(�γ�����,7)+'��' else ���� end) as ����1 
from #t1
where (case when �γ����� like '201_��%' then LEFT(�γ�����,7)+'��' else ���� end) like '201_��__��'
) a
group by ���,�·�,У��,����1
order by У��,����
--У�������ȡ��·ݶ�Ӧ��
select * from #t2
*/
select * from #tb4_1
--У����������Ա�䶯��
if OBJECT_ID('tempdb..#tb5')>0
	drop table #tb5
GO
select У��,����
,SUM(������Ա) as ������Ա
,SUM(��ְ��Ա) as ��ְ��Ա
,SUM(��������ְ��Ա) as ��������ְ��Ա
,SUM(�������ڵ�����Ա) as �������ڵ�����Ա
,SUM(�������ڵ�����Ա) as �������ڵ�����Ա
,COUNT(*) as �·���
,MAX(ltrim(rtrim(str(���)))+(case when �·�<10 then '0' else '' end)+ltrim(rtrim(str(�·�)))) as ��ĩ�·�
into #tb5
from #tb4_1
group by У��,����

/*
select У��,����
,SUM(������Ա) as ������Ա
,SUM(��ְ��Ա) as ��ְ��Ա
,SUM(�������ڵ�����Ա) as �������ڵ�����Ա
,SUM(�������ڵ�����Ա) as �������ڵ�����Ա
,MIN(����) as ��ʼ����
,MAX(����) as ��ֹ����
,COUNT(*) as �·���
into #tb5
from
(
select a.*,b.����,LTRIM(rtrim(str(a.���)))+(case when a.�·�<10 then '0' else '' end)+LTRIM(rtrim(str(a.�·�))) as ����
from #tb4 a
	inner join #t2 b on a.У��=b.У�� and a.���=b.��� and a.�·�=b.�·�
) a
group by У��,����
*/

if OBJECT_ID('tempdb..#tb6')>0
	drop table #tb6
GO
/*
select *,
(select COUNT(*) 
	from �����ֵ� 
	where exists(select * 
				from ���ʱ� 
				where ְԱ����=�����ֵ�.ְԱ���� and У��=a.У��
				and (���� between a.��ʼ���� and a.��ֹ����) 
				and isnull(��ְ��,0)=0
				)
		and not exists(select * 
				from ���ʱ� 
				where ְԱ����=�����ֵ�.ְԱ����  and У��=a.У��
				and (���� between a.��ʼ���� and a.��ֹ����) 
				and isnull(��ְ��,0)=1
				)
) as ����ĩ��ְ����
into #tb6
from #tb5 a
order by У��,����
*/

select *
,(select �µ���ְ��Ա from #tb4_1 where У��=a.У�� and ����=a.���� and ����=a.��ĩ�·�) as ����ĩ��ְ��Ա
into #tb6
from #tb5 a

--#tb6��һ�����ݣ����ڲ�ѯ������ְ��Ա
if OBJECT_ID('tempdb..#tb6_1')>0
	drop table #tb6_1
GO
select * into #tb6_1
from #tb6

select *
,(select ����ĩ��ְ��Ա from #tb6_1 where У��=a.У�� and ����=dbo.�ϸ�����(a.����)) as ������ְ��Ա
from #tb6 a 
order by У��,��ĩ�·�

--������������
if OBJECT_ID('tempdb..#t3')>0
	drop table #t3
GO
select ���,�·�,У��,����,�γ�����,SUM(isnull(isnull(ʵ������,����),0)) as ����,SUM(����״̬) as �˴�
into #t3
from �·ݿ��ڱ�
group by ���,�·�,У��,����,�γ�����

select * from #t3
update #t1 set �γ�����=LEFT(�γ�����,4)+'��'+SUBSTRING(�γ�����,5,len(�γ�����)-4) where �γ����� like '201%' and SUBSTRING(�γ�����,5,1)<>'��'

--У�����ȿγ�����ͳ��ԭʼ����
if OBJECT_ID('tempdb..#tb7')>0
	drop table #tb7
GO
select *
,(case when �γ����� like '201_��%' then LEFT(�γ�����,7)+'��' else (case when ���� not like '201_��__��' then '����' else ���� end) end) as ����1 
into #tb7
from #t3

select * from #tb7

if OBJECT_ID('tempdb..#tb8')>0
	drop table #tb8
GO
select У��,����1 as ����,SUM(����) as ����,SUM(�˴�) as �˴�
into #tb8
from #tb7
group by У��,����1
order by У��,����

--У�������˾�����
select a.У��,a.����,a.���� as ������,b.����ĩ��ְ���� as ����ĩ����,a.����/b.����ĩ��ְ���� as �˾���ֵ
from #tb8 a
	inner join #tb6 b on a.У��=b.У�� and a.����=b.����
	
--����ѧ����
if OBJECT_ID('tempdb..#t4')>0
	drop table #t4
GO
--���ռ����¶��壺1-3��=���ٰ࣬4-6��=�����࣬7-9��=��ٰ࣬10-12��=�＾��			
select ���,�·�,У��,����,�γ�����,ѧ�����,ѧ������,SUM(isnull(isnull(ʵ������,����),0)) as ����,SUM(����״̬) as �˴�
/*,ltrim(rtrim(str(���)))+'��'+(case	when �·� between 1 and 3 then '���ٰ�'
			when �·� between 4 and 6 then '������'
			when �·� between 7 and 9 then '��ٰ�'
			else '�＾��' end) as ����*/
,(case when �γ����� like '201_��%' then LEFT(�γ�����,7)+'��' else ���� end) as ����1 
into #t4
from �·ݿ��ڱ�
where ISNULL(����,0)=0
group by ���,�·�,У��,����,�γ�����,ѧ�����,ѧ������

update #t4 set �γ�����=LEFT(�γ�����,4)+'��'+SUBSTRING(�γ�����,5,len(�γ�����)-4) where �γ����� like '201%' and SUBSTRING(�γ�����,5,1)<>'��'




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
select У��,����1 as ����,ѧ�����,ѧ������,�γ�����,SUM(����) as ����,SUM(�˴�) as �˴�
into #t5
from #t4
group by У��,����1,ѧ�����,ѧ������,�γ�����

select * from #t5

select У��,����,�γ�����,MAX(�˴�) as ��׼�˴�,MIN(�˴�) as ����˴�,COUNT(*) as ѧ����
into #t5_1
from #t5
group by У��,����,�γ�����

select * from #t5_1

select a.*
,b.��׼�˴�
,(case when b.��׼�˴�-a.�˴�>=3 then 1 else 0 end) as ��ʧѧ��
,(case when b.��׼�˴�-a.�˴�>=3 and a.�˴�<=2 then 1 else 0 end) as ��ʧ����ѧ��
into #t5_2
from #t5 a
	inner join #t5_1 b on a.У��=b.У�� and a.����=b.���� and a.�γ�����=b.�γ�����
order by b.��׼�˴�-a.�˴�

select * from �·ݿ��ڱ� where ѧ�����='S18861' and �γ�����='2018�괺������С��ѧ˼ά�а�'  and ����='2018�괺����' and �γ�����='2018�괺������С��ѧ˼ά�а�' and У��='��ɽ����'

select У��,����,ѧ�����,ѧ������,SUM(����) as ����,SUM(�˴�) as �˴�,SUM(��׼�˴�) as ��׼�˴�
,MIN(��ʧѧ��) as ��ʧѧ��
,MIN(��ʧ����ѧ��) as ��ʧ����ѧ��
into #t5_3
from #t5_2
group by У��,����,ѧ�����,ѧ������


select * from #t5_2 where У��='����У��' and ����='2016���＾��' and �γ�����='����' and ѧ�����='DC00920'
select * from �·ݿ��ڱ� where У��='����У��' and ����='2016���＾��' and ѧ�����='DC00920' order by ��������

if OBJECT_ID('tempdb..#t6')>0
	drop table #t6
GO
select У��,����,COUNT(*) as ѧ����,SUM(����) as ����,SUM(�˴�) as �˴�,SUM(��ʧѧ��) as ��ʧѧ����,SUM(��ʧ����ѧ��) as ��ʧ����ѧ����
into #t6
from #t5_3
group by У��,����

--t6��t7��ͬһ�����ݣ�����ȡ�ϼ�����
if OBJECT_ID('tempdb..#t7')>0
	drop table #t7
GO
select * into #t7 from #t6


select * from #t6 order by У��,����

select a.*,b.ѧ���� as �ϼ�ѧ����
from #t6 a
	left join #t7 b on a.У��=b.У�� and dbo.�ϸ�����(a.����)=b.����
order by a.У��,a.����
	
--t5��t8��ͬһ�����ݣ������ж�����������
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

--�ϼ����¼�У��
select a.У��,a.����,a.ѧ�����,a.ѧ������,a.�˴�,a.����,a.��ʧѧ��,a.��ʧ����ѧ��,a.��׼�˴�
,b.У�� as �¼��Ͷ�У�� 
,c.У�� as �ϼ��Ͷ�У��
,c.��ʧѧ�� as �ϼ���ʧѧ��
--into #t10
from #t5_3 a
	left join #t8 b on a.ѧ�����=b.ѧ����� and dbo.�ϸ�����(b.����)=a.����
	left join #t9 c on a.ѧ�����=c.ѧ����� and dbo.�ϸ�����(a.����)=c.����

GO

select* from #t5_3
	
--ȫϢѧ����ϸ
if OBJECT_ID('tempdb..#t11')>0
	drop table #t11
GO
select *
--������Ϣ
,(case when ISNULL(�ϼ��Ͷ�У��,'')<>'' then 1 else 0 end) as ��������
,(case when ISNULL(�ϼ��Ͷ�У��,'')<>'' and ISNULL(�ϼ��Ͷ�У��,'')<>У�� then 1 else 0 end) as ������Уת������
,(case when ISNULL(�ϼ��Ͷ�У��,'')<>'' and ISNULL(�ϼ��Ͷ�У��,'')=У�� then 1 else 0 end) as ������У����
--������Ϣ
,(case when ISNULL(�ϼ��Ͷ�У��,'')<>У�� then 1 else 0 end) as ��������
,(case when ISNULL(�ϼ��Ͷ�У��,'')='' then 1 else 0 end) as ����ȫ��ѧԱ
,(case when ISNULL(�ϼ��Ͷ�У��,'')<>'' and ISNULL(�ϼ��Ͷ�У��,'')<>У�� then 1 else 0 end) as ������Уת����ѧԱ
into #t11
from #t10 a

--������ְѧ������	��������ѧ������	����ѧ����ʧ����	������ʧѧ��������ѧ������	��������������ѧ������	������������ѧ������	����ĩѧ������	��ʧ��	��ʧ��                              ȥ������ѧ������
select * from #t11 where У��='����У��' and ѧ�����='DC00011'

if OBJECT_ID('tempdb..#t12')>0
	drop table #t12
GO
--������Ϣ����
select У��,����
,SUM(�˴�) as �����˴�
,SUM(����) as ��������
,COUNT(*) as ����ѧ������
,SUM(��ʧѧ��) as ��ʧѧ������
,SUM(�˴�*��ʧѧ��) as ��ʧѧ���˴�
,SUM(����*��ʧѧ��) as ��ʧѧ������
,SUM(��ʧ����ѧ��) as ��ʧ����ѧ������
,SUM(�˴�*��ʧ����ѧ��) as ��ʧ����ѧ���˴�
,SUM(����*��ʧ����ѧ��) as ��ʧ����ѧ������
--����
,SUM(��������) as ������������
,SUM(������У����) as ������У��������
,SUM(������Уת������) as ������Уת����������
,SUM((case when ��������=1 then �˴� else 0 end)) as ���������˴�
,SUM((case when ������У����=1 then �˴� else 0 end)) as ������У�����˴�
,SUM((case when ������Уת������=1 then �˴� else 0 end)) as ������Уת�������˴�
--����
,SUM(��������) as ������������
,SUM(����ȫ��ѧԱ) as ����ȫ��ѧԱ����
,SUM(������Уת����ѧԱ) as ������Уת����ѧԱ����
,SUM((case when ��������=1 then �˴� else 0 end)) as ���������˴�
,SUM((case when ����ȫ��ѧԱ=1 then �˴� else 0 end)) as ����ȫ��ѧԱ�˴�
,SUM((case when ������Уת����ѧԱ=1 then �˴� else 0 end)) as ������Уת����ѧԱ�˴�
into #t12
from #t11
group by У��,����

select * from #t11
--�����ϼ������������˴�
if OBJECT_ID('tempdb..#t13')>0
	drop table #t13
GO
if OBJECT_ID('tempdb..#t14')>0
	drop table #t14
GO
--��������������
select * into #t13 from #t12
select * into #t14 from #t12

--����������ѧ����
select isnull(�ϼ��Ͷ�У��,'') as У��,����,COUNT(*) as ѧ����,SUM(�˴�) as �˴�
into #t11_1
from #t11
where isnull(�ϼ��Ͷ�У��,'')<>У�� and isnull(�ϼ��Ͷ�У��,'')<>''
group by isnull(�ϼ��Ͷ�У��,''),����

select * from #t12


select a.*
,d.ѧ���� as ��������������ѧ����
,d.�˴� as ���������������˴�

,b.���� as �ϼ�����
,b.�����˴� as �ϼ��˴�
,b.�������� as �ϼ�����
,b.����ѧ������ as �ϼ�ѧ������

,b.��ʧѧ������ as �ϼ���ʧѧ������
,b.��ʧѧ���˴� as �ϼ���ʧѧ���˴�
,b.��ʧѧ������ as �ϼ���ʧѧ������
,b.��ʧ����ѧ������ as �ϼ���ʧ����ѧ������
,b.��ʧ����ѧ���˴� as �ϼ���ʧ����ѧ���˴�
,b.��ʧ����ѧ������ as �ϼ���ʧ����ѧ������

,b.������������ as �ϼ���������
,b.������У�������� as �ϼ���У��������
,b.������Уת���������� as �ϼ���Уת����������
,b.���������˴� as �ϼ������˴�
,b.������У�����˴� as �ϼ���У�����˴�
,b.������Уת�������˴� as �ϼ���Уת�������˴�

,b.������������ as �ϼ���������
,b.����ȫ��ѧԱ���� as �ϼ�����ѧ����
,b.������Уת����ѧԱ���� as �ϼ���Уת����ѧԱ����
,b.���������˴� as �ϼ������˴�
,b.����ȫ��ѧԱ�˴� as �ϼ�����ѧ�˴�
,b.������Уת����ѧԱ�˴� as �ϼ���Уת����ѧԱ�˴�

,c.���� as �ϼ�ͬ�ȼ���
,c.�����˴� as �ϼ�ͬ���˴�
,c.�������� as �ϼ�ͬ������
,c.����ѧ������ as �ϼ�ͬ��ѧ������

,c.��ʧѧ������ as �ϼ�ͬ����ʧѧ������
,c.��ʧѧ���˴� as �ϼ�ͬ����ʧѧ���˴�
,c.��ʧѧ������ as �ϼ�ͬ����ʧѧ������
,c.��ʧ����ѧ������ as �ϼ�ͬ����ʧ����ѧ������
,c.��ʧ����ѧ���˴� as �ϼ�ͬ����ʧ����ѧ���˴�
,c.��ʧ����ѧ������ as �ϼ�ͬ����ʧ����ѧ������

,c.������������ as �ϼ�ͬ����������
,c.������У�������� as �ϼ�ͬ�ȱ�У��������
,c.������Уת���������� as �ϼ�ͬ����Уת����������
,c.���������˴� as �ϼ�ͬ�������˴�
,c.������У�����˴� as �ϼ�ͬ�ȱ�У�����˴�
,c.������Уת�������˴� as �ϼ�ͬ����Уת�������˴�

,c.������������ as �ϼ�ͬ����������
,c.����ȫ��ѧԱ���� as �ϼ�ͬ������ѧ����
,c.������Уת����ѧԱ���� as �ϼ�ͬ����Уת����ѧԱ����
,c.���������˴� as �ϼ�ͬ�������˴�
,c.����ȫ��ѧԱ�˴� as �ϼ�ͬ������ѧ�˴�
,c.������Уת����ѧԱ�˴� as �ϼ�ͬ����Уת����ѧԱ�˴�
from #t12 a
	left join #t13 b on a.У��=b.У�� and dbo.�ϸ�����(a.����)=b.����
	left join #t13 c on a.У��=c.У�� and dbo.�ϸ�ͬ�ȼ���(a.����)=c.����
	left join #t11_1 d on a.У��=d.У�� and a.����=d.����
order by a.У��
,LEFT(a.����,4)
,(case when charindex('������',a.����)>0 then 1
	when charindex('��ٰ�',a.����)>0 then 2
	when charindex('�＾��',a.����)>0 then 3
	when charindex('���ٰ�',a.����)>0 then 0
	else 5 end)