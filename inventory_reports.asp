<!--#include file="dbConnect.asp"-->

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
        if Session("type") = "" then
            Response.Redirect("canteen_login.asp")
        end if

        Dim systemDate
        systemDate = CDate(Application("date"))
        systemDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)
    %>

<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->


<div id="main">    
    

        
        <div class="container">

            <!--
            <h6 class="h5">Other Report: 
                <a href="bootTopSeller.asp" class="btn btn-sm btn-outline-dark">Top Selling Products</a> 
            </h6>
            -->
            <h1 class="h2 text-center my-3 main-heading"> <strong>Inventory Reports</strong> </h1>
            
            <% rs.Open "SELECT prod_id, prod_brand, prod_name, orig_price, price, qty  FROM products WHERE fix_menu='yes'", CN2 %>

            <%
 
                Response.Write("<p><strong> Date: </strong>")
                Response.Write(systemDate2)
                
            %>
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
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
                    <td class="text-darker"><strong class='text-primary' >&#8369; </strong><%Response.Write(rs("orig_price"))%></td>
                    <td class="text-darker"><strong class='text-primary' >&#8369; </strong><%Response.Write(rs("price"))%></td>
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

    <!-- Login -->
    <div id="login" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <form action="login_authentication.asp" method="POST">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Customer Login</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" name="email" id="email" placeholder="Email">
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" name="password" id="password" placeholder="Password">
                        </div>
                    </div>
                    <div class="modal-footer d-flex justify-content-center">
                        <button type="submit" class="btn btn-sm btn-success" name="btn-login" value="login" >Login</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- End of Login -->

    <!-- Logout -->
    <div id="logout" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <form action="canteen_logout.asp">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Logout</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure to logout?</p>
                    </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Yes</button>
                    <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                </div>
                </div>
            </form>
        </div>
    </div>  
    <!-- End of Logout -->   

  

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