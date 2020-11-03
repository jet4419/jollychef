<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Transaction Process</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!--<link rel="stylesheet" href="tail.select-default.css">-->
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/twitter-bootstrap.css"/>
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/dataTables.bootstrap4.min.css"/>
        <link rel="stylesheet" type="text/css" href="Datatables/buttons/css/buttons.dataTables.min.css"/>
        
        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>

        <script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
        <script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>
        <script src="bootstraptable/jszip/jszip.min.js"></script>
        <script src="bootstraptable/pdfmake/pdfmake.min.js"></script>
        <script src="bootstraptable/pdfmake/vfs_fonts.js"></script>
        <script src="Datatables/buttons/js/dataTables.buttons.min.js"></script>
        <script src="Datatables/buttons/js/buttons.bootstrap4.min.js"></script>
        <script src="Datatables/buttons/js/buttons.foundation.min.js"></script>
        <script src="Datatables/buttons/js/buttons.flash.min.js"></script>
        <script src="Datatables/buttons/js/buttons.html5.min.js"></script>
        <script src="Datatables/buttons/js/buttons.print.min.js"></script>

        <style>
            /* .dt-buttons {
                position: absolute;
                bottom: 10px;
                left: 40%;
                text-align: center;
            }    */

            .dt-buttons {
                position: absolute;
                top: -10px;
                left: 22%;
                margin-top: .5rem;
                text-align: left;
            }   

            .users-info {
                font-family: 'Kulim Park', sans-serif;
                border: 1px solid #aaa;
                padding: 5px;
                border-radius: 10px;
            }

            .total-payment-container {
                /* border: 1px solid #ccc; */
                padding: 5px;
                /* border-radius: 10px; */
            }

            .cust_name {
                color: #438a5e;
            }

            .department_lbl {
                color: #b49c73;
            }

            .order_of {
                color: #333;
            }

            .user-info-label, .user-info-balance {
                color: #074684;
                font-weight: 500;
                font-size: .85rem;
            }

            .no-records {
                height: 85vh;
                display:flex;
                justify-content: center;
                align-items: center;
                
            }

            p.display-date-container {
                margin-top: .5rem;
                padding: 0;
            }

            /* td {
                font-size: 1.1rem;
            } */

            .date-label-container {
                margin-top: 1rem;
                width: 100%;
                display: flex;
                justify-content: space-between;
            }

            .users-info--divider {
                min-height: 150px;
                width: auto;
                display: inline-flex;
                flex-direction: column;
                justify-content: space-evenly;
            }

            .user-info--text{
                border: 5px #000 black;
                white-space: nowrap;
                display: inline-block;
                width: 80px;
            }

            .user-info-balance {
                white-space: nowrap;
                display: inline-block;
                width: 150px;
            }

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

            /* .input-total {
                width: 200px !important;
            } */

            .total-text {
                font-size: 20px;
                font-weight: 500;
            }

            .total-balance {
                /* border: 1px solid #ccc; */
                padding: 5px;
                border-radius: 5px;
            }

            input {
                background: #eee;
                border-radius: 5px;
                border: none;
                padding: 3px 5px ;
                outline: none
            }

            input[data-readonly] {
                pointer-events: none;
            }

            a {
                color: #086972;
                text-decoration: none;
            }

            /* .cash-input {
                width: 175px;
            } */

            .recent-total-payment-container {
                display: flex;
                justify-content: space-around;
                align-items: center;
                flex-wrap: wrap;
            }

            .total-payment-container {
                display: flex;
                justify-content: space-around;
                align-items: center;
                flex-wrap: wrap;
            }


            /* .item {
                width: 250px !important;
            } */

            .recent-total-payment-container > div {
                flex: 0 50%;
            }
            
            /* .item-left {
                padding-right: 150px;
            }

            .item-right {
                padding-left: 150px;
            } */

            .ref-bg {
                background: #fff !important;
            }

        </style>
        <!--<script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
        -->
    </head>

    <%
        if Session("type") = "" then
            Response.Redirect("canteen_login.asp")
        end if
    %>

<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%
        Dim systemDate

        systemDate = CDate(Application("date"))
        transactDate = FormatDateTime(systemDate, 2)

        Dim collectID, custID, referenceNo
        Dim custFullName, currOB
        currOB = 0.00
        ' custID = CInt(Request.QueryString("cust_id"))
        collectID = Request.QueryString("collectID")
        custID = Request.QueryString("custID")
        referenceNo = Request.QueryString("ref_no")
        ' custName = CStr(Request.Form("cust_name"))

        Dim mainPath, yearPath, monthPath

        mainPath = CStr(Application("main_path"))
        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim collectionsFile, arFile, obFile

        collectionsFile = "\collections.dbf"
        obFile = "\ob_test.dbf"
        arFile = "\accounts_receivables.dbf"
        transactionsFile = "\transactions.dbf"

        Dim collectionsPath, arPath

        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
        obPath = mainPath & yearPath & "-" & monthPath & obFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile
        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile

        sqlCheckDate = "SELECT date FROM "&collectionsPath&" "&_
        "WHERE id="&collectID&" and ref_no='"&referenceNo&"' and cust_id="&custID
        set objAccess = cnroot.execute(sqlCheckDate)

        if not objAccess.EOF then

            recordDate = CDate(objAccess("date").value)

        end if

        ' Response.Write("<br>")
        ' Response.Write(recordDate)
        ' Response.Write("<br>")
        ' Response.Write(systemDate)

        'If the record date is not equal to the system date. No editing should be allowed.'
        if recordDate <> systemDate then

            Response.Redirect("t_collections_report.asp")

        end if

        'Getting the information about the customer'
        sqlGetName = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
        set objAccess = cnroot.execute(sqlGetName)

        if not objAccess.EOF then
            
            custFullName = objAccess("cust_fname").value & " " & objAccess("cust_lname")
            department = objAccess("department").value

        else    

            custFullName = "OTC-Customer"
            department = "none"

        end if

        set objAccess = nothing

        sqlGetOB = "SELECT * FROM "&obPath&" WHERE cust_id="&custID&" GROUP BY cust_id"
        set objAccess = cnroot.execute(sqlGetOB)

        if not objAccess.EOF then
            currOB = currOB + CDbl(objAccess("balance").value)
        end if
    %>

        <%if custID<>0  then%>

<div id="main">

    <!--
    <h1 class="h1 text-center my-4 main-heading"> <strong><'%=custFullName&"'s"%> Receivable Lists</strong> </h1>
    -->
    <div id="content">
        <div class="container mb-5 pb-3">

            <div class="users-info mb-3">
                <h1 class="h2 text-center main-heading my-0"> <strong><span class="order_of">Edit Payment of</span> <span class="cust_name"><%=custFullName%></span></strong> </h1>
                <h1 class="h4 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
                <!--
                <h4 class=" total-text text-center total-balance mr-3">Total Balance:
                    <span class="text-primary">&#8369;</span> <'%='currOB%>
                </h4>
                -->
            </div>

            <%  sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
                set objAccess = cnroot.execute(sqlQuery)
                if not objAccess.EOF then
                    isStoreClosed = CStr(objAccess("status"))
                    set objAccess = nothing
                else 
                    isStoreClosed = "open"
                end if    

                set objAccess = nothing
            %>

            <% 
                

                Dim paymentMethod
                sqlGetPaidMethod = "SELECT p_method FROM "&collectionsPath&" WHERE ref_no='"&referenceNo&"'"
                set objAccess = cnroot.execute(sqlGetPaidMethod)

                if not objAccess.EOF then
                    paymentMethod = Trim(objAccess("p_method").value)
                end if

                rs.open "SELECT Collections.ref_no, Collections.invoice, Accounts_Receivables.receivable, "&_
                        "Accounts_Receivables.balance, Collections.cash, OB_Test.cash_paid, Collections.Date "&_
                        "FROM "&collectionsPath&" "&_
                        "INNER JOIN "&obPath&" ON Collections.ref_no = Ob_Test.ref_no "&_
                        "INNER JOIN "&arPath&" On Collections.invoice = Accounts_Receivables.invoice_no "&_
                        "WHERE Collections.ref_no='"&referenceNo&"'", CN2 

                ' rs.open "SELECT Transactions.ref_no, Transactions.invoice, Accounts_Receivables.receivable, "&_
                '         "Accounts_Receivables.balance, Transactions.Debit, OB_Test.cash_paid, Transactions.Date "&_
                '         "FROM "&transactionsPath&" "&_
                '         "INNER JOIN "&obPath&" ON Transactions.ref_no = Ob_Test.ref_no "&_
                '         "INNER JOIN "&arPath&" On Transactions.ref_no = Accounts_Receivables.ref_no "&_
                '         "WHERE Transactions.ref_no='"&referenceNo&"' GROUP BY Accounts_Receivables.invoice_no", CN2 

            %>  
                <!--
                <div class='date-label-container'>
                    <div>
                        <p class='display-date-container'><strong> Date: </strong>
                            <'%='FormatDateTime(recordDate, 2)%>
                        </p>
                    </div>       
                    <div>
                               
                    </div>
                </div>
                -->
                          
            <form id="myForm" class="my-4" method="POST">
                <!-- Payment Method -->
                <input type="text" id="paymentMethod" name="paymentMethod" value="<%=paymentMethod%>" hidden>
            <div class="table-responsive-sm">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Date</th>
                        <th>Invoice</th>
                        <th>Amount Credit</th>
                        <th>Balance</th>
                        <th>Recent Payment</th>
                        <th>Payment</th>
                
                    </thead>

                    <%  Dim totalBalance, totalRecentPayment, recentCashPaid, minInputVal, maxInputVal
                        totalBalance = 0.00 
                        totalRecentPayment = 0.00
                        recentCashPaid = 0.00
                        maxInputVal = 0.00
                        minInputVal = 0.00
                        'ref_no = rs("ref_no").value

                        Const NUMBER_DIGITS = 9

                        Dim myInteger
                        Dim formatedInteger

                        'myInteger = 456789
                        'formatedInteger = Right(String(NUMBER_DIGITS, "0") & ref_no, NUMBER_DIGITS)
                        'reference = formatedInteger

                    %>

                    <%do until rs.EOF%>
                    
                    <tr>
                        <%invoice = rs("invoice").value%>
                        <%recentCashPaid = rs("cash_paid").value%>
                        <% d = CDate(rs("date"))%>
                        <td class="text-darker"><%Response.Write(FormatDateTime(d,2))%></td>
                        <td class="text-darker"><a target="_blank" href='ob_invoice_records.asp?invoice=<%=invoice%>&date=<%=transactDate%>'><%Response.Write(rs("invoice"))%></a></td>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("receivable"))%></td>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("balance"))%></td>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("cash"))%></td>
                        <% totalRecentPayment = totalRecentPayment + CDbl(rs("cash").value) 
                           maxInputVal = CDbl(rs("balance").value) + CDbl(rs("cash").value)
                           minInputVal = (CDbl(rs("receivable").value) - CDbl(rs("cash").value)) * -1
                        %>
                        <%' totalBalance = totalBalance + CDbl(rs("balance").value) %>
                        <!--
                        <td>
                        <button type="button" id="<'%=invoice%>" class="btn btn-info btn-block mx-auto mb-2 btnCollect" style="max-width: 50px;" data-toggle="modal" data-target="#collect_money">
                            <i class="fa fa-credit-card" aria-hidden="true"></i>
                        </button>
                        
                        <a rel="facebox" title="Click to edit the product" href="bootEditProduct.asp?id=<'%'=id%>"><button class="btn btn-warning"><i class="icon-edit"></i> </button> </a>
                        <button class="btn btn-warning" title="Click to edit the product" id=<-%=id%> formaction="editproduct.asp?id=<-%=id%>" onClick="update_data(<-%=id%>,'<-%=x.value%>')"><i class="icon-edit"></i> </button>
                        </td>
                        -->
                        <td>
                        <div class="input-group input-group-sm py-1">
                            <div class="input-group-prepend">
                                <span class="input-group-text bg-primary text-light" id="inputGroup-sizing-sm">&#8369;</span>
                            </div>
                            <input onblur="findTotal()" value="<%=rs("cash")%>" type="number" id="<%=invoice%>" name="new_payment" step="any" class="form-control" aria-label="Small" aria-describedby="inputGroup-sizing-sm" min="<%=minInputVal%>" max="<%=maxInputVal%>" required>
                        </div>
                        </td>

                    </tr>
                    <%rs.MoveNext%>
                    <%loop%>
                    
                    <!--
                    <tfoot>
                        <tr>
                            <td> Total : <input type="number" name="total" id="total"/> </td>
                            <td> </td>
                        </tr>
                    </tfoot>
                    -->
                    <%rs.close%>
                    <%CN2.close%>

                </table>

                

                <div class="total-payment-container">

                    <div class="form-group">
                        <label class="total-text">Reference No</label>
                        <input class="form-control form-control-sm ref-bg" type="text" style="color: #e43f5a; font-weight: 600;" id="reference_no" name="reference_no" min="1" value="<%=referenceNo%>" readonly/>
                    </div>

                    <div class="form-group">
                        <span class="total-text">Sub Total
                            <span class="text-primary">&#8369;</span>
                        </span>
                        <input class="input-total form-control form-control-sm" type="number" name="total" value="<%=totalRecentPayment%>" step="any" min="<%=totalRecentPayment%>" max="<%=totalRecentPayment%>" id="total" required data-readonly/>
                    </div>

                    <div class="form-group">
                        <span class="total-text">Cash
                            <span class="text-primary">&#8369;</span>
                        </span>
                        <input class="input-total cash-input form-control form-control-sm" type="number" value="<%=recentCashPaid%>" name="cash_payment" step="any"  id="cash_payment" min="<%=totalRecentPayment%>" step="any" required/>
                    </div>

                </div>

                <div class="d-flex justify-content-center mb-5">
                    <input type="hidden" name="cust_id" id="cust_id" value="<%=custID%>">
                    <input type="hidden" name="transact_date" id="transact_date" value="<%=transactDate%>">
                    <button type="submit" class="btn btn-danger btn-sm" id="myBtn">Submit Payment</button>
                </div>

            </form>

        </div>    
    </div>

</div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <%else%>

        <h1 class="h1 no-records"> NO RECORDS </h1>

    <%end if%>

    <!-- Date Range of Transactions -->
        <div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="a_ob_records.asp" method="POST" id="allData2">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Date Range of Transaction <i class="far fa-calendar-check"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="daterange_modal_body">
                        <!-- Modal Body (Contents) -->
                        
                            
                    </div>    
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-sm mb-1 bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary btn-sm mb-1" id="generateReport2">Generate Report</button>
                            </div>        
                    </form>
                        
                </div>
            </div>
        </div>
    <!-- End of Date Range of Transactions -->

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
<script>  
$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "36vh",
        scroller: true,
        "paging": false,
        scrollCollapse: true,
        dom: "<'row'<'col-sm-12 col-md-4'i><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-success' },
            { extend: 'excel', className: 'btn btn-sm btn-success' },
            { extend: 'pdf', className: 'btn btn-sm btn-success' },
            { extend: 'print', className: 'btn btn-sm btn-success' }
        ]
    });
}); 

    // Date Generator
        $(document).on("click", ".date_transact", function(event) {

            event.preventDefault();

            $.fn.dataTable.ext.classes.sPageButton = 'button primary_button';
            let custID = $(this).attr("id");
            $.ajax({

            url: "a_ob_daterange.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Generator  




    function monthEnd(nId, nCreditBal, nDebitBal) {

        //alert("Are you sure to cutoff?")
        if(confirm('Are you sure to cutoff on this date?'))
        {
            window.location.href='a_ob_month_end.asp?cust_id='+nId+'&credit_bal='+nCreditBal+'&debit_bal='+nDebitBal;
            //window.location.href='delete.asp?delete_id='+id;
        }

    }

    
    // Payment

    // var $myForm = $('#myForm');

    // if(! $myForm[0].checkValidity()) {
    // // If the form is invalid, submit it. The form won't actually submit;
    // // this will just cause the browser to display the native HTML5 error messages.
    // $myForm.find(':submit').click();
    // }

     $("#total").keydown(function(e){
        e.preventDefault();
    });

    $(document).on("click", "#myBtn", function(event) {

        var valid = this.form.checkValidity();

        if (valid) {

            event.preventDefault();

            var myValue = document.querySelectorAll('input[name="new_payment"]');
            var myStrings = ""
            var myInvoices = ""
            var myValues = ""
            var custID = document.getElementById("cust_id").value
            var subTotal = document.getElementById("total").value
            var cashPayment = document.getElementById("cash_payment").value
            var referenceNo = document.getElementById("reference_no").value
            var paymentMethod = document.getElementById("paymentMethod").value
            var transactDate = document.getElementById("transact_date").value
            myValue.forEach(function(item) {
                if (item.value.trim().length !== 0) {
                    //console.log(item.id + " " + item.value)
                    myInvoices = myInvoices + item.id  + ","
                    myValues = myValues + item.value + ","
                }
            });
            
            $.ajax({
                url: "sales_current_credit_c.asp",
                type: "POST",
                data: {
                       myInvoices: myInvoices, myValues: myValues, subTotal: subTotal, 
                       custID: custID, cashPayment: cashPayment, referenceNo: referenceNo,
                       paymentMethod: paymentMethod, date: transactDate
                      },
                success: function(data) {
                    //alert(data)
                    alert("Payment Transfer Successfully!");
                    //location.reload();
                    //alert(data)
                    location.replace("receipt_ar_current.asp?ref_no="+data);
                    //window.location.href= "editAR.asp?#";
                }
            });

            // console.log(myStrings)
            // $("post")
            // window.location.href= "t_receivables.asp?myStrings="+myStrings
        }
    });

     function findTotal(){
        var arr = document.getElementsByName('new_payment');
        var total = 0;
        for(var i=0;i<arr.length;i++){
            if(parseFloat(arr[i].value))
                total += parseFloat(arr[i].value);
        }
        total = total.toFixed(2)
        document.querySelector('input#total').value = total;
        document.querySelector('input#total').min = total;
        document.querySelector('input#total').max = total;
        document.querySelector('input#cash_payment').min = total;
    }
</script>


</body>
</html>    