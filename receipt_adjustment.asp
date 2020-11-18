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
            <a href="adjustments_main.asp">
                <i class="fas fa-times exit-icon"></i>
            </a>
        </p>
        <div class="receipt--container">
            <div class="receipt__header">
                <h1 class="receipt__header--text">Adjustment</h1>
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

                Dim isValidDate
                isValidDate = IsDate(Request.QueryString("date"))

                if isValidDate = true then

                transactDate = CDate(Request.QueryString("date"))

                yearPath = CStr(Year(transactDate))
                monthPath = CStr(Month(transactDate))

                if Len(monthPath) = 1 then
                    monthPath = "0" & monthPath
                end if

                Dim folderPath 
                folderPath = mainPath & yearPath & "-" & monthPath

                Dim adjustmentFile
                adjustmentFile = "\adjustments.dbf"


                Dim adjustmentPath
                adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile

                Dim fs
                Set fs = Server.CreateObject("Scripting.FileSystemObject")

                if fs.FolderExists(folderPath) <> false or fs.FileExists(adjustmentPath) <> false then 

                Dim refNo, totalPaid
                refNo = Request.QueryString("ref_no")
                totalPaid = 0.00

                totalAmount = 0.00

                rs.open "SELECT a_type, ref_no, invoice, amount, balance, date "&_
                        "FROM "&adjustmentPath&" "&_
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
                            <th>Adjustment</th>
                            <th>Balance</th>
                        </thead>
                        
                        <tbody>
                            <%do until rs.EOF%>
                            <tr>
                                <td><%Response.Write(rs("invoice"))%></td>
                                <%if Trim(CStr(rs("a_type").value)) = "A-minus" then%>
                                    <td>&#8369; <%Response.Write(CDbl(rs("amount").value) * -1 )%></td>
                                <%else%>
                                    <td>&#8369; <%Response.Write(rs("amount"))%></td>
                                <%end if%>
                                <td>&#8369; <%Response.Write(rs("balance"))%></td>
                            <%
                                'totalAmount = totalAmount + CDbl(rs("cash"))
                            rs.moveNext
                            %>    
                            </tr>
                            <%loop%>
                            <%rs.close%>
                            <%CN2.close%>
                        </tbody>
                        </table>
                        <% end if %>
                </div>
                <div class="receipt__footer">
                    <p>Thank you!</p>
                </div>
            </div>
            <%
                else
                    Response.Write("<div><p>No Record.</p></div>")
                end if    
                end if
            %>
    </main>
            
    
</body>
</html>