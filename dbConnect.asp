<%
	
 '   Response.Write  "WEBSALES SYSTEM TEMPORARY UNAVAILABLE..."
	
    
	'RESPONSE.End()

	
'v_DpathRoot = "\\cluster\salesdata"
v_DpathRoot = CStr(Application("main_path"))


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

%>