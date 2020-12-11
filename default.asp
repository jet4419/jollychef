<!--#include file="cust_homepage_checker.html"-->
<!doctype html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Homepage</title>
        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
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

<!--#include file="cust_login_logout.asp"-->

<!--<script src="js/script.js"></script> -->

<script>

    function uuidv4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }
    
    const loginForm = document.getElementById('login-form');

    $('.btn-main').click(function(e){

        e.preventDefault();

        if(loginForm.checkValidity()) {
            //your form execution code
            const tokenID = uuidv4();
            let email = $("#email").val();
            let password = $("#loginPassword").val();
            let warningText = "";

            $.ajax({

                url: "cust_login_auth.asp",
                type: "POST",
                data: {email: email, password: password, tokenID: tokenID},
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
                            localStorage.setItem('tokenid', jsonObject[i].tokenid);
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
