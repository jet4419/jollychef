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
        <link rel="stylesheet" href="tail.select-default.css">
        
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

        else

            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = Day(queryDate1) & " " &  MonthName(Month(queryDate1)) & " " & Year(queryDate1)

        end if   

        if endDate="" then

            queryDate2 = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else 

            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)

        end if   

        Dim monthsDiff

        monthsDiff = DateDiff("m",queryDate1,queryDate2) 

%>

<div id="main" class="mb-5">

    <div id="content" class="mb-5">

    <div class="container mb-5">

        <div class="mt-4 mb-2 d-flex justify-content-between">
            <form action="sales_report_detailed.asp" method="POST" id="allData" class="">
                
                <label>Start Date</label>
                <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
            
                <label class="ml-3">End Date&nbsp;</label>
                <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                
                <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Generate Report</button>
            </form>
            <p hidden></p>
        </div>

        <h1 class="h1 text-center mb-4 main-heading" style="font-weight: 400"> Detailed Sales Report </h1>

        <%
 
            Response.Write("<p><strong> Date Range: </strong>")
            Response.Write(displayDate1 & " - ")
            Response.Write(displayDate2)
            Response.Write "</p>"
                
        %>

        <table class="table table-hover table-bordered table-sm mb-5" id="myTable">
            <thead class="thead-dark">
                <th>Reference No</th>
                <th>Invoice No</th>
                <th>Customer</th>
                <th>Date</th>
                <th>Product Name</th>
                <th>Price</th>
                <th>Qty</th>
                <th>Amount</th>
                <th>Payment</th>
                
            </thead>
        <%
            Dim fs
            set fs=Server.CreateObject("Scripting.FileSystemObject")

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

                    rs.Open "SELECT ref_no, invoice_no, cust_name, date, prod_gen, prod_price, prod_qty, prodamount, payment FROM "&salesOrderPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"')", CN2
        %>

                    <%do until rs.EOF%>
                    <tr>
                        <%transactDate = FormatDateTime(CDate(rs("date")), 2)%>
                        <td class="text-darker"><%Response.Write(rs("ref_no"))%></td> 
                        <td class="text-darker">
                            <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                        </td>
                        <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                        <td class="text-darker"><%Response.Write(transactDate)%></td>
                        <td class="text-darker"><%Response.Write(rs("prod_gen"))%></td> 
                        <td class="text-darker"><%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("prod_price"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("prod_qty"))%></td> 
                        <td class="text-darker"><%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("prodamount"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("payment"))%></td> 

                    <%rs.MoveNext%>
                    <%loop%>
                <%rs.close
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
    $('#myTable').DataTable({
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
        "order": [],
        dom: "<'row'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-success' },
            { extend: 'excel', className: 'btn btn-sm btn-success' },
            { extend: 'pdf', className: 'btn btn-sm btn-success' },
            { extend: 'print', className: 'btn btn-sm btn-success' }
        ]
    });
} ); 
</script>
</body>
</html>