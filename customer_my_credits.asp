<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<%
    Response.Write "<script>"
    Response.Write "console.log('"&Session.SessionID&"')"
    Response.Write "</script>"
%>

<!DOCTYPE html>
<html>
    <head>
        
        <title>Credits</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

        </style>
        <!--<script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
        -->
    </head>

    <%
        if Session("cust_id") = "" then
            Response.Redirect("cust_login.asp")
        end if

        Dim fs
        Set fs=Server.CreateObject("Scripting.FileSystemObject")

        Dim systemDate, yearPath, monthPath

        systemDate = CDate(Application("date"))
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

        Dim mainPath, folderPath

        mainPath = CStr(Application("main_path"))
        folderPath = mainPath & yearPath & "-" & monthPath


        Dim maxRefNoChar, maxRefNo
        rs.Open "SELECT MAX(ref_no) FROM reference_no;", CN2

            do until rs.EOF
                for each x in rs.Fields

                    maxRefNoChar = x.value

                next
                rs.MoveNext
            loop
            Response.Write maxRefNoChar
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

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

    <%
        Dim custFullName, currOB

        currOB = 0.00
        custID = CLng(Session("cust_id"))
        
        sqlGetName = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
        set objAccess = cnroot.execute(sqlGetName)

        if not objAccess.EOF then
            
            custFullName = objAccess("cust_lname").value & " " & objAccess("cust_fname")
            department = objAccess("department").value

        end if

        set objAccess = nothing


        Dim obFile, obFilePath

        obFile = "\ob_test.dbf"
        obFilePath = folderPath & obFile

        sqlGetOB = "SELECT * FROM "&obFilePath&" WHERE cust_id="&custID&" GROUP BY cust_id"
        set objAccess = cnroot.execute(sqlGetOB)

        if not objAccess.EOF then
            currOB = currOB + CDbl(objAccess("balance").value)
        end if

        Dim arFile

        arFile = "\accounts_receivables.dbf"

    %>

        <%if custID<>0  then%>

<div id="main" class="mt-4 pt-4">

    <!--
    <h1 class="h1 text-center my-4 main-heading"> <strong><'%=custFullName&"'s"%> Receivable Lists</strong> </h1>
    -->
    <div id="content">
        <div class="container pb-3 mb-5">

            <div class="users-info mb-5">
                <h1 class="h3 text-center main-heading my-0"> <strong><span class="order_of">Credits of</span> <span class="cust_name"><%=custFullName%></span></strong> </h1>
                <h1 class="h5 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
                
            </div>

            <%  'sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
            '     set objAccess = cnroot.execute(sqlQuery)
            '     if not objAccess.EOF then
            '         isStoreClosed = CStr(objAccess("status"))
            '         set objAccess = nothing
            '     else 
            '         isStoreClosed = "open"
            '     end if    

            '    set objAccess = nothing

                Dim arFolderPath, arMonthPath, arYearPath

                folderPath = mainPath & yearPath & "-" & monthPath
        
                arFolderPath = folderPath
                arMonthPath = monthPath
                arYearPath = yearPath

                arPath = arFolderPath & arFile

                Dim isArFolderExist
                isArFolderExist = fs.FolderExists(arFolderPath)
            %>

            <% rs.Open "SELECT * FROM "&arPath&" WHERE cust_id="&custID&" and balance > 0 ORDER BY date_owed DESC, balance DESC GROUP BY invoice_no", CN2%>    
                          
            <form id="myForm" method="POST">
 
            <div class="table-responsive-sm mt-4">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Date</th>
                        <th>Invoice</th>
                        <th>Amount Credit</th>
                        <th>Balance</th>
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
                    </tr>
                    <%rs.MoveNext%>
                    <%loop%>

                    <%rs.close%>
                    <%CN2.close%>
                    <tfoot>
                        <tr>
                            <td colspan="3"> <strong> Total Balance </strong> </td>
                            <td colspan="1"> <strong> <span class="text-primary">&#8369;</span> <%=currOB%> </strong> </td>
                        </tr>
                    </tfoot>
                </table>

            </div>
            </form>

        </div>    
    </div>

    <%else%>

        <h1 class="h1 no-records"> NO RECORDS </h1>

    <%end if%>

</div>

    <footer class="footer">
        <p> <span class="copyright"> All rights reserved &copy </span> <script>document.write(new Date().getFullYear())</script> </p>
        <p>Feel free to contact me via email at:<span class="email">curiosojet@gmail.com</span></p>

        <div class="footer__social-media">
            <a href="https://twitter.com/devjet04" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://www.facebook.com/DevJet04" target="_blank"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>

        </div>
    </footer>
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

<script src="js/main.js"></script> 
<script>  
$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "36vh",
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
            myValue.forEach(function(item) {
                if (item.value.trim().length !== 0) {
                    //console.log(item.id + " " + item.value)
                    myInvoices = myInvoices + item.id  + ","
                    myValues = myValues + item.value + ","
                }
            });
            
            $.ajax({
                url: "t_receivables.asp",
                type: "POST",
                data: {
                       myInvoices: myInvoices, myValues: myValues, subTotal: subTotal, 
                       custID: custID, cashPayment: cashPayment, referenceNo: referenceNo
                      },
                success: function(data) {
                    //alert(data)

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