select �ο���ʦ
,MAX(�¼�Ч����) as ����ϵÿ�ڿ���߼�Ч
,MAX(�ɼ�Ч����) as ����ϵÿ�ڿ���߼�Ч
from
(
select �ο���ʦ,�γ�����,���,CONVERT(varchar,��������,112)+' '+����ʱ�� as ����ʱ��
,SUM(����״̬) as �˴�
,SUM(����) as ����
,50+5*SUM(����״̬)+SUM(����)*0.15 as �¼�Ч����
,40+(case when �꼶 IN ('��һ','�߶�','����') then 5 else 2.5 end)*SUM(����״̬)+SUM(����)*0.1 as �ɼ�Ч����
from �·ݿ��ڱ�
where �ο���ʦ in (select ְԱ����
from �����ֵ� 
where isnull(OKR_Ա��н��,'')<>''
and OKR_������ in ('����У��/��ĿУ��/����У��','��������')
)
group by �ο���ʦ,�γ�����,���,CONVERT(varchar,��������,112)+' '+����ʱ��,�꼶
) a
group by �ο���ʦ