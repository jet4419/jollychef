<%
'Sample file db-bytearay.asp 
'Simple upload to database.
'Suitable for small files - up to 20% of physical server memory
'This sample works with any connection - MDB (JetOLEDB, ODBC)
' MS SQL (MSDASQL/ODBC) etc.

Server.ScriptTimeout = 240
'Simple upload to database

dim Conn, RS

Dim Action, ID
Action = Request.QueryString("Action")

if Action = "down" then 'download image
	ID = clng(Request.QueryString("ID"))
	if ID>0 then
		Set RS = GetConnection.Execute("Select Image, Description From Images Where ID=" & ID)
		If Rs.Eof then'No image
			Response.write "Image ID " & ID & " does not exists in server-side database."
		else
			Dim Description
			Description = "" & RS("Description")
			if len(Description)=0 then Description = "-" 
			Response.AddHeader "Description", replace(Description, vbCrLf, "~~")
			Response.CacheControl = "no-cache"
			Response.BinaryWrite RS("Image").Value
			
		end if'If Rs.Eof then
	end if'if ID>0 then
	response.end
end if'if Action = "down" then 'download image

if Action = "up" then 'upload image

Dim Form: Set Form = Server.CreateObject("ScriptUtils.ASPForm")

'was the Form successfully received?
if Form.State = 0 then

  'Open connection to database
  Set Conn = GetConnection 
  Set RS = Server.CreateObject("ADODB.Recordset")

  'Open dynamic recordset, table Upload
  RS.Open "Images", Conn, 2, 2
  RS.AddNew

    'Add file from source field 'DBFile' to table field 'Data'
    RS("Image") = Form("Binarydata").ByteArray

    'Store technical informations
    RS("DataSize") = Form("Binarydata").Length
   
    'Store text data info
    RS("Description") = Form("Description")

  RS.Update
  RS.Close
  Conn.Close 
	response.write "File " & Form("Binarydata").FileName & " length:" & Form("Binarydata").Length & ", ID:" & Form("ID") & " was stored to server database." & vbCrLf
'	response.write Form("Binarydata").HexString
  
ElseIf Form.State>10 then
	response.write "Bad State:" & Form.State
End If'Form.State = 0 then
end if' Action = "up" then 'upload image

Function GetConnection()
  dim Conn: Set Conn = CreateObject("ADODB.Connection")
  Conn.Provider = "Microsoft.Jet.OLEDB.4.0"
  Conn.open "Data Source=" & Server.MapPath("upload.mdb") 
	set GetConnection = Conn
end function

if Action="" then

%>  


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
 <TITLE>ASP huge file upload - client/server database synchronization sample (synchronize of Image/Binary fields).</TITLE>
 <STYLE TYPE="text/css"><!--TD	{font-family:Arial,Helvetica,sans-serif }TH	{font-family:Arial,Helvetica,sans-serif }TABLE	{font-size:10pt;font-family:Arial,Helvetica,sans-serif }--></STYLE>
</HEAD>
<BODY BGColor=white>


<Div style=width:600>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  
  <TR>
    <TH noWrap align=left width="20%" bgColor=khaki>&nbsp;<A 
      href="http://www.pstruh.cz/help/scptutl/upload.asp">Power ASP 
      file upload</A> - client/server database synchronization sample (synchronize of Image/Binary fields).&nbsp;</TH>
    <TD>&nbsp;</TD></TR></TABLE>
<TABLE cellSpacing=2 cellPadding=1 width="100%" bgColor=white border=0>
  
  <TR>
    <TD colSpan=2>
      <P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This sample demonstrates work of HugeASP upload with binary database fields. It let's you synchronize client-side and server-side database records.
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please copy upload.mdb database and db-synchronize.asp script to server side, and copy upload.mdb database to client-side. Open client-side upload.mdb database, open Images form (not Images table), write URL address of db-synchronize.asp ASP script, insert images (using drag-drop BMP image files) and try to synchronize with server (click upload on the new record).

<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;See client-side source - Access menu tools->macro->Visual basic editor (Alt-F11) 
<br>Client-side VBA source code lets you upload and download any binary fields along with text fields (descriptions, IDs, etc.)

			</P>
  </TD></TR></TABLE>

<HR COLOR=silver Size=1>
<CENTER>
<FONT SIZE=1>� 1996 � <%=year(date)%> Antonin Foller, <a href="http://www.pstruh.cz">PSTRUH Software</a>, e-mail <A href="mailto:help@pstruh.cz" >help@pstruh.cz</A>
<br>To monitor current running uploads/downloads, see <A Href="http://www.pstruh.cz/help/iistrace/iis-monitor.asp">IISTracer - IIS real-time monitor</A>.
</FONT>

</CENTER>
</Div>
</BODY></HTML>

<%
End If
%>  
