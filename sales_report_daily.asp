<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>

        <title>Daily Reports</title>

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
                display: flex;
                justify-content: space-between;
            }

            /* .daily-reports-label {
                position: relative;
            } */

            /* .btn-day-end {
                position: absolute;
                top: 10px;
                right: 50px;
            }

            .btn-edit-transaction {
                position: absolute;
                top: 10px;
                left: 88px;
            } */

            .displaydate {
                display: inline-block;
                margin-bottom: 7px;
            }

            .btn-day-end {
                opacity: 0;
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
    displayDate = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

%>

<div id="main">

<!--
<div class=" d-flex justify-content-end mr-5">
        <a class="btn btn-success btn-sm text-white" href="javascript:Clickheretoprint()"> Print </a> 
</div>
-->
    <%
        sqlIsClosed = "SELECT MAX(sched_id), status FROM store_schedule"
        set objAccess = cnroot.execute(sqlIsClosed)
    %>      
        
    <div id="content">
		<div class="container mt-4">
            <div class="main-heading--container mb-4">
        <% if not objAccess.EOF then %>
            <%if Trim(objAccess("status").value) <> Trim("closed") then%>
        
                <h1 class="h2 daily-reports-label text-center pt-2 mt-2 main-heading"> 
                    <a href="sales_current_edit.asp">
                        <button class="btn btn-sm btn-outline-dark btn-edit-transaction py-2">Edit Transaction</button>
                    </a>    
                    <span class="h1" style="font-weight: 400">Daily Sales Reports</span>
                    <button class="btn-day-end">Day End</button>
                </h1>
            <%else%>
                <h1 class="h2 daily-reports-label text-center pt-2 mt-2 main-heading"> 
                    <a href="sales_current_edit.asp">
                        <button class="btn btn-sm btn-outline-dark btn-edit-transaction py-2">Edit Transaction</button>
                    </a>    
                    <span class="h1" style="font-weight: 400">Daily Sales Reports</span>
                    <button class="btn-day-end">Day End</button>
                </h1>
            <%end if%>
        <% end if %>    
            <% set objAccess = nothing %>    
            </div>
            <%
                Dim totalAmount, totalProfit
                totalGross = 0.00
                totalNet = 0.00
                totalCOH = 0.00
                totalCredit = 0.00
            %>

			<table class="table table-hover table-bordered table-sm" id="myTable">
             <%
 
                Response.Write("<span class='displaydate'><strong> Date: </strong>")
                Response.Write(displayDate)
                Response.Write("</span>")
            %>
				<thead class="thead-dark">
					<th>Reference No</th>
                    <th>Invoice Number</th>
                    <th>Customer</th>
                    <th>Date</th>
                    <th>Total Amount</th>
                    <th>Cash Paid</th>
                    <th>Change</th>
                    <th>Payment</th>
				</thead>

            <%
                Dim fs, monthLength, yearPath, folderPath, filePath

                set fs=Server.CreateObject("Scripting.FileSystemObject")
                monthLength = Month(systemDate)

                    if Len(monthLength) = 1 then
                        monthPath = "0" & CStr(Month(systemDate))
                    else
                        monthPath = Month(systemDate)
                    end if

                yearPath = Year(systemDate)

                salesFile = "\sales.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                salesPath = folderPath & salesFile
                'Response.Write salesPath

                Do 

                    if fs.FolderExists(folderPath) <> true then EXIT DO
                    if fs.FileExists(salesPath) <> true then EXIT DO

                    rs.Open "SELECT ref_no, invoice_no, cust_name, date, amount, cash_paid, payment FROM "&salesPath&" WHERE duplicate!='yes' and date=CTOD('"&systemDate&"') ORDER BY transactid", CN2
            %>

                        <%do until rs.EOF

                            if Trim(rs("payment").value) = Trim("Cash") or Trim(rs("payment").value) = Trim("Collect") or Trim(rs("payment").value) = Trim("A-minus") then
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

                            <%if Trim(rs("payment").value) = Trim("Credit") then%>
                                <td class="text-darker">
                                    <a class="text-info" target="_blank" href='ob_invoice_records.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                </td> 
                            <%else%>
                                <td class="text-darker">
                                    <a class="text-info" target="_blank" href='receipt.asp?invoice=<%=rs("invoice_no")%>&date=<%=transactDate%>'><%=rs("invoice_no")%>
                                </td>
                            <%end if%>    

                            <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                            <td class="text-darker"><%Response.Write(transactDate)%></td> 
                            <td class="text-darker">
                                <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("amount"))%>
                            </td>
                            <td class="text-darker">
                                <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("cash_paid"))%>
                            </td>
                            <% change = CDbl(rs("cash_paid")) - CDbl(rs("amount")) 
                                if change < 0 then
                                    change = 0
                                end if 
                            %>
                            <td class="text-darker">
                                <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&change)%>
                            </td>
                            <td class="text-darker"><%Response.Write(rs("payment"))%></td>
                        </tr>

                        <%rs.MoveNext%>
                        <%loop%>
                <%  rs.close
                Loop While False  
                %>                      

                <tfoot>
                    <tr>
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Sales</h3></strong> <h5>  <span class="text-primary">  &#8369; </span> <%=totalGross%></h5></td>
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Cash</h3></strong> <h5>  <span class="text-primary">  &#8369; </span> <%=totalCOH%></h5></td>
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Credit</h3></strong> <h5><span class="text-primary">  &#8369; </span> <%=totalCredit%></h5></td>
                    </tr>
                </tfoot>

			</table>
                <!--<div id="total" class="mb-5">
                    <h1 class="lead"><strong class="text-darker font-weight-normal">Total Gross Amount</h1></strong> <h4>  <span class="text-primary">  &#8369; </span> <'%=totalGross%></h4>
                    <h1 class="lead"><strong class="text-darker font-weight-normal">Total Net Amount</h1></strong> <h4><span class="text-primary">  &#8369; </span> <'%=totalNet%></h4>
                </div> -->
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


	// $("#generateReport").on("click", function() {
	// 	//let startDate = $("#startDate").val()
	// 	//alert(startDate)
	// 	$ajax.({
	// 		url: "dateFilter.asp",
	// 		type: "POST",
	// 		data: $("#allData").serialize(),
	// 		success: function(response){
    // 		window.location.href = "dateFilter.asp";
	// 		}

	// 	})
		

}); 
</script>
</body>
</html>