<!--#include file ="conn.asp"-->
<%
	 
	if getData("select * from doc_warhouse where doc_name <> '' and doc_id=" & request("doc_id"),rs) > 0 then
		Response.ContentType = rs("doc_type")
		Response.AddHeader "Content-Disposition", "filename=" & rs("doc_name")
		Response.BinaryWrite rs("doc_data")
	Else 
%>
<HTML><BODY>File not found in the database.</BODY></HTML>
<%
	End If
%>