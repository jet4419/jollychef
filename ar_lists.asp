<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Paying Debt</title>
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
        <link rel="stylesheet" type="text/css" href="bootstraptable/buttons/css/buttons.dataTables.min.css"/>
  
        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>

        <script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
        <script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>
        <script src="bootstraptable/jszip/jszip.min.js"></script>
        <script src="bootstraptable/pdfmake/pdfmake.min.js"></script>
        <script src="bootstraptable/pdfmake/vfs_fonts.js"></script>
        <script src="bootstraptable/buttons/js/dataTables.buttons.min.js"></script>
        <script src="bootstraptable/buttons/js/buttons.bootstrap4.min.js"></script>
        <script src="bootstraptable/buttons/js/buttons.foundation.min.js"></script>
        <script src="bootstraptable/buttons/js/buttons.flash.min.js"></script>
        <script src="bootstraptable/buttons/js/buttons.html5.min.js"></script>
        <script src="bootstraptable/buttons/js/buttons.print.min.js"></script>

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

            .total-text {
                font-size: 20px;
                font-weight: 500;
            }

            .total-balance {
                /* border: 1px solid #ccc; */
                padding: 5px;
                border-radius: 5px;
            }

            input[data-readonly] {
                pointer-events: none;
            }

            a {
                color: #086972;
                text-decoration: none;
            }

            .total-payment-container {
                display: flex;
                justify-content: space-evenly;
                align-items: center;
                flex-wrap: wrap;
            }

            .form-group {
                margin-bottom: 10px !important;
            }

            input[type=number]::-webkit-inner-spin-button, 
            input[type=number]::-webkit-outer-spin-button { 
            -webkit-appearance: none; 
            margin: 0; 
            }

             /* Chrome, Safari, Edge, Opera */
            input::-webkit-outer-spin-button,

            input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;

            }

            /* Firefox */
            input[type=number] {
            -moz-appearance: textfield;

            }

            #loading-image {
                background: url('./img/loading.jpg') center center/cover;
                /* display: none; */
                height: 200px;
                width: 200px; 
            }

        </style>
        <!--
        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
        -->
        
    </head>

    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if

        Dim fs
        Set fs=Server.CreateObject("Scripting.FileSystemObject")

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim monthLength

        monthLength = Month(systemDate)
        if Len(monthLength) = 1 then
            monthPath = "0" & CStr(Month(systemDate))
        else
            monthPath = Month(systemDate)
        end if

        Dim folderPath

        folderPath = mainPath & yearPath & "-" & monthPath


        Dim maxRefNoChar, maxRefNo
        rs.Open "SELECT MAX(ref_no) FROM reference_no;", CN2

            do until rs.EOF
                for each x in rs.Fields

                    maxRefNoChar = x.value

                next
                rs.MoveNext
            loop
            'Response.Write maxRefNoChar
            if maxRefNoChar <> "" then
                maxRefNo = Mid(maxRefNoChar, 6) + 1
            else
                maxRefNo = "000000000" + 1
            end if
            
        rs.close  

        Const NUMBER_DIGITS = 9
        Dim formatedInteger

        formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxRefNo, NUMBER_DIGITS)
        maxRefNo = formattedInteger
    %>

<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%
        if Request.Form("cust_id") = "" then
            Response.Redirect("ob_main.asp")
        end if

        if IsNumeric(Request.Form("cust_id")) = false then
            Response.Redirect("ob_main.asp")
        end if

        'Dim currOB
        
        'currOB = 0.00

        Dim custFullName
        
        custID = CLng(Request.Form("cust_id"))
        custFullName = CStr(Request.Form("cust_name"))
        department = CStr(Request.Form("department"))
        creditDate = CStr(Request.Form("date_records"))

        ' Dim obFile, obFilePath

        ' obFile = "\ob_test.dbf"
        ' obFilePath = folderPath & obFile

        ' sqlGetOB = "SELECT * FROM "&obFilePath&" WHERE cust_id="&custID&" GROUP BY cust_id"
        ' set objAccess = cnroot.execute(sqlGetOB)

        ' if not objAccess.EOF then
        '     currOB = currOB + CDbl(objAccess("balance").value)
        ' end if

    %>

        <%if custID<>0  then%>

<div id="main" class=" mb-5">

    <!--
    <h1 class="h1 text-center my-4 main-heading"> <strong><'%=custFullName&"'s"%> Receivable Lists</strong> </h1>
    -->
    <div id="content">
        <div class="container pb-3 mb-2">

            <div class="users-info mb-1">
                <h1 class="h3 text-center main-heading my-0" style="font-weight: 400"><span class="order_of">Credits of</span> <span id="custName" class="cust_name" style="font-weight: 600"><%=custFullName%></span></h1>
                <h1 class="h5 text-center main-heading my-0" style="font-weight: 600"> <span id="custDepartment" class="department_lbl"><%=department%></span> </h1>
                
            </div>
            <button id="<%=custID%>" class="btn btn-sm btn-dark btnPayDebt mt-2" data-toggle="modal" data-target="#date_credit">Select Credit Date</button>

            <%  'sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
            '     set objAccess = cnroot.execute(sqlQuery)
            '     if not objAccess.EOF then
            '         isStoreClosed = CStr(objAccess("status"))
            '         set objAccess = nothing
            '     else 
            '         isStoreClosed = "open"
            '     end if    

            '    set objAccess = nothing

                Dim arFile, arFolderPath

                arFile = "\accounts_receivables.dbf"
                arFolderPath = mainPath & creditDate
                arPath = arFolderPath & arFile

                Dim isArFolderExist
                isArFolderExist = fs.FolderExists(arFolderPath)
            %>

            <% rs.Open "SELECT * FROM "&arPath&" WHERE cust_id="&custID&" and balance > 0 ORDER BY date_owed DESC, balance DESC GROUP BY invoice_no", CN2%>    
                          
            <form id="myForm" method="POST">
 
            <div class="table-responsive-sm mt-2">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Date</th>
                        <th>Invoice</th>
                        <th>Amount Credit</th>
                        <th>Balance</th>
                        <th>Payment</th>
                
                    </thead>

                    <% Dim totalBalance 
                    totalBalance = 0.00 
                    %>
                    <%do until rs.EOF%>
                    <tr>
                        <%invoice = rs("invoice_no").value%>
                        <% d = CDate(rs("date_owed"))
                           d = FormatDateTime(d, 2)
                        %>
                        <td class="text-darker"><%Response.Write(d)%></td>
                        <td class="text-darker"><a target="_blank" href='ob_invoice_records.asp?invoice=<%=invoice%>&date=<%=d%>'><%Response.Write(rs("invoice_no"))%></a></td>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("receivable"))%></td>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("balance"))%></td>
                        <% totalBalance = totalBalance + CDbl(rs("balance").value) %>
                        <td>
                        <div class="input-group input-group-sm py-1">
                            <div class="input-group-prepend">
                                <span class="input-group-text bg-primary text-light" id="inputGroup-sizing-sm">&#8369;</span>
                            </div>
                            <input onblur="findTotal()" type="number" id="<%=invoice%>" name="sub_total" step="any" class="form-control" aria-label="Small" aria-describedby="inputGroup-sizing-sm" min="0.1" max="<%=rs("balance")%>">
                        </div>
                        </td>

                    </tr>
                    <%rs.MoveNext%>
                    <%loop%>

                    <%rs.close%>
                    <%CN2.close%>
                    <tfoot>
                        <tr>
                            <td colspan="3"> <strong> Total Balance </strong> </td>
                            <td colspan="2"> <strong> <%=totalBalance%> </strong> </td>
                        </tr>
                    </tfoot>
                </table>

                

                <div class="total-payment-container">

                    <div class="item item-left form-group ">
                        <span class="total-text">Reference No</span>
                        <input class="form-control form-control-sm" style="color: #e43f5a; font-weight: 600;" type="text" id="reference_no" name="reference_no" value="<%=maxRefNo%>" pattern="[0-9]{9}" required/>
                    </div>
                    
                    <div class="item item-left form-group">
                        <span class="total-text">Sub Total
                            <span class="text-dark">&#8369;</span>
                        </span>
                        <input class="input-total form-control form-control-sm" type="number" name="total" value="0" step="any" min="0.1" max="0" id="total" required data-readonly/>
                    </div>

                    <div class="item item-right form-group">
                        <span class="total-text">Cash
                            <span class="text-dark">&#8369;</span>
                        </span>
                        <input class="input-total cash-input form-control form-control-sm" type="number" value="0" min="0.1" name="cash_payment" step="any"  id="cash_payment" step="any" required/>
                    </div>

                </div>

                <div class="d-flex justify-content-center">
                    <input type="hidden" name="cust_id" id="cust_id" value="<%=custID%>">
                    <input type="hidden" name="credit_date" id="credit_date" value="<%=creditDate%>">
                    <button type="submit" class="btn btn-dark btn-sm" id="myBtn">Submit Payment</button>
                </div>

            </div>
            </form>

            

        </div>    
    </div>

    <!-- PROGRESS BAR WHEN Processing the payment
    <div id="loading-image"> </div>
    -->

    <%else%>

        <h1 class="h1 no-records"> NO RECORDS </h1>

    <%end if%>

</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <!-- Pay Debt -->
        <div class="modal fade" id="pay_debt_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <form action="ar_lists.asp" class="form-group mb-3" id="payDebtForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Pay Current Credit </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="payDebtBody">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" id="payDebtCash" class="btn btn-primary">Save changes</button>
                            </div>
                        </form>  
                </div>
            </div>
        </div> 
      <!-- END OF Pay Debt -->    

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

/* Progress Bar
const loadingImg = document.getElementById('loading-image');
loadingImg.classList.add('hidden');
*/

$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "35vh",
        scroller: true,
        "paging": false,
        scrollCollapse: true,
        "order": [],
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

    // Pay Debt
    $(document).on("click", ".btnPayDebt", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            $.ajax({

            url: "ar_list_datepicker.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#payDebtBody").html(data);
                $("#pay_debt_modal").modal("show");
            }
        })    
    }) // End of Pay Debt    

    
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

            var myValue = document.querySelectorAll('input[name="sub_total"]');
            var myStrings = ""
            var myInvoices = ""
            var myValues = ""
            var custID = document.getElementById("cust_id").value
            var subTotal = document.getElementById("total").value
            var cashPayment = document.getElementById("cash_payment").value
            var referenceNo = document.getElementById("reference_no").value
            var creditDate = document.getElementById("credit_date").value

            var custName = document.getElementById('custName').textContent;
            var custDepartment = document.getElementById('custDepartment').textContent;

            myValue.forEach(function(item) {
                if (item.value.trim().length !== 0) {
                    //console.log(item.id + " " + item.value)
                    myInvoices = myInvoices + item.id  + ","
                    myValues = myValues + item.value + ","
                }
            });

           /* Progress Bar 
           loadingImg.classList.remove('hidden');
           */
            
            $.ajax({
                url: "ar_payment_c.asp",
                type: "POST",
                data: {
                       myInvoices: myInvoices, myValues: myValues, subTotal: subTotal, 
                       custID: custID, cashPayment: cashPayment, referenceNo: referenceNo, custName: custName, custDepartment: custDepartment,
                       creditDate: creditDate
                      },
                success: function(data) {
                    //alert(data)

                /* Progress Bar
                loadingImg.classList.add('hidden')
                */
                    if (data=='false') {
                        
                        alert('Error: Reference already exist!');
                        location.reload();
                    }

                    else {

                        alert("Payment Transfer Successfully!");
                        //location.reload();
                        //alert(data)
                        location.replace("receipt_ar.asp?ref_no="+data);


                        //window.location.href= "editAR.asp?#";
                    }
                }
            });

            // console.log(myStrings)
            // $("post")
            // window.location.href= "t_receivables.asp?myStrings="+myStrings
        }
    });

     function findTotal(){
        var arr = document.getElementsByName('sub_total');
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