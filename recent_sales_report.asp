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
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>

<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->


<div id="main">    
    <h6 class="h5 ml-5">Other Reports: 
        <a href="bootTopSeller.asp" class="btn btn-sm btn-outline-dark">Top Selling Products</a> 
        <a href="bootCustomReport.asp" class="btn btn-sm btn-outline-dark">Generate Custom Reports</a>
    </h6>

    <div id="content">
        <h1 class="h2 text-center mb-4 main-heading"> <strong>Sales Report</strong> </h1>
        <div class="container">
            <%
                Dim totalAmount, totalProfit, totalCOH, totalCredit

                totalGross = 0.00
                totalNet = 0.00
                totalCOH = 0.00
                totalCredit = 0.00
            %>
            <% rs.Open "SELECT * FROM sales WHERE date=CTOD('"&systemDate&"') ORDER BY transactid", CN2 %>
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
                    do until rs.EOF

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
                            
                    <% d = CDate(rs("date"))%>
                    <td class="text-darker"><%Response.Write(rs("ref_no"))%></td> 
                    <%  if Trim(rs("payment").value) = Trim("Credit") then 
                            cash = 0.00
                            credit = rs("amount").value%>
                            <td class="text-darker">
                                <a class="text-info" href='ob_invoice_records.asp?invoice=<%=rs("invoice_no")%>'><%=rs("invoice_no")%>
                            </td> 
                        <%    
                        else  
                            credit = 0.00
                            cash = rs("amount").value%>
                            <td class="text-darker">
                                <a class="text-info" href='receipt.asp?invoice=<%=rs("invoice_no")%>'><%=rs("invoice_no")%>
                            </td>
                    <%
                        end if
                    %>
                    
                    <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                    <td class="text-darker"><%Response.Write(FormatDateTime(d,2))%></td>
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
                <tfoot>
                    <tr>
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Gross Amount</h3></strong> <h5>  <span class="text-primary">  &#8369; </span> <%=totalGross%></h5></td>
                        <!--<td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Net Amount</h3></strong> <h5><span class="text-primary">  &#8369; </span> <'%=totalNet%></h5></td>-->
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Cash</h3></strong> <h5>  <span class="text-primary">  &#8369; </span> <%=totalCOH%></h5></td>
                        <td><h3 class="lead"><strong class="text-darker font-weight-normal">Total Credit</h3></strong> <h5><span class="text-primary">  &#8369; </span> <%=totalCredit%></h5></td>
                    </tr>
                </tfoot>
            </table>
           
        </div> 
    <div>   

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

</div>

  

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