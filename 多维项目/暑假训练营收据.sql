declare @���� varchar(50),@��� numeric(11,2),@ѧ�� varchar(50),@cursor cursor
declare @�վݺ� varchar(50),@���վݺ� varchar(50)
set @cursor=cursor for
select a.����,a.���,b.ѧ��
from [Sheet1$] a
	left join ѧԱ��Ϣ�� b on a.����=b.����
open @cursor
fetch next from @cursor into @����,@���,@ѧ��
while @@FETCH_STATUS=0
begin
	set @�վݺ�=dbo.WiseMis_GetNewId('˰���վݺ�',null)
	set @���վݺ�=dbo.WiseMis_GetNewId('���վݺ�',null)
	--�����վ�����
	insert into ˰��_�վ�(�վݺ�,���վݺ�, ѧ��, ����, �꼶, ��������, У������,����, ������, �վ�����, �տ��˺�, ǩ������,CreateUser,CreateTime)
			values (@�վݺ�,@���վݺ�,@ѧ��,@����,'���꼶','2018-07-28','ݸ��У��','����','GCY','����','ˢ��','����','GCY','2018-07-28')
	insert into ˰��_�վ���ϸ(У������,����,�վݺ�, ѧ��, ����, �γ�����, ��ʱ��, ��ʱ��, ��׼��ʱ��, ���,��λ,CreateUser,CreateTime)
		values ('ݸ��У��','����',@�վݺ�,@ѧ��,@����,'�������꼶���ѵ��Ӫ',1,@���,@���,@���,'��','GCY','2018-07-28')
	--�����վ���ϸ
	exec WiseMis_SetNewId '˰���վݺ�',@�վݺ�
	exec WiseMis_SetNewId '���վݺ�',@���վݺ�
	fetch next from @cursor into @����,@���,@ѧ��
end
close @cursor
deallocate @cursor