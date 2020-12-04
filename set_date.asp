<!--#include file="dbConnect.asp"-->
<!--#include file="checker_programmer.html"-->
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
    </head>
   
<body>

<%
    ' if Session("type") = "" then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if

    ' if Trim(Session("type")) <> Trim("programmer") then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if      
%>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<div id="main" class="mt-5">
    <div class="container pt-5">

        <div class="container border rounded" style="max-width: 500px;">
            <h3 class="text-center py-3">Set Date </h3>
            <form action="set_date_c.asp" method="POST">

                <div class="form-group mb-5">
                    <label for="date" style="font-weight: 600">Choose Date</label>
                    <input type="date" id="date" name="date" class="form-control form-control-sm" autocomplete="off" placeholder="date" required>
                </div>
        
                <input type="submit" name="btnSetDate" value="Submit" class="btn btn-primary btn-block mb-2">
                
            </form>
        </div>

    </div>
</div>

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>
</body>
</html>