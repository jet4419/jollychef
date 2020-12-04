<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        
        <title>Top Seller Products</title>
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
        <link rel="stylesheet" type="text/css" href="Datatables/buttons/css/buttons.dataTables.min.css"/>

        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>

        <script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
        <script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>
        <script src="bootstraptable/jszip/jszip.min.js"></script>
        <script src="bootstraptable/pdfmake/pdfmake.min.js"></script>
        <script src="bootstraptable/pdfmake/vfs_fonts.js"></script>
        <script src="Datatables/buttons/js/dataTables.buttons.min.js"></script>
        <script src="Datatables/buttons/js/buttons.bootstrap4.min.js"></script>
        <script src="Datatables/buttons/js/buttons.foundation.min.js"></script>
        <script src="Datatables/buttons/js/buttons.flash.min.js"></script>
        <script src="Datatables/buttons/js/buttons.html5.min.js"></script>
        <script src="Datatables/buttons/js/buttons.print.min.js"></script>
        <!-- Hey -->
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
        if Session("type") = "" then
            Response.Redirect("canteen_login.asp")
        end if
    %>

<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<%

    startDate = Request.Form("startDate")
    endDate = Request.Form("endDate")


    rs.open "SELECT MIN(date) AS date FROM sales_order", CN2
    if startDate="" then
        
        queryDate1 = CDate(FormatDateTime(rs("date"), 2))
        displayDate1 = Day(rs("date")) & " " & MonthName(Month(rs("date"))) & " " & Year(rs("date"))
   
       
    else
        
        queryDate1 = CDate(FormatDateTime(startDate, 2))
        displayDate1 = Day(queryDate1) & " " &  MonthName(Month(queryDate1)) & " " & Year(queryDate1)

    end if    

    rs.close

    rs.open "SELECT MAX(date) AS date FROM sales_order", CN2

    if endDate="" then

        queryDate2 = CDate(FormatDateTime(rs("date"), 2))
        displayDate2 = Day(rs("date")) & " " & MonthName(Month(rs("date"))) & " " & Year(rs("date"))

    else 
        queryDate2 = CDate(FormatDateTime(endDate, 2))
        'Response.Write(queryDate2)
        displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)
    end if   

    rs.close 

%>

<div id="main">

    <div id="content mb-5">
        
        <div class="container mb-5">

            <div class="mt-3 mb-4 d-flex justify-content-between">

                <form action="bootTopSeller.asp" method="POST" id="allData" class="">
                    
                    <label>Start Date</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End Date&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Date Range</button>
                </form>
                <p></p>

            </div>

            <h1 class="h2 text-center mb-4 main-heading"> <strong>Top Selling Products</strong> </h1>

            <%
                Dim totalQtySold
                totalQtySold = 0
             %>

            <%  rs.Open "SELECT product_id, prod_brand, prod_gen, SUM(prod_qty) FROM sales_order WHERE date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') GROUP BY product_id", CN2  
            %>

            <%
 
                Response.Write("<p><strong> Date Range: </strong>")
                Response.Write(displayDate1 & " - ")
                Response.Write(displayDate2)
                
            %>
  
            <table class="table table-striped table-bordered table-sm" id="myTable">

                <thead class="thead-dark">
                    <th>Product ID</th>
                    <th>Brand Name</th>
                    <th>Product Name</th>
                    <th>Qty Sold</th>
                </thead>

                <%
                    
                    Dim prodID
                    qtySold = 0
                    
                %>
                
                <%do until rs.EOF%>

                    <tr>
                    <%for each x in rs.Fields%> 
                        <td class="text-darker"><%Response.Write(x.value)%></td>   
                    <%next%>
                    <%rs.MoveNext%>

                <%loop%>

            </table>
        </div> 
    <div>   
</div>

<%

    rs.close
    CN2.close

%>

<!--#include file="cashier_login_logout.asp"-->     


<script src="js/main.js"></script>
<script>  
$(document).ready( function () {
    $('#myTable').DataTable({
        "order": [[ 3, "desc" ]],
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
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
});
</script>
</body>
</html>