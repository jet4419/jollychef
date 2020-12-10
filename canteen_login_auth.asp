<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp"-->
<!--#include file="sha256.asp"-->
<%
    Dim userEmail, userPassword, tokenID, isValidEmail

    userEmail = Trim(Request.Form("email"))
    userPassword = Trim(Request.Form("password"))
    tokenID = CStr(Trim(Request.Form("tokenID")))

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

            setLoginStatus = "UPDATE users SET token_id='"&tokenID&"', log_status='active' WHERE email='"&userEmail&"'"
            cnroot.execute(setLoginStatus)

            isLoggedIn = true

            Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

                .Add 0, oJSON.Collection()
                With .item(0)

                    .Add "id", Trim(rs("id").value)
                    .Add "name", Trim(rs("first_name").value)
                    .Add "fullname", Trim(rs("first_name").value) & " " & Trim(rs("last_name").value)
                    .Add "email", Trim(rs("email").value)
                    .Add "type", Trim(rs("user_type").value)
                    .Add "tokenid", tokenID

                End With     

            ' Session("name") = rs("first_name").value
            ' Session("fullname") = rs("first_name").value & " " & rs("last_name").value
            ' Session("email") = rs("email").value
            ' Session("type") = rs("user_type").value
            ' Session.Timeout= 180

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