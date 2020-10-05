<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
    <!-- Bootstrap JS -->
    <script src="./bootstrap/js/bootstrap.min.js"></script>
    <title>Canteen Sign Up Page</title>

    <style>

        body {
            background: linear-gradient(rgba(0, 0, 0, .5), rgba(0, 0, 0, .5)), url("img/home-bg.jpg") no-repeat center/ cover;
            /* font-size: 1.6rem; */
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            /* letter-spacing: .1rem; */
        }

        .signup__header {
            background: linear-gradient(rgba(0, 0, 0, .7), rgba(0, 0, 0, .6)), url(img/login-bg.jpg) no-repeat center / cover;
            min-height: 5rem;
            width: 100%;
            text-align: center;
            padding: 3rem 0;
            color: #fff;
            border-radius: inherit;
        }

        .user-type {
            font-weight: 500;
        }

    </style>

</head>
<body>

<%

    if Session("name")="" then
        Response.Redirect("canteen_homepage.asp")
    end if

    if ASC(Session("type")) <> ASC("programmer") then 
        Response.Redirect("canteen_homepage.asp")    
    end if

    btnSignup = Request.Form("btn-signup")
    firstName = Trim(Request.Form("fname"))
    firstName = Ucase(Left(firstName, 1)) & Mid(firstName, 2)

    lastName = Trim(Request.Form("lname"))
    lastName = Ucase(Left(lastName, 1)) & Mid(lastName, 2)

    userEmail = Trim(Request.Form("email"))
    userPassword = Trim(Request.Form("password1"))
    confirmPassword = Trim(Request.Form("password2"))
    userType = Trim(Request.Form("user-type"))
    isValid = true

    if userPassword<>confirmPassword then
		Response.Write("<script language=""javascript"">")
		Response.Write("alert('Password does not match!')")
		Response.Write("</script>")
        isValid=false
        if isValid = false then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""canteen_signup.asp"";")
            Response.Write("</script>")
        end if
	end if

    If btnSignup<>"" then

        rs.open "SELECT email FROM users WHERE email='"&userEmail&"'", CN2

        if not rs.EOF then
            
            'if CStr(rs("email").value) = CStr(userEmail) then
            
            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Email already registered')")
            Response.Write("</script>")
            isValid = false
            
            if isValid = false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""canteen_signup.asp"";")
                Response.Write("</script>")
            end if
            
        end if

        rs.close

        if isValid = true then
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
            sqlAdd = "INSERT INTO users (id, first_name, last_name, email, password, user_type)"&_ 
            "VALUES ("&id&", '"&firstName&"', '"&lastName&"','"&userEmail&"', '"&userPassword&"', '"&userType&"')"
            set objAccess = cnroot.execute(sqlAdd)
            set objAccess = nothing
            rs.close
            CN2.close

            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Registered Successfully!')")
            Response.Write("</script>")
            registerSuccess = true
                if registerSuccess = true then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""canteen_homepage.asp"";")
                    Response.Write("</script>")
                end if
        end if    
        CN2.close
    End If

%>

    <main class="signup">
      
            <div class="signup__header">
                <h2 class="signup__header--text">Sign Up</h2>
            </div>

            <div class="signup__body bg-white p-4 border rounded">
                <form action="canteen_signup.asp" method="POST">

                    <div class="form-group d-flex justify-space-evenly">
                    <input type="text" name="fname" id="fname" class="form-control form-control-sm " placeholder="First Name" required>
                    <input type="text" name="lname" id="lname" class="form-control form-control-sm ml-3" placeholder="Last Name" required>
                </div>
                
                <div class="form-group">
                    <input type="email" name="email" id="email" class="form-control form-control-sm" autocomplete="off" placeholder="Email" required>
                </div>

                <div class="form-group d-flex justify-space-evenly">
                    <input type="password" name="password1" class="form-control form-control-sm"  placeholder="Password" required>
                    <input type="password" name="password2" class="form-control form-control-sm ml-3"  placeholder="Confirm Password" required>
                </div>

                <div class="form-group pb-3">
                    <label class="user-type">User Type</label>
                    <select class="form-control form-control-sm" name="user-type" id="user-type">
                        <option value="admin">Admin</option>
                        <option value="cashier" selected>Cashier</option>
                        <option value="accountant">Accountant</option>
                        <option value="programmer">Programmer</option>
                    </select>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-success" name="btn-signup" value="signup">Register</button>   
                </div>    
                </form>
            </div>

        </div>
        
    </main>
    
</body>
</html>