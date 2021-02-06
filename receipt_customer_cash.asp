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
    <!--<script src="https://kit.fontawesome.com/6f3e46d502.js" crossorigin="anonymous"></script>-->
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
                <h1 class="receipt__header--text">Payment Receipt</h1>
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
                        Dim yearPath, monthPath
                        
                        yearPath = CStr(Year(systemDate))
                        monthPath = CStr(Month(systemDate))

                        if Len(monthPath) = 1 then
                            monthPath = "0" & monthPath
                        end if

                        Dim salesFile, salesOrderFile

                        salesFile = "\sales.dbf"
                        salesOrderFile = "\sales_order.dbf"

                        Dim salesPath, salesOrderPath

                        salesPath = mainPath & yearPath & "-" & monthPath & salesFile
                        salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile

                        invoice = Request.QueryString("invoice")
                        totalAmount = 0.00

                        Dim isInvoiceNumeric
                        isInvoiceNumeric = IsNumeric(invoice)

                        if invoice <> "" and isInvoiceNumeric = true then

                        sqlGetCashPaid = "SELECT ref_no, cash_paid FROM "&salesPath&" WHERE duplicate!='yes' and invoice_no="&invoice
                        set objAccess = cnroot.execute(sqlGetCashPaid)

                        if not objAccess.EOF then

                            refNo = objAccess("ref_no").value
                            cashPaid = CDbl(objAccess("cash_paid").value)
                            
                        end if
                        
                        rs.Open "SELECT prod_qty, prod_gen, prod_price, prodamount, date FROM "&salesOrderPath&" WHERE duplicate!='yes' and invoice_no="&invoice, CN2

                        if not rs.EOF then
                    %>
                    <%d = CDate(rs("date"))%>
                    <div class="sales__info">
                        <!--<span><strong>Receipt #<span></span></strong> 12345678</span>-->
                        <span><strong>Reference No.</strong> <%=refNo%></span>
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

                        Dim change
                        change = cashPaid - totalAmount

                        if change < 0 then
                            change = 0
                        end if 

                        CN2.close%>
                    </tbody>
                    
                    <tfoot>
                        <tr>
                            <td colspan="3"><strong><span class="tfooter-total-text">Total</span></strong></td>
                            <td colspan="1"><span class="tfooter-amount-text"><strong>&#8369; <%Response.Write(totalAmount)%></strong></span> </td>
                        </tr>

                        <tr>
                            <td colspan="3"><strong><span>Cash</span></strong></td>
                            <td colspan="1"><span>&#8369; <%Response.Write(cashPaid)%></span> </td>
                        </tr>

                        <tr>
                            <td colspan="3"><strong><span>Change</span></strong></td>
                            <td colspan="1"><span>&#8369; <%Response.Write(change)%></span> </td>
                        </tr>
                    </tfoot>
                  </table>
            
            </div>
            <div class="receipt__footer">
                <p>Thank you!</p>
            </div>
        </div>
    </main>
                   <% else %>
                        <strong><p> No records </p></strong>
                   <% end if %>
                   <% end if %>
    
</body>
</html>