<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Detailed Sales Report</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="./css/main.css">
        <link rel="stylesheet" href="./css/reports.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
  
        <script src="./jquery/jquery_uncompressed.js"></script>
        <script src="./jquery-print/jQuery.print.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>

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

            /* .salesTotalAmount {
                font-weight: 600;
                border-bottom: 1.5px solid #000 !important;
            } */
            
            /* .salesTotalAmount::before {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                height: 0.5em;
                border-left: 1px solid black;
            } */

            td:empty::after {
                content: "\00a0";
            }

            .bold-text {
                font-weight: 500;
            }

            /* .currency-sign {
                color: #007bff;
                font-weight: 500;
            } */

            .date-range-print {
                display: inline-block;
                padding-left: .5rem;
            }

            .heading-print {
                display: none;
            }

            a.text-info,
            a.text-info:hover {
                color: #000 !important;
            }



            /* .blank_row {
                height: 31.6px !important;
                background-color: #FFFFFF;
            } */

            /* @media print {
                 a.text-info, a.text-info:hover {
                    text-decoration: none !important;
                }
            } */
        
        @media print {

            table {
                border: solid #000 !important;
                border-width: 1px 0 0 1px !important;
            }

            th, td {
                border: solid #000 !important;
                border-width: 0 1px 1px 0 !important;
            }
            
            * {
                color: #000 !important;
            }

            a.text-info,
            a.text-info:hover {
                text-decoration: none !important;
                color: #000 !important;
            }

            @page {
                margin: 2cm;
            }

            #printData {
                /* columns: 7; */
                /* orphans: 3; */
            }

            .currency-sign {
                color: #393e46 !important;
            }
            

            @page :first {
                margin-top: 2.5cm;
            }

            header, footer, aside, nav, form, iframe, .menu, .hero, .adslot {
                display: none;
            }
            
            .salesTotalAmount {
                text-decoration: underline;
                text-underline-position: under;
                
            }
            /* .heading-print {
                display: block;
            } */
        }

        </style>

        <link rel="stylesheet" media="screen" href="./css/screen.css"/>
        <link rel="stylesheet" media="print" href="./css/print.css"/>

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
        Dim startDate, endDate, userSessionID

        startDate = Request.Form("startDate")
        endDate = Request.Form("endDate")
        userSessionID = CDBL(Session.SessionID)

        if startDate="" then

            queryDate1 = CDate(FormatDateTime(systemDate, 2))
            displayDate1 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else

            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = MonthName(Month(queryDate1)) & " " & Day(queryDate1) & ", " & Year(queryDate1)

        end if   

        if endDate="" then

            queryDate2 = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else 

            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = MonthName(Month(endDate)) & " " & Day(endDate) & ", " & Year(endDate)

        end if   

        Dim monthsDiff

        monthsDiff = DateDiff("m",queryDate1,queryDate2) 

%>

<div id="main" class="mb-5">

    <div id="content" class="mb-5">

        <div class="container mb-5">

            <div class="mt-4 mb-2 d-flex justify-content-between">
                <form action="sales_report_detailed_ref.asp" method="POST" id="allData" class="">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-sm btn-outline-dark mb-1" id="generateReport">Generate</button>
                </form>
                <p>
                    <a href="sales_report_detailed.asp" class="btn btn-sm btn-outline-dark">Report by Order</a>
                    <a href="sales_report_sum.asp" class="btn btn-sm btn-outline-dark">Report Summary</a>
                </p>
            </div>
            

           
            <h1 class="text-center mt-4 mb-4 report-heading--text"> Sales Report <p class="report-type">per Reference</p></h1>

            <div>
                <%
        
                    Response.Write("<p class='float-left'><strong> Date: </strong>")
                    Response.Write(displayDate1 & " - ")
                    Response.Write(displayDate2)
                    Response.Write "</p>"
                
                %>  
                <button id="printMe" class="btn btn-sm btn-light float-right mr-1">Print</button>

            </div>

            <div id="printData"> 

                <div class="print-main-heading">
                    <p class="print-heading-company">JollyChef Inc.</p> 
                    <p class="heading-print"> Sales Report per Customer/Reference: <span class="date-range-print"> <%=displayDate1 & " to " & displayDate2 %></span>
                    </p>
                </div>

                <table class="table table-hover table-bordered table-sm mb-5" id="myTable">
                    <thead class="thead-bg">
                        <th>Customer</th>
                        <th>Reference No</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Cash</th>
                        <th>Charge</th>          
                    </thead>
                    <%
                

                    Dim fs
                    set fs = Server.CreateObject("Scripting.FileSystemObject")

                    Dim invoiceNo, testInvoice, totalQty, invoiceCounter
                    totalQty = 0
                    invoiceCounter = 0

                    Dim custIdCont, isFirstUser, isNewUser, customerCount
                    customerCount = 0

                    Dim salesOrderReportFile, prevSalesReportPath, salesReportPath

                    salesOrderReportFile = "sales_report_container.dbf"
                    prevSalesReportPath = mainPath & "tbl_blank\" & salesOrderReportFile
                    salesReportPath = tempFolderPath & salesOrderReportFile

                    if fs.FolderExists(tempFolderPath) <> true then
                        fs.CreateFolder(tempFolderPath)
                    end if

                    On Error Resume Next

                        if fs.FileExists(salesReportPath) then

                            fs.DeleteFile(salesReportPath)

                        end if

                        if fs.FileExists(salesReportPath) <> true then 

                            fs.CopyFile prevSalesReportPath, salesReportPath
                        
                        end if

                    On Error GoTo 0

                    for i=0 to monthsDiff

                        monthLength = Month(DateAdd("m",i,queryDate1))
                        if Len(monthLength) = 1 then
                            monthPath = "0" & CStr(Month(DateAdd("m",i,queryDate1)))
                        else
                            monthPath = Month(DateAdd("m",i,queryDate1))
                        end if

                        yearPath = Year(DateAdd("m",i,queryDate1))
                        
                        salesOrderFile = "\sales_order.dbf"
                        folderPath = mainPath &yearPath&"-"&monthPath
                        salesOrderPath = folderPath & salesOrderFile

                        Do 
                            
                            if fs.FolderExists(folderPath) <> true then EXIT DO
                            if fs.FileExists(salesOrderPath) <> true then EXIT DO

                            rs.Open "SELECT * FROM "&salesOrderPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY cust_name, cust_id", CN2

                            do until rs.EOF 

                                insertSalesReport = insertSalesReport & " INSERT INTO "&salesReportPath&" "&_
                                "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate, session_id) VALUES ("&rs("transactid")&", '"&rs("ref_no")&"', "&rs("invoice_no")&", "&rs("cust_id")&", '"&rs("cust_name")&"', "&rs("product_id")&", '"&rs("prod_brand")&"', '"&rs("prod_gen")&"', "&rs("prod_price")&", "&rs("prodamount")&", "&rs("prod_qty")&", "&rs("profit")&", ctod(["&rs("date")&"]), '"&rs("payment")&"', '"&rs("duplicate")&"', "&userSessionID&"); "

                                rs.MoveNext
                            loop

                            ' Response.Write insertSalesReport
                            rs.close

                        Loop While False  
                            
                    next%>    
                    <%
                        'INSERTING SALES RECORDS'
                        if insertSalesReport <> "" then
                            cnroot.execute(insertSalesReport)
                        end if
                    %>

                        <%if fs.FileExists(salesReportPath) = true then

                            'Displaying reports'
                            rs.Open "SELECT cust_id, cust_name, invoice_no, date, prod_gen, prod_price, prod_qty, SUM(prodamount) AS prodamount, payment FROM "&salesReportPath&" WHERE session_id="&userSessionID&" and duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') GROUP BY invoice_no ORDER BY cust_name, cust_id, invoice_no", CN2

                            Dim totalSales, totalCredit, totalCash
                            totalSales = 0
                            totalCredit = 0
                            totalCash = 0

                            Dim isTotalPrinted
                        

                                do until rs.EOF
                                    
                                    Response.Flush
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

                                    if custIdCont = "" or custIdCont = CLNG(rs("cust_id")) then
                                        customerCount = customerCount + 1
                                        totalSales = totalSales + CDBL(rs("prodamount"))
                                    else
                                        isTotalPrinted = true

                                        if customerCount > 1 then%>
                                            <tr> 
                                                <td></td>   
                                                <td></td>   
                                                <td></td>   
                                                <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalSales)%></td>      
                                                <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalCash)%></td>   
                                                <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalCredit)%></td>
                                            </tr>
                                        <%end if%>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                    <%
                                        totalSales = CDBL(rs("prodamount"))
                                        totalCash = 0
                                        totalCredit = 0
                                        isTotalPrinted = false
                                        customerCount = 1
                                    end if

                                    paymentType = Trim(CSTR(rs("payment")))
                                    if paymentType = "Credit" then
                                        totalCredit = totalCredit + CDBL(rs("prodamount"))
                                    else
                                        totalCash = totalCash + CDBL(rs("prodamount"))
                                    end if

                                    custIdCont = CLNG(rs("cust_id"))

                                    invoiceNo = CLNG(rs("invoice_no"))%> 
                                    <tr>
                                        <%transactDate = FormatDateTime(CDate(rs("date")), 2)%> 
                                        <%if customerCount > 1 then%>
                                            <td></td> 
                                        <%else%>
                                            <td class="text-darker name-label"><%Response.Write(rs("cust_name"))%></td> 
                                        <%end if%> 
                                        <td class="text-darker">
                                            <%if invoiceCounter < 2 then%>
                                                <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                                <% testInvoice = CINT(rs("invoice_no"))%>
                                            <%end if%>
                                        </td>
                                        <td class="text-darker"><%Response.Write(dateFormat)%></td>
                                        <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                        <%invoiceAmount = CDBL(rs("prodamount"))%>

                                        <%if paymentType = "Credit" then%>
                                            <td></td>
                                            <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                        <%else%>
                                            <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                            <td></td>
                                        <%end if%>

                                    </tr>
                                    <%rs.MoveNext%>
                        
                                <%loop%>
                            <%rs.close%>   

                            <%if customerCount > 1 then
                                if isTotalPrinted = false then%>
                                    <tr> 
                                        <td></td>   
                                        <td></td>   
                                        <td></td>   
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalSales)%></td>      
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalCash)%></td>   
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=formatNumber(totalCredit)%></td>
                                    </tr>
                                <%end if%>
                            <%end if%>

                        <%end if%>
                          
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

                <!-- DELETING sales_report_container -->
                <%  
                    if fs.FileExists(salesReportPath) = true then

                        deleteReport = "DELETE FROM "&salesReportPath&" WHERE session_id="&userSessionID
                        set objAccess = cnroot.execute(deleteReport)
                        set objAccess = nothing

                    end if

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

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>   
<script src="./js/print.js"></script> 

<!-- Preventing the PopUp Resubmit Form
<script>
    if ( window.history.replaceState ) {
        window.history.replaceState( null, null, window.location.href );
    }
</script>
-->
</body>
</html>