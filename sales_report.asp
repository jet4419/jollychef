<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Sales Report</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
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

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
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
    Dim startDate, endDate

    startDate = Request.Form("startDate")
    endDate = Request.Form("endDate")

    if startDate="" then
        
        queryDate1 = CDate(FormatDateTime(systemDate, 2))
        displayDate1 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)
        
        'yearPath = Year(queryDate1)
       
    else
        queryDate1 = CDate(FormatDateTime(startDate, 2))
        displayDate1 = Day(queryDate1) & " " &  MonthName(Month(queryDate1)) & " " & Year(queryDate1)
        'month1 = Month(queryDate1)
        'yearPath = Year(queryDate1)
    end if    


    if endDate="" then

        queryDate2 = CDate(FormatDateTime(systemDate, 2))
        displayDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)
        
        'yearPath = Year(queryDate2)

    else  
        queryDate2 = CDate(FormatDateTime(endDate, 2))
        displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)
        'month2 = Month(queryDate2)
        'yearPath = Year(queryDate2)
    end if  

    
    Dim monthsDiff

    monthsDiff = DateDiff("m",queryDate1,queryDate2) 

%>
<div id="main">
    
    <div id="content">
		<div class="container mt-4 mb-5">
            <div class="mt-3 mb-2 d-flex justify-content-between">
                <form action="sales_report.asp" method="POST" id="allData" class="">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date"> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1 " id="generateReport">Generate</button>
                </form>
                <p><a href="sales_report_detailed.asp" class="btn btn-sm btn-outline-dark">Detailed Sales Report</a></p>
            </div>

            <h1 class="h2 text-center mb-4 main-heading" style="font-weight: 400"> Sales Report </h1>

            <%
 
                Response.Write("<p><strong> Date Range: </strong>")
                Response.Write(displayDate1 & " - ")
                Response.Write(displayDate2)
                Response.Write("</p>")
                
            %>

			<table class="table table-hover table-bordered table-sm" id="myTable">
				<thead class="thead-dark">
					<th>Reference No</th>
                    <th>Invoice Number</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Cash</th>
                    <th>Charge</th>
                    <th>Payment</th>
				</thead>

            <%
                Dim totalAmount, totalCOH, totalCredit
                
                totalGross = 0.00
                totalCOH = 0.00
                totalCredit = 0.00

                'Dim totalProfit
                'totalNet = 0.00

                Dim fs
                Set fs = Server.CreateObject("Scripting.FileSystemObject")

                Dim monthPath, yearPath

                Dim salesFile, folderPath, salesPath
                salesFile = "\sales.dbf"

                for i = 0 To monthsDiff   
   
                    monthLength = Month(DateAdd("m",i,queryDate1))
                    if Len(monthLength) = 1 then
                        monthPath = "0" & CStr(Month(DateAdd("m",i,queryDate1)))
                    else
                        monthPath = Month(DateAdd("m",i,queryDate1))
                    end if

                    yearPath = Year(DateAdd("m",i,queryDate1))
           
                    folderPath = mainPath & yearPath & "-" & monthPath
                    salesPath =  folderPath & salesFile
                    'Response.Write filePath & "<br>"

                    Do 

                        if fs.FolderExists(folderPath) <> true then EXIT DO
                        if fs.FileExists(salesPath) <> true then EXIT DO

                        rs.Open "SELECT * FROM "&salesPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY transactid", CN2

            %>    
                        <%do until rs.EOF
                            if Trim(rs("payment").value) = Trim("Cash") then
                                totalCOH = totalCOH + CDbl(rs("amount"))
                            end if

                            if Trim(rs("payment").value) = Trim("Credit") then
                                totalCredit = totalCredit + CDbl(rs("amount"))
                            end if

                            if Trim(rs("payment").value) = Trim("Credit") or Trim(rs("payment").value) = Trim("Cash") then 
                                totalGross = totalGross + CDbl(rs("amount"))
                            end if

                            'totalNet = totalNet + CDbl(rs("profit"))
                        %>
                            <tr> 
                                
                                <% transactDate = FormatDateTime(CDate(rs("date")), 2)%>
                                <td class="text-darker"><%Response.Write(rs("ref_no"))%></td> 
                                <%  if Trim(rs("payment").value) = Trim("Credit") then 
                                        cash = 0.00
                                        credit = rs("amount").value%>
                                        <td class="text-darker">
                                            <a class="text-info" target="_blank" href='ob_invoice_records.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                        </td> 
                                    <%    
                                    else  
                                        credit = 0.00
                                        cash = rs("amount").value%>
                                        <td class="text-darker">
                                            <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                        </td>
                                <%
                                    end if
                                %>
                                
                                <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                                <td class="text-darker"><%Response.Write(transactDate)%></td>
                                <td class="text-darker"><strong class='text-primary' >&#8369; </strong><%Response.Write(rs("amount"))%></td>

                                
                                <td class="text-darker">
                                    <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&cash)%>
                                </td> 

                                <td class="text-darker">
                                    <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&credit)%>
                                </td>  
                                <td class="text-darker"><%Response.Write(rs("payment"))%></td> 
                            </tr>
                            <%rs.MoveNext%>
                        <%loop%>
                <%  rs.close
                    Loop While False  
                    
                next%>                     

			</table>

		</div>    
    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!--#include file="cashier_login_logout.asp"--> 


<script src="js/main.js"></script>

<script>  
 $(document).ready( function () {
    // $('#myTable').DataTable({
    //     scrollY: 430,
    //     scroller: true
    // });

    $('#myTable').DataTable({
        scrollY: "28vh",
        scroller: true,
        scrollCollapse: true,
        dom: "<'row'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
        "order": [],
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-success' },
            { extend: 'excel', className: 'btn btn-sm btn-success' },
            { extend: 'pdf', className: 'btn btn-sm btn-success' },
            { extend: 'print', className: 'btn btn-sm btn-success' }
        ]
    });

}); 
</script>
</body>
</html>