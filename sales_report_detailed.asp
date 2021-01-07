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

            .totalAmount {
                font-weight: 600;
                border-bottom: 1.5px solid #000 !important;
            }
            
            .totalAmount::before {
                content: "";
                position: absolute;
                bottom: 0;
                left: 0;
                height: 0.5em;
                border-left: 1px solid black;
            }

            td:empty::after {
                content: "\00a0";
            }

            .bold-text {
                font-weight: 500;
            }

            .currency-sign {
                color: #007bff;
                font-weight: 500;
            }

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
        Dim startDate, endDate

        startDate = Request.Form("startDate")
        endDate = Request.Form("endDate")

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
                <form action="sales_report_detailed.asp" method="POST" id="allData" class="">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Generate</button>
                </form>
                <p hidden></p>
            </div>

            <button id="printMe" class="btn btn-sm btn-dark">Print</button>
            <h1 class="h2 text-center mb-4 main-heading" style="font-weight: 400"> Detailed Sales Report </h1>

            <%
    
                Response.Write("<p><strong> Date: </strong>")
                Response.Write(displayDate1 & " - ")
                Response.Write(displayDate2)
                Response.Write "</p>"
                    
            %>

            <div id="printData"> 

                <p class="heading-print">Detailed Sales Report: <span class="date-range-print"> <%=displayDate1 & " to " & displayDate2 %></span></p>

                <table class="table table-hover table-bordered table-sm mb-5" id="myTable">
                    <thead class="thead-dark">
                        <th>Customer</th>
                        <th>Reference No</th>
                        <th>Date</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Amount</th>            
                    </thead>
                    <%
                    Dim fs
                    set fs=Server.CreateObject("Scripting.FileSystemObject")

                    Dim invoiceNo, testInvoice, totalSales, totalQty, invoiceCounter
                    totalSales = 0
                    totalQty = 0
                    invoiceCounter = 0

                    Dim custIdCont, isFirstUser, isNewUser, customerCount
                    customerCount = 0

                    Dim salesOrderReportFile, prevSalesReportPath, salesReportPath

                    salesOrderReportFile = "sales_report_container.dbf"
                    prevSalesReportPath = mainPath & "tbl_blank\" & salesOrderReportFile
                    salesReportPath = mainPath & "temp_folder\" & salesOrderReportFile

                    if fs.FileExists(salesReportPath) <> true then 

                        fs.CopyFile prevSalesReportPath, salesReportPath
                        Response.Write "File successfully copied"
                    
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
                                "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate) VALUES ("&rs("transactid")&", '"&rs("ref_no")&"', "&rs("invoice_no")&", "&rs("cust_id")&", '"&rs("cust_name")&"', "&rs("product_id")&", '"&rs("prod_brand")&"', '"&rs("prod_gen")&"', "&rs("prod_price")&", "&rs("prodamount")&", "&rs("prod_qty")&", "&rs("profit")&", ctod(["&rs("date")&"]), '"&rs("payment")&"', '"&rs("duplicate")&"'); "

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
                        rs.Open "SELECT cust_id, cust_name, invoice_no, date, prod_gen, prod_price, prod_qty, prodamount FROM "&salesReportPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY cust_name, cust_id, invoice_no", CN2
                    %>

                            <%do until rs.EOF
                                
                                Response.Flush

                                if custIdCont = "" or custIdCont = CLNG(rs("cust_id")) then
                                    customerCount = customerCount + 1
                                else
                                    customerCount = 1
                                end if

                                custIdCont = CLNG(rs("cust_id"))

                                if invoiceNo = "" or invoiceNo = CLNG(rs("invoice_no")) then
                                    totalSales = totalSales + CDBL(rs("prodamount")) 
                                    totalQty = totalQty + CINT(rs("prod_qty"))
                                    invoiceCounter = invoiceCounter + 1
                                else%>
                                    <%if invoiceCounter > 1 then%>
                                        <tr> 
                                            <td></td>   
                                            <td></td>   
                                            <td></td>   
                                            <td></td>   
                                            <td></td>   
                                            <td class="totalAmount"><%=totalQty%></td>   
                                            <td class="totalAmount">&#8369; <%=totalSales%></tr>
                                        </tr>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                        <%isTotalPrinted = true%>
                                    <%else%>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                    <%end if%>
                                    <%
                                    totalSales = CDBL(rs("prodamount"))
                                    totalQty = CINT(rs("prod_qty"))
                                    custID = ""
                                    invoiceCounter = 1
                                    isTotalPrinted = false
                                end if

                                invoiceNo = CLNG(rs("invoice_no"))%> 
                                <tr>
                                    <%transactDate = FormatDateTime(CDate(rs("date")), 2)%> 
                                    <%if customerCount > 1 then%>
                                        <td></td> 
                                    <%else%>
                                        <td class="text-darker bold-text"><%Response.Write(rs("cust_name"))%></td> 
                                    <%end if%> 
                                    <td class="text-darker">
                                        <%if invoiceCounter < 2 then%>
                                            <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                            <% testInvoice = CINT(rs("invoice_no"))%>
                                        <%end if%>
                                    </td>
                                    <td class="text-darker"><%Response.Write(transactDate)%></td>
                                    <td class="text-darker"><%Response.Write(rs("prod_gen"))%></td> 
                                    <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prod_price"))%></td> 
                                    <td class="text-darker"><%Response.Write(rs("prod_qty"))%></td> 
                                    <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                    <%invoiceAmount = CDBL(rs("prodamount"))%>
                                </tr>
                                <%rs.MoveNext%>
                      
                            <%loop%>
                        <%rs.close%>   

                        <%
                            if invoiceCounter > 1 then
                                if isTotalPrinted = false then%>
                                    <tr> 
                                        <td></td>   
                                        <td></td>   
                                        <td></td>   
                                        <td></td>   
                                        <td></td>   
                                        <td class="totalAmount"><%=totalQty%></td>      
                                        <td class="totalAmount">&#8369; <%=totalSales%></tr>
                                    </tr>
                                <%end if%>
                            <%end if%>
                          
                </table>

                <!-- DELETING sales_report_container -->
                <%  
                    ' Dim fl As File

                    ' If fs.FileExists(salesReportPath) Then
                    '     Set fl = fs.GetFile(salesReportPath)
                    '     If (fl.Attributes And ReadOnly) Then
                    '     fl.Attributes = fl.Attributes - ReadOnly
                    '     End If
                    ' End If

                    ' filesys.CreateTextFile("c:\somefile.txt", True
                    ' If filesys.FileExists("c:\somefile.txt") Then
                    ' filesys.DeleteFile "c:\somefile.txt"
                    ' Response.Write("File deleted")
                    ' End If

                    deleteReport = "DELETE FROM "&salesReportPath&" "
                    cnroot.execute(deleteReport)

                    fs.DeleteFile salesReportPath, True

                    

                    ' if fs.fileExists(salesReportPath) Then
                    '     fs.DeleteFile salesReportPath, True
                    ' Else
                    '     Response.Write "File does not exist"
                    ' End if
                    ' Set fs = Nothing

                    ' if fs.FileExists(salesReportPath) then

                    '     Response.Write "File exist on " & salesReportPath
                    '     fs.DeleteFile salesReportPath, true 

                    ' end if

                    
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
                border-bottom: 1px solid #252422 !important;
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