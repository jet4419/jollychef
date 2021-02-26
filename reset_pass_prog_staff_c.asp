<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    Dim isValidEmail, isValidPassword

    staffEmail = Trim(Request.Form("email"))

    'Encryption of Password
    salt = "2435uhu34hi34"

    userPassword = Trim(Request.Form("password1"))
    confirmPassword = Trim(Request.Form("password2"))
    isValid = true

    rs.open "SELECT email FROM users WHERE email='"&staffEmail&"'", CN2

    if rs.EOF then

        isValidEmail = false
        Response.Write "invalid email"

        if CStr(userPassword) <> CStr(confirmPassword) then
            
            Response.Write " and password"

        end if

    else

        isValidEmail = true

        if userPassword <> confirmPassword then
            
            isValidPassword = false

            Response.Write "invalid password"

        else

            isValidPassword = true

        end if

    end if 

    rs.close


    if isValidEmail = true and isValidPassword = true then

        'Encryption of Password
        salt = "2435uhu34hi34"
        userPassword = sha256(userPassword&salt)

        sqlUpdate = "UPDATE users SET password = '"&userPassword&"' WHERE email = '"&staffEmail&"'"
        cnroot.execute(sqlUpdate)

        Response.Write "password reset completed" 

    end If

%>
