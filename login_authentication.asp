<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    btnLogin = Request.Form("btn-login")
    userEmail = Trim(Request.Form("email"))
    userPassword = Request.Form("password")

    'Decryption of Password
    salt = "2435uhu34hi34"
    userPassword = sha256(userPassword&salt)

    If btnLogin<>"" then
        
        rs.Open "SELECT * FROM users WHERE email='"&userEmail&"' and password='"&userPassword&"'", CN2
        
        if not rs.EOF  then

		Session("name") = rs("first_name").value
        Session("fullname") = rs("first_name").value & " " & rs("last_name").value
        Session("email") = rs("email").value
		Session("type") = rs("user_type").value
        Session.Timeout= 180
        
        Response.Write("<script language=""javascript"">")
		Response.Write("alert('Logged in successfully!')")
		Response.Write("</script>")
        isValidQty = false
            if rs("user_type")="admin" then
                rs.close
                CN2.close
                
                if isValidQty=false then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""canteen_homepage.asp"";")
                    Response.Write("</script>")
                end if
            else 
                rs.close
                CN2.close
                if isValidQty=false then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""canteen_homepage.asp"";")
                    Response.Write("</script>")
                end if
                ' Response.Redirect("default.asp")
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
                Response.Write("window.location.href=""canteen_login.asp"";")
                Response.Write("</script>")
            end if
         end if

    end if    


%>