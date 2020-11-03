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

            .container-rounded { border-radius: 1rem;}
            

        </style>

    </head>
   
<body>

<%
    if Session("type") = "" then
        Response.Redirect("canteen_login.asp")
    end if
%>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->



<%
    if Trim(CStr(Session("type"))) <> Trim(CStr("admin")) then

        if Trim(CStr(Session("type"))) <> Trim(CStr("programmer")) then
            Response.Redirect("canteen_homepage.asp")
        end if   
         
    end if        
%>

<div id="main">

    <div class="container mb-5 pt-5">

        <div class="container border container-rounded" style="max-width: 500px; background: #eee;">
            <h3 class="text-center pt-3 m-0">Employees </h3>
            <h3 class="text-center pt-1 pb-3">Registration </h3>
            <form action="customer_registration_c.asp" method="POST">

                <div class="form-group d-flex justify-space-evenly">
                    <input type="text" name="firstname" class="form-control form-control-sm " placeholder="First Name" required>
                    <input type="text" name="lastname" class="form-control form-control-sm ml-3" placeholder="Last Name" required>
                </div>
                <!--
                <div class="form-group">    
                    <input type="text" name="lastname" class="form-control form-control-sm" placeholder="Last Name" required>
                </div>
                -->
                <div class="form-group">
                    <input type="email" name="custEmail" class="form-control form-control-sm" autocomplete="off" placeholder="Email" required>
                </div>

                <div class="form-group d-flex justify-space-evenly">
                    <input type="password" name="password1" class="form-control form-control-sm"  placeholder="Password" required>
                    <input type="password" name="password2" class="form-control form-control-sm ml-3"  placeholder="Confirm Password" required>
                </div>

                <div class="form-group">
                    <input type="text" name="address" class="form-control form-control-sm" placeholder="Address">
                </div>

                <div class="form-group">
                    <input type="text" name="contact_no" class="form-control form-control-sm" pattern="[0-9]{11}" placeholder="Contact No">
                </div>

                <div class="form-group mb-3">
                    <input type="text" name="department" class="form-control form-control-sm" placeholder="Department">
                </div>

                <div class="d-flex justify-content-center">
                    <input type="submit" name="btnRegister" value="Register" class="btn btn-success mb-2">
                </div>

            </form>
            
        </div>

    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

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

<script src="js/main.js"></script>
</body>
</html>