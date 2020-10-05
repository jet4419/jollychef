<!--#include file="dbConnect.asp"-->

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

<!-- <%
    if Session("type")<>"" then
        Response.Redirect("canteen_homepage.asp")
    end if

    if Session("cust_id")<>"" then
        response.Redirect("default.asp")
    end if

%> -->

    <main class="login">

        
            <div class="login__header">
                <h2 class="login__header--text">Sign In</h2>
            </div>

            <div class="login__body">
                <form action="login_authentication.asp" method="POST" class="form-body">

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

            <div class="login__footer">
                Looking to <a href="#" class="login__footer--link">create an account?</a>
            </div>
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