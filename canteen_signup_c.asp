<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->

<%
    Dim isValidEmail, isValidPassword

    ' if Session("name")="" then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if

    ' if ASC(Session("type")) <> ASC("programmer") then 
    '     Response.Redirect("canteen_homepage.asp")    
    ' end if

    firstName = Trim(Request.Form("firstname"))
    firstName = Ucase(Left(firstName, 1)) & Mid(firstName, 2)

    lastName = Trim(Request.Form("lastname"))
    lastName = Ucase(Left(lastName, 1)) & Mid(lastName, 2)

    userEmail = Trim(Request.Form("email"))
    userPassword = Trim(Request.Form("password1"))
    confirmPassword = Trim(Request.Form("password2"))
    userType = Trim(Request.Form("userType"))
    isValid = true

    rs.open "SELECT email FROM users WHERE email='"&userEmail&"'", CN2

    if not rs.EOF then
        
        isValidEmail = false
        Response.Write "invalid email"

        if CStr(userPassword) <> CStr(confirmPassword) then
            
            Response.Write " and password"

        end if

    else

        isValidEmail = true

    end if   

    rs.close    

    if isValidEmail = true then

        if userPassword <> confirmPassword then
            
            isValidPassword = false

            Response.Write "invalid password"

        else

            isValidPassword = true

        end if

    end if


    if isValidEmail = true and isValidPassword = true then

        rs.Open "SELECT MAX(id) FROM users;", CN2

        do until rs.EOF
            for each x in rs.Fields
                maxValue = x.value
            next
            rs.MoveNext
        loop

        maxValue= CInt(maxValue) + 1
        id = maxValue

        'Encryption of Password
        salt = "2435uhu34hi34"
        userPassword = sha256(userPassword&salt)
        ' query
        sqlAdd = "INSERT INTO users (id, first_name, last_name, email, password, user_type, token_id, log_status)"&_ 
        "VALUES ("&id&", '"&firstName&"', '"&lastName&"','"&userEmail&"', '"&userPassword&"', '"&userType&"', '', '')"
        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing
        rs.close
        CN2.close

        Response.Write "registered"

    End If

%>