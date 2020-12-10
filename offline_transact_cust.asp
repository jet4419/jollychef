<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Offline Transaction</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">

         <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>
        
        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

        <style>

            div.tail-select.no-classes {
                width: 400px !important;
            }

            .transact-container {
                /* border: 1.5px solid #ccc;
                border-radius: 5px; */
                padding: 1.5rem;
                /* width: auto; */

                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;  
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

            .department-lbl {
                font-weight: 600;
            }

            span.option-description {
                color: #0278ae !important;
                font-size: .75rem !important;
            }
            /* form {
                width: 500px;
            } */

        </style>
    </head>


<%  

    Dim maxArRefChar, maxArRefNo
    rs.Open "SELECT MAX(ref_no) FROM ar_reference_no;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxArRefChar = x.value

            next
            rs.MoveNext
        loop
        
    rs.close  

    'AR Reference No
    if maxArRefChar <> "" then
        maxArRefNo = Mid(maxArRefChar, 8) + 1
    else
        maxArRefNo = "000000000" + 1
    end if

    Const NUMBER_DIGITS = 9
    Dim formattedIntegerAR

    formattedIntegerAR = Right(String(NUMBER_DIGITS, "0") & maxArRefNo, NUMBER_DIGITS)

    maxArRefNo = formattedIntegerAR
    
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

    <div class="container mt-5 d-flex justify-content-center flex-column">

        <section class="transact-container"> 

            <p class="h2 mb-5 p-0 text-center">Offline Transactions <i class="fas fa-store store-icon"></i></i></p>

            <form id="myForm">

                <div class="form-group">

                    <label style="font-weight: 500"> Customer </label> <br>
                    <select id="customers" class="form-control mr-2" name="customers" style="width:650px; "class="chzn-select" required placeholder="Select Customer">

                    <% 
                        rs.open "SELECT cust_id, cust_fname, cust_lname, department, cust_type FROM customers ORDER BY department, cust_lname, cust_fname", CN2

                        if not rs.EOF then
                        
                            do until rs.EOF%>

                                <option value="<%=rs("cust_id")%>" data-description="<%=Trim(rs("department"))%>"> 
                                    <%=Trim(rs("cust_lname")) & " " & Trim(rs("cust_fname")) %>
                                </option>  
                                
                        <%rs.MoveNext
                        loop  
                        rs.close

                        end if  
                    %>

                    </select>

                </div>

                <div class="form-group">
                    <label for="ref_no" style="font-weight: 500">Reference No.</label>
                    <input type="text" style="color: #495057; font-weight: 600;" class="form-control form-control" name="arReferenceNo" id="ref_no" value="<%=maxArRefNo%>" pattern="[0-9]{9}" required>
                </div>

                <div class="form-group">

                    <label class="ml-1" style="font-weight: 500">Total Credits </label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text bg-primary text-light">&#8369;</span>
                        </div>
                        <input type="number" id="total_credits" name="total_credits" class="form-control w-25" aria-label="Amount (to the nearest dollar)" min="0.1" step="any" required>

                    </div>

                </div>

                <div class="btn-footer text-center mt-5">
                    <button class="btn btn-dark btnSubmit w-100"> Submit </button>
                </div>

            </form>
        
        </section>

        

    </div>
</div>   

<!--#include file="cashier_login_logout.asp"-->
  
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

<script src="js/main.js"></script> 
<script src="tail.select-full.min.js"></script>

<script>

    tail.select("#customers", {
        search: true,
        deselect: true,   
        descriptions: true 
    });

    const cashierName = localStorage.getItem('fullname');
    const myForm = document.getElementById('myForm');

    $('.btnSubmit').click( function() {
        
        // e.preventDefault();
        
        if(myForm.checkValidity()) {
            
            var URL = 'offline_credit_cust_c.asp';

            const custID = document.getElementById('customers').value;
            const arReferenceNo = document.getElementById('ref_no').value;
            let totalCredits = document.getElementById('total_credits').value;

            // console.log(prodID);
            $.ajax({
                url: URL,
                type: 'POST',
                data: {custID: custID, arReferenceNo: arReferenceNo, totalCredits: totalCredits, cashierName: cashierName},
            })
            .done(function(data) { 
                if (data !== 'invalid ref') {
                    alert('Transaction completed!');
                    location.reload();
                } else {
                    alert('Error: Invalid Reference Number');    
                }
            })
            .fail(function() {
                console.log("Response Error");
            });

        } else {
            console.error('Invalid inputs');
        }

    });

</script>

</body>
</html>   

 <%'end if %> 
