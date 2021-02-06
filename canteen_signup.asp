<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<!--#include file="checker_programmer.html"-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
    <!-- Bootstrap JS -->
    <script src="./jquery/jquery_uncompressed.js"></script>
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
            padding: 2rem 0;
            color: #fff;
            border-radius: inherit;
        }

        .user-type {
            font-weight: 500;
        }

        .warning-border { border-color: red !important; }

    </style>

</head>
<body>

    <main class="signup">
      
        <div class="signup__header">
            <h2 class="signup__header--text">Sign Up</h2>
        </div>

        <div class="signup__body bg-white p-4 border rounded">
            <form id="staff-reg-form">
                <div class="form-group d-flex justify-space-evenly">
                    <input type="text" name="fname" id="firstname" class="form-control form-control-sm " placeholder="First Name" required>
                    <input type="text" name="lname" id="lastname" class="form-control form-control-sm ml-3" placeholder="Last Name" required>
                </div>
            
                <div class="form-group">
                    <input type="email" name="email" id="staffEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" required>
                    <span class="email-warning" style="color: red"></span>
                </div>

                <div class="form-group d-flex justify-space-evenly">
                    <input type="password" name="password1" class="form-control form-control-sm"  placeholder="Password" id="password1" required>
                    <input type="password" name="password2" class="form-control form-control-sm ml-3"  placeholder="Confirm Password" id="password2" required>
                </div>
                <span class="password-warning mb-3" style="display: inline-block; color: red"></span>

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
                    <button type="submit" class="btn-main btn btn-primary" name="btn-signup" value="signup">Register</button>   
                </div>    
            </form>
        </div>
        
    </main>
    
<script>
    
    const staffRegForm = document.getElementById('staff-reg-form');

    $('.btn-main').click(function(e){

        e.preventDefault();

        if(staffRegForm.checkValidity()) {

            let firstname = $("#firstname").val();
            let lastname = $("#lastname").val();
            let email = $("#staffEmail").val();
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

            $.ajax({

                url: "canteen_signup_c.asp",
                type: "POST",
                data: {
                        firstname: firstname, lastname: lastname, email: email, password1: password1,
                        password2: password2, userType: userType
                },
                success: function(data) {
                    console.log(data, password1, password2)
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

</body>
</html>