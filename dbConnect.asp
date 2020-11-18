<%
	
 '   Response.Write  "WEBSALES SYSTEM TEMPORARY UNAVAILABLE..."
	
    
	'RESPONSE.End()

	' if Application("test_global_asa") <> "" then

   '    Response.Write Application("test_global_asa")

   ' else
   '    Response.Write "Not working"
   ' end if
'v_DpathRoot = "\\cluster\salesdata"

mainPath = "C:\jollychef\"

v_DpathRoot = mainPath


session("rootPath") = v_DpathRoot

Set CNRoot = CreateObject("ADODB.Connection")
dcnCnnStrRoot = "Driver=Microsoft Visual Foxpro Driver; " & _
   "UID=;SourceType=DBF;Exclusive=No;Backgroundfetch=NO; " & _   
   "SourceDB="& v_DpathRoot
CNRoot.Open dcnCnnStrRoot

v_DpathBr=session("salesbrDataPath")
'response.Write v_DpathBr

br = v_DpathRoot & trim(v_DpathBr)
'response.Write br
'response.End()
Set CN2 = CreateObject("ADODB.Connection") 
dcnCnnStr2 = "Driver=Microsoft Visual Foxpro Driver; " & _
   "UID=;SourceType=DBF;Exclusive=No;Backgroundfetch=NO; " & _  
   "SourceDB=" & br
CN2.Open dcnCnnStr2
set rs=Server.CreateObject("ADODB.recordset")

   sqlGetDate = "SELECT MAX(date) AS date FROM system_date" 
   set objAccess = cnroot.execute(sqlGetDate)

   if not objAccess.EOF then
      systemDate = CDate(objAccess("date").value)
   else
      systemDate = CDate(Date)
   end if  

   systemDate = CDate(FormatDateTime(systemDate,2))
   ' Application("test_global_asa") = "Global Asa is running"

   sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
   set objAccess = cnroot.execute(sqlQuery)

      currDate = systemDate

      if not objAccess.EOF then
            schedID = CInt(objAccess("sched_id"))
            isStoreClosed = CStr(objAccess("status"))
            dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
            'currDate = CDate(Date)
      else
            isStoreClosed = "open"
            dateClosed = CDate(Date)
            'currDate = CDate(Date)
      end if

   set objAccess = nothing

   if dateClosed < currDate then
      sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
      cnroot.execute(sqlUpdate)
   end if

%>