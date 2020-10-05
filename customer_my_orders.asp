<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Orders</title>
        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/twitter-bootstrap.css"/>
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/dataTables.bootstrap4.min.css"/>

        <style>

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

        </style>

    </head>

<body>

<%
    if Session("cust_id") = "" then
        Response.Redirect("cust_login.asp")
    else
%>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

<main id="main">

    <h1 class="h2 text-center pt-3 mb-4 main-heading"> <strong>My Pending Orders</strong> </h1>
    <div id="content">
        <div class="container mb-5">
            <%
                Dim mainPath, systemDate, yearPath, monthPath

                mainPath = CStr(Application("main_path"))
                systemDate = CDate(Application("date"))
                yearPath = CStr(Year(systemDate))
                monthPath = CStr(Month(systemDate))
                

                if Len(monthPath) = 1 then
                    monthPath = "0" & monthPath
                end if

                Dim ordersHolderFile
                ordersHolderFile = "\orders_holder.dbf"

                Dim ordersHolderPath
                ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile
            %>
            <% rs.Open "SELECT DISTINCT unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" and cust_id="&Session("cust_id")&" GROUP BY unique_num", CN2 %>
            <table class="table table-striped table-bordered table-sm" id="myTable">
            <caption>List of orders</caption>
                <thead class="thead-dark">
                    <th>Order#</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Amount</th>
                    <th>Date</th>
                    <th>Action</th>
                    <!--<th>Date</th>-->
                </thead>
                <% Dim i %>
                <%do until rs.EOF%>
                <tr>
                    <%i = i + 1%>
                    <td class="text-bold"><%Response.Write(i)%></td> 
                    <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("department"))%></td>   
                    <td class="text-darker"><%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("amount"))%></td> 
                    <td class="text-darker"><%Response.Write(FormatDateTime(rs("date"), 2))%></td>   
                    <td>
                    <a href='customer_my_orders_list.asp?unique_num=<%=rs("unique_num")%>&cust_id=<%=rs("cust_id")%>' id="<%=rs("cust_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct w-100">
                        View Orders
                    </a>
                    </td>
                <%rs.MoveNext%>
                </tr>
                <%loop%>
                <%rs.close%>
            </table>
        </div>    
    </div>
    
        
	
</main>

<!-- Login -->
<div id="login" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="cust_login_auth.asp" method="POST">
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
                <form action="cust_logout.asp">
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

<!--<script src="js/script.js"></script> -->
<script src="js/main.js"></script>   
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>
<script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
<script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>

<script>

$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
        dom: "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
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

<%end if%>

</body>
</html>
