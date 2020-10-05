<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cash Transactions Report</title>
        
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!-- <link rel="stylesheet" href="tail.select-default.css"> -->
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" href="tail.select-default.css">
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
                height: auto;
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

            input {
                background: #eee;
                border-radius: 5px;
                border: none;
                padding: 3px 5px ;
            }

            a {
                color: #086972;
                text-decoration: none;
            }

            .order_of {
                color: #333;
            }

            .cust_name {
                color: #438a5e;
            }

            .department_lbl {
                color: #b49c73;
            }

            .total-value {
                font-weight: 500
            }

        </style>
        <!--<script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
        -->
    </head>
<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>
    
<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

    <%
        Dim custID, custName

        custID = CDbl(Request.Form("cust_id"))
        custName = CStr(Request.Form("cust_name"))

    %>

<div id="main">    

        <%if custID<>0  then%>
    <%

        Dim department
        department = Request.Form("department")

        Dim startDate, endDate, systemDate

        startDate = Request.Form("startDate")
        endDate = Request.Form("endDate")
        systemDate = CDate(Application("date"))

        if startDate="" then
            
            startDate = CDate(FormatDateTime(systemDate, 2))
            displayDate1 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else
            startDate = CDate(FormatDateTime(startDate, 2))
            displayDate1 = Day(startDate) & " " &  MonthName(Month(startDate)) & " " & Year(startDate)
        end if    

        if endDate="" then

            endDate = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else  

            endDate = CDate(FormatDateTime(endDate, 2))
            displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)     

        end if   

        Dim monthsDiff

        monthsDiff = DateDiff("m", startDate, endDate) 

        p_start_date = startDate
        p_end_date = endDate
    %>

    <div id="content">
        <div class="container mb-5">
            <div class="users-info mb-3">
                <h1 class="h2 text-center main-heading my-0"> <strong><span class="order_of">Sales Reports of</span> <span class="cust_name"><%=custName%></span></strong> </h1>
                <h1 class="h4 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
            </div>

            <div class="users-info--divider">
                <span class="p-0 m-0 d-block">
                    <button type="button" class="btn btn-dark btn-sm mb-1 d-inline w-100 date_transact" id="<%=custID%>"  data-toggle="modal" data-target="#date_transactions">Generate Date Reports</button>
                </span> 
            </div>

            <div class='date-label-container'>
                <div>
                    <p class='display-date-container'><strong> Date Range: </strong>
                        <%=displayDate1 & " - "%>
                        <%=displayDate2%>
                    </p>
                </div>       
            </div>

            <div class="table-responsive-sm">
            <table class="table table-striped table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Reference No.</th>
                    <th>Transaction Type</th>
                    <th>Invoice</th>
                    <th>Amount</th>
                    <th>Date</th>
                </thead>
        <% 
            Dim fs
            Set fs = Server.CreateObject("Scripting.FileSystemObject")

            Dim mainPath, monthPath, yearPath

            mainPath = CStr(Application("main_path"))

            Dim transactionsFile, folderPath, transactionsPath
            transactionsFile = "\transactions.dbf"

            for i = 0 To monthsDiff   

                monthLength = Month(DateAdd("m",i,p_start_date))
                if Len(monthLength) = 1 then
                    monthPath = "0" & CStr(Month(DateAdd("m",i,p_start_date)))
                else
                    monthPath = Month(DateAdd("m",i,p_start_date))
                end if

                yearPath = Year(DateAdd("m",i,p_start_date))

                folderPath = mainPath & yearPath & "-" & monthPath
                transactionsPath =  folderPath & transactionsFile

                Dim balance, totalBalance, totalCashPaid
                totalBalance = 0.00
                totalCashPaid = 0.00

                Do 

                    if fs.FolderExists(folderPath) <> true then EXIT DO
                    if fs.FileExists(transactionsPath) <> true then EXIT DO    


                    rs.open "SELECT id, ref_no, t_type, invoice, debit, credit, date "&_ 
                            "FROM "&transactionsPath&" "&_
                            "WHERE cust_id="&custID&" and t_type='OTC' and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"') ORDER BY id", CN2 
                    %>
             
                    <%
                        balance = endingCredit        
                    %>

                    <%do until rs.EOF%>
                    <%d = CDate(rs("date"))
                    d = FormatDateTime(d, 2)
                    %>
                    <tr>
                        <td class="text-darker">
                            <a target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'><%Response.Write(rs("ref_no"))%></a>
                            </td>
                        <td class="text-info"><%=rs("t_type")%></td>

                        <td class="text-darker">
                            <a target="_blank" href='ob_invoice_records.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'><%=rs("invoice")%></a>
                        </td>    

                        <% if CDbl(rs("debit")) < 0 then %>
                            <td class="text-darker"><%=rs("credit")%></td>
                            <% totalCashPaid = totalCashPaid + CDbl(rs("credit").value) %>
                        <% else %>
                            <td class="text-darker">
                                <span class="text-primary">&#8369;</span><%=rs("debit")%>
                                <% totalCashPaid = totalCashPaid + CDbl(rs("debit").value) %>
                            </td>
                        <% end if %>    

                        <td class="text-darker"><%Response.Write(d)%></td>

                    </tr>
                    <%rs.MoveNext%>
                    <%loop%>
                    <%rs.close
                     Loop While False  
                next%>

                <tfoot>
                    <tr>
                        <td colspan="3"><h3 class="lead"><strong class="text-darker font-weight-bold">Total</strong></h3></td>
                        <td colspan="2">
                            <h3 class="lead">
                                <strong class="text-darker font-weight-normal">
                                    <span class="text-primary">  &#8369; </span>
                                    <span class="total-value"><%=totalCashPaid%></span>
                                </strong>    
                            </h3>
                        </td>
                    </tr>
                </tfoot>

            </table>
            </div>
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
                    <form action="customer_my_sales_reports.asp" method="POST" id="allData2">
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
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
        "order": [],
        "paging": false,
        dom: "<'row'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
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
            let custID = $(this).attr("id");
            $.ajax({

            url: "customer_my_sales_daterange.asp",
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
</script>


</body>
</html>    