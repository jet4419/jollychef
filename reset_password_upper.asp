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

        <style>
            .warning-border { border-color: red !important; }
        </style>
    </head>
   
<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<%
    if Trim(Session("type")) <> Trim("programmer") then
        Response.Redirect("canteen_homepage.asp")
    end if        
%>

<div id="main">
    <div class="container pt-4">

        <div class="container border rounded" style="max-width: 500px;">
            <h3 class="text-center py-3">Admins Reset Password </h3>
            <form>
                <div class="form-group">
                    <input type="email" id="email" name="custEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" required>
                    <span class="email-warning" style="color: red"></span>
                </div>
                <div class="form-group">
                    <input type="password" id="password1" name="password1" class="form-control form-control-sm" placeholder="Password" required>
                </div>
                <div class="form-group">
                    <input type="password" id="password2" name="password2" class="form-control form-control-sm" placeholder="Confirm Password" required>
                </div>
                <span class="password-warning mb-3" style="display: inline-block; color: red"></span>
        
                <input type="submit" name="btnRegister" value="Reset Password" class="btn-main btn btn-primary btn-block mb-2">
                
            </form>
        </div>

    </div>
</div>

<!-- Login -->
<div id="login" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="login_authentication.asp" method="POST">
            <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Customer Login</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" name="email" id="email" placeholder="Email">
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Password">
                  </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="submit" class="btn btn-sm btn-success" name="btn-login" value="login" >Login</button>
            </div>
            </div>
        </form>
    </div>
</div>
<!-- End of Login -->

<!-- Logout -->
<div id="logout" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="canteen_logout.asp">
            <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Logout</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>Are you sure to logout?</p>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Yes</button>
                <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
            </div>
            </div>
        </form>
    </div>
</div>
<!-- End of Logout -->

<script>
    
    $('.btn-main').click(function(){

        if($("form")[1].checkValidity()) {
            //your form execution code
        event.preventDefault();

        let email = $("#email").val();
        let password1 = $("#password1").val();
        let password2 = $("#password2").val();
        let userType = $("#user-type").val();

        let emailWarning = "";
        let passwordWarning = "";
        const emailInput = document.querySelector("#email");
        const passwordInput1 = document.querySelector("#password1");
        const passwordInput2 = document.querySelector("#password2");
        const emailWarningContainer = document.querySelector(".email-warning");
        const passwordWarningContainer = document.querySelector(".password-warning");

        //console.log(arID)
            $.ajax({

                url: "reset_password_upper_c.asp",
                type: "POST",
                data: {
                        email: email, password1: password1, password2: password2
                },
                success: function(data) {
                    console.log(data, password1, password2)
                    if (data==='invalid email') {
                        emailWarning = "Can't find your account"
                        emailWarningContainer.innerHTML = emailWarning;
                        emailInput.classList.add("warning-border");
                        // emailInput.style.borderColor = "red";
                        passwordWarningContainer.innerHTML = "";
                        passwordInput1.classList.remove("warning-border");
                        passwordInput2.classList.remove("warning-border");
                    }

                    else if (data === 'invalid password') {
                        passwordWarning = "Password does not match";
                        passwordWarningContainer.innerHTML = passwordWarning;
                        passwordInput1.classList.add("warning-border");
                        passwordInput2.classList.add("warning-border");
                        emailWarningContainer.innerHTML = "";
                        emailInput.classList.remove("warning-border");
                    }

                    else if (data === 'invalid email and password') {
                        
                        emailWarning = "Can't find your account"
                        emailWarningContainer.innerHTML = emailWarning;
                        emailInput.classList.add("warning-border")

                        passwordWarning = "Password does not match"
                        passwordWarningContainer.innerHTML = passwordWarning;
                        passwordInput1.classList.add("warning-border")
                        passwordInput2.classList.add("warning-border")
                    }

                    else {
                        alert("Password successfully reset!");
                        window.location.reload();
                    }
                    

                }
            })
        }

        else console.log("invalid form");
    });

</script>

<script src="js/main.js"></script>
</body>
</html>