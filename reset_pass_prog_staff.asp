<!--#include file="checker_programmer.html"-->
<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">

        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>

        <title>Reset Password</title>  

    </head>
   
<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<%
    ' if Trim(Session("type")) <> Trim("programmer") then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if        
%>

<div id="main">
    <div class="container pt-5">

        <div class="container border rounded" style="max-width: 500px;">
            <h3 class="text-center py-3">Staff Reset Password </h3>
            <form id="form-reset-pass">
                <div class="form-group">
                    <input type="email" id="staffEmail" name="staffEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" maxlength="30" required>
                    <span class="email-warning" style="color: red"></span>
                </div>
                <div class="form-group">
                    <input type="password" id="password1" name="password1" class="form-control form-control-sm" placeholder="Password" minlength="4" maxlength="25" required>
                </div>
                <div class="form-group">
                    <input type="password" id="password2" name="password2" class="form-control form-control-sm" placeholder="Confirm Password" minlength="4" maxlength="25" required>
                </div>
                <span class="password-warning mb-3" style="display: inline-block; color: red"></span>
        
                <input type="submit" name="btnRegister" value="Reset Password" class="btn-main btn btn-primary btn-block mb-2">
                
            </form>
        </div>

    </div>
</div>

<!--#include file="cashier_login_logout.asp"-->

<script>

const formResetPass = document.getElementById('form-reset-pass');
    
    $('.btn-main').click(function(event){

        if(formResetPass.checkValidity()) {

            event.preventDefault();

            const staffEmail = $("#staffEmail").val();
            const password1 = $("#password1").val();
            const password2 = $("#password2").val();
            const userType = $("#user-type").val();

            let emailWarning = "";
            let passwordWarning = "";
            const emailInput = document.querySelector("#staffEmail");
            const passwordInput1 = document.querySelector("#password1");
            const passwordInput2 = document.querySelector("#password2");
            const emailWarningContainer = document.querySelector(".email-warning");
            const passwordWarningContainer = document.querySelector(".password-warning");

    
            $.ajax({

                url: "reset_pass_prog_staff_c.asp",
                type: "POST",
                data: {
                        email: staffEmail, password1: password1, password2: password2
                },

                success: function(data) {

                    if (data==='invalid email') {
                        invalidEmailFunc();
                        // emailInput.style.borderColor = "red";
                        passwordWarningContainer.innerHTML = "";
                        passwordInput1.classList.remove("warning-border");
                        passwordInput2.classList.remove("warning-border");
                    }

                    else if (data === 'invalid password') {
                        invalidPassFunc();
                        emailWarningContainer.innerHTML = "";
                        emailInput.classList.remove("warning-border");
                    }

                    else if (data === 'invalid email and password') {
                        
                        invalidEmailFunc();

                        invalidPassFunc();
                    }

                    else {
                        alert("Password successfully reset!");
                        window.location.reload();
                    }

                }
            })

            function invalidEmailFunc() {
                emailWarning = "Can't find your account";
                emailWarningContainer.innerHTML = emailWarning;
                emailInput.classList.add("warning-border");
            }

            function invalidPassFunc() {
                passwordWarning = "Password does not match";
                passwordWarningContainer.innerHTML = passwordWarning;
                passwordInput1.classList.add("warning-border");
                passwordInput2.classList.add("warning-border");
            }

        } 

    });


</script>

<script src="js/main.js"></script>
</body>
</html>