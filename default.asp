<!--#include file="cust_homepage_checker.html"-->
<!doctype html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Homepage</title>
        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        
        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JSS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>
        <!--<script src="https://kit.fontawesome.com/6f3e46d502.js" crossorigin="anonymous"></script> -->
        <!--<link rel="stylesheet" href="css/font-awesome.min.css">-->

        <style>

            .homepage-text--container {
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                color: #fff;
                font-size: 3.5rem;
            }

        </style>

    </head>

<body class="customer-default-page">

<%
    ' if Session("type") <> "" then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if
%>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

<main id="main" class="main--main-page default">

    <h1 class="home-main-heading"> 
    	
    	<span class="home-main-heading-text home-main-heading--text-1">
        	<span class="letter-r">JollyChef</span>
            <span class="letter-c">Inc.</span>
        </span> 
        <span class="home-main-heading-text home-main-heading--text-2">We serve passion</span> 
    </h1>
    
</main>

<!-- Login -->
<div id="login" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="cust_login_auth.asp" method="POST">
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
                    <input type="email" class="form-control" name="email" id="email" placeholder="Email" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" name="password" id="loginPassword" placeholder="Password" required>
                    <span class="wrong-password-text" style=" padding-top: 10px; color: red; font-size: 11px; text-align: center;"></span>
                </div>
            </div>
            <div class="modal-footer d-flex justify-content-center">
                <button type="submit" class="btn-main btn btn-sm btn-success" name="btn-login" value="login" >Login</button>
            </div>
            </div>
        </form>
    </div>
</div>
<!-- End of Login -->

<!-- Logout -->
        <div id="logout" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="cust_logout.asp">
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

<!--<script src="js/script.js"></script> -->

<script>
    
    $('.btn-main').click(function(){

        if($("form")[0].checkValidity()) {
            //your form execution code
        event.preventDefault();

        let email = $("#email").val();
        let password = $("#loginPassword").val();
        let warningText = "";

        //console.log(arID)
            $.ajax({

                url: "cust_login_auth.asp",
                type: "POST",
                data: {email: email, password: password},
                success: function(data) {
                    
                    if (data==='invalid email') {
                        warningText = "Invalid Email"
                        document.querySelector(".wrong-password-text").innerHTML = warningText;
                    }

                    else if (data==='False') {
                        warningText = "Sorry, your password was incorrect.";
                        document.querySelector(".wrong-password-text").innerHTML = warningText;
                        
                    }

                    else {
                        const jsonObject = JSON.parse(data)
                        // console.log(jsonObject[0]);
                        for (let i in jsonObject) {

                            localStorage.setItem('cust_id', jsonObject[i].cust_id);
                            localStorage.setItem('fname', jsonObject[i].fname);
                            localStorage.setItem('lname', jsonObject[i].lname);
                            localStorage.setItem('email', jsonObject[i].email); 
                            localStorage.setItem('department', jsonObject[i].department); 
                        }

                        alert("Logged in successfully!");
                        window.location.href = "default.asp";
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
