<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="css/receipt.css">
    <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
    <link href="fontawesome/css/brands.css" rel="stylesheet">
    <link href="fontawesome/css/solid.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/6f3e46d502.js" crossorigin="anonymous"></script>
</head>
<body>

    <main class="receipt">
        <p>
            <a href="customers_order.asp">
                <i class="fas fa-times exit-icon"></i>
            </a>
        </p>
        <div class="receipt--container">
            <div class="receipt__header">
                <h1 class="receipt__header--text">Order Invoice</h1>
                <div class="receipt__header--infos">
                    <div class="company__info">
                        <span class="company__info--container">
                            <span class="info-label"><strong>Name:</strong></span> 
                            <span class="info-text">JollyChef Inc.</span>
                        </span>
                        
                        <span class="company__info--container">
                            <span class="info-label"><strong>Address: </strong></span>
                            <span>Km. 112 Maharlika Highway, Cabanatuan City</span>
                            <!-- <span class="info-text">Royce Canteen</span> -->
                            
                        </span>
                    </div>
                    
            <%
                Dim mainPath, folderPath, yearPath, monthPath, transactDate, invoice

                Dim isValidDate
                isValidDate = IsDate(Request.QueryString("date"))

                if isValidDate = true then

                transactDate = CDate(Request.QueryString("date"))
                invoice = CDbl(Request.QueryString("invoice"))

                Dim isInvoiceNumeric
                isInvoiceNumeric = IsNumeric(invoice)

                yearPath = CStr(Year(transactDate))
                monthPath = CStr(Month(transactDate))

                folderPath = mainPath & yearPath & "-" & monthPath

                if Len(monthPath) = 1 then
                    monthPath = "0" & monthPath
                end if

                Dim salesOrderFile

                salesOrderFile = "\sales_order.dbf"


                Dim salesOrderPath

                salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile  
                'Response.Write salesOrderPath

                

                Dim isInvoiceExist 
                isInvoiceExist = false

                Dim recentMonthPath, recentYearPath

                recentMonthPath = monthPath
                recentYearPath = yearPath
                checkPath = salesOrderPath

                ' Response.Write "Path: " & salesOrderPath & "<br>"
                ' Response.Write "Check Path: " & checkPath & "<br>"
                if isInvoiceNumeric = true and transactDate <> "" and invoice <> ""  then
                    Dim fs
                    Set fs = Server.CreateObject("Scripting.FileSystemObject")

                    if fs.FolderExists(folderPath) <> false then 

                        do until fs.FileExists(checkPath) = true

                        checkInvoice = "SELECT invoice_no FROM "&checkPath&" WHERE duplicate!='yes' and invoice_no="&invoice
                        set objAccess = cnroot.execute(checkInvoice)

                            if objAccess.EOF then
                                'Response.Write "Hey"
                                recentMonthPath = CInt(recentMonthPath) - 1
                                recentYearPath = CInt(recentYearPath)

                                if recentMonthPath = 0 then

                                    recentMonthPath = 12
                                    recentYearPath = CInt(recentYearPath) - 1

                                end if

                                if Len(recentMonthPath) = 1 then
                                    recentMonthPath = "0" & recentMonthPath
                                end if

                                recentFolderPath = mainPath & recentYearPath & "-" & recentMonthPath

                                checkPath = recentFolderPath & salesOrderFile

                            else

                                salesOrderPath = checkPath
                                isInvoiceExist = true
                                EXIT DO

                            end if

                        loop

                    end if

                    'Response.Write salesOrderPath
                    if fs.FileExists(salesOrderPath) <> false then 

                    totalAmount = 0.00
                    rs.Open "SELECT ref_no, prod_qty, prod_gen, prod_price, prodamount, date FROM "&salesOrderPath&" WHERE invoice_no="&invoice, CN2                      

                        if not rs.EOF then
                %>
                        <%d = CDate(rs("date"))%>
                        <div class="sales__info">
                            <!--<span><strong>Receipt #<span></span></strong> 12345678</span>-->
                            <span><strong>Reference No.</strong> <%=rs("ref_no")%></span>
                            <span><strong>Invoice No.</strong> <%=Request.QueryString("invoice")%></span>
                            <span><strong>Date:</strong> <%=FormatDateTime(d,2)%></span>
                        </div>
                    </div>
                </div>

                <div class="receipt__body">
                    <table>
                        <thead class="thead-dark">
                            <th>Qty</th>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th>Amount</th>
                        </thead>
                        
                        <tbody>
                            <%do until rs.EOF%>
                            <tr>
                                <td><%Response.Write(rs("prod_qty"))%></td>
                                <td><%Response.Write(rs("prod_gen"))%></td>
                                <td><%Response.Write(rs("prod_price"))%></td>
                                <td><%Response.Write(rs("prodamount"))%></td>
                            <%
                            totalAmount = totalAmount + CDbl(rs("prodamount"))
                            rs.moveNext
                            %>    
                            </tr>
                            <%loop%>
                            <%rs.close
                            CN2.close%>
                        </tbody>
                        
                        <tfoot>
                            <tr>
                                <td colspan="3"><strong><span class="tfooter-total-text">Total</span></strong></td>
                                <td colspan="1"><span class="tfooter-amount-text"><strong>&#8369;<%Response.Write(totalAmount)%></strong></span> </td>
                            </tr>
                        </tfoot>
                    </table>
                
                </div>
                <div class="receipt__footer">
                    <p>Thank you!</p>
                </div>
            </div>
            <%end if%>
                <%end if%>
                <%
                    else
                        Response.Write("No Record.")
                    end if

            end if        
                %>
    </main>
    
</body>
</html>