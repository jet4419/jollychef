<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->

<%
    btnLogin = Request.Form("btn-login")
    userEmail = Trim(Request.Form("email"))
    userPassword = Request.Form("password")
    'Encryption of Password
    salt = "2435uhu34hi34"
    userPassword = sha256(userPassword&salt)

    If btnLogin<>"" then
        rs.Open "SELECT * FROM customers WHERE email='"&userEmail&"' and password='"&userPassword&"'", CN2
        if not rs.EOF  then 
        Session("cust_id") = rs("cust_id")
		Session("fname") = rs("cust_fname")
        Session("lname") = rs("cust_lname")
        Session("email") = rs("email")
        Session.Timeout=60
		'Session("type") = rs("user_type")
        
        Response.Write("<script language=""javascript"">")
		Response.Write("alert('Logged in successfully!')")
		Response.Write("</script>")
        isValidQty = false
 
            if isValidQty=false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""default.asp"";")
                Response.Write("</script>")
            end if

        else
            rs.close
            CN2.close
            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Logged in Failed')")
            Response.Write("</script>")
            loggedInFail = true
            if loggedInFail = true then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""cust_login.asp"";")
                Response.Write("</script>")
            end if
        end if

    end if    


%>