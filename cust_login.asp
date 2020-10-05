<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/login_page_styles.css">
    <title>Canteen Login Page</title>
</head>
<body>

<%

    if Session("type") <> "" then
        Response.Redirect("canteen_homepage.asp")
    end if

    if Session("cust_id") <> "" then
        Response.Redirect("default.asp")

    else

        btnLogin = Request.Form("btn-login")
        userEmail = Trim(Request.Form("email"))
        userPassword = Request.Form("password")
        'Decryption of Password
        salt = "2435uhu34hi34"
        userPassword = sha256(userPassword&salt)

        If btnLogin<>"" then
            rs.Open "SELECT * FROM customers WHERE email='"&userEmail&"' and password='"&userPassword&"'", CN2
            if not rs.EOF  then 
            Session("cust_id") = rs("cust_id")
            Session("fname") = rs("cust_fname")
            Session("lname") = rs("cust_lname")
            Session("email") = rs("email")
            'Session("type") = rs("user_type")
            
            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Logged in successfully!')")
            Response.Write("</script>")
            isLoggedIn = true
    
                if isLoggedIn = true then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""default.asp"";")
                    Response.Write("</script>")
                end if

            else
                rs.close
                CN2.close
                Response.Write("<script language=""javascript"">")
                Response.Write("alert('Logged in Failed')")
                Response.Write("</script>")
                loggedInFail = true
                if loggedInFail = true then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""cust_login.asp"";")
                    Response.Write("</script>")
                end if
            end if

        end if    

    end if
%>

    <main class="login">

        
            <div class="login__header">
                <h2 class="login__header--text">Sign In</h2>
            </div>

            <div class="login__body">
                <form action="cust_login.asp" method="POST" class="form-body">

                    <div class="label-input-groups">
                        <label class="form-label" name="email" for="email">Email</label>
                        <input class="form-inputs" type="email" name="email" id="email">
                    </div>

                    <div class="label-input-groups">
                        <label class="form-label" for="password">Password</label>   
                        <input class="form-inputs" name="password" type="password" name="password" id="loginPassword">
                    </div>

                    <button type="submit" class="btn-main btn-login-form" name="btn-login" value="login">Login</button>   
                </form>
            </div>
            <!--
            <div class="login__footer">
                Looking to <a href="bootRegisterCustomer.asp" class="login__footer--link">create an account?</a>
            </div>
            -->
        </div>
        
    </main>

<!--<script>

const xhr = new XMLHttpRequest();

xhr.open('POST', 'login_authentication.asp', true);
xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

xhr.onload = () => {

} 

</script> -->
</body>
</html>