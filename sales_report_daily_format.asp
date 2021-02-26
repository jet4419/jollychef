<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Daily Sales Report</title>
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
        Dim dailyReportDate

        dailyReportDate = Request.Form("startDate")

        if dailyReportDate="" then

            queryDate = CDate(FormatDateTime(systemDate, 2))
            displayDate = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else

            queryDate = CDate(FormatDateTime(dailyReportDate, 2))
            displayDate = MonthName(Month(queryDate)) & " " & Day(queryDate) & ", " & Year(queryDate)

        end if   

%>

<div id="main" class="mb-5">

    <div id="content" class="mb-5">

        <div class="container mb-5">

            <div class="mt-4 mb-2 d-flex justify-content-between">
                <form action="sales_report_daily_format.asp" method="POST" id="allData" class=""> 
                    <label for="startDate">Select Date</label>
                    <input class="form-control form-control-sm d-inline col-4" name="startDate" id="startDate" type="date" max="<%=systemDate%>" required> 
                    
                    <button type="submit" class="btn btn-outline-dark btn-sm mb-1" id="generateReport">Generate</button>
                </form>
                <p>
                    <a href="collections_report_daily.asp" class="btn btn-sm btn-outline-dark">Daily Collections Report</a>
                </p>
            </div>
            

            <h1 class="h2 text-center pb-2 mt-4 main-heading" style="font-weight: 400"> Daily Sales Report <p class="report-type"><%=displayDate%></p>
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
                    <p class="heading-print"> Daily Sales Report: <span class="date-range-print"> <%=displayDate%></span>
                    </p>
                </div>

                <table class="table table-hover table-bordered table-sm mb-5" id="myTable">
                    <thead class="thead-bg">
                        <th>Customer</th>
                        <th>Reference No</th>
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

                    Dim monthLength, monthPath, yearPath

                    monthLength = Month(queryDate)

                    if Len(monthLength) = 1 then
                        monthPath = "0" & CStr(Month(queryDate))
                    else
                        monthPath = Month(queryDate)
                    end if

                    yearPath = Year(queryDate)

                    Dim salesOrderFile, salesOrderPath

                    salesOrderFile = "\sales_order.dbf"
                    folderPath = mainPath & yearPath & "-" & monthPath
                    salesOrderPath = folderPath & salesOrderFile

                    
                    if fs.FileExists(salesOrderPath) = true then

                        'Displaying reports'
                        rs.Open "SELECT cust_id, cust_name, invoice_no, date, prod_gen, prod_price, prod_qty, SUM(prodamount) AS prodamount, payment FROM "&salesOrderPath&" WHERE duplicate!='yes' and date = CTOD('"&queryDate&"') GROUP BY invoice_no ORDER BY cust_name, cust_id, invoice_no", CN2

                        Dim totalSales, totalCharge, totalCash
                        totalSales = 0
                        totalCharge = 0
                        totalCash = 0

                        Dim customerTotalSales, customerTotalCash, customerTotalCharge 
                        customerTotalSales = 0
                        customerTotalCash = 0
                        customerTotalCharge = 0

                        Dim isTotalPrinted%>

                            <%do until rs.EOF
                                
                                Response.Flush

                                if custIdCont = "" or custIdCont = CLNG(rs("cust_id")) then
                                    customerCount = customerCount + 1
                                    customerTotalSales = customerTotalSales +  CDBL(rs("prodamount"))
                                else
                                    
                                    isTotalPrinted = true
                                    
                                    if customerCount > 1 then%>
                                    <tr> 
                                        <td></td>   
                                        <td></td>     
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalSales%></td>      
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>   
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>
                                    <%end if%>
                                    <tr>
                                        <td class="blank_row" colspan="7"></td>
                                    </tr>

                                   <%
                                    customerTotalSales = CDBL(rs("prodamount"))
                                    customerTotalCash = 0
                                    customerTotalCharge = 0
                                    isTotalPrinted = false
                                    customerCount = 1
                                end if

                                totalSales = totalSales + CDBL(rs("prodamount"))
                                paymentType = Trim(CSTR(rs("payment")))
                                if paymentType = "Credit" then
                                    customerTotalCharge = customerTotalCharge + CDBL(rs("prodamount"))
                                    totalCharge = totalCharge + CDBL(rs("prodamount"))
                                else
                                    customerTotalCash = customerTotalCash + CDBL(rs("prodamount"))
                                    totalCash = totalCash + CDBL(rs("prodamount"))
                                end if

                                custIdCont = CLNG(rs("cust_id"))

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
                                    <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                    <%invoiceAmount = CDBL(rs("prodamount"))%>

                                    <%if paymentType = "Credit" then%>
                                        <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; 0</span>")%></td>
                                        <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                    <%else%>
                                        <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; </span>"&rs("prodamount"))%></td>
                                        <td class="text-darker"><%Response.Write("<span class='currency-sign' >&#8369; 0</span>")%></td>
                                    <%end if%>

                                </tr>
                                <%rs.MoveNext%>
                      
                            <%loop%>
                        <%rs.close%>   

                        <%
                            if customerCount > 1 then
                                if isTotalPrinted = false then%>
                                    <tr> 
                                        <td></td>   
                                        <td></td>      
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalSales%></td>      
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>   
                                        <td class="salesTotalAmount"><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>
                                <%end if%>
                            <%end if
                    end if%>    

                    <tr> 
                        <td class="final-total">Total</td>   
                        <td class="final-total"></td>      
                        <td class="final-total"><span class="currency-sign">&#8369; </span> <%=totalSales%></td>      
                        <td class="final-total"><span class="currency-sign">&#8369; </span> <%=totalCash%></td>   
                        <td class="final-total"><span class="currency-sign">&#8369; </span><%=totalCharge%></td>
                    </tr>  

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

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>   
<script src="./js/print.js"></script> 

</body>
</html>