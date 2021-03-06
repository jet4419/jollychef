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
                <form action="test_getstring.asp" method="POST" id="allData" class="">
                    
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

                    rs.CursorLocation = 3

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

                            Response.Write "<br> Folder Path: " & folderPath & "<br>"
                            rs.Open "SELECT cust_id, cust_name, invoice_no, date, prod_gen, prod_price, prod_qty, prodamount FROM "&salesOrderPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY cust_name, cust_id", CN2
                            Response.Write "<br> Conn OPEN </br>"
                            Response.Write "Goods " & i & " M:" & monthPath & "<br>"

                            Response.Write "<br> Conn CLOSED </br>"

                            salesMonthLength = Month(DateAdd("m",i+1,queryDate1))
                            if Len(salesMonthLength) = 1 then
                                salesMonthPath = "0" & CStr(Month(DateAdd("m",i+1,queryDate1)))
                            else
                                salesMonthPath = Month(DateAdd("m",i+1,queryDate1))
                            end if

                            salesYearPath = Year(DateAdd("m",i+1,queryDate1))

                            salesFolderPath = mainPath & salesYearPath & "-" & salesMonthPath
                            salesOrderPath = salesFolderPath & salesOrderFile

                            Response.Write "<br>" & salesFolderPath & "<br>"
                            if fs.FolderExists(salesFolderPath) <> true then EXIT DO
                            if fs.FileExists(salesOrderPath) <> true then EXIT DO
                        
                            rs.close

                        Loop While False  
                        
                    next        


                        rs.Sort = "cust_id"
                        
                        do until rs.EOF

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
                                            <td><%=rs("date")%></td>   
                                            <td class="totalAmount"><%=totalQty%></td>   
                                            <td class="totalAmount">&#8369; <%=totalSales%></tr>
                                        </tr>
                                        <tr>
                                            <td colspan="7"></td>
                                        </tr>
                                        <%isTotalPrinted = true%>
                                    <%else%>
                                        <tr>
                                            <td colspan="7"></td>
                                        </tr>
                                        <%isTotalPrinted = false%>
                                    <%end if%>
                                <%
                                    totalSales = CDBL(rs("prodamount"))
                                    totalQty = CINT(rs("prod_qty"))
                                    custID = ""
                                    invoiceCounter = 1
                                end if

                                invoiceNo = CLNG(rs("invoice_no"))

                                ' Response.Write "<br> " & isSameUser & "<br>"
                                'Response.Write "<br>" & testInvoice & ": " & totalAmount & "<br>"

                            rs.MoveNext    
                            %> 
          
                        
                        <%loop%>
                </table>
            
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

document.getElementById('printMe').addEventListener('click', () => {
    $("#printData").print({
        globalStyles: true,
        mediaPrint: false,
        stylesheet: null,
        noPrintSelector: ".no-print",
        iframe: true,
        append: null,
        prepend: null,
        manuallyCopyFormValues: true,
        deferred: $.Deferred(),
        timeout: 750,
        title: null,
        doctype: '<!doctype html>'
	});
})

 
</script>
</body>
</html>