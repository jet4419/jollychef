<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>

        <title>Inventory Reports</title>
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

            table {
                -webkit-user-select: none;
                -khtml-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                -o-user-select: none;
                user-select: none;
            }
        </style>
    </head>

    <%
        systemDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)
    %>

<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->


<div id="main">    
    

        
        <div class="container pt-4">

            <!--
            <h6 class="h5">Other Report: 
                <a href="bootTopSeller.asp" class="btn btn-sm btn-outline-dark">Top Selling Products</a> 
            </h6>
            -->
            <h1 class="h2 text-center my-4 main-heading mb-5" style="font-weight: 400">Inventory Reports</h1>
            
            <% rs.Open "SELECT prod_id, prod_brand, prod_name, orig_price, price, qty  FROM products WHERE fix_menu='yes'", CN2 %>

            <%
 
                Response.Write("<p><strong> Date: </strong>")
                Response.Write(systemDate2)
                Response.Write("</p>")
                
            %>
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-bg">
                    <th>ID</th>
                    <th>Brand</th>
                    <th>Name</th>
                    <th>Cost</th>
                    <th>Selling Price</th>
                    <th>Qty Left</th>
                </thead>

                <%do until rs.EOF%>

                <tr> 
                    <td class="text-darker"><%Response.Write(rs("prod_id"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("prod_brand"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("prod_name"))%></td> 
                    <td class="text-darker"><strong class='currency-sign' >&#8369; </strong><%Response.Write(rs("orig_price"))%></td>
                    <td class="text-darker"><strong class='currency-sign' >&#8369; </strong><%Response.Write(rs("price"))%></td>
                    <td class="text-darker"><%Response.Write(rs("qty"))%></td> 
                </tr>
                <%rs.MoveNext%>
                <%loop%>
                
            </table>
           
        </div> 
 
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <%
        rs.close
        CN2.close
    %>

    <!--#include file="cashier_login_logout.asp"-->


<script src="js/main.js"></script> 

<script>  
 $(document).ready( function () {

    $('#myTable').DataTable({
    scrollY: '38vh',
        scroller: true,
        scrollCollapse: true,
        // dom: 'Blfrtip',
        "order": [],
        dom: "<'row'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-light' },
            { extend: 'excel', className: 'btn btn-sm btn-light' },
            { extend: 'pdf', className: 'btn btn-sm btn-light' },
            { extend: 'print', className: 'btn btn-sm btn-light' }
        ]
    });
} ); 
</script>
</body>
</html>