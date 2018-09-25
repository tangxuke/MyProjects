LOCAL o as zkemkeeper.IZKEM
o=CREATEOBJECT("zkemkeeper.ZKEM")

SET DATE SHORT 
*!*连接数据库
=SQLSETPROP(0,"Transactions",2)
LOCAL nHandle
nHandle=SQLSTRINGCONNECT("Driver={SQL Server};Server=200.200.200.3;Database=HRDB1;Uid=sa;Pwd=iced_lotus")
IF nHandle<1
	RETURN
ENDIF

LOCAL cRsCursor
cRsCursor=SYS(2015)
IF SQLEXEC(nHandle,"exec 更新考勤名单",cRsCursor)<1
	RETURN
ENDIF

*!*上传上次失败的记录
IF FILE("C:\CardRecord.txt")
	LOCAL cLastError,cNewLastError
	cNewLastError=""
	cLastError=FILETOSTR("C:\CardRecord.txt")
	IF !EMPTY(cLastError)
		LOCAL nLines,cLine,cErrorSQL,cNewErrorSQL
		cNewErrorSQL=""
		cErrorSQL=""
		nLineCount=0
		nLines=ALINES(arr,cLastError)
		FOR nLine=1 TO nLines
			cLine=arr[nLine]
			nLineCount = nLineCount + 1
			cErrorSQL = cErrorSQL + CHR(13) + CHR(10) + cLine
			IF nLineCount>=100
				IF SQLEXEC(nHandle,cErrorSQL)<1
					cNewErrorSQL = cNewErrorSQL + CHR(13) + CHR(10) + cErrorSQL
					=SQLROLLBACK(nHandle)
				ELSE
					IF SQLCOMMIT(nHandle)<>1
						cNewErrorSQL = cNewErrorSQL + CHR(13) + CHR(10) + cErrorSQL
					ENDIF
				ENDIF
				cErrorSQL = ""
				nLineCount=0
			ENDIF
		ENDFOR
		IF !EMPTY(cErrorSQL)
			IF SQLEXEC(nHandle,cErrorSQL)<1
				cNewErrorSQL = cNewErrorSQL + CHR(13) + CHR(10) + cErrorSQL
				=SQLROLLBACK(nHandle)
			ELSE
				IF SQLCOMMIT(nHandle)<>1
					cNewErrorSQL = cNewErrorSQL + CHR(13) + CHR(10) + cErrorSQL
				ENDIF
			ENDIF
		ENDIF
		=STRTOFILE("","C:\CardRecord.txt")
		IF !EMPTY(cNewErrorSQL)
			=STRTOFILE(cNewErrorSQL,"C:\CardRecord.txt",0)
		ENDIF
	ENDIF
ENDIF

LOCAL cTempCursor
cTempCursor=SYS(2015)
IF SQLEXEC(nHandle,"select * from 考勤机表 where ISNULL(禁用否,0)=0 and 脱机模式=1",cTempCursor)<1
	=SQLDISCONNECT(nHandle)
	RETURN
ENDIF
SELECT (cTempCursor)
SCAN
	SELECT (cTempCursor)
	LOCAL cJihao,cIP,bUseCard,bUseFinger,nGhLength
	cJihao=ALLTRIM(考勤机号)
	cIP=ALLTRIM(IP地址)
	bUseCard=NVL(刷卡,.f.)
	bUseFinger=NVL(指纹,.f.)
	nGhLength=NVL(工号位数,6)

	*!*连接考勤机
	IF !o.Connect_Net(cIP,4370)
		LOOP
	ENDIF
	
	*!*暂停考勤机正常作业
	o.EnableDevice(0,.f.)

	*!*读取考勤记录
	IF o.ReadAllGLogData(0)

		LOCAL dwEnrollNumber,dwVerifyMode,dwInOutMode,dwYear,dwMonth,dwDay,dwHour,dwMinute,dwSecond,dwWorkcode
		dwEnrollNumber=""
		dwVerifyMode=0
		dwInOutMode=0
		dwYear=0
		dwMonth=0
		dwDay=0
		dwHour=0
		dwMinute=0
		dwSecond=0
		dwWorkcode=0

		LOCAL tRecordTime	&&刷卡时间
		LOCAL nRecordCount
		nRecordCount=0
		LOCAL cSQL
		cSQL=""
		DO WHILE o.SSR_GetGeneralLogData(0,@dwEnrollNumber,@dwVerifyMode,@dwInOutMode,@dwYear,@dwMonth,@dwDay,@dwHour,@dwMinute,@dwSecond,@dwWorkcode)
			tRecordTime=DATETIME(dwYear,dwMonth,dwDay,dwHour,dwMinute,dwSecond)

			*!*记录
			nRecordCount = nRecordCount + 1
			cSQL = cSQL + CHR(13) + CHR(10) + "insert into 考勤表(考勤机号,用户ID,刷卡时间) values ('"+cJihao+"','"+TRANSFORM(dwEnrollNumber)+"','"+TRANSFORM(tRecordTime)+"')"
			IF nRecordCount>=100
				_cliptext=cSQL
				IF SQLEXEC(nHandle,cSQL)<1
					=STRTOFILE(cSQL,"C:\CardRecord.txt",1)
					=SQLROLLBACK(nHandle)
				ELSE
					IF SQLCOMMIT(nHandle)<>1
						=STRTOFILE(cSQL,"C:\CardRecord.txt",1)
					ENDIF
				ENDIF
				cSQL=""
				nRecordCount=0
			ENDIF
		ENDDO

		IF !EMPTY(cSQL)
			_cliptext=cSQL
			IF SQLEXEC(nHandle,cSQL)<1
				=STRTOFILE(cSQL,"C:\CardRecord.txt",1)
				=SQLROLLBACK(nHandle)
			ELSE
				IF SQLCOMMIT(nHandle)<>1
					=STRTOFILE(cSQL,"C:\CardRecord.txt",1)
				ENDIF
			ENDIF
		ENDIF

		*!*清空考勤机数据
		o.ClearGLog(0)
	ENDIF
	
	*!*更新名单
	*删除考勤机内名单
	o.ClearData(0,5)
	*!*开始批量上传
	IF !o.BeginBatchUpdate(0,1)
		LOOP 
	ENDIF 
	*上传新名单
	SELECT (cRsCursor)
	SCAN 
		WAIT WINDOW "正在更新名单到考勤机"+cJihao+"……"+TRANSFORM(RECNO())+"/"+TRANSFORM(RECCOUNT()) NOWAIT NOCLEAR 
		IF bUseCard
			=o.SetStrCardNumber(ALLTRIM(TRANSFORM(IC卡号)))
		ENDIF 
		LOCAL cGH
		cGH=RIGHT(ALLTRIM(工号),nGhLength)
		=o.SSR_SetUserInfo(0,cGH,ALLTRIM(姓名),"",0,.t.)
		IF bUseFinger AND LEN(NVL(指纹1,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,0,ALLTRIM(指纹1))
		ENDIF 
		IF bUseFinger AND LEN(NVL(指纹2,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,1,ALLTRIM(指纹2))
		ENDIF 
		IF bUseFinger AND LEN(NVL(指纹3,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,2,ALLTRIM(指纹3))
		ENDIF 
	ENDSCAN 
	*!*批量上传
	=o.BatchUpdate(0)
	*!*恢复考勤机正常作业
	o.EnableDevice(0,.t.)
	=o.RefreshData(0)
	=o.Disconnect()
ENDSCAN
SELECT (cTempCursor)
USE
SELECT (cRsCursor)
USE

WAIT CLEAR 
*!*断开连接
*!*执行自动打卡
LOCAL cSQL
TEXT TO cSQL NOSHOW TEXTMERGE 
--password

declare @工号 char(6)
set @工号='000027'
declare @日期 datetime
set @日期=cast(left(convert(varchar,getdate(),120),10)+' 23:59:59' as datetime)
declare @姓名 varchar(50),@分组号 varchar(50),@客户端 varchar(50),@指纹组别 char(1)
select @姓名=姓名,@分组号=分组号,@指纹组别=指纹组别 from rszd where 工号=@工号
set @客户端=(select top 1 考勤机号 from 考勤机表 where 脱机模式=1 and 指纹=1 and 组别=@指纹组别)

declare @刷卡日期 char(6),@刷卡时间 char(8),@班次日期 char(8)
SET @班次日期=convert(varchar,@日期,112)

declare @应上班 bit,@加班 bit,@加班工时 int,@理论早上上班 datetime,@理论早上下班 datetime,@理论下午上班 datetime,@理论下午下班 datetime,@理论加班上班 datetime
declare @早上上班 datetime,@早上下班 datetime,@下午上班 datetime,@下午下班 datetime,@加班上班 datetime,@加班下班 datetime
set @理论早上上班=dbo.查询理论上班时间(@工号,@日期,'早上上班')
set @理论早上下班=dbo.查询理论上班时间(@工号,@日期,'早上下班')
set @理论下午上班=dbo.查询理论上班时间(@工号,@日期,'下午上班')
set @理论下午下班=dbo.查询理论上班时间(@工号,@日期,'下午下班')
set @理论加班上班=dbo.查询理论上班时间(@工号,@日期,'晚上加班')

set @早上上班=dbo.查询打卡时间5(@工号,@日期,'早上上班')
set @早上下班=dbo.查询打卡时间5(@工号,@日期,'早上下班')
set @下午上班=dbo.查询打卡时间5(@工号,@日期,'下午上班')
set @下午下班=dbo.查询打卡时间5(@工号,@日期,'下午下班')
set @加班上班=dbo.查询打卡时间5(@工号,@日期,'加班上班')
set @加班下班=dbo.查询打卡时间5(@工号,@日期,'加班下班')

set @应上班=dbo.是否应上班(@工号,@日期)
if exists(select * from 加班申请明细 where 工号=@工号 and 申请单号 in (select 申请单号 from 加班申请单 where 审核=1 and convert(varchar,申请日期,112)=convert(varchar,@日期,112)))
	set @加班=1
else
	set @加班=0

if @加班=1
	set @加班工时=(select top 1 (case when 工时>16 then 16 else 工时 end)*60 from 加班申请明细 where 工号=@工号 and 申请单号 in (select 申请单号 from 加班申请单 where 审核=1 and convert(varchar,申请日期,112)=convert(varchar,@日期,112)))
else
	set @加班工时=0

if @应上班=1 or @加班=1
begin
	set @刷卡日期=convert(varchar,@日期,12)
	--早上上班
	set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@理论早上上班)),108)
	if @日期>@理论早上上班 and (@早上上班 is null or @早上上班>@理论早上上班)
		insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'A1',@客户端,@班次日期)
	--早上下班
	set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),@理论早上下班),108)
	if @日期>@理论早上下班 and (@早上下班 is null or @早上下班<@理论早上下班)
		insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'A0',@客户端,@班次日期)
	--下午上班
	set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@理论下午上班)),108)
	if @日期>@理论下午上班 and (@下午上班 is null or @下午上班>@理论下午上班)
		insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'B1',@客户端,@班次日期)
	--下午下班
	set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),@理论下午下班),108)
	if @日期>@理论下午下班 and (@下午下班 is null or @下午下班<@理论下午下班)
		insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'B0',@客户端,@班次日期)
	--加班
	if @加班=1 and @应上班=1
	begin
		--加班上班
		set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@理论加班上班)),108)
		if @日期>@理论加班上班 and (@加班上班 is null or @加班上班>@理论加班上班)
			insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'C1',@客户端,@班次日期)
		--加班下班
		set @刷卡时间=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,@加班工时*60+7,@理论加班上班)),108)
		if @日期>dateadd(ss,15*60*rand(),dateadd(mi,@加班工时*60+7,@理论加班上班)) and (@加班下班 is null or @加班下班<dateadd(ss,15*60*rand(),dateadd(mi,@加班工时*60+7,@理论加班上班)))
			insert into hr_kq_data(工号,姓名,分组号,日期,时间,班次,客户端,班次日期) values (@工号,@姓名,@分组号,@刷卡日期,@刷卡时间,'C0',@客户端,@班次日期)
	end
end

ENDTEXT 
=SQLEXEC(nHandle,cSQL)
=SQLDISCONNECT(nHandle)
