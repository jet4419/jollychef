<!--#include file="dbConnect.asp"-->

<%
    Dim userID, name, fullname, email, userType, tokenID

    userID = CLng(Request.Form("userID"))
    name = CStr(Trim(Request.Form("name")))
    fullname = CStr(Trim(Request.Form("fullname")))
    email = CStr(Trim(Request.Form("email")))
    userType = CStr(Trim(Request.Form("type")))
    tokenID = CStr(Trim(Request.Form("tokenID")))

    getStaffInfo = "SELECT id, first_name, last_name, email, user_type, token_id, log_status FROM users WHERE token_id='"&tokenID&"' AND id="&userID&" AND first_name='"&name&"' AND email='"&email&"' AND user_type='"&userType&"' AND log_status='active' "
    set objAccess = cnroot.execute(getStaffInfo)

    if not objAccess.EOF then

       Response.Write "access granted"
    
    else

        Response.Write "access denied"

    end if






%>