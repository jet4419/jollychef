<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Detailed Sales Report</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/homepage_style.css">
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

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }
            
            /* .totalAmount::before {
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
            
            .totalAmount {
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
                <form action="sales_report_sum_day.asp" method="POST" id="allData" class="">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Generate</button>
                </form>
                <p>
                <a href="sales_report_detailed.asp" class="btn btn-sm btn-outline-dark">Sales Report by Order</a>
                <a href="sales_report_detailed_ref.asp" class="btn btn-sm btn-outline-dark">Sales Report by Ref</a>
                <a href="sales_report_sum.asp" class="btn btn-sm btn-outline-dark">Summary by Customer</a>
            </p>
            </div>
            
            <h1 class="h2 text-center mt-4 mb-4 main-heading" style="font-weight: 400"> Sales Report Summary by Day</h1>

            <div>
                <%
        
                    Response.Write("<p class='float-left'><strong> Date: </strong>")
                    Response.Write(displayDate1 & " - ")
                    Response.Write(displayDate2)
                    Response.Write "</p>"
                
                %>  
                <button id="printMe" class="btn btn-sm btn-dark float-right mr-1">Print</button>
            </div>

            <div id="printData"> 

                <p class="heading-print"> Sales Report Summary per Day: <span class="date-range-print"> <%=displayDate1 & " to " & displayDate2 %></span></p>

                <table class="table table-hover table-bordered table-sm mb-5" id="myTable">
                    <thead class="thead-bg">
                        <th>Customer</th>
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
                    salesReportPath = mainPath & "temp_folder\" & salesOrderReportFile

                    if fs.FileExists(salesReportPath) then

                        On Error Resume Next
                            fs.DeleteFile(salesReportPath)
                        On Error GoTo 0
                    end if


                    if fs.FileExists(salesReportPath) <> true then 

                        fs.CopyFile prevSalesReportPath, salesReportPath
                        ' Response.Write "File successfully copied"
                    
                    end if

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
                        'Displaying reports'
                        rs.Open "SELECT date, SUM(prodamount) AS prodamount, payment FROM "&salesReportPath&" WHERE session_id="&userSessionID&" and duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') GROUP BY date, payment ORDER BY date", CN2

                        Dim totalSales, totalCredit, totalCash
                        totalSales = 0
                        totalCredit = 0
                        totalCash = 0

                        Dim dayTotalSales, dayTotalCash, dayTotalCredit
                        dayTotalSales = 0
                        dayTotalCash = 0
                        dayTotalCredit = 0

                        Dim isTotalPrinted, dateCounter
                        dateCounter = 1
                    %>

                            <%do until rs.EOF
                                
                                Response.Flush

                                if dateCont = "" or dateCont = CDATE(rs("date")) then
                                    dayTotalSales = dayTotalSales + CDBL(rs("prodamount"))
                                else
                                    dateCounter = dateCounter + 1
                                    isTotalPrinted = true
                                    %>
                                    <tr> 
                                        <td><%=dateFormat%></td>   
                                        <td><span class="currency-sign">&#8369;</span> <%=dayTotalSales%></td>      
                                        <td><span class="currency-sign">&#8369;</span> <%=dayTotalCash%></td>   
                                        <td><span class="currency-sign">&#8369;</span> <%=dayTotalCredit%></td>
                                    </tr>
                                   <%
                                    dayTotalSales = CDBL(rs("prodamount"))
                                    dayTotalCash = 0
                                    dayTotalCredit = 0
                                    isTotalPrinted = false
                                end if

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

                                paymentType = Trim(CSTR(rs("payment")))
                                if paymentType = "Credit" then
                                    totalCredit = totalCredit + CDBL(rs("prodamount"))
                                    dayTotalCredit = dayTotalCredit + CDBL(rs("prodamount"))
                                else
                                    totalCash = totalCash + CDBL(rs("prodamount"))
                                    dayTotalCash = dayTotalCash + CDBL(rs("prodamount"))
                                end if

                                dateCont = CDATE(rs("date"))
                                totalSales = totalSales + CDBL(rs("prodamount"))%> 

                                <%rs.MoveNext%>

                                <%if rs.EOF then%>
                                    <tr> 
                                        <td><%=dateFormat%></td>   
                                        <td><span class="currency-sign">&#8369;</span> <%=dayTotalSales%></td>      
                                        <td><span class="currency-sign">&#8369;</span>  <%=dayTotalCash%></td>   
                                        <td><span class="currency-sign">&#8369;</span>  <%=dayTotalCredit%></td>
                                    </tr>
                                <%end if%>

                            <%loop%>

                        <%rs.close%>   

                        <%
                        if dateCounter > 1 then  
                            if isTotalPrinted = false then%>
                                <tr>   
                                    <td></td>   
                                    <td class="totalAmount">&#8369; <%=totalSales%></td>      
                                    <td class="totalAmount">&#8369; <%=totalCash%></td>   
                                    <td class="totalAmount">&#8369; <%=totalCredit%></td>
                                </tr>
                            <%end if%>
                        <%end if%>
                          
                </table>

                <!-- DELETING sales_report_container -->
                <%  
                    deleteReport = "DELETE FROM "&salesReportPath&" WHERE session_id="&userSessionID
                    set objAccess = cnroot.execute(deleteReport)
                    set objAccess = nothing

                    set rs = nothing
                    CN2.close


                    ' closeTbl = "USE IN "&salesReportPath
                    ' cnroot.execute(closeTbl)

                    
 
                     '''Check if file exists before deleting
                    ' if fs.FileExists(salesReportPath) then

                    '     fs.DeleteFile(salesReportPath)
                    '     Response.Write "File was deleted"

                    ' end if
                    ' set fs=nothing

                    
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


<script> 

    // $("#myTable").print({
    //     	globalStyles: true,
    //     	mediaPrint: false,
    //     	stylesheet: null,
    //     	noPrintSelector: ".no-print",
    //     	iframe: true,
    //     	append: null,
    //     	prepend: null,
    //     	manuallyCopyFormValues: true,
    //     	deferred: $.Deferred(),
    //     	timeout: 750,
    //     	title: null,
    //     	doctype: '<!doctype html>'
	// });

    // $("#myTable").find('.printMe').on('click', function() {
    //     console.log('Print');
    //     $.print("#myTable");
    // });




// function printData() {
//     // $("#myTable").find('.print').on('click', function() {
//     //     $.print("#printable");
//     // });
    
// }


//    var divToPrint=document.getElementById("myTable");
//    newWin= window.open("");
//    newWin.document.write(divToPrint.outerHTML);
//    newWin.print();
//    newWin.close();
// }

// document.getElementById('printMe').addEventListener('click', () => {
//     $("#printData").print({
//         globalStyles: true,
//         mediaPrint: false,
//         stylesheet: null,
//         noPrintSelector: ".no-print",
//         iframe: true,
//         append: null,
//         prepend: null,
//         manuallyCopyFormValues: true,
//         deferred: $.Deferred(),
//         timeout: 750,
//         title: null,
//         doctype: '<!doctype html>'
// 	});
// })

document.getElementById('printMe').addEventListener('click', printDiv)

function printDiv() {
    var divToPrint = document.getElementById('printData');
    var htmlToPrint =
        `<style type="text/css"> 

            * {
                box-sizing: border-box;
                text-align: left;
                font-size: 16px;
                color: rgb(16,16,16);
            }

            table {
                background-color: transparent;
                width: 100%;
                display: table;
                box-sizing: border-box;
                text-align: start;
                // border-color: grey;
                font-variant: normal;
                border: 0.1px solid #000;
                border-collapse: collapse;
            }

            th, td {
                font-family: sans-serif;
            }

            thead {
                display: table-header-group;
                vertical-align: middle;
                border-color: inherit;
                border: 0.1px #bbb solid;
            }

            th {
                display: table-cell;
                font-weight: 600;
                border-color: #32383e;
                vertical-align: bottom;
                padding: .3rem;
                border: 0.1px #e9ecef solid;
                font-size: 13px;
            }

            td {
                display: table-cell;
                border: solid 0.1px #e9ecef !important;
                border-bottom: none;
                border-collapse: collapse;
                font-size: 12px;
                padding: .3rem;
            }

            
            * {
                color: #000 !important;
            }

            a.text-info,
            a.text-info:hover {
                text-decoration: none !important;
                color: #000 !important;
                font-size: 12px;
            }

            @page {
                margin: 2cm;
            }

            #printData {
                /* columns: 7; */
                /* orphans: 3; */
            }

            .currency-sign {
                // color: #393e46 !important;
                font-size: 11pt;
            }
            

            @page :first {
                margin-top: 2.5cm;
            }

            header, footer, aside, nav, form, iframe, .menu, .hero, .adslot {
                display: none;
            }
            
            .totalAmount {
                // text-decoration: underline;
                // text-underline-position: under;
                border: 1px solid #252422 !important;
                font-size: 11pt;

            }

            .blank_row {
                display: table-cell !important;
                padding: .3rem !important;
                height: 30px;
            }

            td.bold-text {
                font-weight: 600 !important;
            }

            .heading-print {
                display: block !important;
                font-weight: 600;
                margin-bottom: 1cm;
                font-size: 16px;
            }

            .date-range-print {
                font-weight: 400;
                font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
                display: inline-block;
                font-size: 13px;
            }

            #printData::after {
                content: 'JollyChef Inc.';
                display: block;
                text-align: center;
                padding: 50px;
            }

        </style>`

    htmlToPrint += divToPrint.outerHTML;
    newWin = window.open("");
    newWin.document.write(htmlToPrint);
    newWin.print();
    newWin.close();
}

 
</script>
</body>
</html>