<%
'Set this page up in IIS to receive HTTP 500 errors
''Type' needs to be 'URL' and the URL is e.g.: '/500Error.asp' if this file is named '500Error.asp' and is in the site root directory.
'This script assumes there is a "/Log" folder, and that IIS has write access to it.
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

Dim objFSO, err
Set objFSO=CreateObject("Scripting.FileSystemObject")

Set err = Server.GetLastError()

outFile=Server.MapPath("/Log/ErrorLog.txt")
Set objFile = objFSO.OpenTextFile(outFile, ForAppending, True, TristateTrue)

objFile.WriteLine Now & " - ERROR - ASPCode:" & err.ASPCode & " ASPDescription: " & err.ASPDescription & " Category: " & err.Category & " Description: " & err.Description & " File: " & err.File & " Line: " & err.Line & " Source: " & err.Source  & vbCrLf
objFile.Close

Set objFile = Nothing
Set err = Nothing

%>