<!--#include file="dbConnect.asp"-->
<!--#include file="sha256.asp"-->
<!--#include file="customer_checker_login.html"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/login_page_styles.css">
    <title>Canteen Login Page</title>

    <script src="./jquery/jquery_uncompressed.js"></script>
</head>
<body>

    <main class="login">

        
            <div class="login__header">
                <h2 class="login__header--text">Sign In</h2>
            </div>

            <div class="login__body">
                <form id="login-form" class="form-body">

                    <div class="label-input-groups">
                        <label class="form-label" name="email" for="email">Email</label>
                        <input class="form-inputs" type="email" name="email" id="email" required>
                    </div>

                    <div class="label-input-groups">
                        <label class="form-label" for="password">Password</label>   
                        <input class="form-inputs" name="password" type="password" name="password" id="loginPassword" required>
                        <span class="wrong-password-text" style="display: inline-block; padding-top: 10px; color: red; font-size: 11px; text-align: center;"></span>
                    </div>

                    <button type="submit" class="btn-main btn-login-form" name="btn-login" value="login">Login</button>   
                </form>
            </div>
            <!--
            <div class="login__footer">
                Looking to <a href="bootRegisterCustomer.asp" class="login__footer--link">create an account?</a>
            </div>
            -->
        </div>
        
    </main>

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
            const email = $("#email").val();
            const password = $("#loginPassword").val();
            let warningText = "";

        
            $.ajax({

                url: "cust_login_auth.asp",
                type: "POST",
                data: {email: email, password: password, tokenID: tokenID},
                success: function(data) {
                    // console.log(data);
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

                            // console.log(localStorage.getItem('cust_id'));
                            // console.log(localStorage.getItem('fname'));
                            // console.log(localStorage.getItem('lname'));
                            // console.log(localStorage.getItem('email'));

                            

                        alert("Logged in successfully!");
                        window.location.href = "default.asp";
                    }
                    

                }
            })
        }

        else console.log("invalid form");
    });

</script>

<!--<script>

const xhr = new XMLHttpRequest();

xhr.open('POST', 'login_authentication.asp', true);
xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

xhr.onload = () => {

} 

</script> -->
</body>
</html>