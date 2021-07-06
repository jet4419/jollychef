<%@ Language=VBScript %>
<!-- #include file="vbsUpload.asp" -->
<!-- #include file="conn.asp" -->

<form method=post
      enctype="multipart/form-data"
      action=Process_DB.asp>
Your File:<BR><input type=file name=YourFile><BR><BR>
<input type=submit name=submit value="Upload">
</form>

<%
Dim objUpload,DB

If Request.TotalBytes > 0 Then
	Set objUpload = New vbsUpload
	DB = "doc_warhouse"

' Make a note that doc_id column IDENTITY is set. So the id will be generated automatically
				getsql = true																	
				if getdata("select top 0 * from " & DB,RS) > -1 then
					rs.AddNew 
					rs.Fields("doc_name") = objUpload.Files.Item(0).FileName
					rs.Fields("doc_type") = objUpload.Files.Item(0).ContentType
					RS("doc_data").AppendChunk objUpload.Files.Item(0).Blob
					rs.Update 

				Else 
					Response.Write "Error"
					Response.End
				end if
				
				getsql = false

				if getdata("select max(doc_id) as docs from " & DB,RS) > -1 then
				Response.redirect "download.asp?doc_id="&RS("docs").value
				End if
End if

%>
