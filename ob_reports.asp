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
    sDay = Day(systemDate)
    sMonth = MonthName(Month(systemDate))
    sYear = Year(systemDate)

    myYear = Year(systemDate)
    myDay = Day(systemDate)
    if Len(myDay) = 1 then
        myDay = "0" & myDay
    end if

    myMonth = Month(systemDate)
    if Len(myMonth) = 1 then
        myMonth = "0" & myMonth
    end if

    dateFormat = myMonth & "/" & myDay & "/" & Mid(myYear, 3)
%>

<div id="main">    
    
    <div id="content">
        <div class="container">
            <h1 class="h2 text-center mt-5 mb-5 main-heading d-flex justify-content-between">
                 <button class="btn btn-sm btn-outline-dark float-right date_transact" data-toggle="modal" data-target="#date_transactions" title="Select date of reports" data-toggle="tooltip" data-placement="top" title="Tooltip on top">Select Date</button>
                <span class="h2" style="font-weight: 400">OB as of <%=sMonth & " " & sDay & ", " & sYear %></span>
                <%if (Month(systemDate) <> Month(systemDate + 1)) then%>
                    <button class="btn btn-outline-dark float-right month-end-label">Month End</button>
                <%else%>
                    <button class="btn btn-sm btn-outline-dark float-right month-end-label">Month End</button>
                <%end if%>
            </h1>

            <%  
                Dim yearPath, monthPath

                yearPath = CStr(Year(systemDate))
                monthPath = CStr(Month(systemDate))

                if Len(monthPath) = 1 then
                    monthPath = "0" & monthPath
                end if
          
                arFile = "\accounts_receivables.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                arPath = folderPath & arFile

                rs.open "SELECT cust_id, cust_name, cust_dept, invoice_no, balance FROM "&arPath&" WHERE balance > 0 ORDER BY cust_dept, cust_name, date_owed", CN2
            %>
            
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-bg">
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Department</th>
                    <th>Invoice</th>
                    <th>Date</th>
                    <th>Balance</th>
                    <!--
                    <th>Adjustments</th>
                    -->
              
                    
                </thead>

                <%do until rs.EOF%>
                <tr>
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td>
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_name")))%></td>
                    <td class="text-darker"><%Response.Write(rs("cust_dept"))%></td>
                    <td class="text-darker">
                        <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=d%>'><%=rs("invoice_no")%>
                    </td>
                    <td class="text-darker">
                        <%Response.Write(dateFormat)%>
                    </td> 
                    <td class="text-darker"><span class="currency-sign">&#8369;</span> <%Response.Write(formatNumber(rs("balance")))%></td>
                    
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
        scrollY: "28vh",
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

    
</script>

</body>
</html>    