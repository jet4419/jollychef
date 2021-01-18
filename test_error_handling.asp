<%
    On Error Resume Next
    ' Function errorTrap
    '     Response.Write ("Sorry you have encountered an error."  & "<br>")
    '     Response.Write ("Your error number is " & Err.number  & "<br>")
    '     Response.Write ("The error source is " & Err.source & "<br>")
    '     Response.Write ("The error description is " & Err.description  & "<br>")
    '     Response.Write ("The error description is " & Err.line & "<br>")
    ' End Function

    ' Dim result

    ' on error resume next
    ' Response.Writes 
    ' ' result = 20/0 '(Performing division by 0 Scenario)
    ' '     If Err.Number <> 0 Then '(Making use of Err Object’s Number property)
    ' '         Response.Write Err.Number 
    ' '         '(Give details about the Error)
    ' '         'Err.Clear '(Will Clear the Error)
    ' '         Response.Write "<br>Error: " & err.description
    ' '     End If
    ' ' on error goto 0
    ' if err.number <> 0 then
    '     errorTrap()
    ' end if

    'Response.Write "<br>Error description: " & err.description & ". Error number: " & err.number

   
    Set objASPError = Server.GetLastError()
    result = 20/0
    Response.Writes
    Response.Write Server.HTMLEncode(objASPError.Line())
    ' If Len(CStr(objASPError.ASPCode)) > 0 Then
    '     Response.Write Server.HTMLEncode(", " & objASPError.ASPCode)
    ' End If
    ' Response.Write Server.HTMLEncode(" (0x" & Hex(objASPError.Number) & ")" ) & "<br>"
    ' If Len(CStr(objASPError.ASPDescription)) > 0 Then 
    '     Response.Write Server.HTMLEncode(objASPError.ASPDescription) & "<br>"
    ' ElseIf Len(CStr(objASPError.Description)) > 0 Then 
    '     Response.Write Server.HTMLEncode(objASPError.Description) & "<br>" 
    ' End If
    ' Response.Write objASPError.Line
    ' Response.Write objASPError.Description
    ' Response.Write objASPError.ASPDescription
%>