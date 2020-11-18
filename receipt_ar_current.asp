<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="css/receipt_ar.css">
    <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
    <link href="fontawesome/css/brands.css" rel="stylesheet">
    <link href="fontawesome/css/solid.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!--<script src="https://kit.fontawesome.com/6f3e46d502.js" crossorigin="anonymous"></script>-->
</head>
<body>

    <main class="receipt">
        
        <p>
            <a href="sales_current_edit.asp">
                <i class="fas fa-times exit-icon"></i>
            </a>
        </p>
        
        <div class="receipt--container">
            <div class="receipt__header">
                <h1 class="receipt__header--text">AR Payment Receipt</h1>
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

                        Dim yearPath, monthPath, transactDate

                        transactDate = FormatDateTime(systemDate, 2)

                        yearPath = CStr(Year(transactDate))
                        monthPath = CStr(Month(transactDate))

                        if Len(monthPath) = 1 then
                            monthPath = "0" & monthPath
                        end if

                        Dim collectionsFile, arFile, obFile, adjustmentFile

                        collectionsFile = "\collections.dbf"
                        arFile = "\accounts_receivables.dbf"
                        obFile = "\ob_test.dbf"
                        adjustmentFile = "\adjustments.dbf"


                        Dim collectionsPath, transactionsPath, obPath, adjustmentPath

                        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
                        arPath = mainPath & yearPath & "-" & monthPath & arFile
                        obPath = mainPath & yearPath & "-" & monthPath & obFile
                        adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile

                        Dim refNo, totalPaid
                        refNo = Request.QueryString("ref_no")
                        totalPaid = 0.00

                        'Response.Write obPath
    
                        getTotalPaid = "SELECT cash_paid FROM "&obPath&" WHERE ref_no = '"&refNo&"'"
                        set objAccess = cnroot.execute(getTotalPaid)

                        if not objAccess.EOF then
                            totalPaid = CDbl(objAccess("cash_paid"))
                        end if

                        set objAccess = nothing
                        
                        totalAmount = 0.00

                        rs.open "SELECT ref_no, invoice, cash, balance, date "&_
                                "FROM "&collectionsPath&" "&_
                                "WHERE duplicate!='yes' and ref_no = '"&refNo&"' ", CN2
                        
 
                        if not rs.EOF and refNo <> "" then        
                    %>
                    <%d = CDate(rs("date"))%>
                    <div class="sales__info">

                        <span><strong>Reference No.</strong> <%=rs("ref_no")%></span>
                        <span><strong>Date:</strong> <%=FormatDateTime(d,2)%></span>

                    </div>
                </div>
            </div>
            
            <div class="receipt__body">
                <table>
                    <thead class="thead-dark">
                        <th>Invoice No.</th>
                        <th>Payment</th>
                        <th>Balance</th>
                    </thead>
                    
                    <tbody>
                        <%do until rs.EOF%>
                        <tr>
                            <td><%Response.Write(rs("invoice"))%></td>
                            <td>&#8369; <%Response.Write(rs("cash"))%></td>
                            <td>&#8369; <%Response.Write(rs("balance"))%></td>
                        <%
                            totalAmount = totalAmount + CDbl(rs("cash"))
                        rs.moveNext
                        %>    
                        </tr>
                        <%loop%>
                        <%rs.close%>
                        <%CN2.close%>
                    </tbody>
                    
                    <tfoot>
                       
                    
     
                        <tr>
                            <td colspan="1">
                                <strong>
                                    <span class="tfooter-total-text">Total</span>
                                </strong>
                            </td>

                            <td colspan="1">
                                <span class="tfooter-total-text">
                                    <strong>&#8369; <%Response.Write(totalAmount)%></strong>
                                </span> 
                            </td>
                        </tr>
                        <tr>
                            <td colspan="1">
                                <strong>
                                    <span>Cash</span>
                                </strong>
                            </td>

                            <td colspan="1">
                                <span>
                                    &#8369; <%Response.Write(totalPaid)%>
                                </span> 
                            </td>
                        </tr>
                            <% 
                                change = CDbl(totalPaid) - CDbl(totalAmount) 
                                
                                if change < 0 then
                                    change = 0
                                end if 
                            %>
                        <tr>
                            <td colspan="1">
                                <strong>
                                    <span>Change</span>
                                </strong>
                            </td>

                            <td colspan="1">
                                <span>
                                    &#8369; <%Response.Write(change)%>
                                </span> 
                            </td>
                        </tr>
                    </tfoot>
                  </table>
                    <% end if %>
            </div>
            <div class="receipt__footer">
                <p>Thank you!</p>
            </div>
        </div>
    </main>
    
</body>
</html>