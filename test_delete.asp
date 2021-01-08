<!--#include file="dbConnect.asp"-->

<%

  On Error Resume Next

  Dim fs
  Set fs = Server.CreateObject("Scripting.FileSystemObject")

  filepath = Server.MapPath("./temp_folder/sales_report_container.dbf")
  
  if fs.FileExists(filepath) then
    fs.DeleteFile(filepath)
    if Err.Number = 0 then
      Response.Write "File was deleted"
    else
      Response.Write "<br> No permission to delete. Error: " & Err.description & "<br>"
    end if
  end if
  set fs=nothing

  if CN2.Errors.Count <> 0 then
    Response.Write "<br> There's a connection error Error: " & CN2.Error & "<br>"
  else 
    Response.Write "<br> No Error <br>"
  end if

%>