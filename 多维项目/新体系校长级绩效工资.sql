select ���,�·�,�ο���ʦ,OKR_��ʦ����,ϵ��,SUM(��ʱ) as ��ʱ,SUM(�˴�) as �˴�,SUM(����) as ����
,SUM(��Ч����) as �¼�Ч����
,(select top 1 ʵ�ʼ�Ч����+isnull(����ȫ���ƽ���,0) from DuoweiEdu_Salary_New.dbo.���ʱ� where ���=cc.��� and �·�=cc.�·� and ְԱ����=cc.�ο���ʦ) as [ԭ��Ч����(������ȫ����)]
,SUM(��Ч����)-(select top 1 ʵ�ʼ�Ч����+isnull(����ȫ���ƽ���,0) from DuoweiEdu_Salary_New.dbo.���ʱ� where ���=cc.��� and �·�=cc.�·� and ְԱ����=cc.�ο���ʦ) as ��Ч���
from
(
select ���,�·�,�ο���ʦ,OKR_��ʦ����,ϵ��,���,�γ�����,��ʱ,�˴�,����,��Ч����,����
from
(
select ���,�·�,�ο���ʦ,OKR_��ʦ����,ϵ��,���,�γ�����,COUNT(*) as ��ʱ,SUM(�˴�) as �˴�,SUM(����) as ����,SUM(��Ч����) as ��Ч����
,ROW_NUMBER() over (partition by ���,�·�,�ο���ʦ order by sum(��Ч����) desc) as ����
from
(
select ���,�·�,�ο���ʦ,OKR_��ʦ����,�༶����,���,�γ�����,a.�꼶
,CONVERT(varchar,a.��������,112)+' '+a.����ʱ�� as ����ʱ��
,'��ʱ�ѣ�'+LTRIM(RTRIM(str(isnull(c.����ʱ����,c.������ʱ����))))
+'���˴ηѣ�'+LTRIM(RTRIM(str(isnull(c.����˴ι���,c.�����˴ι���))))
+'��������ɣ�'+LTRIM(RTRIM(str(isnull(c.�������ϵ��,c.��������ϵ��),11,2))) as ϵ��
,sum(a.����״̬) as �˴�
,sum(a.����) as ����
--,40+(case when a.�꼶 IN ('��һ','�߶�','����') then 5 else 2.5 end)*SUM(����״̬)+SUM(����)*0.1 as ��Ч����
,isnull(c.����ʱ����,c.������ʱ����)+sum(a.����״̬)*isnull(c.����˴ι���,c.�����˴ι���)+sum(a.����)*isnull(c.�������ϵ��,c.��������ϵ��) as ��Ч����
from �·ݿ��ڱ� a
	inner join �����ֵ� b on a.�ο���ʦ=b.ְԱ����
	inner join OKR��Ч������ c on b.OKR_��ʦ����=c.��ʦ����
where b.OKR_������='����У��/��ĿУ��/����У��'
group by ���,�·�,�ο���ʦ,OKR_��ʦ����,�༶����,���,�γ�����,a.�꼶,c.����ʱ����,c.������ʱ����,c.����˴ι���,c.�����˴ι���,c.�������ϵ��,c.��������ϵ��
,CONVERT(varchar,a.��������,112)+' '+a.����ʱ��
,'��ʱ�ѣ�'+LTRIM(RTRIM(str(isnull(c.����ʱ����,c.������ʱ����))))
+'���˴ηѣ�'+LTRIM(RTRIM(str(isnull(c.����˴ι���,c.�����˴ι���))))
+'��������ɣ�'+LTRIM(RTRIM(str(isnull(c.�������ϵ��,c.��������ϵ��),11,2)))
) aa
group by ���,�·�,�ο���ʦ,OKR_��ʦ����,ϵ��,���,�γ�����
) bb
where ����<=4
) cc
group by ���,�·�,�ο���ʦ,OKR_��ʦ����,ϵ��
order by �ο���ʦ,���,�·�