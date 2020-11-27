<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp"-->
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

            Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

                isLoggedIn = true

                .Add 0, oJSON.Collection()
                With .item(0)

                    .Add "cust_id", rs("cust_id")
                    .Add "fname", Trim(rs("cust_fname"))
                    .Add "lname", Trim(rs("cust_lname"))
                    .Add "email", Trim(rs("email"))
                    .Add "department", Trim(rs("department").value)

                End With      

            End With

            Response.Write(oJSON.JSONoutput())

        else

            rs.close
            CN2.close
        
            isLoggedIn = false

            Response.Write isLoggedIn

        end if

    end if    


%>