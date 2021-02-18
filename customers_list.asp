<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>

        <title>Customers List</title>

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
                left: 30%;
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

<div id="main">

    <div class="main-heading--container mb-4">
        <h1 class="h2 text-center pt-4 mb-3 pb-3 main-heading" style="font-weight: 400">  Customers List </h1>
    </div>
    <div id="content">
    <div class="container pt-1 mb-5">

        <% rs.Open "SELECT cust_id, cust_lname, cust_fname, department FROM customers WHERE cust_type!='out' ORDER BY cust_lname", CN2 %>

        <table class="table table-hover table-bordered table-sm" id="myTable">
            <thead class="thead-bg">
                <th>ID</th>
                <th>Last Name</th>
                <th>First Name</th>
                <th>Department</th>
            </thead>

            <%do until rs.EOF%>
                <tr>
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("cust_lname"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("cust_fname"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("department"))%></td> 
                </tr>
                <%rs.MoveNext%>
            <%loop%>
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
        dom: "<'row'<'col-sm-12 col-md-3'l><'col-sm-12 col-md-6'B><'col-sm-12 col-md-3'f>>" +
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