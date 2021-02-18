<!--#include file="dbConnect.asp"-->
<!--#include file="checker_programmer.html"-->
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

<main id="main">

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
                <th>Action</th>
            </thead>

            <%do until rs.EOF%>
                <tr>
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("cust_lname"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("cust_fname"))%></td> 
                    <td class="text-darker"><%Response.Write(rs("department"))%></td> 
                    <td>
                        <button type="button" id="<%=rs("cust_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 deleteCustomer" style="max-width: 50px;" data-toggle="modal" data-target="#deleteCustomerModal" disabled>
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <button type="button" id="<%=rs("cust_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 updateCustomer" style="max-width: 50px;" data-toggle="modal" data-target="#editCustomer">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
                <%rs.MoveNext%>
            <%loop%>
        </table>
    </div>    
    </div>
</main>

    <!-- Update Modal -->
        <div class="modal fade" id="editCustomer" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="customer_update2.asp" class="form-group mb-3" id="updateForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"> Edit Customer</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pb-0" id="customer_details">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-sm btn-secondary bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" id="saveEditProduct" class="btn btn-sm btn-primary">Save changes</button>
                            </div>
                        </form>  
                </div>
            </div>
        </div> 
    <!-- END OF Update User MODAL --> 

    <!-- Delete Modal -->
        <div class="modal fade bs-example-modal-sm" id="deleteCustomerModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <form class="form-group mb-3" id="deleteForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"> Delete Customer <i class="icon-shopping-cart"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="deleteCustomerModalBody">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-sm btn-secondary bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" id="btnDeleteCustomer" class="btn btn-sm btn-danger">Delete</button>
                            </div>
                        </form>  
                </div>
            </div>
        </div> 
      <!-- END OF Delete User MODAL -->   



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
    }); 

    // Edit Product
    $(document).on("click", ".updateCustomer", function(event) {

        event.preventDefault();

        let customerID = $(this).attr("id");
        //console.log(arID)
        $.ajax({

            url: "customer_update.asp",
            type: "POST",
            data: {customerID: customerID},
            success: function(data) {
                $("#customer_details").html(data);
                $("#editCustomer").modal("show");

           }
        })

    }); 

    // Delete Modal
    $(document).on("click", ".deleteCustomer", function(event) {

        event.preventDefault();

        let customerID = $(this).attr("id");
        //console.log(arID)
        $.ajax({

            url: "customer_delete.asp",
            type: "POST",
            data: {customerID: customerID},
            success: function(data) {
                $("#deleteCustomerModalBody").html(data);
                $("#deleteCustomerModal").modal("show");

           }
        })

    }); 

     //Delete Product
    $(document).on('click', '#btnDeleteCustomer', function(event){

        event.preventDefault();

        let result = confirm("Are you sure to delete?");

        if(result) {
            $.ajax({
                url: "customer_delete2.asp",
                type: "POST",
                data: $("#deleteForm").serialize(),
                success: function(data) {
                    alert("Customer Deleted Successfully!");
                    $("#deleteCustomerModal").modal("hide");
                    location.reload();
                }
            })
        }
    })

</script>

</body>
</html>