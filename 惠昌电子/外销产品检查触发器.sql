declare @name varchar(50),@cursor cursor,@tr_name varchar(50),@createsql varchar(4000)

set @cursor=cursor for
select name from sysobjects where name like 'tr_外销_%' and xtype='TR'
open @cursor
fetch next from @cursor into @name
while @@fetch_status=0
begin
	exec('drop trigger ['+@name+']')
	fetch next from @cursor into @name
end
close @cursor
deallocate @cursor


set @cursor=cursor for
select name from sysobjects where ObjectProperty(id,'IsUserTable')=1 and exists(select * from syscolumns where id=sysobjects.id and name in ('cpbh')) and name not like '%_Log' and name not like '邓生_%'
open @cursor
fetch next from @cursor into @name
while @@fetch_status=0
begin
	set @tr_name='tr_外销_'+@name
	if exists(select * from sysobjects where name=@tr_name and xtype='TR')
		exec('drop trigger ['+@tr_name+']')
	set @createsql='
create trigger dbo.['+@tr_name+'] on ['+@name+']
for insert,update
as
declare @cpbh varchar(50),@message varchar(200)
if exists(select * from inserted where exists(select * from cpzd with(nolock) where cpbh=inserted.cpbh) and not exists(select * from cpzd with(nolock) where cpbh=inserted.cpbh and saleDesc=''外销''))
begin
	set @cpbh=(select top 1 cpbh from inserted where exists(select * from cpzd with(nolock) where cpbh=inserted.cpbh) and not exists(select * from cpzd with(nolock) where cpbh=inserted.cpbh and saleDesc=''外销''))
	set @message=''{b}【''+@cpbh+''】不是外销产品，请确认！{e}''
	raiserror(@message,18,1)
	rollback
end
	'
	exec(@createsql)
	fetch next from @cursor into @name
end
close @cursor
deallocate @cursor


set @cursor=cursor for
select name from sysobjects where ObjectProperty(id,'IsUserTable')=1 and exists(select * from syscolumns where id=sysobjects.id and name in ('产品编号')) and name not like '%_Log' and name not like '邓生_%'
open @cursor
fetch next from @cursor into @name
while @@fetch_status=0
begin
	set @tr_name='tr_外销_'+@name
	if exists(select * from sysobjects where name=@tr_name and xtype='TR')
		exec('drop trigger ['+@tr_name+']')
	set @createsql='
create trigger dbo.['+@tr_name+'] on ['+@name+']
for insert,update
as
declare @cpbh varchar(50),@message varchar(200)
if exists(select * from inserted where exists(select * from cpzd with(nolock) where cpbh=inserted.产品编号) and not exists(select * from cpzd with(nolock) where cpbh=inserted.产品编号 and saleDesc=''外销''))
begin
	set @cpbh=(select top 1 产品编号 from inserted where exists(select * from cpzd with(nolock) where cpbh=inserted.产品编号) and not exists(select * from cpzd with(nolock) where cpbh=inserted.产品编号 and saleDesc=''外销''))
	set @message=''{b}【''+@cpbh+''】不是外销产品，请确认！{e}''
	raiserror(@message,18,1)
	rollback
end
	'
	exec(@createsql)
	fetch next from @cursor into @name
end
close @cursor
deallocate @cursor