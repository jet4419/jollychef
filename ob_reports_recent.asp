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

    Dim startDate, endDate, obDate, dateSplit

    obDate = CDate(Request.Form("date_records"))

    'Don't mind the if statement because obDate should never be null'
    'Only look for the else statement'
    if obDate = "" then

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
    
        ' dateSplit = Split(obDate, ",")

        startDate = CDate(Year(obDate) & "-" & Month(obDate))
        endDate = DateAdd("m", 1, startDate) - 1

        if obDate = systemDate then

            displayDate1 = MonthName(Month(obDate)) & " " & Day(obDate) & ", " & Year(obDate)

        else

            displayDate1 = MonthName(Month(startDate)) & " " & Day(startDate) & ", " & Year(startDate)

        end if

        displayDate2 = MonthName(Month(endDate)) & " " & Day(endDate) & ", " & Year(endDate)

        ' Response.Write "<br> Start Date: " & startDate & "<br>"
        ' Response.Write "<br> End Date: " & endDate & "<br>"

    end if

    
%>


<div id="main">    
    
    <div id="content">
        <div class="container">

            <h1 class="h2 text-center mt-5 mb-5 main-heading d-flex justify-content-between">
                <button class="btn btn-sm btn-outline-dark date_transact" data-toggle="modal" data-target="#date_transactions" title="Select date of reports" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Select Date</button>
                <span class="h2 text-center" style="font-weight: 400">OB of 
                <%if obDate = systemDate then
                    Response.Write displayDate1
                  else 
                    Response.Write displayDate2
                  end if
                %>
                </span>
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


                obMyYear = Year(obDate)
                obMyDay = Day(obDate)
                if Len(obMyDay) = 1 then
                    obMyDay = "0" & obMyDay
                end if

                obMyMonth = Month(obDate)
                if Len(obMyMonth) = 1 then
                    obMyMonth = "0" & obMyMonth
                end if

                obDateFormat = obMyMonth & "/" & obMyDay & "/" & Mid(obMyYear, 3)

                Dim ebFile, ebPath, ebMonthPath, ebYearPath
                ebFile = "\eb_test.dbf"
                ebMonthPath = Month(obDate)
                ebYearPath = Year(obDate)

                if LEN(ebMonthPath) = 1 then
                    ebMonthPath = "0" & ebMonthPath
                end if

                ebPath =  mainPath & ebYearPath & "-" & ebMonthPath & ebFile

                if obDate = systemDate then

                    rs.open "SELECT cust_id, cust_name, department, balance AS credit_bal, date AS end_date "&_ 
                         "FROM "&obPath&" "&_
                         "GROUP BY cust_id ORDER BY department, cust_name", CN2

                else

                    rs.open "SELECT cust_id, cust_name, department, credit_bal, end_date "&_ 
                        "FROM "&ebPath&" "&_
                        "WHERE end_date=CTOD('"&endDate&"') ORDER BY department, cust_name", CN2
                end if
            %>
            
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-bg">
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
                        <td class="text-darker"><span class="currency-sign">&#8369;</span> <%Response.Write(formatNumber(rs("credit_bal")))%></td>
                        <% 
                            myDate = CDATE(rs("end_date"))
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
                            d = CDate(rs("end_date"))
                        %>
                        <td class="text-darker">
                            <%if obDate = systemDate then
                                Response.Write(obDateFormat)
                            else
                                Response.Write(dateFormat)
                            end if%>
                        </td>                   
                    </tr>

                <%rs.MoveNext%>
                <%loop%>
                <%rs.close%>

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
            { extend: 'copy', className: 'btn btn-sm btn-light' },
            { extend: 'excel', className: 'btn btn-sm btn-light' },
            { extend: 'pdf', className: 'btn btn-sm btn-light' },
            { extend: 'print', className: 'btn btn-sm btn-light' }
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