--select * from �����ֵ�
GO
create function dbo.������ְ����(@��ʼ���� datetime,@�������� datetime)
returns int
as
begin
	declare @���� int
	select @����=COUNT(*)
	from �����ֵ�
	where ��ְ��=1 
	and CONVERT(varchar,��ְ����,112)>=CONVERT(varchar,@��ʼ����,112)
	and CONVERT(varchar,��ְ����,112)<=CONVERT(varchar,@��������,112)
	
	return @����
end
GO

USE [DuoweiEdu_Salary_New]
GO

/****** Object:  UserDefinedFunction [dbo].[����������]    Script Date: 09/24/2018 12:13:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter function [dbo].[����������](@���� varchar(50))
returns int
as
begin
	declare @���� int
	select @����=SUM(isnull(ʵ������,����))
	from �·ݿ�ʱ�˴������
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	
	return @����
end

GO



alter function dbo.�������˴�(@���� varchar(50))
returns int
as
begin
	declare @�˴� int
	select @�˴�=SUM(�˴�)
	from �·ݿ�ʱ�˴������
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	
	return @�˴�
end
GO

alter function dbo.���������˴�(@���� varchar(50))
returns int
as
begin
	declare @�˴� int,@�ϸ����� varchar(50)
	set @�ϸ�����=dbo.�ϸ�����(@����)
	
	select @�˴�=SUM(����״̬)
	from �·ݿ��ڱ�
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	and ѧ����� in (select ѧ����� from �·ݿ��ڱ� where (LTRIM(rtrim(str(���)))+'��'+����=@�ϸ����� or ����=@�ϸ�����))
						
	return @�˴�
end
GO

alter function dbo.����ѧ����(@���� varchar(50))
returns int
as
begin
	declare @���� int
	select @����=COUNT(*)
	from 
	(select ѧ����� 
	from �·ݿ��ڱ�
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	group by ѧ�����
	) a
	
	return @����
end
GO

alter function dbo.��������ѧ����(@���� varchar(50))
returns int
as
begin
	declare @���� int,@�ϸ����� varchar(50)
	set @�ϸ�����=dbo.�ϸ�����(@����)
	
	select @����=COUNT(*)
	from 
	(select ѧ�����
	from �·ݿ��ڱ�
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	and ѧ����� in (select ѧ����� from �·ݿ��ڱ� where (LTRIM(rtrim(str(���)))+'��'+����=@�ϸ����� or ����=@�ϸ�����))
	group by ѧ�����
	) a
						
	return @����
end
GO


alter function dbo.���������˴�(@���� varchar(50))
returns int
as
begin
	declare @�˴� int,@�ϸ����� varchar(50)
	set @�ϸ�����=dbo.�ϸ�����(@����)
	
	select @�˴�=SUM(����״̬)
	from �·ݿ��ڱ�
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	and ѧ����� not in (select ѧ����� from �·ݿ��ڱ� where (LTRIM(rtrim(str(���)))+'��'+����=@�ϸ����� or ����=@�ϸ�����))
						
	return @�˴�
end
GO

create function dbo.�ϸ�����(@���� varchar(50))
returns varchar(50)
as
begin
	declare @�ϸ����� varchar(50)
	set @�ϸ�����=(case when @����='2017���＾��' then '2017����ٰ�'
						when @����='2018�꺮�ٰ�' then '2017���＾��'
						when @����='2018�괺����' then '2018�꺮�ٰ�'
						when @����='2018����ٰ�' then '2018�괺����'
						when @����='2018���＾��' then '2018����ٰ�'
						else '' end)
	return @�ϸ�����
end
GO

alter function dbo.������������(@���� varchar(50))
returns int
as
begin
	declare @���� int,@�ϸ����� varchar(50)
	set @�ϸ�����=dbo.�ϸ�����(@����)
	
	select @����=COUNT(*)
	from
	(select ѧ�����
	from �·ݿ��ڱ�
	where (LTRIM(rtrim(str(���)))+'��'+����=@���� or ����=@����)
	and ѧ����� not in (select ѧ����� from �·ݿ��ڱ� where (LTRIM(rtrim(str(���)))+'��'+����=@�ϸ����� or ����=@�ϸ�����))
	group by ѧ�����
	) a
						
	return @����
end
GO

create function dbo.�ϸ�ͬ�ȼ���(@���� varchar(50))
returns varchar(50)
as
begin
	declare @�ϸ����� varchar(50)
	set @�ϸ�����=(case when @����='2017���＾��' then '2016���＾��'
						when @����='2018�꺮�ٰ�' then '2017�꺮�ٰ�'
						when @����='2018�괺����' then '2017�괺����'
						when @����='2018����ٰ�' then '2017����ٰ�'
						when @����='2018���＾��' then '2017���＾��'
						else '' end)
	return @�ϸ�����
end
GO

GO
select *
,dbo.������ְ����(��ʼ����,��������) as ��ְ����
,dbo.������ְ����(��ʼ����,��������) as ��ְ����
,1.000*dbo.������ְ����(��ʼ����,��������)/dbo.������ְ����(��ʼ����,��������) as Ա����ʧ��
,dbo.����������(����) as ������
,dbo.����������(����)/dbo.������ְ����(��ʼ����,��������) as �˾�����
,dbo.�������˴�(����) as ���˴�
,dbo.����ѧ����(����) as ѧ����
,dbo.���������˴�(����) as �����˴�
,dbo.��������ѧ����(����) as ����ѧ����
,1.000*dbo.���������˴�(����)/dbo.�������˴�(����) as �˴�������
,1.000*dbo.��������ѧ����(����)/dbo.����ѧ����(����) as ��ͷ������
,dbo.���������˴�(����) as �����˴�
,dbo.������������(����) as ��������
,dbo.���������˴�(dbo.�ϸ�����(����)) as �ϼ������˴�
,dbo.������������(dbo.�ϸ�����(����)) as �ϼ���������
,1.000*dbo.���������˴�(����)/dbo.���������˴�(dbo.�ϸ�����(����)) as �����˴�������
,1.000*dbo.������������(����)/dbo.������������(dbo.�ϸ�����(����)) as ������ͷ������
,dbo.����������(dbo.�ϸ�����(����)) as �ϼ�����
,1.000*dbo.����������(����)/dbo.����������(dbo.�ϸ�����(����)) as ��������������
,dbo.����������(dbo.�ϸ�ͬ�ȼ���(����)) as �ϼ�ͬ������
,1.000*dbo.����������(����)/dbo.����������(dbo.�ϸ�ͬ�ȼ���(����)) as ����ͬ������������
from ���ȱ�
order by ��ʼ����