<%@ Language=VBScript %>
<!-- #include file="vbsUpload.asp" -->
<form method=post
      enctype="multipart/form-data"
      action=<%=request.servervariables("script_name")%>>
Your File:<BR><input type=file name=YourFile><BR><BR>
<input type=submit name=submit value="Upload">
</form>
<%
Dim objUpload, lngLoop

If Request.TotalBytes > 0 Then
	Set objUpload = New vbsUpload

  For lngLoop = 0 to objUpload.Files.Count - 1
    'If accessing this page annonymously,
    'the internet guest account must have
    'write permission to the path below.
    objUpload.Files.Item(lngLoop).Save "c:\jollychef\img"

	Response.Write "File Uploaded"
	Next

End if
%>