<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    Dim isValidEmail, isValidPassword

    staffEmail = Trim(Request.Form("email"))
    currentPassword = Trim(CStr(Request.Form("currentPassword")))

    'Encryption of Password
    salt = "2435uhu34hi34"
    currentPassword = sha256(currentPassword&salt)

    userPassword = Trim(Request.Form("password1"))
    confirmPassword = Trim(Request.Form("password2"))
    isValid = true

    rs.open "SELECT email, password FROM users WHERE email='"&staffEmail&"'", CN2

    if rs.EOF then

        isValidEmail = false
        Response.Write "invalid email"

        if CStr(userPassword) <> CStr(confirmPassword) then
            
            Response.Write " and password"

        end if

    else

        isValidEmail = true
        savedPassword = Trim(CStr(rs("password")))

        if savedPassword = currentPassword then

            isValidCurrPassword = true

        else

            isValidCurrPassword = false
            Response.Write "invalid current password"

        end if

    end if 

    rs.close

    if isValidEmail = true and isValidCurrPassword = true then

        if userPassword <> confirmPassword then
            
            isValidPassword = false

            Response.Write "invalid password"

        else

            isValidPassword = true

        end if

    end if


    if isValidEmail = true and isValidPassword = true then

        'Encryption of Password
        salt = "2435uhu34hi34"
        userPassword = sha256(userPassword&salt)

        sqlUpdate = "UPDATE users SET password = '"&userPassword&"' WHERE email = '"&staffEmail&"'"
        cnroot.execute(sqlUpdate)

        Response.Write "password reset completed" 

    end If

%>
