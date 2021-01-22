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
                /* margin-top: .5rem; */
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
                /* color: #206a5d; */
                color: #318fb5;
                text-decoration: none;
            }

            a.link-or:hover {
                /* color: #557571; */
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

            .department_lbl {
                color: #7d7d7d;
            }

            .total-value, .total-text {
                font-size: 18px;
                font-weight: 500;
            }

            /* .no-cell {
                border: 0 !important; 
            } */

            .total-darker {
                font-weight: 600;
            }

                /* thead {
                    display: table-row-group !important;
                } */

                table { page-break-inside:auto }
                tr    { page-break-inside:avoid; page-break-after:auto }
                thead { display:table-header-group }
                /* tfoot { display: table-row-group !important} */

                table tfoot{display:table-row-group !important;}
            
            @media print {
                h1 {
                    padding-bottom: 0.1cm;
                }
                
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
        if Request.Form("cust_id") = "" or Request.Form("cust_name") = "" or Request.Form("department") = "" or Request.Form("startDate") = "" or Request.Form("endDate") = "" then
            Response.Redirect("ob_main.asp")
        end if
    %>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%
        ' dates = Request.Form("date_records")

        ' if dates = "" then
        '     Response.Redirect("canteen_homepage.asp")
        ' end if

        custID = CInt(Request.Form("cust_id"))
        custName = CStr(Request.Form("cust_name"))
        department = CStr(Request.Form("department"))
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

        ' dateSplit = Split(dates, ",")

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

        ' Response.Write "<br> Months Diff: " & monthsDiff & "<br>"

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

        ' Response.Write "Exact Date: " & exactStartDate & "<br>"

        Dim isValidPath
        isValidPath = fs.FolderExists(folderPath)

        Dim ebID, endingCredit, endingDebit
        endingCredit = 0.00
        endingDebit = 0.00

        if isValidPath = true then
            
            Dim ebFile, ebPath
            ebFile = "\eb_test.dbf"
            ebPath = folderPath & ebFile 

            Response.Write lastDayExactDate

            'Getting the beginning balance'
            rs.open "SELECT credit_bal, debit_bal FROM "&ebPath&" WHERE cust_id="&custID&" and end_date=CTOD('"&previousDate&"')", CN2

            if not rs.EOF then
                endingCredit = CDbl(rs("credit_bal"))
                endingDebit = CDbl(rs("debit_bal"))
            end if

            rs.close

        end if

    %>

<div id="main" class="mb-5">
    <div id="content">
        <div class="container mb-5">
            <div class="users-info mt-0 mb-2">
                <h1 class="h2 text-center main-heading my-0"> <strong><span class="order_of">Receivable Card of</span> <span class="cust_name"><%=custName%></span></strong> </h1>
                <h1 class="h4 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
            </div>

        <% 

            if custID <> "" then %>

                <div class="users-info--divider">

                    <span class="p-0 m-0 d-block">
                        <button type="button" class="btn btn-dark btn-sm d-inline w-100 date_transact" id="<%=custID%>"  data-toggle="modal" data-target="#date_transactions">Generate Date Reports</button>
                    </span>

                </div>

            <%end if%>  

                <div class='date-label-container'>
                    <div>
                        <p class='display-date-container'><strong> Date Range: </strong>
                            <span class="date-range">
                            <%=displayDate1 & " - "%>
                            <%=displayDate2%>
                            </span>
                        </p>
                    </div>      
                </div>
            <!--
            <button class="btn btn-sm btn-dark" onclick="printData()">Print</button>
            -->
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
                    </thead>

                    <%if isValidPath = true then%>

                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td><strong>Beginning Balance</strong></td>
                            <td><strong><span class="currency-sign">&#8369;</span> <%=endingCredit%></strong></td>
                            <td></td>
                        </tr>
                        <% 
                            Dim totalCredit, totalDebit, balance
                            balance = endingCredit

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
                                                    <a class="link-or" target="_blank" href='receipt_adjustment.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=transactDate%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                                </td>
                                            <%else%>
                                                <td>
                                                    <a class="link-or" target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=transactDate%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                                </td>
                                            <%end if%>    
                                            <td class="text-info"><%=rs("t_type")%></td>

                                            <% if CInt(rs("invoice")) <= 0 then%>
                                                <td class="text-darker link-or"><%="none"%></td> 
                                            <% else %>    
                                                <td>
                                                    <a class="link-or" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=transactDate%>''><%=rs("invoice")%></a>
                                                </td> 
                                            <% end if %>    
                                            <% if CDbl(rs("debit")) <= 0 then %>
                                                <td class="text-darker"><%=" "%></td>
                                            <% else %>
                                                <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=rs("debit")%></td>
                                                <% totalDebit = CDbl(totalDebit) + CDbl(rs("debit").value) 
                                                balance = balance - CDbl(rs("debit").value)
                                                %>
                                            <% end if %>    
                                            <% if CDbl(rs("credit")) <= 0 then %>
                                                <td class="text-darker"><%=" "%></td>
                                            <% else %>    
                                                <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=rs("credit")%></td>
                                                <% totalCredit = CDbl(totalCredit) + CDbl(rs("credit").value) 
                                                balance = balance + CDbl(rs("credit").value)
                                                %>
                                            <% end if %>    
                                            <td class="text-darker"><span class="currency-sign">&#8369;</span> <%=balance%></td>
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

<!-- Date Range of Transactions -->
<div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">

            <form action="ar_card_report.asp" method="POST" id="allData2">

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

            <form action="t_adjustment_ref.asp" method="POST" id="allData3">

                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Adjustment Plus <i class="fas fa-plus text-success"></i> </h5>
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

            <form action="t_adjustment_minus_ref.asp" method="POST" id="allData4">

                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Adjustment Minus <i class="fas fa-minus text-danger"></i></h5>
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

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<script src="js/main.js"></script> 
<script>  

const dateText = document.querySelector('.date-range').textContent;

$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "32vh",
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
            { 
                extend: 'print', className: 'btn btn-sm btn-light' ,
                title: 'Receivable Card '+ dateText,
                footer: 'true',

                customize: function (win) {
                    $(win.document.body).find('h1').css('font-size', '24px');
                    $(win.document.body).find('h1').css('font-weight', '400');
                }
            }
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

    // function printData() {
    //     var divToPrint=document.getElementById("myTable");
    //     newWin= window.open("");
    //     newWin.document.write(divToPrint.outerHTML);
    //     newWin.print();
    //     newWin.close();
    // }
    /*
    function printData() { 
        var disp_setting="toolbar=yes,location=no,directories=yes,menubar=yes,"; 
            disp_setting+="scrollbars=yes,width=700, height=400, left=100, top=25"; 
        var content_vlue = document.getElementById("myTable").outerHTML; 
        
        var docprint=window.open("","",disp_setting); 
        docprint.document.open(); 
        docprint.document.write('</head><body onLoad="self.print()" style="width: 700px; font-size:11px; font-family:arial; font-weight:normal;">');          
        docprint.document.write(content_vlue); 
        docprint.document.close(); 
        docprint.focus(); 
    }
    */
    

</script>


</body>
</html>    