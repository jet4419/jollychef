<!--#include file="dbConnect.asp"-->
<%
Function myfunction()
    
    rs.open "SELECT * FROM users WHERE id=1", CN2

    for each x in rs.fields

        Response.Write x.name & " " & x.value & "<br>"

    next

End Function

response.write(myfunction())
%>  