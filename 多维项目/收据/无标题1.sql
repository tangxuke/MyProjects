declare @У������ varchar(50),@��� int,@�·� int
set @У������='����У��'
set @���=2018
set @�·�=6

if object_id('tempdb..#tb')>0
	drop table #tb

create table #tb(���� datetime,��� numeric(11,2))
insert into #tb(����,���) values ('2018-06-03',17604)
insert into #tb(����,���) values ('2018-06-07',4400)
insert into #tb(����,���) values ('2018-06-10',1040)
insert into #tb(����,���) values ('2018-06-11',3120)
insert into #tb(����,���) values ('2018-06-17',5790)
insert into #tb(����,���) values ('2018-06-21',5120)
insert into #tb(����,���) values ('2018-06-24',8367.5)
insert into #tb(����,���) values ('2018-06-30',31126.5)

update ˰��_�վ� set ��������2=null where У������=@У������ and year(��������)=@��� and month(��������)=@�·�


declare @�������� datetime,@��� numeric(11,2),@���ѽ�� numeric(11,2),@�վݺ� varchar(50)

while exists(select * from #tb where ���>0)
begin
	select top 1 @��������=����,@���=��� from #tb where ���>0 order by ��� desc

	select top 1 @�վݺ�=�վݺ�,@���ѽ��=���ѽ��
	from ˰��_�վ�
	where У������=@У������ and year(��������)=@��� and month(��������)=@�·� and ��������2 is null
	order by abs(@���-���ѽ��)

	if @���>=@���ѽ��
	begin
		update ˰��_�վ� set ��������2=@�������� where �վݺ�=@�վݺ�
		update #tb set ���=���-@���ѽ�� where convert(varchar,����,112)=convert(varchar,@��������,112)
	end
	else
	begin
		update ˰��_�վ� set ��������2=@��������,���ѽ��=@���,�ֽ�=@��� where �վݺ�=@�վݺ�
		update #tb set ���=0 where convert(varchar,����,112)=convert(varchar,@��������,112)
	end
	
end


