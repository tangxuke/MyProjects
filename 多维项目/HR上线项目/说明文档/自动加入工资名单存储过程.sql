create proc ADDGZRY @PATTABLE VARCHAR(20),@PAT_ID INT,@YM VARCHAR(20),@A_ID INT as
begin

declare @start_date varchar(20),@end_date varchar(20),@rs int,@start_date1 varchar(20),@end_date1 varchar(20)
declare @ry1 varchar(1000),@bm varchar(2000),@startdate datetime,@enddate datetime
select @ry1=condictionry_v,@bm=condictiondept from GZ_PATTAB where PAT_ID=@PAT_id


select @start_date=convert(varchar(10),cast(@YM+'01' as datetime),126)
select @end_date=convert(varchar(10),dateadd(dd,-1,dateadd(mm,1,cast(@YM+'01' as datetime))),126)
set @start_date1=''''+@start_date+''''
set @end_date1=''''+@end_date+''''
select @ry1=REPLACE(@ry1,'[start_date]',@start_date1)
select @ry1=REPLACE(@ry1,'[end_date]',@end_date1)
select @startdate=cast(@YM+'01' as datetime)
select @enddate=dateadd(dd,-1,dateadd(mm,1,cast(@YM+'01' as datetime)))



if OBJECT_ID('gzrs')>0
drop table gzrs
exec('select COUNT(1) rs into gzrs from '+@PATTABLE+' where 1=1')
select @rs=rs from gzrs

--select @start_date

EXEC('INSERT '+@PATTABLE+'(A0188,GZ_YM,A_ID,KGUID,DEPT_ID,A0191,A0190,A0101,PAT_ID,start_date,end_date,flag,used)
SELECT A0188,'+@ym+','+@A_ID+',NEWID(),DEPT_ID,A0191,A0190,A0101,'+@PAT_ID+','''+@startdate+''','''+@enddate+''',0,0 FROM A01
WHERE A0188 in('+@ry1+')
and dept_id in(select dept_id from deptcode where '+@bm+')
and a0188 not in(select a0188 from '+@PATTABLE+' where gz_ym='+@ym+')')


if OBJECT_ID('gzrs')>0
drop table gzrs
exec('select COUNT(1) rs into gzrs from '+@PATTABLE+' where 1=1')
declare @rs2 int
select @rs2=rs from gzrs


select '此次共成功加入'+CAST(@rs2-@rs as varchar(4))+'人'


end



--truncate table gzpat2

--select * from gzpat2

SELECT * FROM C083

UPDATE C083 SET C083013=NULL
UPDATE C083 SET SIGNED=0