<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!--#include file="checker_admin_prog.html"-->
<!DOCTYPE html>
<html>
    <head>

        <title>Adding of Customer</title>
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

            .container-rounded { 
                border-radius: 1rem; 
                background-color: rgb(249, 249, 249);

                background: rgba( 249, 249, 249, 0.50 );
                box-shadow: 0 8px 32px 0 rgba( 31, 38, 135, 0.37 );
                backdrop-filter: blur( 4px );
                -webkit-backdrop-filter: blur( 4px );
                border-radius: 10px;
                border: 1px solid rgba( 249, 249, 249, 0.18 );
            }
            
            .warning-border { border-color: red !important; }

        </style>

    </head>
   
<body>

<%
    ' if Session("type") = "" then
    '     Response.Redirect("canteen_login.asp")
    ' end if
%>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->



<%
    ' if Trim(CStr(Session("type"))) <> Trim(CStr("admin")) then

    '     if Trim(CStr(Session("type"))) <> Trim(CStr("programmer")) then
    '         Response.Redirect("canteen_homepage.asp")
    '     end if   
         
    ' end if        
%>

<div id="main">

    <div class="container mb-5 pt-5">

        <div class="container border container-rounded" style="max-width: 500px;">
            <h3 class="h3 text-center py-4 m-0 main-heading">Customer Registration </h3>
            
            <form>

                <div class="form-group d-flex justify-space-evenly">
                    <input type="text" id="firstname" name="firstname" class="form-control form-control-sm " placeholder="First Name" required>
                    <input type="text" id="lastname" name="lastname" class="form-control form-control-sm ml-3" placeholder="Last Name" required>
                </div>
    
                <div class="form-group">
                    <input type="email" id="custEmail" name="custEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" required>
                    <span class="email-warning" style="color: red"></span>
                </div>

                <div class="form-group d-flex justify-space-evenly m-0">
                    <input type="password" id="password1" name="password1" class="form-control form-control-sm"  placeholder="Password" required>
                    <input type="password" id="password2" name="password2" class="form-control form-control-sm ml-3"  placeholder="Confirm Password" required>
                </div>
                <span class="password-warning mb-3" style="display: inline-block; color: red"></span>

                <div class="form-group">
                    <input type="text" id="address" name="address" class="form-control form-control-sm" placeholder="Address">
                </div>

                <div class="form-group">
                    <input type="text" id="contact_no" name="contact_no" class="form-control form-control-sm" pattern="[0-9]{11}" placeholder="Contact No">
                </div>

                <div class="form-group mb-3">
                    <input type="text" id="department" name="department" class="form-control form-control-sm" placeholder="Department" required>
                </div>

                <div class="d-flex justify-content-center">
                    <input type="submit" name="btnRegister" value="Register" class="btn-main btn btn-sm btn-primary mb-2">
                </div>

            </form>
            
        </div>

    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!--#include file="cashier_login_logout.asp"-->

<script>
    
    $('.btn-main').click(function(event){
        
        // event.preventDefault();

        console.log($("form"))
        if($("form")[1].checkValidity()) {
            //your form execution code
        // event.preventDefault();

        let firstname = $("#firstname").val();
        let lastname = $("#lastname").val();
        let email = $("#custEmail").val();
        let password1 = $("#password1").val();
        let password2 = $("#password2").val();
        let address = $("#address").val();
        let contact_no = $("#contact_no").val();
        let department = $("#department").val();
        let emailWarning = "";
        let passwordWarning = "";
        const emailInput = document.querySelector("#email");
        const passwordInput1 = document.querySelector("#password1");
        const passwordInput2 = document.querySelector("#password2");
        const emailWarningContainer = document.querySelector(".email-warning");
        const passwordWarningContainer = document.querySelector(".password-warning");

        //console.log(arID)
            $.ajax({

                url: "customer_registration_c.asp",
                type: "POST",
                data: {firstname: firstname, lastname: lastname, email: email, password1: password1,
                       password2:password2, address: address, contact_no: contact_no, department: department
                },
                success: function(data) {
                    // console.log(data, password1, password2)
                    if (data==='invalid email') {
                        emailWarning = "Email already exist"
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
                        
                        emailWarning = "Email already exist"
                        emailWarningContainer.innerHTML = emailWarning;
                        emailInput.classList.add("warning-border")

                        passwordWarning = "Password does not match"
                        passwordWarningContainer.innerHTML = passwordWarning;
                        passwordInput1.classList.add("warning-border")
                        passwordInput2.classList.add("warning-border")
                    }

                    else {
                        alert("Registered successfully!");
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