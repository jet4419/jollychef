<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Daily Collections Report</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        
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

            /* .main-heading {
                font-family: 'Kulim Park', sans-serif;
            } */

            th {
                display: table-cell !important;
                padding: .3rem;
            }

            .bold-text {
                font-weight: 500;
            }

            .date-range-print {
                display: inline-block;
                padding-left: .5rem;
            }

            .heading-print {
                display: none;
            }

            /* .final-total {
                font-weight: 600;
                font-size: 13pt;
                border-bottom: #000 1px solid !important;
            } */
/* 
            thead { display: table-header-group !important}
            tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}
            
            #myTable {
                overflow: visible !important;
            }

            tr { 
                page-break-inside: avoid !important;
            }

            td { 
                page-break-inside: avoid !important;
            } */

            /* .table-responsive { overflow-x: visible !important; } */

        @media print {

            * {
                font-family: monospace;
                font-size: 12pt;
            }

            thead { 
                display: table-header-group !important;
            }
            
            tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}
            /* thead {   
                position: fixed !important;
                display: block;
                height: auto;
                width: 100%;
            } */
            /* tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}

            #myTable {
                overflow: visible !important;
            }

            tr { 
                page-break-inside: avoid !important;
            }

            td { 
                page-break-inside: avoid !important;
            } */

            /* .tbl-responsive { overflow-x: visible !important; } */

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

    Dim collectionsReportDate

    collectionsReportDate = Request.Form("startDate")

        if collectionsReportDate="" then
            
            queryDate = CDate(FormatDateTime(systemDate, 2))
            displayDate = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else

            queryDate = CDate(FormatDateTime(collectionsReportDate, 2))
            displayDate = MonthName(Month(queryDate)) & " " & Day(queryDate) & ", " & Year(queryDate)

        end if   

%>

<div id="main">

    <div id="content">

        <div class="container">
            <div class="mt-4 mb-2 d-flex justify-content-between">

                <form action="collections_report_daily.asp" method="POST" id="allData" class="">
                    
                    <label>Select Date</label>
                    <input class="form-control form-control-sm d-inline col-4" name="startDate" id="startDate" type="date" max="<%=systemDate%>" required> 
                    
                    <button type="submit" class="btn btn-outline-dark btn-sm mb-1" id="generateReport">Generate</button>
                </form>

                <p>
                    <a href="sales_report_daily_format.asp" class="btn btn-sm btn-outline-dark">Daily Sales Report</a>
                </p>
            </div>

            <h1 class="h2 text-center pb-2 mt-4 main-heading" style="font-weight: 400">Daily Collections Report <p class="report-type"><%=displayDate%></p></h1>

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
                    <p class="heading-print">Daily Collections Report: <span class="date-range-print"> <%=displayDate%></span>
                    </p>
                </div>

                <table class="table table-hover table-bordered table-sm" id="myTable">
                    <thead class="thead-bg">
                        <tr>
                            <th>Customer Name</th>
                            <th>Reference Number</th>
                            <th>Amount</th>
                            <th>Cash</th>
                            <th>Charge</th>
                        </tr>
                    </thead>
                <%
                    Dim fs
                    set fs=Server.CreateObject("Scripting.FileSystemObject")

                    Dim monthLength, monthPath, yearPath

                    monthLength = Month(queryDate)

                    if Len(monthLength) = 1 then
                        monthPath = "0" & CStr(Month(queryDate))
                    else
                        monthPath = Month(queryDate)
                    end if

                    yearPath = Year(queryDate)

                    Dim collectID, cash_paid, ar_paid, custID, referenceNo

                    printTotal = false

                    Dim customerTotalAmount, customerTotalCash, customerTotalCharge
                    customerTotalAmount = 0
                    customerTotalCash = 0
                    customerTotalCharge = 0

                    Dim collectionsReportFile, collectionsReportPath

                    collectionsReportFile = "\collections.dbf"
                    collectionsReportPath = mainPath & yearPath & "-" & monthPath &collectionsReportFile

                    Dim totalSales, totalCash, totalCharge
                    totalSales = 0
                    totalCash = 0
                    totalCharge = 0

                    if fs.FileExists(collectionsReportPath) = true then

                        'Displaying reports'
                        rs.Open "SELECT * FROM "&collectionsReportPath&" WHERE duplicate!='yes' and date = CTOD('"&queryDate&"') GROUP BY id, cust_id ORDER BY cust_name, cust_id", CN2

                        do until rs.EOF 

                            Response.Flush

                            totalSales = totalSales + CDBL(rs("tot_amount"))
                            paymentType = Trim(CSTR(rs("p_method")))


                            if custIdCont = "" or custIdCont = CLNG(rs("cust_id")) then
                                customerCount = customerCount + 1
                                customerTotalAmount = customerTotalAmount + CDBL(rs("tot_amount"))
                            else
                                printTotal = true
                                
                                if customerCount > 1 then

                                    if printTotal = true then%>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td  class="collectionTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                            <td class="collectionTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>
                                            <td class="collectionTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                        </tr>
                                        <%
                                        printTotal = false
                                        customerTotalAmount = CDBL(rs("tot_amount"))
                                        customerTotalCash = 0
                                        customerTotalCharge = 0
                                    end if
                                end if%>

                                <tr>
                                    <td class="blank_row" colspan="7"></td>
                                </tr>

                                <%
                                customerCount = 1
                        
                            end if

                            custIdCont = CLNG(rs("cust_id"))

                            collectID = rs("id").value %>
                            <tr>
                                <%
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
                                    d = CDate(rs("date"))
                                    d  = FormatDateTime(d, 2)
                                %>
                                <% custID = rs("cust_id").value %>

                                <%if customerCount > 1 then%>
                                    <td></td> 
                                <%else%>
                                    <td class="text-darker name-label"><%Response.Write(rs("cust_name"))%></td> 
                                <%end if%> 

                                <td class="text-darker">
                                    <%Response.Write(rs("invoice"))%>
                                </td> 

                                <td class="text-darker">
                                    <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&rs("tot_amount"))%>
                                </td> 
                                <%if Trim(rs("p_method").value) = Trim("ar") then 
                                    cash_paid = 0.00
                                    ar_paid = rs("cash").value

                                else  
                                    ar_paid = 0.00
                                    cash_paid = rs("cash").value
                                end if
                                %>
                                <td class="text-darker">
                                    <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&cash_paid)%>
                                </td> 

                                <td class="text-darker">
                                    <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&ar_paid)%>
                                </td> 

                                <%
                                    if paymentType = "ar" then
                                        customerTotalCharge = customerTotalCharge + CDBL(rs("cash"))
                                        totalCharge = totalCharge + CDBL(rs("cash"))
                                    else
                                        customerTotalCash = customerTotalCash + CDBL(rs("cash"))
                                        totalCash = totalCash + CDBL(rs("cash"))
                                    end if

                                    ' Response.Write "Cust Total Charge: " & customerTotalCharge & " Cust Total Cash: " & customerTotalCash & "<br>"
                                %>
                                
                            </tr>

                            <%rs.MoveNext
                        loop
                        rs.close
                        %>

                        <%if customerCount > 1 then%>

                            <%if isTotalPrinted = false then%>
                                <tr> 
                                    <td></td>
                                    <td></td>
                                    <td class='collectionTotalAmount'><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                    <td class='collectionTotalAmount'><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>
                                    <td class='collectionTotalAmount'><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                </tr>
                            <%end if%>

                        <%end if%>   

                        <tr> 
                            <td class="final-total screen-final-total">Total</td>
                            <td class="final-total"></td>
                            <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalSales%></td>
                            <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalCash%></td>
                            <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalCharge%></td>
                        </tr>  

                    <%end if%>      

                </table>

                <%  
                    set rs = nothing
                    CN2.close    
                %>


            </div>
        </div>    
    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!-- Edit Transact Modal -->
    <div class="modal fade" id="editTransact" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="t_edit_transaction_c.asp" class="form-group mb-3" id="updateForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"> Edit Transaction <i class="fas fa-shopping-cart"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pb-0" id="collect_details">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-sm btn-secondary bg-dark" data-dismiss="modal">Close</button>
                            <button type="submit" id="saveEditProduct" class="btn btn-sm btn-primary">Save changes</button>
                        </div>
                </form>  
            </div>
        </div>
    </div> 
<!-- END OF Edit Transact MODAL -->  


<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>    
<script src="./js/print.js"></script> 

</body>
</html>