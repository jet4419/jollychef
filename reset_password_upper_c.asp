<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
        btnReg = Request.Form("btnRegister")

        custEmail = Trim(Request.Form("custEmail"))
        userPassword = Trim(Request.Form("password1"))
        confirmPassword = Trim(Request.Form("password2"))
        isValid = true

        if userPassword<>confirmPassword then
            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Password does not match!')")
            Response.Write("</script>")
        isValid=false
            if isValid = false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""reset_password_upper.asp"";")
                Response.Write("</script>")
            end if
	    end if



        If btnReg<>"" then

        rs.open "SELECT email FROM users WHERE email='"&custEmail&"'", CN2

        if rs.EOF then

            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Can't find your account.')")
            Response.Write("</script>")
            isValid = false
            if isValid = false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""reset_password_upper.asp"";")
                Response.Write("</script>")
            end if  
        end if   

        rs.close

           if isValid = true then


            'Encryption of Password
            salt = "2435uhu34hi34"
            userPassword = sha256(userPassword&salt)

            sqlUpdate = "UPDATE users SET password = '"&userPassword&"' WHERE email = '"&custEmail&"'"
            cnroot.execute(sqlUpdate)

            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Password reset successfully!')")
            Response.Write("</script>")
                isRegistered=true
                if isRegistered = true then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""reset_password_upper.asp"";")
                    Response.Write("</script>")
                end if
            end if    
        End If

    %>
