declare @姓名 varchar(50),@金额 numeric(11,2),@学号 varchar(50),@cursor cursor
declare @收据号 varchar(50),@新收据号 varchar(50)
set @cursor=cursor for
select a.姓名,a.金额,b.学号
from [Sheet1$] a
	left join 学员信息表 b on a.姓名=b.姓名
open @cursor
fetch next from @cursor into @姓名,@金额,@学号
while @@FETCH_STATUS=0
begin
	set @收据号=dbo.WiseMis_GetNewId('税务收据号',null)
	set @新收据号=dbo.WiseMis_GetNewId('新收据号',null)
	--生成收据主体
	insert into 税务_收据(收据号,新收据号, 学号, 姓名, 年级, 交费日期, 校区名称,季度, 经手人, 收据类型, 收款账号, 签单类型,CreateUser,CreateTime)
			values (@收据号,@新收据号,@学号,@姓名,'六年级','2018-07-28','莞城校区','其他','GCY','交费','刷卡','续费','GCY','2018-07-28')
	insert into 税务_收据明细(校区名称,季度,收据号, 学号, 姓名, 课程名称, 课时数, 课时费, 标准课时费, 金额,单位,CreateUser,CreateTime)
		values ('莞城校区','其他',@收据号,@学号,@姓名,'五升六年级暑假训练营',1,@金额,@金额,@金额,'期','GCY','2018-07-28')
	--生成收据明细
	exec WiseMis_SetNewId '税务收据号',@收据号
	exec WiseMis_SetNewId '新收据号',@新收据号
	fetch next from @cursor into @姓名,@金额,@学号
end
close @cursor
deallocate @cursor