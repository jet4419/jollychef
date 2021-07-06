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
                color: #318fb5;
                text-decoration: none;
            }

            a.link-or:hover {
                color: #3282b8;
                text-decoration: underline;
            }

            a.link-or:visited {
                color: #318fb5;
            }

            .order_of {
                font-weight: 400;
                color: #333;
            }

            .cust_name {
                color: #463535;
            }

            .total-value, .total-text {
                /* font-size: 18px; */
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

            .total-darker {
                font-weight: 600;
            }

            .btn-adjustment:hover i.fa-plus, .btn-adjustment:hover i.fa-minus {
                color: white !important;
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
        if Request.QueryString("cust_id") = "" then
            Response.Redirect("adjustments_main.asp")
        end if

        if IsNumeric(Request.QueryString("cust_id")) = false then
            Response.Redirect("adjustments_main.asp")
        end if

        custID = CInt(Request.QueryString("cust_id"))

        sqlGetInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
        set objAccess = cnroot.execute(sqlGetInfo)

        if not objAccess.EOF then

            custName = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
            department = Trim(objAccess("department").value)

        end if

        set objAccess = nothing

    %>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%

        Dim monthLength, monthPath, yearPath

        monthLength = Month(systemDate)
        if Len(monthLength) = 1 then
            monthPath = "0" & CStr(Month(systemDate))
        else
            monthPath = Month(systemDate)
        end if

        yearPath = Year(systemDate)

        obFile = "\ob_test.dbf"
        folderPath = mainPath & yearPath & "-" & monthPath
        obPath = folderPath & obFile


        rs.Open "SELECT MIN(date) AS first_date, MAX(date) AS end_date FROM "&obPath&" WHERE duplicate!='yes' and cust_id="&custID&" and status!=""completed""", CN2

        if not rs.EOF then

            startDate = CDate(rs("first_date"))
            endDate = CDate(rs("end_date"))

        else

            startDate = systemDate
            endDate = systemDate

        end if

        rs.close

        displayDate1 = "1" & " " & MonthName(Month(startDate)) & " " & Year(startDate)

        displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)

        Dim fs, counter
        Set fs = Server.CreateObject("Scripting.FileSystemObject")

        Dim ebMonth, ebYear, previousDate

        ebMonth = Month(startDate)
        ebYear = Year(startDate)
        previousDate = CDate(ebYear & "-" & ebMonth) - 1

        Dim ebID, endingCredit, creditBal, debitBal
        endingCredit = 0

        Dim ebFile, ebPath, ebMonthPath, ebYearPath
        ebFile = "\eb_test.dbf"
        ebYearPath = yearPath
        ebMonthPath = CINT(monthPath) - 1

        if ebMonthPath = 0 then
            ebMonthPath = 12
            ebYearPath = CINT(yearPath) - 1
        end if

        if Len(ebMonthPath) = 1 then
            ebMonthPath = "0" & ebMonthPath
        end if

        ebPath = mainPath & ebYearPath & "-" & ebMonthPath & ebFile

        if fs.FileExists(ebPath) = true then

            rs.open "SELECT credit_bal FROM "&ebPath&" WHERE cust_id="&custID&" and end_date=CTOD('"&previousDate&"')", CN2

            if not rs.EOF then
                endingCredit = CDbl(rs("credit_bal"))
            end if

            rs.close

        else

            endingCredit = 0

        end if
        
        Dim p_start_date, p_end_date, currCredit, currDebit

        p_start_date = startDate
        p_end_date = endDate


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
        <div class="container mb-5">
            <div class="users-info mb-3">
                <h1 class="h2 text-center main-heading mt-3">
                    <span class="order_of">Receivable Card of</span> 
                    <span class="customer-name"><%=custName%></span> 
                </h1>

                <h1 class="h4 text-center main-heading my-0"> 
                    <span class="department_lbl"><%=department%></span> 
                </h1>
            </div>

           <% 
              Dim transactionsFile, transactionsPath

              transactionsFile = "\transactions.dbf"
              transactionsPath = folderPath & transactionsFile 

              rs.Open "SELECT * FROM "&transactionsPath&" WHERE cust_id="&custID&" and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"') GROUP BY cust_id", CN2 

            %>

            <%if not rs.BOF then%>

                <div class="users-info--divider">
                    <span class="p-0 m-0 d-block">
                        <strong class='text-dark'>Adjustments</strong>
                        <button class="btn btn-outline-dark btn-sm btn-adjustment btn-adjustment-plus" id="<%=rs("cust_id")%>" title="Adjustment plus" data-toggle="tooltip" data-placement="top" data-toggle="modal" data-target="#adjustment_plus">
                            <i class="fas fa-plus text-dark"></i>
                        </button>
                        <button class="btn btn-outline-dark btn-sm btn-adjustment btn-adjustment-minus" id="<%=rs("cust_id")%>" title="Adjustment minus" data-toggle="tooltip" data-placement="top" data-toggle="modal" data-target="#adjustment_minus">
                            <i class="fas fa-minus text-dark"></i>
                        </button>
                    </span>
                    <!--
                    <a href="#">
                        <button class="btn btn-outline-dark btn-sm">Adjustments</button>
                    </a>
                    -->

                </div>
                
            <%end if%>
            <%rs.close
              set objAccess = nothing
            %>    

            
            <% rs.open "SELECT * FROM "&transactionsPath&" WHERE t_type!='OTC' and cust_id="&custID&" and date between CTOD('"&p_start_date&"') and CTOD('"&p_end_date&"')", CN2 %>
                <div class='date-label-container'>
                    <div>
                        <p class='display-date-container'><strong> Date: </strong>
                            <%=displayDate1 & " - "%>
                            <%=displayDate2%>
                        </p>
                    </div>       
                </div>

            <div class="table-responsive-sm">

                <table class="table table-hover table-bordered table-sm" id="myTable">
                    <thead class="thead-bg">
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
                        <td><strong><span class="currency-sign">&#8369;</span> <%=formatNumber(endingCredit)%></strong></td>
                        <td></td>
                    </tr>
                    <% 
                        Dim totalCredit, totalDebit, balance
                        balance = endingCredit
                        ' totalCredit = 0.00
                        ' totalDebit = 0.00
                    %>
                    
                    <%do until rs.EOF%>

                        <% 
                            d = CDate(rs("date"))
                            d = FormatDateTime(d, 2)
                        %>
                        <tr>
                            <%if Trim(CStr(rs("t_type").value)) = "A-plus" or Trim(CStr(rs("t_type").value)) = "A-minus" then%>
                                <td>
                                    <a class="text-dark" target="_blank" href='receipt_adjustment.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                </td>
                            <%else%>    
                                <td>
                                    <a class="text-dark" target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'><%Response.Write(rs("ref_no"))%></a>
                                </td>
                            <%end if%>
                            <td><%=rs("t_type")%></td>
 
                            <% if CInt(rs("invoice")) <= 0 then%>
                                <td class="text-darker link-or"><%="none"%></td> 
                            <% else %>    
                                <td >
                                    <a class="text-dark" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'><%=rs("invoice")%></a>
                                </td> 
                            <% end if %>    
                            <% if CDbl(rs("debit")) <= 0 then %>
                                <td class="text-darker"><%=" "%></td>
                            <% else %>
                                <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=formatNumber(rs("debit"))%></td>
                                <% totalDebit = CDbl(totalDebit) + CDbl(rs("debit").value) 
                                balance = balance - CDbl(rs("debit").value)
                                %>
                            <% end if %>    
                            <% if CDbl(rs("credit")) <= 0 then %>
                                <td class="text-darker"><%=" "%></td>
                            <% else %>    
                                <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=formatNumber(rs("credit"))%></td>
                                <% totalCredit = CDbl(totalCredit) + CDbl(rs("credit").value) 
                                balance = balance + CDbl(rs("credit").value)
                                %>
                            <% end if %>    
                            <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=formatNumber(balance)%></td>
                            
                            <td class="text-darker"><%Response.Write(dateFormat(rs("date")))%></td>

                        </tr>
                        <%rs.MoveNext%>
                    <%loop%>
                    <%rs.close%>
                    <tfoot>
                        <tr>
                            <td><strong class="text-darker total-text total-darker">Total</strong>
                            </td>
                            <td class="no-cell"></td>
                            <td class="no-cell"></td>
                            <td>
                                <strong class="text-darker">
                                    <span class="total-value total-darker"> <span class="currency-sign">&#8369; </span> <%=formatNumber(totalDebit)%></span>
                                </strong>    
                            </td>

                            <td>
                                <strong class="text-darker">
                                    <span class="total-value total-darker"> <span class="currency-sign">&#8369; </span> <%=formatNumber(totalCredit)%></span>
                                </strong>    
                            </td>

                            <td>
                                <strong class="text-darker">
                                    <span class="total-value total-darker"> <span class="currency-sign">&#8369; </span> <%=formatNumber(currCredit)%></span>
                                </strong>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>

                </table>

                <%
                    Function formatNumber(myNum)

                        Dim i, counter, numFormat
                        counter = 1
                        numFormat = ""

                        for i = Len(myNum) to 1 step -1

                            ' Response.Write "<br>" & i & "<br>"
                            if counter mod 3 = 0 then
                                if counter = Len(myNum) then
                                    numFormat = Mid(myNum, i, 1) & numFormat
                                else
                                    numFormat = "," & Mid(myNum, i, 1) & numFormat
                                end if
                            else
                                numFormat = Mid(myNum, i, 1) & numFormat
                            end if

                            counter = counter + 1

                        next

                        formatNumber = numFormat

                    End Function

                %>

                <%
                    Function dateFormat(reportDate)

                        myDate = CDATE(reportDate)
                        myYear = Year(myDate)
                        myDay = Day(myDate)
                        if Len(myDay) = 1 then
                            myDay = "0" & myDay
                        end if

                        myMonth = Month(myDate)
                        if Len(myMonth) = 1 then
                            myMonth = "0" & myMonth
                        end if

                        dateFormat = myMonth & "/" & myDay & "/" & Mid(myYear, 3)

                    End Function

                %>

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
                    <h5 class="modal-title" id="exampleModalLabel">Date Range of Transaction <i class="far fa-calendar-check"></i>
                    </h5>
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
    

<!--#include file="cashier_login_logout.asp"-->


<script src="js/main.js"></script> 
<script>  
$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "28vh",
        scroller: true,
        "paging": false,
        "order": [],
        scrollCollapse: true,
        dom: "<'row'<'col-sm-12 col-md-4'i><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-light' },
            { extend: 'excel', className: 'btn btn-sm btn-light' },
            { extend: 'pdf', className: 'btn btn-sm btn-light' },
            { extend: 'print', className: 'btn btn-sm btn-light' }
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