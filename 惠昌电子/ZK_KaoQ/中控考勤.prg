LOCAL o as zkemkeeper.IZKEM
o=CREATEOBJECT("zkemkeeper.ZKEM")

SET DATE SHORT 
*!*�������ݿ�
=SQLSETPROP(0,"Transactions",2)
LOCAL nHandle
nHandle=SQLSTRINGCONNECT("Driver={SQL Server};Server=200.200.200.3;Database=HRDB1;Uid=sa;Pwd=iced_lotus")
IF nHandle<1
	RETURN
ENDIF

LOCAL cRsCursor
cRsCursor=SYS(2015)
IF SQLEXEC(nHandle,"exec ���¿�������",cRsCursor)<1
	RETURN
ENDIF

*!*�ϴ��ϴ�ʧ�ܵļ�¼
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
IF SQLEXEC(nHandle,"select * from ���ڻ��� where ISNULL(���÷�,0)=0 and �ѻ�ģʽ=1",cTempCursor)<1
	=SQLDISCONNECT(nHandle)
	RETURN
ENDIF
SELECT (cTempCursor)
SCAN
	SELECT (cTempCursor)
	LOCAL cJihao,cIP,bUseCard,bUseFinger,nGhLength
	cJihao=ALLTRIM(���ڻ���)
	cIP=ALLTRIM(IP��ַ)
	bUseCard=NVL(ˢ��,.f.)
	bUseFinger=NVL(ָ��,.f.)
	nGhLength=NVL(����λ��,6)

	*!*���ӿ��ڻ�
	IF !o.Connect_Net(cIP,4370)
		LOOP
	ENDIF
	
	*!*��ͣ���ڻ�������ҵ
	o.EnableDevice(0,.f.)

	*!*��ȡ���ڼ�¼
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

		LOCAL tRecordTime	&&ˢ��ʱ��
		LOCAL nRecordCount
		nRecordCount=0
		LOCAL cSQL
		cSQL=""
		DO WHILE o.SSR_GetGeneralLogData(0,@dwEnrollNumber,@dwVerifyMode,@dwInOutMode,@dwYear,@dwMonth,@dwDay,@dwHour,@dwMinute,@dwSecond,@dwWorkcode)
			tRecordTime=DATETIME(dwYear,dwMonth,dwDay,dwHour,dwMinute,dwSecond)

			*!*��¼
			nRecordCount = nRecordCount + 1
			cSQL = cSQL + CHR(13) + CHR(10) + "insert into ���ڱ�(���ڻ���,�û�ID,ˢ��ʱ��) values ('"+cJihao+"','"+TRANSFORM(dwEnrollNumber)+"','"+TRANSFORM(tRecordTime)+"')"
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

		*!*��տ��ڻ�����
		o.ClearGLog(0)
	ENDIF
	
	*!*��������
	*ɾ�����ڻ�������
	o.ClearData(0,5)
	*!*��ʼ�����ϴ�
	IF !o.BeginBatchUpdate(0,1)
		LOOP 
	ENDIF 
	*�ϴ�������
	SELECT (cRsCursor)
	SCAN 
		WAIT WINDOW "���ڸ������������ڻ�"+cJihao+"����"+TRANSFORM(RECNO())+"/"+TRANSFORM(RECCOUNT()) NOWAIT NOCLEAR 
		IF bUseCard
			=o.SetStrCardNumber(ALLTRIM(TRANSFORM(IC����)))
		ENDIF 
		LOCAL cGH
		cGH=RIGHT(ALLTRIM(����),nGhLength)
		=o.SSR_SetUserInfo(0,cGH,ALLTRIM(����),"",0,.t.)
		IF bUseFinger AND LEN(NVL(ָ��1,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,0,ALLTRIM(ָ��1))
		ENDIF 
		IF bUseFinger AND LEN(NVL(ָ��2,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,1,ALLTRIM(ָ��2))
		ENDIF 
		IF bUseFinger AND LEN(NVL(ָ��3,""))>0
			=o.SSR_SetUserTmpStr(0,cGH,2,ALLTRIM(ָ��3))
		ENDIF 
	ENDSCAN 
	*!*�����ϴ�
	=o.BatchUpdate(0)
	*!*�ָ����ڻ�������ҵ
	o.EnableDevice(0,.t.)
	=o.RefreshData(0)
	=o.Disconnect()
ENDSCAN
SELECT (cTempCursor)
USE
SELECT (cRsCursor)
USE

WAIT CLEAR 
*!*�Ͽ�����
*!*ִ���Զ���
LOCAL cSQL
TEXT TO cSQL NOSHOW TEXTMERGE 
--password

declare @���� char(6)
set @����='000027'
declare @���� datetime
set @����=cast(left(convert(varchar,getdate(),120),10)+' 23:59:59' as datetime)
declare @���� varchar(50),@����� varchar(50),@�ͻ��� varchar(50),@ָ����� char(1)
select @����=����,@�����=�����,@ָ�����=ָ����� from rszd where ����=@����
set @�ͻ���=(select top 1 ���ڻ��� from ���ڻ��� where �ѻ�ģʽ=1 and ָ��=1 and ���=@ָ�����)

declare @ˢ������ char(6),@ˢ��ʱ�� char(8),@������� char(8)
SET @�������=convert(varchar,@����,112)

declare @Ӧ�ϰ� bit,@�Ӱ� bit,@�Ӱ๤ʱ int,@���������ϰ� datetime,@���������°� datetime,@���������ϰ� datetime,@���������°� datetime,@���ۼӰ��ϰ� datetime
declare @�����ϰ� datetime,@�����°� datetime,@�����ϰ� datetime,@�����°� datetime,@�Ӱ��ϰ� datetime,@�Ӱ��°� datetime
set @���������ϰ�=dbo.��ѯ�����ϰ�ʱ��(@����,@����,'�����ϰ�')
set @���������°�=dbo.��ѯ�����ϰ�ʱ��(@����,@����,'�����°�')
set @���������ϰ�=dbo.��ѯ�����ϰ�ʱ��(@����,@����,'�����ϰ�')
set @���������°�=dbo.��ѯ�����ϰ�ʱ��(@����,@����,'�����°�')
set @���ۼӰ��ϰ�=dbo.��ѯ�����ϰ�ʱ��(@����,@����,'���ϼӰ�')

set @�����ϰ�=dbo.��ѯ��ʱ��5(@����,@����,'�����ϰ�')
set @�����°�=dbo.��ѯ��ʱ��5(@����,@����,'�����°�')
set @�����ϰ�=dbo.��ѯ��ʱ��5(@����,@����,'�����ϰ�')
set @�����°�=dbo.��ѯ��ʱ��5(@����,@����,'�����°�')
set @�Ӱ��ϰ�=dbo.��ѯ��ʱ��5(@����,@����,'�Ӱ��ϰ�')
set @�Ӱ��°�=dbo.��ѯ��ʱ��5(@����,@����,'�Ӱ��°�')

set @Ӧ�ϰ�=dbo.�Ƿ�Ӧ�ϰ�(@����,@����)
if exists(select * from �Ӱ�������ϸ where ����=@���� and ���뵥�� in (select ���뵥�� from �Ӱ����뵥 where ���=1 and convert(varchar,��������,112)=convert(varchar,@����,112)))
	set @�Ӱ�=1
else
	set @�Ӱ�=0

if @�Ӱ�=1
	set @�Ӱ๤ʱ=(select top 1 (case when ��ʱ>16 then 16 else ��ʱ end)*60 from �Ӱ�������ϸ where ����=@���� and ���뵥�� in (select ���뵥�� from �Ӱ����뵥 where ���=1 and convert(varchar,��������,112)=convert(varchar,@����,112)))
else
	set @�Ӱ๤ʱ=0

if @Ӧ�ϰ�=1 or @�Ӱ�=1
begin
	set @ˢ������=convert(varchar,@����,12)
	--�����ϰ�
	set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@���������ϰ�)),108)
	if @����>@���������ϰ� and (@�����ϰ� is null or @�����ϰ�>@���������ϰ�)
		insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'A1',@�ͻ���,@�������)
	--�����°�
	set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),@���������°�),108)
	if @����>@���������°� and (@�����°� is null or @�����°�<@���������°�)
		insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'A0',@�ͻ���,@�������)
	--�����ϰ�
	set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@���������ϰ�)),108)
	if @����>@���������ϰ� and (@�����ϰ� is null or @�����ϰ�>@���������ϰ�)
		insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'B1',@�ͻ���,@�������)
	--�����°�
	set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),@���������°�),108)
	if @����>@���������°� and (@�����°� is null or @�����°�<@���������°�)
		insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'B0',@�ͻ���,@�������)
	--�Ӱ�
	if @�Ӱ�=1 and @Ӧ�ϰ�=1
	begin
		--�Ӱ��ϰ�
		set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,-15,@���ۼӰ��ϰ�)),108)
		if @����>@���ۼӰ��ϰ� and (@�Ӱ��ϰ� is null or @�Ӱ��ϰ�>@���ۼӰ��ϰ�)
			insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'C1',@�ͻ���,@�������)
		--�Ӱ��°�
		set @ˢ��ʱ��=convert(varchar,dateadd(ss,15*60*rand(),dateadd(mi,@�Ӱ๤ʱ*60+7,@���ۼӰ��ϰ�)),108)
		if @����>dateadd(ss,15*60*rand(),dateadd(mi,@�Ӱ๤ʱ*60+7,@���ۼӰ��ϰ�)) and (@�Ӱ��°� is null or @�Ӱ��°�<dateadd(ss,15*60*rand(),dateadd(mi,@�Ӱ๤ʱ*60+7,@���ۼӰ��ϰ�)))
			insert into hr_kq_data(����,����,�����,����,ʱ��,���,�ͻ���,�������) values (@����,@����,@�����,@ˢ������,@ˢ��ʱ��,'C0',@�ͻ���,@�������)
	end
end

ENDTEXT 
=SQLEXEC(nHandle,cSQL)
=SQLDISCONNECT(nHandle)
