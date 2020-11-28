<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Transactions Report</title>
        <link rel="stylesheet" href="css/homepage_style.css">
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
                padding: 23px 5px 5px 5px;
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
                width: 100%;
                display: flex;
                justify-content: space-between;
            }

            .users-info--divider {
                height: auto;
                width: auto;
                display: flex;
                justify-content: space-between;
                white-space: nowrap;
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

            .btn-adjustment {
                width: 35px;
            }

            input {
                background: #eee;
                border-radius: 5px;
                border: none;
                padding: 3px 5px ;
            }

            a.link-or {
                color: #206a5d;
                text-decoration: none;
            }

            a.link-or:hover {
                color: #557571;
                text-decoration: underline;
            }

            .order_of {
                font-weight: 400;
                color: #333;
            }

            .cust_name {
                color: #463535;
            }

            .department_lbl {
                color: #7d7d7d;
            }

            .total-value, .total-text {
                font-size: 18px;
                font-weight: 500;
            }

            .fa-plus, .fa-minus {
                color: #fff;
            }

            .ad-plus-icon, .ad-minus-icon {
                /* background: #fca652; */
                background: #23bf47;
                color: #fff;
                padding: 5px;
                border-radius: 5px;
                font-size: 16px;
            }

            .ad-minus-icon {
                /* background: #de4463; */
                background: #ef1641;
            }



        </style>

    </head>

    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>

<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>

    <%
        custID = CInt(Request.Form("cust_id"))
        custName = CStr(Request.Form("cust_name"))
        department = CStr(Request.Form("department"))
    %>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%
        dates = Request.Form("date_records")

        if dates = "" then
            Response.Redirect("canteen_homepage.asp")
        end if

        dateSplit = Split(dates, ",")

        startDate = CDate(dateSplit(0))
        displayDate1 = Day(startDate) & " " & MonthName(Month(startDate)) & " " & Year(startDate)
        
        endDate = CDate(dateSplit(1))
        displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)

        Dim monthLength, monthPath, yearPath

        monthLength = Month(startDate)
        if Len(monthLength) = 1 then
            monthPath = "0" & CStr(Month(startDate))
        else
            monthPath = Month(startDate)
        end if

        yearPath = Year(startDate)

        obFile = "\ob_test.dbf"
        folderPath = mainPath & yearPath & "-" & monthPath
        obPath = folderPath & obFile

        Dim ebID, endingCredit, endingDebit, creditBal, debitBal
        endingCredit = 0.00

        rs.open "SELECT * FROM "&obPath&" WHERE cust_id="&custID&" and date BETWEEN CTOD('"&startDate&"') AND CTOD('"&endDate&"')", CN2

        do until rs.EOF

            if ASC(rs("status")) = ASC("completed") then

                sqlQuery = "SELECT * FROM eb_test WHERE cust_id="&custID&" and first_date=CTOD('"&startDate&"') and end_date=CTOD('"&endDate&"')"
                set objAccess = cnroot.execute(sqlQuery)

                if not objAccess.EOF then
                    ebID = CInt(objAccess("id").value)
                end if    
                set objAccess = nothing

                if ebID=1 then
                    endingCredit = 0
                    endingDebit = 0

                else 

                    sqlPrevRow = "SELECT * FROM eb_test WHERE id = (select max(id) from eb_test where id < "&ebID&" and cust_id="&custID&")"
                    set objAccess = cnroot.execute(sqlPrevRow)
                        if not objAccess.EOF then
                            endingCredit = CDbl(objAccess("credit_bal"))
                            endingDebit = CDbl(objAccess("debit_bal"))
                        else
                            endingCredit = 0
                            endingDebit = 0
                        end if
                    set objAccess = nothing

                end if
                
            else
                sqlQuery = "SELECT * FROM "&obPath&" WHERE cust_id="&custID&" and date BETWEEN CTOD('"&startDate&"') AND CTOD('"&startDate&"') GROUP BY cust_id"
                set objAccess = cnroot.execute(sqlQuery)

                if CDbl(objAccess("balance").value) < 0.00 then
                    creditBal = 0
                    debitBal = ABS(CDbl(objAccess("balance").value))    
                else
                    creditBal = CDbl(objAccess("balance").value)
                    debitBal = 0
                end if

                endingDebit = 0.00
                endingCredit = 0.00
                set objAccess = nothing

                sqlQuery = "SELECT MAX(id) AS max_eb_id, credit_bal, debit_bal FROM eb_test WHERE cust_id="&custID
                set objAccess = cnroot.execute(sqlQuery)
                    if not objAccess.EOF then
                        endingCredit = CDbl(objAccess("credit_bal"))
                        endingDebit = CDbl(objAccess("debit_bal"))
                        set objAccess = nothing
                    end if
                
            end if

        rs.MoveNext
        loop
            
        rs.close
        
        Dim p_start_date, p_end_date, currCredit, currDebit

        p_start_date = startDate
        p_end_date = endDate


        ' sqlGetOB = "SELECT MAX(balance) AS balance FROM "&obPath&" WHERE cust_id="&custID&" and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"')"
        ' set objAccess = cnroot.execute(sqlGetOB)
        'SELECT TOP 1 ar_id, date_owed FROM "&arPath&" ORDER BY ar_id DESC
        sqlGetOB = "SELECT TOP 1 id, balance FROM "&obPath&" WHERE cust_id="&custID&" and duplicate!='yes' and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"') ORDER BY id DESC"
        set objAccess = cnroot.execute(sqlGetOB)

        if not objAccess.EOF then
            if CDbl(objAccess("balance").value) < 0 then
                currCredit = 0
                currDebit = ABS(CDbl(objAccess("balance").value))
            else
                currCredit = CDbl(objAccess("balance").value)
                currDebit = 0    
            end if    
        end if

        set objAccess = nothing

        transferDate1 = CStr(p_start_date)
        transferDate2 = CStr(p_end_date)
    %>

<div id="main" class="mb-5">
    <!-- Dates Container -->
    <input type="text" name="startDate" id="startDate" value="<%=transferDate1%>" hidden>
    <input type="text" name="endDate" id="endDate" value="<%=transferDate2%>" hidden>
    <!-- End of Dates Container -->
    <div id="content">
        <div class="container pt-4 mb-5">
            <div class="users-info mb-3">
                <h1 class="h2 text-center main-heading my-0"> <strong><span class="order_of">Receivable Card of</span> <span class="cust_name"><%=custName%></span></strong> </h1>
                <h1 class="h4 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
            </div>
            <% 'rs.open "SELECT MAX(Ob_Test.id), Customers.cust_id, Customers.cust_fname, Customers.cust_lname, Customers.department, OB_Test.balance FROM ob_test INNER JOIN Customers On Ob_Test.cust_id = Customers.cust_id WHERE OB_Test.cust_type='in'", CN2 %>

           <% 
              Dim transactionsFile, transactionsPath

              transactionsFile = "\transactions.dbf"
              transactionsPath = folderPath & transactionsFile 

              rs.Open "SELECT * FROM "&transactionsPath&" WHERE cust_id="&custID&" and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"') GROUP BY cust_id", CN2 

            %>

            <%if not rs.BOF then%>

                <div class="users-info--divider">
                    <span class="p-0 m-0 d-block">
                        <strong class='text-danger'>Adjustments</strong>
                        <button class="btn btn-dark btn-sm btn-adjustment btn-adjustment-plus" id="<%=rs("cust_id")%>" title="Adjustment plus" data-toggle="tooltip" data-placement="top" data-toggle="modal" data-target="#adjustment_plus">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button class="btn btn-dark btn-sm btn-adjustment btn-adjustment-minus" id="<%=rs("cust_id")%>" title="Adjustment minus" data-toggle="tooltip" data-placement="top" data-toggle="modal" data-target="#adjustment_minus">
                            <i class="fas fa-minus"></i>
                        </button>
                    </span>
                    <!--
                    <a href="#">
                        <button class="btn btn-outline-dark btn-sm">Adjustments</button>
                    </a>
                    -->
                    <span class="p-0 m-0 d-block">
                        <button type="button" class="btn btn-dark btn-sm mb-1 d-inline w-100 date_transact" id="<%=custID%>"  data-toggle="modal" data-target="#date_transactions">Generate Date Reports</button>
                    </span>
                </div>
                
            <%end if%>
            <%rs.close
              set objAccess = nothing
            %>    

            
            <% rs.open "SELECT * FROM "&transactionsPath&" WHERE t_type!='OTC' and cust_id="&custID&" and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"')", CN2 %>
                <div class='date-label-container'>
                    <div>
                        <p class='display-date-container'><strong> Date Range: </strong>
                            <%=displayDate1 & " - "%>
                            <%=displayDate2%>
                        </p>
                    </div>       
                </div>

            <div class="table-responsive-sm">
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Reference No.</th>
                    <th>Transaction Type</th>
                    <th>Invoice</th>
                    <th>Debit</th>
                    <th>Credit</th>
                    <th>Balance</th>
                    <th>Date</th>
                    <!--
                    <th>Debit Balance</th>
                    -->
                </thead>

                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td><strong>Beginning Balance</strong></td>
                    <td><strong><span class="text-primary">&#8369;</span><%=endingCredit%></strong></td>
                    <td></td>
                </tr>
                <% 
                    Dim totalCredit, totalDebit, balance
                    balance = endingCredit
                    totalCredit = 0.00
                    totalDebit = 0.00
                %>
                
                <%do until rs.EOF%>

                <% d = CDate(rs("date"))
                   d = FormatDateTime(d, 2)
                %>
                <tr>
                    <%if Trim(CStr(rs("t_type").value)) = "A-plus" or Trim(CStr(rs("t_type").value)) = "A-minus" then%>
                        <td>
                            <a class="link-or" target="_blank" href='receipt_adjustment.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                        </td>
                    <%else%>    
                        <td>
                            <a class="link-or" target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'><%Response.Write(rs("ref_no"))%></a>
                        </td>
                    <%end if%>
                    <td class="text-info"><%=rs("t_type")%></td>
                    <!--
                    <td class="text-primary"><%'=custName%></td>  
                    -->
                    <% if CInt(rs("invoice")) <= 0 then%>
                        <td class="text-darker"><%="none"%></td> 
                    <% else %>    
                        <td >
                            <a class="link-or" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'><%=rs("invoice")%></a>
                        </td> 
                    <% end if %>    
                    <% if CDbl(rs("debit")) <= 0 then %>
                        <td class="text-darker"><%=" "%></td>
                    <% else %>
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%=rs("debit")%></td>
                        <% totalDebit = CDbl(totalDebit) + CDbl(rs("debit").value) 
                           balance = balance - CDbl(rs("debit").value)
                        %>
                    <% end if %>    
                    <% if CDbl(rs("credit")) <= 0 then %>
                        <td class="text-darker"><%=" "%></td>
                    <% else %>    
                        <td class="text-darker"><span class="text-primary">&#8369;</span><%=rs("credit")%></td>
                        <% totalCredit = CDbl(totalCredit) + CDbl(rs("credit").value) 
                           balance = balance + CDbl(rs("credit").value)
                        %>
                    <% end if %>    
                    <td class="text-darker"><span class="text-primary">&#8369;</span><%=balance%></td>
                    
                    <td class="text-darker"><%Response.Write(d)%></td>
                    <!--
                    <td class="text-darker"><span class="text-primary">&#8369;</span><%'Response.Write(rs("debit_bal"))%></td>
                    -->
                </tr>
                <%rs.MoveNext%>
                <%loop%>
                <%rs.close%>
                <tfoot>
                    <tr>
                        <td colspan="3"><h3 class="lead"><strong class="text-darker total-text">Total</strong></h3></td>
                        <td>
                            <h3 class="lead">
                                <strong class="text-darker">
                                    <span class="total-value"><%=totalDebit%></span>
                                </strong>    
                            </h3>
                        </td>

                        <td>
                            <h3 class="lead">
                                <strong class="text-darker">
                                    <span class="total-value"><%=totalCredit%></span>
                                </strong>    
                            </h3>
                        </td>

                        <td>
                            <h3 class="lead">
                                <strong class="text-darker">
                                    <span class="total-value"><%=currCredit%></span>
                                </strong>
                            </h3>
                        </td>
                        <td></td>
                    </tr>
                </tfoot>

            </table>

            </div>
   
        </div>    
    </div>

</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <!-- Date Range of Transactions -->
        <div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="ar_card_report2.asp" method="POST" id="allData2">
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

    <!-- Adjustment Plus -->
        <div class="modal fade" id="adjustment_plus" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="adjustment_plus.asp" method="POST" id="allData3">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Adjustment Plus <i class="text-white bg-dark fas fa-plus ad-plus-icon"></i> </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="adjustment_plus_body">
                        <!-- Modal Body (Contents) -->
                        
                            
                    </div>    
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-sm mb-1 bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary btn-sm mb-1" id="generateReport3">Proceed</button>
                            </div>        
                    </form>
                        
                </div>
            </div>
        </div>
    <!-- End of Adjustment Plus -->

    <!-- Adjustment Minus -->
        <div class="modal fade" id="adjustment_minus" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="adjustment_minus.asp" method="POST" id="allData4">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Adjustment Minus <i class="text-white bg-dark fas fa-minus ad-minus-icon"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="adjustment_minus_body">
                        <!-- Modal Body (Contents) -->
                        
                            
                    </div>    
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary btn-sm mb-1 bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary btn-sm mb-1" id="generateReport4">Proceed</button>
                            </div>        
                    </form>
                        
                </div>
            </div>
        </div>
    <!-- End of Adjustment Minus -->
    


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
        "order": [],
        scrollCollapse: true,
        dom: "<'row'<'col-sm-12 col-md-4'i><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
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

            let custID = $(this).attr("id");
            $.ajax({

            url: "ar_card_daterange2.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Generator  

    // Adjustment Plus
        $(document).on("click", ".btn-adjustment-plus", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            let startDate = $("#startDate").val();
            let endDate = $("#endDate").val();

            $.ajax({

            url: "adjustment_daterange.asp",
            type: "POST",
            data: {custID: custID, startDate: startDate, endDate: endDate},
            success: function(data) {
                $("#adjustment_plus_body").html(data);
                $("#adjustment_plus").modal("show");
            }
        })    
    }) // End of Adjustment Plus

    // Adjustment Minus
        $(document).on("click", ".btn-adjustment-minus", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            let startDate = $("#startDate").val();
            let endDate = $("#endDate").val();

            $.ajax({

            url: "adjustment_minus_drange.asp",
            type: "POST",
            data: {custID: custID, startDate: startDate, endDate: endDate},
            success: function(data) {
                $("#adjustment_minus_body").html(data);
                $("#adjustment_minus").modal("show");
            }
        })    
    }) // End of Adjustment Minus



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

<!-- This is a testing Git branch -->