<!--#include file="dbConnect.asp"-->

<%
    Dim isValidParam
    isValidParam = true

    if Request.Form("userID") = "" or Request.Form("fname") = "" or Request.Form("lname") = "" or Request.Form("email") = "" or Request.Form("custDept") = "" or Request.Form("tokenID") = "" then

        isValidParam = false
        Response.Write "access denied"

    end if

    if isValidParam = true then

        Dim userID, fname, lname, email, department, tokenID

        userID = CLng(Request.Form("userID"))
        fname = CStr(Trim(Request.Form("fname")))
        lname = CStr(Trim(Request.Form("lname")))
        email = CStr(Trim(Request.Form("email")))
        department = CStr(Trim(Request.Form("custDept")))
        tokenID = CStr(Trim(Request.Form("tokenID")))

        getCustInfo = "SELECT cust_id, cust_fname, cust_lname, email, department, token_id, log_status FROM customers WHERE token_id='"&tokenID&"' AND cust_id="&userID&" AND cust_fname='"&fname&"' AND cust_lname='"&lname&"' AND email='"&email&"' AND department='"&department&"' AND log_status='active' "
        set objAccess = cnroot.execute(getCustInfo)

        if not objAccess.EOF then

        Response.Write "access granted"
        
        else

            Response.Write "access denied"

        end if

    end if




%>