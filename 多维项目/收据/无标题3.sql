alter table ˰��_�վ���ϸ disable trigger all
GO
update ˰��_�վ� set ��������2=null where У������='����У��' and year(��������)=2018 and month(��������)=6
GO
declare @ѧ�� varchar(50),@���� varchar(50),@�������� datetime,@���ѽ�� numeric(11,2),@cursor cursor,@�վݺ� varchar(50),@���վݺ� varchar(50),@�վݺ�2 varchar(50)
set @cursor=cursor for
select �վݺ�,���վݺ�,ѧ��,����,��������,���ѽ�� from ˰��_�վ�2 where У������='����У��'
open @cursor
fetch next from @cursor into @�վݺ�,@���վݺ�,@ѧ��,@����,@��������,@���ѽ��
while @@fetch_status=0
begin
	if exists(select * from ˰��_�վ� where У������='����У��' and year(��������)=2018 and month(��������)=6 and (��������2 is null) and ����=@���� and ѧ��=@ѧ��)
	begin
		select top 1 @�վݺ�2=�վݺ� from ˰��_�վ� where У������='����У��' and year(��������)=2018 and month(��������)=6 and (��������2 is null) and ����=@���� and ѧ��=@ѧ��
		update ˰��_�վ� set ��������2=@��������,���ѽ��2=@���ѽ�� where �վݺ�=@�վݺ�2
	end
	else
	begin
		insert into ˰��_�վ�(�վݺ�, ���վݺ�, ѧ��, ����, �꼶, ���ѽ��, �����˻�, �ֽ�, ˢ��, ΢��, ֧����, ֱ�����, �ۿ۽��, ��������, У������, ����, ������, ״̬, �վ�����, �տ��˺�, ǩ������, ��Ʊ��, ҵ��������, Remark, CreateUser, CreateTime, __record__guid__, ��������2, ���ѽ��2)
			select �վݺ�, ���վݺ�, ѧ��, ����, �꼶, ���ѽ��, �����˻�, �ֽ�, ˢ��, ΢��, ֧����, ֱ�����, �ۿ۽��, ��������, '����У��', ����, ������, ״̬, �վ�����, �տ��˺�, ǩ������, ��Ʊ��, ҵ��������, Remark, CreateUser, CreateTime, __record__guid__, @��������, @���ѽ��
			from ˰��_�վ�2
			where �վݺ�=@�վݺ�
		insert into ˰��_�վ���ϸ(�վݺ�, У������, ����, ѧ��, ����, �γ�����, �༶����, ��ʱ��, ��λ, ��ʱ��, ��׼��ʱ��, ���, Remark, CreateUser, CreateTime)
			select @�վݺ�, '����У��', @����, ѧ��, ����, �γ�����, �༶����, ��ʱ��, ��λ, ��ʱ��, ��׼��ʱ��, ���, Remark, CreateUser, CreateTime
			from �վ���ϸ
			where �վݺ�=(select top 1 �վݺ� from �վ� where ѧ��=@ѧ�� and ����=@���� and ���ѽ��=@���ѽ�� and year(��������)=2018)
	end
	fetch next from @cursor into @�վݺ�,@���վݺ�,@ѧ��,@����,@��������,@���ѽ��
end
close @cursor
deallocate @cursor

GO

alter table ˰��_�վ���ϸ disable trigger all
GO