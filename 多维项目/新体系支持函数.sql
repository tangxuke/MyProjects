
alter function dbo.��Ա״̬(@��� int,@�·� int,@У�� varchar(50),@ְԱ���� varchar(50),@��ѯ�� int)
returns bit
as
begin
	/**
	* ���ݲ�ѯ�룬��ѯ��Ա״̬
	* ��ѯ��=1�������Ƿ��³���ְ��Ա
	* ��ѯ��=2�������Ƿ�������Ա
	* ��ѯ��=3�������Ƿ���ְ��Ա
	* ��ѯ��=4�������Ƿ������Ա
	* ��ѯ��=5�������Ƿ������Ա
	* ��ѯ��=6�������Ƿ��µ���ְ��Ա
	* ��ѯ��=7�������Ƿ���������ְ��Ա
	*/
	declare @״̬�� bit,@������� int,@�����·� int
	select top 1 @�������=���,@�����·�=�·� from ���ʱ� where ���*12+�·�<@���*12+@�·� order by ���*12+�·� desc
	
	
	set @״̬��=(case
				--��ѯ��=1�������Ƿ��³���ְ��Ա
				when @��ѯ��=1 then (case when exists(select * from ���ʱ� where У��=@У�� and ���=@������� and �·�=@�����·� and ְԱ����=@ְԱ���� and isnull(��ְ��,0)=0) then 1 else 0 end)
				--��ѯ��=2�������Ƿ�������Ա
				when @��ѯ��=2 then (case when exists(select * from ���ʱ� where У��=@У�� and ���=@��� and �·�=@�·� and ְԱ����=@ְԱ���� and year(��ְʱ��)=@��� and MONTH(��ְʱ��)=@�·�) then 1 else 0 end)
				--��ѯ��=3�������Ƿ���ְ��Ա
				when @��ѯ��=3 then (case when exists(select * from ���ʱ� where У��=@У�� and ���=@��� and �·�=@�·� and ְԱ����=@ְԱ���� and isnull(��ְ��,0)=1 and year(��ְ����)=@��� and MONTH(��ְ����)=@�·�) then 1 else 0 end)
				--��ѯ��=4�������Ƿ������Ա
				when @��ѯ��=4 then (case when exists(select * from ���ʱ� where У��<>@У�� and ���=@��� and �·�=@�·� and ְԱ����=@ְԱ����) 
											and exists(select * from ���ʱ� where У��=@У�� and ���=@������� and �·�=@�����·� and ְԱ����=@ְԱ����)
									then 1 else 0 end)
				--��ѯ��=5�������Ƿ������Ա
				when @��ѯ��=5 then (case when exists(select * from ���ʱ� where У��=@У�� and ���=@��� and �·�=@�·� and ְԱ����=@ְԱ����) 
											and exists(select * from ���ʱ� where У��<>@У�� and ���=@������� and �·�=@�����·� and ְԱ����=@ְԱ����)
									then 1 else 0 end)
				--��ѯ��=6�������Ƿ��µ���ְ��Ա
				when @��ѯ��=6 then (case when exists(select * from ���ʱ� where У��=@У�� and ���=@��� and �·�=@�·� and ְԱ����=@ְԱ���� and isnull(��ְ��,0)=0) then 1 else 0 end)
				--��ѯ��=7�������Ƿ���������ְ��Ա��������Ϊ2����
				when @��ѯ��=7 then 
							(case when exists(
														select * 
														from ���ʱ� 
														where У��=@У�� 
														and ���=@��� 
														and �·�=@�·� 
														and ְԱ����=@ְԱ���� 
														and isnull(��ְ��,0)=1 
														and year(��ְ����)=@��� 
														and MONTH(��ְ����)=@�·�
														and datediff(dd,��ְʱ��,��ְ����)<=60
														) 
														then 1 else 0 end)
				else 0
				end)
	
	
	return @״̬��
end

GO

alter function dbo.�ϸ�����(@���� varchar(6))
returns varchar(6)
as
begin
	declare @�ϸ����� varchar(6)
	select top 1 @�ϸ�����=����
	from ���ʱ�
	where ����<@����
	order by ���� desc
	
	return @�ϸ�����
end
GO