<!--#include file="session_cashier.asp"-->
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

            <h3 class="text-center py-3">Reset Password </h3>
            <form id="form-reset-pass">

                <div class="form-group">
                    <input type="email" id="staffEmail" name="staffEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" maxlength="30" readonly required>
                    <span class="email-warning" style="color: red"></span>
                </div>

                <div class="form-group">
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control form-control-sm" placeholder="Current Password" minlength="4" maxlength="25" required>
                </div>
                <span class="current-password-warning mb-3" style="display: none; color: red"></span>

                <div class="form-group">
                    <input type="password" id="password1" name="password1" class="form-control form-control-sm" placeholder="New Password" minlength="4" maxlength="25" required>
                </div>

                <div class="form-group">
                    <input type="password" id="password2" name="password2" class="form-control form-control-sm" placeholder="Confirm New Password" minlength="4" maxlength="25" required>
                </div>
                <span class="password-warning mb-3" style="display: inline-block; color: red"></span>

                <div class="w-50" style="margin: auto">
                    <input type="submit" name="btnRegister" value="Reset Password" class="btn-main btn btn-success btn-block mb-2">
                </div>

            </form>
        </div>

    </div>
</div>

<!--#include file="cashier_login_logout.asp"-->

<script>

const staffEmail = localStorage.getItem('email');
document.getElementById('staffEmail').value = staffEmail;

const formResetPass = document.getElementById('form-reset-pass');
    
    $('.btn-main').click(function(event){

        if(formResetPass.checkValidity()) {

            event.preventDefault();

            let currentPassword = $("#currentPassword").val();
            let password1 = $("#password1").val();
            let password2 = $("#password2").val();
            let userType = $("#user-type").val();

            let emailWarning = "";
            let passwordWarning = "";
            const emailInput = document.querySelector("#staffEmail");

            const currPassInput = document.querySelector("#currentPassword");
            const currPasswordWarning = document.querySelector(".current-password-warning");

            const passwordInput1 = document.querySelector("#password1");
            const passwordInput2 = document.querySelector("#password2");

            const emailWarningContainer = document.querySelector(".email-warning");
            const passwordWarningContainer = document.querySelector(".password-warning");

            $.ajax({

                url: "reset_pass_staff_c.asp",
                type: "POST",
                data: {
                        email: staffEmail, currentPassword: currentPassword, password1: password1, password2: password2
                },
                success: function(data) {

                    if (data==='invalid email') {

                        invalidEmailFunc();

                        passwordWarningContainer.innerHTML = "";
                        passwordInput1.classList.remove("warning-border");
                        passwordInput2.classList.remove("warning-border");
                    }

                    else if (data === 'invalid current password') {
                        invalidCurrPassFunc();
                        emailWarningContainer.innerHTML = "";
                        emailInput.classList.remove("warning-border");
                        passwordWarningContainer.innerHTML = "";
                        passwordInput1.classList.remove("warning-border");
                        passwordInput2.classList.remove("warning-border");
                    }

                    else if (data === 'invalid password') {

                        invalidPassFunc();
                        emailWarningContainer.innerHTML = "";
                        emailInput.classList.remove("warning-border");
                        currPasswordWarning.style.display = "none";
                        currPassInput.classList.remove("warning-border");

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

            function invalidCurrPassFunc() {
                passwordWarning = "Current password doesn\'t match";
                currPasswordWarning.innerHTML = passwordWarning;
                currPasswordWarning.style.display = "inline-block";
                currPassInput.classList.add("warning-border");
        
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