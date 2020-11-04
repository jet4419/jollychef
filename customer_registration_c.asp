<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<%
    if Trim(CStr(Session("type"))) <> Trim(CStr("admin")) then

        if Trim(CStr(Session("type"))) <> Trim(CStr("programmer")) then
            Response.Redirect("canteen_homepage.asp")
        end if   
         
    end if    
%>

<%
    Dim isValidEmail, isValidPassword

        btnReg = Request.Form("btnRegister")

        custFirstName = Trim(Request.Form("firstname"))
        custFirstName = Ucase(Left(custFirstName, 1)) & Mid(custFirstName, 2)

        custLastName = Trim(Request.Form("lastname"))
        custLastName = Ucase(Left(custLastName, 1)) & Mid(custLastName, 2)

        custEmail = Trim(Request.Form("email"))
        userPassword = Trim(Request.Form("password1"))
        confirmPassword = Trim(Request.Form("password2"))

        custAddress = Request.Form("address")
        custAddress = Ucase(Left(custAddress, 1)) & Mid(custAddress, 2)

        custNumber = Trim(Request.Form("contact_no"))

        custDepartment = Request.Form("department")
        custDepartment = Ucase(Left(custDepartment, 1)) & Mid(custDepartment, 2)

        customerType = "in"
        isValid = true

        rs.open "SELECT email FROM customers WHERE email='"&custEmail&"'", CN2

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
           
            rs.Open "SELECT MAX(cust_id) FROM customers;", CN2

                do until rs.EOF
                    for each x in rs.Fields
                        maxValue = x.value
                    next
                    rs.MoveNext
                loop

                'Encryption of Password
                salt = "2435uhu34hi34"
                userPassword = sha256(userPassword&salt)

                maxValue= CInt(maxValue) + 1
                custID = maxValue
                ' query
                sqlAdd = "INSERT INTO customers (cust_id, cust_fname, cust_lname, address, contact_no, email, password, department, cust_type)"&_ 
                "VALUES ("&custID&",'"&custFirstName&"', '"&custLastName&"', '"&custAddress&"', '"&custNumber&"', '"&custEmail&"', '"&userPassword&"', '"&custDepartment&"', '"&customerType&"')"
                set objAccess = cnroot.execute(sqlAdd)
                set objAccess = nothing
                rs.close
                CN2.close

                Response.Write "registered"
  
        end If

    %>
