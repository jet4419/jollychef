<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Schedule of Receivables</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/dataTables.bootstrap4.min.css">
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
             .dt-buttons {
                position: absolute;
                top: -10px;
                left: 22%;
                margin-top: .5rem;
                text-align: left;
            }   

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

            .month-end-label {
                opacity: 0;
            }

        </style>

    </head>

    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>
<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<% 
    Dim obReportDate
    obReportDate = Request.Form("ob_report_date")

    'Response.Write obReportDate > systemDate

    if obReportDate = "" or obReportDate = systemDate or CDATE(obReportDate) > systemDate then
        obReportDate = systemDate
    end if

    displayDate = MonthName(Month(obReportDate)) & " " & Day(obReportDate) & ", " & Year(obReportDate)

    myYear = Year(obReportDate)
    myDay = Day(obReportDate)
    if Len(myDay) = 1 then
        myDay = "0" & myDay
    end if

    myMonth = Month(obReportDate)
    if Len(myMonth) = 1 then
        myMonth = "0" & myMonth
    end if

    dateFormat = myMonth & "/" & myDay & "/" & Mid(myYear, 3)
%>

<div id="main">    
    
    <div id="content">
        <div class="container">
            <h1 class="h2 text-center mt-3 mb-3 main-heading d-flex justify-content-between">
                 <button class="btn btn-sm btn-outline-dark date_transact" data-toggle="modal" data-target="#date_transactions" title="Select date of reports" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Select Date</button>

                <a href="schedule_receivables.asp" class="btn btn-sm btn-outline-dark">Schedule</a>
            </h1>

            <h1 class="h2 text-center mb-4 main-heading" style="font-weight: 400">Schedule of Receivables 
                <p class="mb-0 report-type">Summary <span class="report-date">as of <%=displayDate%></span>
                </p>
            </h1>

            <div>
                <%
        
                    Response.Write("<p class='float-left'><strong> Date: </strong>")
                    Response.Write(displayDate)
                    Response.Write "</p>"
                        
                %>
                <button id="printMe" class="btn btn-sm btn-light float-right mr-1">Print</button>
            </div>
            
            <div id="printData"> 
                <div class="print-main-heading">
                    <p class="print-heading-company">JollyChef Inc.</p> 
                    <p class="heading-print"> Schedule of Receivables Summary: <span class="date-range-print"> <%=displayDate%></span>
                    </p>
                </div>

                <table class="table table-hover table-bordered table-sm" id="myTable">
                    <thead class="thead-bg">
                        <th>Customer Name</th>
                        <th>Balance</th>    
                    </thead>

                    <%  

                    Dim yearPath, monthPath

                    yearPath = CStr(Year(obReportDate))
                    monthPath = CStr(Month(obReportDate))

                    if Len(monthPath) = 1 then
                        monthPath = "0" & monthPath
                    end if
            
                    arFile = "\accounts_receivables.dbf"
                    folderPath = mainPath & yearPath & "-" & monthPath
                    arPath = folderPath & arFile

                    rs.open "SELECT cust_id, cust_name, SUM(balance) AS balance FROM "&arPath&" WHERE balance != 0 GROUP BY cust_id ORDER BY cust_name, cust_id", CN2

                    Dim totalBalance
                    totalBalance = 0
        

                    do until rs.EOF

                        Response.Flush

                        totalBalance = totalBalance + CDBL(rs("balance"))%>

                        <tr>
                            <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                            <td class="text-darker"><span class="currency-sign">&#8369;</span> <%Response.Write(formatNumber(rs("balance")))%></td>  
                        </tr>
                        <%rs.MoveNext%>
                    <%loop%>
                    <%rs.close%>

                    <tr class="final-total"> 
                        <td class="total-label">Total</td>
                        <td class="final-total"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalBalance)%></td>
                    </tr>      

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
                    <form action="schedule_receivables_sum.asp" method="POST" id="allData2" class="">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Date of OB Reports </h5>
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
  

    <!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>  
<script src="tail.select-full.min.js"></script>
<script src="./js/print.js"></script> 
<script>
    // Date Transactions Generator
    $(document).on("click", ".date_transact", function(event) {

        event.preventDefault();
        //let custID = $(this).attr("id");
        $.ajax({

            url: "ob_select_daterange2.asp",
            type: "GET",
            data: {},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Transactions Generator 
</script>

</body>
</html>    