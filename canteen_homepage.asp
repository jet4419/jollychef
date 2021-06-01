<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!doctype html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Canteen Homepage</title>
        
       
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/homepage.css">
        
        
        <link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
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

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<div id="bg-clip"></div>

<main id="main" class="main--main-page homepage">

    <!--#include file="cashier_login_logout.asp"-->

	<div class="home-main-heading"> 
    	
    	<span class="home-main-heading-text home-main-heading--text-1">
        	<span class="letter-r">
                <span class="jolly-chef-text">JollyChef</span>
            </span>
            <span class="letter-c">Inc.</span>
        </span> 
        <span class="home-main-heading-text home-main-heading--text-2">We serve passion</span> 
    </div>

    <div class="home-heading-logo">
        <img src="../img/order_food.svg">
    </div>
    
</main>

<script>
    
    $('.btn-main').click(function(){

        if($("form")[0].checkValidity()) {
            //your form execution code
        event.preventDefault();

        let email = $("#email").val();
        let password = $("#password").val();
        let warningText = "";

        //console.log(arID)
            $.ajax({

                url: "canteen_login_auth.asp",
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

                        for (let i in jsonObject) {

                            localStorage.setItem('name', jsonObject[i].name);
                            localStorage.setItem('fullname', jsonObject[i].fullname);
                            localStorage.setItem('email', jsonObject[i].email);
                            localStorage.setItem('type', jsonObject[i].type); 
                        }

                        alert("Logged in successfully!");
                        window.location.href = "canteen_homepage.asp";
                    }
                    

                }
            })
        }

        else console.log("invalid form");
    });

</script>
<script src="js/main.js"></script>  
<script> 
    // const btnNav = document.getElementById('btn-collapsible-bar');
    
    // btnNav.addEventListener('click', () => {
    //     console.log('hey')

    //     const mySidebar = document.getElementById('mySidebar');
    //     const mainElement = document.getElementById("main");
    //     const footerElement = document.querySelector('.footer');
     
    //     mySidebar.classList.toggle('scale-up-width');
    //     mainElement.classList.toggle('scale-up-margin');

    //     if (footerElement) {

    //         footerElement.classList.toggle('scale-up-margin');
    //     }
                
    // })

</script>

</body>
</html>
