alter table 税务_收据明细 disable trigger all
GO
update 税务_收据 set 交费日期2=null where 校区名称='光明校区' and year(交费日期)=2018 and month(交费日期)=6
GO
declare @学号 varchar(50),@季度 varchar(50),@交费日期 datetime,@交费金额 numeric(11,2),@cursor cursor,@收据号 varchar(50),@新收据号 varchar(50),@收据号2 varchar(50)
set @cursor=cursor for
select 收据号,新收据号,学号,季度,交费日期,交费金额 from 税务_收据2 where 校区名称='光明校区'
open @cursor
fetch next from @cursor into @收据号,@新收据号,@学号,@季度,@交费日期,@交费金额
while @@fetch_status=0
begin
	if exists(select * from 税务_收据 where 校区名称='光明校区' and year(交费日期)=2018 and month(交费日期)=6 and (交费日期2 is null) and 季度=@季度 and 学号=@学号)
	begin
		select top 1 @收据号2=收据号 from 税务_收据 where 校区名称='光明校区' and year(交费日期)=2018 and month(交费日期)=6 and (交费日期2 is null) and 季度=@季度 and 学号=@学号
		update 税务_收据 set 交费日期2=@交费日期,交费金额2=@交费金额 where 收据号=@收据号2
	end
	else
	begin
		insert into 税务_收据(收据号, 新收据号, 学号, 姓名, 年级, 交费金额, 电子账户, 现金, 刷卡, 微信, 支付宝, 直减金额, 折扣金额, 交费日期, 校区名称, 季度, 经手人, 状态, 收据类型, 收款账号, 签单类型, 发票号, 业绩归属人, Remark, CreateUser, CreateTime, __record__guid__, 交费日期2, 交费金额2)
			select 收据号, 新收据号, 学号, 姓名, 年级, 交费金额, 电子账户, 现金, 刷卡, 微信, 支付宝, 直减金额, 折扣金额, 交费日期, '光明校区', 季度, 经手人, 状态, 收据类型, 收款账号, 签单类型, 发票号, 业绩归属人, Remark, CreateUser, CreateTime, __record__guid__, @交费日期, @交费金额
			from 税务_收据2
			where 收据号=@收据号
		insert into 税务_收据明细(收据号, 校区名称, 季度, 学号, 姓名, 课程名称, 班级类型, 课时数, 单位, 课时费, 标准课时费, 金额, Remark, CreateUser, CreateTime)
			select @收据号, '光明校区', @季度, 学号, 姓名, 课程名称, 班级类型, 课时数, 单位, 课时费, 标准课时费, 金额, Remark, CreateUser, CreateTime
			from 收据明细
			where 收据号=(select top 1 收据号 from 收据 where 学号=@学号 and 季度=@季度 and 交费金额=@交费金额 and year(交费日期)=2018)
	end
	fetch next from @cursor into @收据号,@新收据号,@学号,@季度,@交费日期,@交费金额
end
close @cursor
deallocate @cursor

GO

alter table 税务_收据明细 disable trigger all
GO