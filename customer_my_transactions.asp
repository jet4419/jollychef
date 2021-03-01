<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Credits Transactions Report</title>
        
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
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

            /* .main-heading {
                font-family: 'Kulim Park', sans-serif;
            } */

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

            a.link-or {
                /* color: #206a5d; */
                color: #318fb5;
                text-decoration: none;
            }

            a.link-or:hover {
                /* color: #557571; */
                color: #3282b8;
                text-decoration: underline;
            }

            .order_of {
                font-weight: 400;
                color: #333;
            }

            .cust_name {
                color: #463535;
            }

            /* .department_lbl {
                color: #7d7d7d;
            } */

            .total-value, .total-text {
                font-size: 18px;
                font-weight: 500;
            }

            .total-darker {
                font-weight: 600;
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

<div id="main">

<%
    custID = CInt(Request.Form("cust_id"))
    custName = CStr(Request.Form("cust_name"))
    
    ' if custID<>0 then

        custID = CInt(Request.Form("cust_id"))
        custName = CStr(Request.Form("cust_name"))
        ' dates = Request.Form("date_records")
        department = Request.Form("department")
        startDate = CDate(Request.Form("startDate"))
        lastDayOfStartDate = DateAdd("m", 1, startDate ) - 1
        endDate = CDate(Request.Form("endDate"))
        lastDayOfEndDate = DateAdd("m", 1, endDate ) - 1
        endDate = DateAdd("m", 1, endDate ) - 1

        Dim previousDate
        previousDate = startDate - 1

        if endDate > systemDate then
            endDate = systemDate   
        end if

        displayDate1 = MonthName(Month(startDate)) & " " & Day(startDate) & ", " & Year(startDate)
 
        displayDate2 = MonthName(Month(endDate)) & " " & Day(endDate) & ", " & Year(endDate)

        Dim monthsDiff

        monthsDiff = DateDiff("m",startDate, endDate) 

        'Setting up of folder and file path'
        Dim monthLength, monthPath, yearPath

            monthLength = Month(startDate)
            if Len(monthLength) = 1 then
                monthPath = "0" & CStr(Month(startDate))
            else
                monthPath = Month(startDate)
            end if

            yearPath = Year(startDate)
            folderPath = mainPath & yearPath & "-" & monthPath
        'End of Setting up of folder and file path

        Dim fs, counter
        Set fs = Server.CreateObject("Scripting.FileSystemObject")
        counter = 0

        Dim exactStartDate, lastDayExactDate

        exactStartDate = startDate

        for i = counter To monthsDiff

            if fs.FolderExists(folderPath) = true then EXIT for

            monthLength = Month(DateAdd("m",i,startDate))
            if Len(monthLength) = 1 then
                monthPath = "0" & CStr(Month(DateAdd("m",i,startDate)))
            else
                monthPath = Month(DateAdd("m",i,startDate))
            end if

            yearPath = Year(DateAdd("m",i,startDate))
    
            folderPath = mainPath & yearPath & "-" & monthPath

            counter = i

            exactStartDate = DateAdd("m",i,startDate)
            
        next

        lastDayExactDate = DateAdd("m", 1, exactStartDate ) - 1

        Dim isValidPath
        isValidPath = fs.FolderExists(folderPath)

        Dim ebID, endingCredit, endingDebit
        endingCredit = 0.00

        if isValidPath = true then

            Dim ebFile, ebPath, ebMonthPath, ebYearPath
            ebFile = "\eb_test.dbf"

            ebMonthPath = Month(previousDate)
            if Len(ebMonthPath) = 1 then
                ebMonthPath = "0" & ebMonthPath
            end if

            ebYearPath = Year(previousDate)

            ebPath = mainPath & ebYearPath & "-" & ebMonthPath & ebFile

            if fs.FileExists(ebPath) = true then

                'Getting the beginning balance'
                rs.open "SELECT credit_bal FROM "&ebPath&" WHERE cust_id="&custID&" and end_date=CTOD('"&previousDate&"')", CN2

                if not rs.EOF then
                    endingCredit = CDbl(rs("credit_bal"))
                end if

                rs.close

            else
                endingCredit = 0
            end if

        end if
        'End of isValidPath condition'

        Dim p_start_date, p_end_date
        'Dim currCredit, currDebit

        p_start_date = startDate
        p_end_date = endDate

%>



    <div id="content">
        <div class="container mb-5">
            <div class="users-info">
                <h1 class="h2 text-center main-heading my-0"> <strong><span class="order_of">Receivable Card of</span> <span class="cust_name"><%=custName%></span></strong> </h1>
                <h1 class="h4 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
            </div>

            <%if custID <> "" then%>

                <div class="users-info--divider">

                    <span class="p-0 m-0 d-block">
                        <button type="button" class="btn btn-dark btn-sm mb-1 d-inline w-100 date_transact" id="<%=custID%>"  data-toggle="modal" data-target="#date_transactions">Generate Date Reports</button>
                    </span>
                   
                </div>
                
            <%end if%>

                <div class='date-label-container'>
                
                    <div>
                        <p class='display-date-container'><strong> Date: </strong>
                            <%=displayDate1 & " - "%>
                            <%=displayDate2%>
                        </p>
                    </div>       
                    
                </div>

            <div class="table-responsive-sm">

                <table class="table table-striped table-bordered table-sm" id="myTable">
                    <thead class="thead-bg">
                        <th>Reference No.</th>
                        <th>Transaction Type</th>
                        <th>Invoice</th>
                        <th>Debit</th>
                        <th>Credit</th>
                        <th>Balance</th>
                        <th>Date</th>
                    </thead>

                    <%if isValidPath = true then%>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td><strong>Beginning Balance</strong></td>
                            <td><strong><span class="currency-sign">&#8369; </span><%=endingCredit%></strong></td>
                            <td></td>
                        </tr>
                        <% 
                            Dim totalCredit, totalDebit, balance
                            balance = endingCredit
                            totalCredit = 0.00
                            totalDebit = 0.00

                            Dim transactionsFile, transactionsPath

                            transactionsFile = "\transactions.dbf"
                            transactionsPath = folderPath & transactionsFile 
                        %>

                        <%
                            
                            for i = counter To monthsDiff

                                monthLength = Month(DateAdd("m",i,startDate))
                                if Len(monthLength) = 1 then
                                    monthPath = "0" & CStr(Month(DateAdd("m",i,startDate)))
                                else
                                    monthPath = Month(DateAdd("m",i,startDate))
                                end if

                                yearPath = Year(DateAdd("m",i,startDate))
                        
                                folderPath = mainPath & yearPath & "-" & monthPath
                                transactionsPath =  folderPath & transactionsFile

                                Do 

                                    if fs.FolderExists(folderPath) <> true then EXIT DO
                                    if fs.FileExists(transactionsPath) <> true then EXIT DO

                                    rs.open "SELECT * FROM "&transactionsPath&" WHERE t_type!='OTC' and duplicate!='yes' and cust_id="&custID&" and date between CTOD('"&startDate&"') and CTOD('"&endDate&"')", CN2

                                    do until rs.EOF

                                        myDate = CDATE(rs("date"))
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
                                        transactDate = FormatDateTime(rs("date"), 2)%>
                                        <tr>
                                            <%if Trim(CStr(rs("t_type").value)) = "A-plus" or Trim(CStr(rs("t_type").value)) = "A-minus" then%>
                                                <td>
                                                    <a  target="_blank" href='receipt_adjustment.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=transactDate%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                                </td>
                                            <%else%>
                                                <td>
                                                    <a  target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=transactDate%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                                </td>
                                            <%end if%>    
                                            <td><%=rs("t_type")%></td>

                                            <% if CInt(rs("invoice")) <= 0 then%>
                                                <td class="text-darker"><%="none"%></td> 
                                            <% else %>    
                                                <td>
                                                    <a  target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=transactDate%>''><%=rs("invoice")%></a>
                                                </td> 
                                            <% end if %>    
                                            <% if CDbl(rs("debit")) <= 0 then %>
                                                <td class="text-darker"><%=" "%></td>
                                            <% else %>
                                                <td class="text-darker"><span class="currency-sign">&#8369; </span><%=rs("debit")%></td>
                                                <% totalDebit = CDbl(totalDebit) + CDbl(rs("debit").value) 
                                                balance = balance - CDbl(rs("debit").value)
                                                %>
                                            <% end if %>    
                                            <% if CDbl(rs("credit")) <= 0 then %>
                                                <td class="text-darker"><%=" "%></td>
                                            <% else %>    
                                                <td class="text-darker"><span class="currency-sign">&#8369; </span><%=rs("credit")%></td>
                                                <% totalCredit = CDbl(totalCredit) + CDbl(rs("credit").value) 
                                                balance = balance + CDbl(rs("credit").value)
                                                %>
                                            <% end if %>    
                                            <td class="text-darker"><span class="currency-sign">&#8369; </span><%=balance%></td>
                                            <% d = CDate(rs("date"))%>
                                            <td class="text-darker"><%Response.Write(dateFormat)%></td>

                                        </tr>
                                        <%rs.MoveNext%>
                                    <%loop
                                rs.close
                                loop while false

                            next
                        %>

                        <tfoot>
                            <tr>
                                <td><h3 class="lead"><strong class="text-darker total-text total-darker">Total</strong></h3></td>
                                <td class="no-cell"></td>
                                <td class="no-cell"></td>
                                <td>
                                    <h3 class="lead">
                                        <strong class="text-darker total-value">
                                            <span class="total-darker"><%=totalDebit%></span>
                                        </strong>    
                                    </h3>
                                </td>

                                <td>
                                    <h3 class="lead">
                                        <strong class="text-darker total-value">
                                            <span class="total-darker"><%=totalCredit%></span>
                                        </strong>    
                                    </h3>
                                </td>

                                <td>
                                    <h3 class="lead">
                                        <strong class="text-darker total-value">
                                            <span class="total-darker"><%=balance%></span>
                                        </strong>
                                    </h3>
                                </td>
                                <td></td>
                            </tr>
                        </tfoot>

                    <%end if%>
                    
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
                    <form action="customer_my_transactions.asp" method="POST" id="allData2">
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


<!--#include file="cust_login_logout.asp"-->


<script src="js/main.js"></script> 
<script>  
$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "32vh",
        scroller: true,
        scrollCollapse: true,
        "order": [],
        "paging": false,
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