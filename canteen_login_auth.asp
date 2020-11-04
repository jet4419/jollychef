<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    Dim userEmail, userPassword, loginOutput, isValidEmail

    userEmail = Trim(Request.Form("email"))
    userPassword = Trim(Request.Form("password"))

    'Decryption of Password
    salt = "2435uhu34hi34"
    userPassword = sha256(userPassword&salt)

    rs.Open "SELECT * FROM users WHERE email='"&userEmail&"'", CN2

    if not rs.EOF then 

        isValidEmail = true

    else

        Response.Write "invalid email"

    end if   

    rs.close

    if isValidEmail = true then 
        
        rs.Open "SELECT * FROM users WHERE email='"&userEmail&"' and password='"&userPassword&"'", CN2
        
        if not rs.EOF  then

        Session("name") = rs("first_name").value
        Session("fullname") = rs("first_name").value & " " & rs("last_name").value
        Session("email") = rs("email").value
        Session("type") = rs("user_type").value
        Session.Timeout= 180
        
        isLoggedIn = true

        Response.Write isLoggedIn

        else
            rs.close
            CN2.close
        
            isLoggedIn = false

            Response.Write isLoggedIn

        end if

    end if    




%>