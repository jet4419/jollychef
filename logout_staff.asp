<!--#include file="dbConnect.asp"-->

<%

    Dim tokenID

    tokenID = CStr(Trim(Request.Form("tokenID")))

    logoutStaff = "UPDATE users SET token_id='', log_status='inactive' WHERE token_id='"&tokenID&"' "

    on error resume next
    cnroot.execute(logoutStaff)

    if err<>0 then
        Response.Write("logout error")
    else
        Response.Write("logout success")
    end if



%>