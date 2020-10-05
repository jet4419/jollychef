<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    
    ' Session.Timeout=1

    if Session("name") = "" then

        Response.Write("<script language=""javascript"">")
		Response.Write("alert('Your session timed out!')")
		Response.Write("</script>")
        isActive = false
 
            if isValidQty=false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""canteen_login.asp"";")
                Response.Write("</script>")
            end if

    
    else
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Offline Transaction</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

        <style>

            div.tail-select.no-classes {
                width: 400px !important;
            }

            .closed {
                height: 100vh;
                background: rgba(0,0,0,.7);
                content: "STORE CLOSED";
                z-index: 1000;
            }

            .center {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                text-align: center;
            }

            .cursive {
                font-family: 'Sedgwick Ave', cursive;
                font-size: 8rem;
            }

            .unlock {
                position: absolute;
                top: 1rem;
                left: 1rem;
                font-size: 2.5rem;
                color: #ccc;
            }

            .optgroup-title b {
                font-weight: bold !important; 
                color: rgba(0,0,0,.8)
            }

            .store-icon {
                color: #5e6f64;
            }

        </style>
    </head>

<%  'if Session("store")="closed" then%>
    <!--    <script>
            document.body.classList.add('closed')    
            document.body.innerHTML = "<a href='store_open.asp'><span class='unlock'>X</span></a><p class='center cursive'>Sorry, We're CLOSED</p>"
        </script> 
    -->
<%'else%>

<%  sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
    set objAccess = cnroot.execute(sqlQuery)
    Dim systemDate, maxDailyDate
    systemDate = CDate(Application("date"))

    if not objAccess.EOF then
        schedID = CInt(objAccess("sched_id"))
        isStoreClosed = Trim(objAccess("status").value)
        dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
        'currDate = CDate(Date)
    else
        isStoreClosed = "open"
        dateClosed = CDate(Date)
        'currDate = CDate(Date)
    end if

    set objAccess = nothing

    if dateClosed < systemDate then
        sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
        cnroot.execute(sqlUpdate)
    end if

    Dim maxRefNoChar, maxRefNo
    rs.Open "SELECT MAX(ref_no) FROM reference_no;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxRefNoChar = x.value

            next
            rs.MoveNext
        loop
        ' Response.Write(TypeName(maxRefNo))   

    rs.close  

    'Cash Reference No
    if maxRefNoChar <> "" then
        maxRefNo = Mid(maxRefNoChar, 6) + 1
    else
        maxRefNo = "000000000" + 1
    end if

    Const NUMBER_DIGITS = 9
    Dim formattedInteger

    formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxRefNo, NUMBER_DIGITS)

    maxRefNo = formattedInteger
    
%>

<%if systemDate >= dateClosed then%>

    <%if isStoreClosed <> "closed" then%>
<body>   

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<%
    day1 = Day(systemDate)

    if Len(day1) = 1 then
        day1 = "0" & day1
    end if

    month1 = Month(systemDate)

    if Len(month1) = 1 then
        month1 = "0" & month1
    end if

    year1 = Year(systemDate)
    fullDate = year1 & "-" & month1 & "-" & day1
%>

<div id="main">

    <div class="container">

        <p class="display-4 mb-5 p-0 text-center">Offline Transactions <i class="fas fa-store store-icon"></i></i></p>
        
        <form action="t_offline_transact_c.asp" method="POST">

            <div class="form-group col-md-4 pl-0">
                <label for="email" style="font-weight: 500">Reference No.</label>
                <input type="text" style="color: #f6ab6c; font-weight: 600;" class="form-control form-control" name="ref_no" id="ref_no" value="<%=maxRefNo%>" pattern="[0-9]{9}" required>
            </div>

            <div class="form-group col-md-4 pl-0">

                <label class="ml-1" style="font-weight: 500">Total Cash Payment </label>
                <div class="input-group mb-3">
                    <div class="input-group-prepend">
                        <span class="input-group-text bg-primary text-light">&#8369;</span>
                    </div>
                    <input type="number" name="total_payment" class="form-control w-25" aria-label="Amount (to the nearest dollar)" min="0.1" step="any" required>

                </div>

            </div>

            <div class="form-group pl-0">    
                <label>Date</label>
                <input class="form-control form-control-sm d-inline col-2" name="date" value="<%=fullDate%>" id="date" type="date" required> 
            </div>

            <button class="btn btn-danger"> Submit </button>

        </form>

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
<!--
    <footer class="footer bg-dark text-white text-center p-5">
        <span class=".lead">Email: curiosojet@gmail.com  &nbsp;&nbsp; <span class="text-danger">&copy <script>document.write(new Date().getFullYear())</script> </span> All rights reserved. </span>
    </footer>
-->    
    </body>        
    <%else%>   
        <body class="closed">     
        <%if currDate = dateClosed then%>
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%else%>
            <a href="#">
                <span class='unlock' data-toggle="modal" data-target="#confirmOpenStore">
                    <i class="fas fa-lock"></i>
                </span>
            </a><p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%end if%>
        </body>
    <%end if%>
<%else%>

    <body class="closed">
        <p class='center cursive'>Sorry :( , We're CLOSED</p>
    </body>

<%end if%>

<!-- Confirm Open Store-->
        <div id="confirmOpenStore" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="a_store_open.asp" method="POST">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmation <i class="fas fa-unlock-alt"></i> </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure to open the store?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Yes</button>
                        <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    <!-- End of Confirm Open Store -->
<script src="js/main.js"></script> 
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>

</body>
</html>   

 <%end if %> 
