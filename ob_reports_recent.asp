<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>OB Reports</title>
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

            .btn-month-end {
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

    if Request.Form("date_records") = "" then
        Response.Redirect("canteen_homepage.asp")
    end if

    Dim startDate, endDate, dates, dateSplit

    dates = Request.Form("date_records")
    Response.Write dates

    if dates = "" then

        if startDate="" then

            rs.open "SELECT MAX(first_date) AS start_date FROM eb_test", CN2
            
            queryDate1 = CDate(FormatDateTime(rs("start_date"), 2))
            displayDate1 = Day(rs("start_date")) & " " & MonthName(Month(rs("start_date"))) & " " & Year(rs("start_date"))

            rs.close
        
        else
            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = Day(queryDate1) & " " &  MonthName(Month(queryDate1)) & " " & Year(queryDate1)
        end if    


        if endDate="" then

            rs.open "SELECT MAX(end_date) AS end_date FROM eb_test", CN2

            queryDate2 = CDate(FormatDateTime(rs("end_date"), 2))
            displayDate2 = Day(rs("end_date")) & " " & MonthName(Month(rs("end_date"))) & " " & Year(rs("end_date"))

            rs.close

        else  
            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)
        end if   

    else
    
        dateSplit = Split(dates, ",")

        if dateSplit(0) = "true" then

            startDate = CDate(dateSplit(1))
            displayDate1 = Day(startDate) & " " & MonthName(Month(startDate)) & " " & Year(startDate)

            endDate = systemDate
            displayDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else    

            startDate = CDate(dateSplit(0))
            displayDate1 = Day(startDate) & " " & MonthName(Month(startDate)) & " " & Year(startDate)
            
            endDate = CDate(dateSplit(1))
            displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)

        end if
        ' startDate = Request.Form("startDate")
        ' endDate = Request.Form("endDate")

    end if

    
%>


<div id="main">    
    
    <div id="content">
        <div class="container">

            <h1 class="h2 text-center mt-4 mb-5 main-heading d-flex justify-content-between">
                <button class="btn btn-sm btn-outline-dark date_transact" data-toggle="modal" data-target="#date_transactions" title="Select date of reports" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Select Date</button>
                <span class="h2 text-center" style="font-weight: 500">Outstanding Balance of <%=displayDate2%></span>
                <button class="btn-month-end">End</button>
            </h1>

            <%  

                Dim monthLength, monthPath, yearPath

                monthLength = Month(systemDate)
                if Len(monthLength) = 1 then
                    monthPath = "0" & CStr(Month(systemDate))
                else
                    monthPath = Month(systemDate)
                end if

                yearPath = Year(systemDate)

                Dim obFile, folderPath, obPath

                obFile = "\ob_test.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                obPath = folderPath & obFile

                'Response.Write obPath

                if dateSplit(0) = "true" then
                'Response.Write "OB is true"
                ' rs.open "SELECT Ob_Test.cust_id, Customers.cust_lname, Customers.cust_fname, Customers.department, Ob_Test.balance AS credit_bal, Ob_Test.date AS end_date "&_ 
                '         "FROM "&obPath&" "&_
                '         "INNER JOIN Customers ON Ob_Test.cust_id = Customers.cust_id "&_
                '         "WHERE Ob_Test.status!='completed' GROUP BY Ob_Test.cust_id", CN2
                ' rs.open "SELECT TOP 2 Ob_Test.cust_id, Customers.cust_lname, Customers.cust_fname, Customers.department, Ob_Test.balance AS credit_bal, Ob_Test.date AS end_date "&_ 
                '         "FROM "&obPath&" "&_
                '         "INNER JOIN Customers ON Ob_Test.cust_id = Customers.cust_id "&_
                '         "WHERE Ob_Test.status!='completed' and Ob_Test.duplicate!='yes' ORDER BY Ob_Test.id DESC GROUP BY Ob_Test.cust_id", CN2
                 rs.open "SELECT cust_id, cust_name, department, balance AS credit_bal, date AS end_date "&_ 
                         "FROM "&obPath&" "&_
                         "WHERE balance!=0 GROUP BY cust_id ORDER BY cust_name", CN2

                else
                    'Response.Write "EB is true"
                ' rs.open "SELECT Eb_Test.cust_id, Customers.cust_lname, Customers.cust_fname, Customers.department, Eb_Test.credit_bal, Eb_Test.end_date "&_ 
                '         "FROM eb_test "&_
                '         "INNER JOIN Customers ON Eb_Test.cust_id = Customers.cust_id "&_
                '         "WHERE Eb_Test.first_date=CTOD('"&startDate&"') and Eb_Test.end_date=CTOD('"&endDate&"')", CN2
                rs.open "SELECT cust_id, cust_name, department, credit_bal, end_date "&_ 
                        "FROM eb_test "&_
                        "WHERE first_date=CTOD('"&startDate&"') and end_date=CTOD('"&endDate&"') ORDER BY cust_name", CN2
                end if
            %>
            
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Department</th>
                    <th>Balance</th>
                    <th>Date</th>
                </thead>

                <%do until rs.EOF%>

                <tr>
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td>
                    <!--
                    <td class="text-darker"><'%'Response.Write(Trim(rs("cust_lname")) & " " & Trim(rs("cust_fname")))%></td>
                    -->
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_name")))%></td>
                    <td class="text-darker"><%Response.Write(rs("department"))%></td>
                    <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("credit_bal"))%></td>
                    <% d = CDate(rs("end_date"))%>
                    <td class="text-darker">
                        <%Response.Write(FormatDateTime(d,2))%>
                    </td>                   
                </tr>

                <%rs.MoveNext%>
                <%loop%>
                <%rs.close%>

            </table>
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
                    <form action="ob_reports_recent.asp" method="POST" id="allData2" class="">
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
                                <button type="submit" class="btn btn-success btn-sm mb-1" id="generateReport2">Generate Report</button>
                            </div>        
                    </form>
                        
                </div>
            </div>
        </div>
    <!-- End of Date Range of Transactions -->
  

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>  
<script src="tail.select-full.min.js"></script>
<script>  
let j = 0
 $(document).ready( function () {
    $('#myTable').DataTable({
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //scrollY: 430,
        scrollY: "40vh",
        scroller: true,
        scrollCollapse: true,
        "order": [],
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
   

    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

});

// Date Transactions Generator
        $(document).on("click", ".date_transact", function(event) {

            event.preventDefault();
            //let custID = $(this).attr("id");
            $.ajax({

            url: "ob_select_daterange.asp",
            type: "GET",
            data: {},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Transactions Generator  

// function monthEnd() {

//     //alert("Are you sure to cutoff?")
//     if(confirm('Are you sure to month end on this date?'))
//     {
//         window.location.href='a_ob_month_end.asp';
//         //window.location.href='delete.asp?delete_id='+id;
//     }

// }
    
</script>

</body>
</html>    