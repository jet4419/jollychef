<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->

<%
    Dim userEmail, userPassword, loginOutput, isValidEmail

    userEmail = Trim(Request.Form("email"))
    userPassword = Trim(Request.Form("password"))
    'Encryption of Password
    salt = "2435uhu34hi34"
    userPassword = sha256(userPassword&salt)

    rs.Open "SELECT * FROM customers WHERE email='"&userEmail&"'", CN2

    if not rs.EOF then 

        isValidEmail = true

    else

        Response.Write "invalid email"

    end if   

    rs.close

    if isValidEmail = true then 

        rs.Open "SELECT * FROM customers WHERE email='"&userEmail&"' and password='"&userPassword&"'", CN2

        if not rs.EOF  then 

        Session("cust_id") = rs("cust_id")
		Session("fname") = rs("cust_fname")
        Session("lname") = rs("cust_lname")
        Session("email") = rs("email")
        Session.Timeout=60
		'Session("type") = rs("user_type")
        
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