<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Adjustment Minus</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <!--<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">-->
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
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

            /* .input-total { */
                /* background: #fff; */
                /* border-color: #fff; */
                /* outline: none; */
                /* background: none;
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
                outline: none;
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

            .total-payment-container {
                /* display: flex;
                justify-content: space-between;
                flex-wrap: wrap; */
                display: flex;
                justify-content: space-evenly;
                align-items: center;
                flex-wrap: wrap;
            }

            .item {
                width: 250px !important;
            }

            /* .total-payment-container > div {
                flex: 0 50%;
            }
             */
            /* .item-left {
                padding-right: 150px;
            }

            .item-right {
                padding-left: 150px;
            } */

            .remarks-container {
                display: flex;
                justify-content: center;
                /* align-items: center; */
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
        Dim custID, ref_no, custName, department
        custID = CLng(Request.Form("cust_id"))
        ref_no_and_date = CStr(Request.Form("ref_no"))
        custName = CStr(Request.Form("cust_name"))
        department = CStr(Request.Form("department"))
        

        ref_no_and_date = Split(ref_no_and_date,",")

        ref_no = CStr(ref_no_and_date(0))
        ref_date = CDate(ref_no_and_date(1))

        Dim mainPath, yearPath, monthPath

        mainPath = CStr(Application("main_path"))
        yearPath = CStr(Year(ref_date))
        monthPath = CStr(Month(ref_date))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim collectionsFile, arFile

        collectionsFile = "\collections.dbf"
        arFile = "\accounts_receivables.dbf"

        Dim collectionsPath, arPath

        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile

    %>

        <%if custID<>0  then%>

<div id="main">

    <!--
    <h1 class="h1 text-center my-4 main-heading"> <strong><'%=custFullName&"'s"%> Receivable Lists</strong> </h1>
    -->
    <div id="content">
        <div class="container mb-5">

            <div class="users-info mb-5">
                <h1 class="h3 text-center main-heading my-0"> <strong><span class="order_of">(-) Adjustment for</span> <span class="cust_name"><%=custName%></span></strong> </h1>
                <h1 class="h5 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
            </div>  

            <% 'rs.Open "SELECT date, ref_no, invoice, debit FROM transactions WHERE ref_no="&ref_no&" and t_type='Pay' and cust_id="&custID, CN2
            '    rs.Open "SELECT Transactions.date, Transactions.ref_no, Transactions.invoice, Accounts_Receivables.receivable, Accounts_Receivables.balance, Transactions.debit "&_
            '            "FROM Transactions "&_
            '            "INNER JOIN Accounts_Receivables ON Transactions.invoice = Accounts_Receivables.invoice_no "&_
            '            "WHERE Transactions.ref_no='"&ref_no&"' and Transactions.t_type='Pay' and Transactions.cust_id="&custID, CN2

                ' rs.open "SELECT Collections.date, Collections.ref_no, Collections.invoice, Accounts_Receivables.receivable, Accounts_Receivables.balance, Collections.cash "&_
                '         "FROM "&collectionsPath&" "&_
                '         "INNER JOIN "&arPath&" ON Collections.ref_no = Accounts_Receivables.ref_no "&_
                '         "WHERE Accounts_Receivables.ref_no = '"&ref_no&"' GROUP BY Collections.invoice", CN2    
                    
                rs.open "SELECT Collections.date, Collections.ref_no, Collections.invoice, Accounts_Receivables.receivable, Accounts_Receivables.balance, Collections.cash "&_
                        "FROM "&collectionsPath&" "&_
                        "INNER JOIN "&arPath&" ON Collections.ref_no = Accounts_Receivables.ref_no "&_
                        "WHERE Collections.ref_no = '"&ref_no&"' GROUP BY Accounts_Receivables.invoice_no", CN2        

            %>    
                          
            <form id="myForm" method="POST">
                <input type="text" name="cust_name" id="cust_name" value="<%=custName%>" hidden>
                <input type="text" name="department" id="department" value="<%=department%>" hidden>
            <div class="table-responsive-sm">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">

                        <th>Date</th>
                        <th>Reference No.</th>
                        <th>Invoice</th>
                        <th>Amount Credit</th>
                        <th>Balance</th>
                        <th>Previous Paid</th>
                        <th>Adjustment</th>
                
                    </thead>

                    <% Dim totalCashPaid
                       totalCashPaid = 0.00 
                    %>
                    <%do until rs.EOF%>
                    <tr>
                        <%invoice = rs("invoice").value%>
                        <% refDate = CDate(rs("date"))%>
                        <td class="text-darker">
                            <%=(FormatDateTime(refDate,2))%>
                        </td>

                        <td class="text-darker">
                            <%=(rs("ref_no"))%>
                        </td>

                        <td class="text-darker">
                            <a href='ob_invoice_records.asp?invoice=<%=invoice%>'><%=(rs("invoice"))%></a>
                        </td>

                        <td class="text-darker">
                            <span class="text-primary">&#8369;</span><%=(rs("receivable"))%>
                        </td>

                        <td class="text-darker">
                            <span class="text-primary">&#8369;</span><%=(rs("balance"))%>
                        </td>

                        <td class="text-darker">
                            <span class="text-primary">&#8369;</span><%=(rs("cash"))%>
                            <%
                                totalCashPaid = totalCashPaid + CDbl(rs("cash"))
                            %>
                        </td>

                        <td>
                            <div class="input-group input-group-sm py-1">
                                <div class="input-group-prepend">
                                    <span class="input-group-text bg-primary text-light" id="inputGroup-sizing-sm">&#8369;</span>
                                </div>
                                <input onblur="findTotal()" type="number" id="<%=invoice%>" name="sub_adjustment_total" step="any" class="form-control" aria-label="Small" aria-describedby="inputGroup-sizing-sm" min="0.1" max="<%=rs("balance")%>">
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

                <div class="total-payment-container mt-3">
                    

                    <div class="item item-left form-group">
                        <span class="total-text">Recent Cash Paid
                            (<span class="text-primary">&#8369;</span>)
                        </span>
                        <input class="input-total form-control form-control-sm" type="number" name="total" value="<%=totalCashPaid%>" step="any" min="0.1" id="total" readonly/>
                    </div>

                    <div class="item item-right form-group">
                        <span class="total-text">Total Adjustment
                            (<span class="text-primary">&#8369;</span>)
                        </span>
                        <input class="input-total cash-input form-control form-control-sm" type="number" value="0" min="0.1" max="0" name="total_adjustment" step="any"  id="total_adjustment" step="any" required data-readonly/>
                    </div>


                    <div class="item item-left form-group">
                        <label class="total-text">Reference No</label>
                        <input class="form-control form-control-sm" style="color: #e43f5a; font-weight: 600;" type="text" id="reference_no" name="reference_no" value="<%=ref_no%>" readonly/>
                    </div>

                    <!--
                    <div class="item item-right form-group col-6">
                        <label class="total-text">Remarks</label>
                        <input class="form-control form-control-sm" type="text" name="remarks" id="remarks" pattern="[a-zA-Z0-9 ' . -]+" required>
                    </div>
                    -->

                </div>

                    <div class="remarks-container form-group">
                        <div>
                            <label class="d-block total-text text-center">Remarks</label>
                            <input class="item form-control form-control-sm" type="text" name="remarks" id="remarks" pattern="[a-zA-Z0-9 ' . - : ,]+" required>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center">
                        <input type="hidden" name="cust_id" id="cust_id" value="<%=custID%>">
                        <button type="submit" class="btn btn-dark btn-sm" id="myBtn">Submit Adjustment</button>
                    </div>
            </div>
            </form>

        </div>    
    </div>

    <%else%>

        <h1 class="h1 no-records"> NO RECORDS </h1>

    <%end if%>

</div>
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
        $(document).on("click", ".date_transact", function() {
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



    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

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

    $(document).on("click", "#myBtn", function() {

        var valid = this.form.checkValidity();

        if (valid) {

            event.preventDefault();

            var myValue = document.querySelectorAll('input[name="sub_adjustment_total"]');
            var myStrings = ""
            var myInvoices = ""
            var myAdjustments = ""
            var custID = document.getElementById("cust_id").value
            var custName = document.getElementById("cust_name").value
            var department = document.getElementById("department").value
            var totalAdjustment = document.getElementById("total_adjustment").value
            var remarks = document.getElementById("remarks").value
            //var cashPayment = document.getElementById("cash_payment").value
            var referenceNo = document.getElementById("reference_no").value
            myValue.forEach(function(item) {
                if (item.value.trim().length !== 0) {
                    //console.log(item.id + " " + item.value)
                    myInvoices = myInvoices + item.id  + ","
                    myAdjustments = myAdjustments + item.value + ","
                }
            });
            
            $.ajax({
                url: "t_adjustment_minus_ref_c.asp",
                type: "POST",
                data: {
                       myInvoices: myInvoices, myAdjustments: myAdjustments,
                       custID: custID, custName: custName, department: department, referenceNo: referenceNo,
                       remarks: remarks
                      },
                success: function(data) {

                    alert("Adjustment Submitted Successfully!");
                    //location.reload();
                    //alert(data)
                    location.replace("t_ob_main.asp");
                    //location.reload();

                    //window.location.href= "editAR.asp?#";

                }
            });

            // console.log(myStrings)
            // $("post")
            // window.location.href= "t_receivables.asp?myStrings="+myStrings
        }
    });

     function findTotal(){
        var arr = document.getElementsByName('sub_adjustment_total');
        var total = 0;
        for(var i=0;i<arr.length;i++){
            if(parseFloat(arr[i].value))
                total += parseFloat(arr[i].value);
        }
        total = total.toFixed(2)
        document.querySelector('input#total_adjustment').value = total;
        document.querySelector('input#total_adjustment').min = total;
        document.querySelector('input#total_adjustment').max = total;
        //document.querySelector('input#cash_payment').min = total;
    }
</script>


</body>
</html>    