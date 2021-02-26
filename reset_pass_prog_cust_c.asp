<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    Dim isValidEmail, isValidPassword

    custEmail = Trim(Request.Form("email"))

    'Encryption of Password
    salt = "2435uhu34hi34"

    userPassword = Trim(Request.Form("password1"))
    confirmPassword = Trim(Request.Form("password2"))
    isValid = true

    rs.open "SELECT email FROM customers WHERE email='"&custEmail&"'", CN2

    if rs.EOF then

        isValidEmail = false
        Response.Write "invalid email"

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
        userPassword = sha256(userPassword&salt)

        sqlUpdate = "UPDATE customers SET password = '"&userPassword&"' WHERE email = '"&custEmail&"'"
        cnroot.execute(sqlUpdate)

        Response.Write "password reset completed"

    End If

%>
