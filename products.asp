<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Products</title>
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
        
        <style>
            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

            .main-heading--container {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .main-title {
                font-weight: 500;
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



    <!--<div class=" d-flex justify-content-end mr-5">
        <a class="btn btn-success btn-sm text-white" href="javascript:Clickheretoprint()"> Print </a>
    </div> -->
    <div id="main">

    <div id="content">
    <div class="container mb-5">

        <h1 class="main-heading--container h1 text-center mt-2 mb-4 pt-3"> 
            <button type="button" id="btnAddProduct" class="btn btn-outline-dark float-left" data-toggle="modal" data-target="#addProduct"> 
                <i class="fas fa-plus-circle pr-1"></i> <span> Add Product </span> 
            </button> 
            <span class="pr-5 main-heading main-title">Products</span> 
            <a href="daily_menu_list.asp" id="btnAddDailyMeal" class="btn btn-outline-dark float-right">
                Menu List
            </a>
        </h1>

        <% rs.Open "SELECT prod_id, prod_brand, prod_name, orig_price, price, category, qty FROM products", CN2 %>

        <table class="table table-hover table-bordered table-sm" id="myTable">
            <thead class="thead-dark">
                <th>Brand Name</th>
                <th>Product Name</th>
                <th>Original Price</th>
                <th>Sale Price</th>
                <th>Category</th>
                <th>Quantity</th>
                <th>Action</th>
            </thead>

            <%do until rs.EOF%>

                <tr>
                    <td class="text-darker">
                        <%Response.Write(rs("prod_brand"))%>
                    </td> 

                    <td class="text-darker">
                        <%Response.Write(rs("prod_name"))%>
                    </td> 

                    <td class="text-darker">
                        <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("orig_price"))%>
                    </td> 

                    <td class="text-darker">
                        <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("price"))%>
                    </td> 

                    <td class="text-darker">
                        <%Response.Write(rs("category"))%>
                    </td> 

                    <td class="text-darker">
                        <%Response.Write(rs("qty"))%>
                    </td>  

                    <td>
                        <button type="button" id="<%=rs("prod_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct" style="max-width: 50px;" data-toggle="modal" data-target="#deleteProductModal" disabled >
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <button type="button" id="<%=rs("prod_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 updateProduct" style="max-width: 50px;" data-toggle="modal" data-target="#editProduct">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>

            <%rs.MoveNext%>
            <%loop%>
            
        </table>
    </div>    
    </div>

    <%
        rs.close
        CN2.close
    %>

    <!-- Add Product Modal -->
            <div class="modal fade" id="addProduct" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Add Product <i class="fas fa-shopping-cart"></i></h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body pb-0">
                            <!-- Modal Body (Contents) -->
                            <form action="product_add.asp" class="form-group mb-3" method="POST">

                                <div class="form-group mb-1">    
                                    <label class="ml-1" style="font-weight: 500"> Brand Name </label>
                                    <input type="text" class="form-control form-control-sm" name="brandName" id="brandName" pattern="[a-zA-Z0-9 ' -]+">
                                </div>

                                <div class="form-group mb-1">    
                                    <label class="ml-1" style="font-weight: 500"> Product Name </label>
                                    <input type="text" class="form-control form-control-sm" name="productName" id="productName" required pattern="[a-zA-Z0-9 ' -]+">
                                </div>

                                <div class="form-group mb-1"> 
                                    <label class="ml-1" style="font-weight: 500"> Selling Price </label>
                                    <input type="number" class="form-control form-control-sm" name="price" required id="price">
                                </div>

                                <div class="form-group mb-1"> 
                                    <label class="ml-1" style="font-weight: 500"> Original Price </label>
                                    <input type="number" class="form-control form-control-sm" name="origPrice" required id="origPrice">
                                </div>

                                <div class="form-group mb-1"> 
                                    <label class="ml-1" style="font-weight: 500"> Quantity </label>
                                    <input type="number" class="form-control form-control-sm" name="qty" required id="qty">
                                </div>

                                <div class="form-group mb-1"> 
                                    <label class="form-label" style="font-weight: 500" for="particulars">Particulars</label>
                                    <select class="form-control form-control-sm" name="particulars" id="particulars" required>
                                        <option value="" disabled selected>Select a category</option>
                                        <option value="breakfast">Breakfast</option>
                                        <option value="lunch">Meat</option>
                                        <option value="vegetable">Vegetable</option>
                                        <option value="fish">Fish</option>
                                        <option value="chicken">Chicken</option>
                                        <option value="rice">Rice</option>
                                        <option value="dessert">Dessert</option>
                                        <option value="snacks">Snacks</option>
                                        <option value="drinks">Drinks</option>
                                        <option value="candies">Candies</option>
                                        <option value="groceries">Groceries</option>
                                        <option value="fresh-meat">Fresh Meat</option>
                                        <option value="others">Others</option>
                                    </select>
                                </div>
                                
                                <div class="form-group mt-3">
                                    <label class="form-label" style="font-weight: 500" for="particulars">Track this on inventory report? </label>
                                    <div class="form-check form-check-inline ml-2">
                                        <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu1" value="yes" required>
                                        <label class="form-check-label" for="isFixMenu1">Yes</label>
                                    </div>

                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu2" value="no">
                                        <label class="form-check-label" for="isFixMenu2">No</label>
                                    </div>

                                    <input type="text" name="userType" id="userType" value="" hidden>

                                </div> 
                                    
                                   
                        
                        </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-sm btn-dark" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-sm btn-primary" id="save">Save changes</button>
                                </div>
                            </form>  
                    </div>
                </div>
            </div>
            <!-- END OF Add User Modal -->

    <!-- Update Modal -->
        <div class="modal fade" id="editProduct" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="product_update2.asp" class="form-group mb-3" id="updateForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"> Edit Product <i class="icon-shopping-cart"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body pb-0" id="collect_details">
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
        <div class="modal fade bs-example-modal-sm" id="deleteProductModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <form class="form-group mb-3" id="deleteForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel"> Delete Product <i class="icon-shopping-cart"></i></h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="deleteModalBody">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-sm btn-secondary bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" id="btnDeleteProduct" class="btn btn-sm btn-danger">Delete</button>
                            </div>
                        </form>  
                </div>
            </div>
        </div> 
      <!-- END OF Update User MODAL -->    
        </div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

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

const userType = localStorage.getItem('type');
document.querySelector('#userType').value = userType;

 $(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "45vh",
        scroller: true,
        scrollCollapse: true
    });


    // Add Product  
    // $(document).on('click', '#save', function() {
    //     let brandName = $("#brandName").val()
    //     brandName = brandName.charAt(0).toUpperCase() + brandName.slice(1);
    //     let productName = $("#productName").val();
    //     productName = productName.charAt(0).toUpperCase() + productName.slice(1);
    //     let price = $("#price").val();
    //     let origPrice = $("#origPrice").val();
    //     let qty = $("#qty").val();
    //     let category = $("#particulars").val();

    //     $.ajax({
    //         url: "product_add.asp",
    //         type: "post",
    //         data: {brandName: brandName, productName: productName, price: price, origPrice: origPrice, qty: qty, category: category},
    //         success: function(data) {
    //             alert("New Product Added successfully!");
    //             $("#addProduct").modal("hide");
    //             location.reload();
    //             //window.location.href= "editAR.asp?#";
    //         }
    //     });
    // });

    // Edit Product
    $(document).on("click", ".updateProduct", function(event) {

        event.preventDefault();

        let productID = $(this).attr("id");
        //console.log(arID)
        $.ajax({

            url: "product_update.asp",
            type: "POST",
            data: {productID: productID},
            success: function(data) {
                $("#collect_details").html(data);
                $("#editProduct").modal("show");

           }
        })

    }); 

     //UPDATE Product
    // $(document).on('click', '#saveEditProduct', function(){
    //     $.ajax({
    //         url: "bootProductsUpdate2.asp",
    //         type: "POST",
    //         data: $("#updateForm").serialize(),
    //         success: function(data) {
    //             //console.log(data)
    //             alert("Product Updated Successfully!");
    //             $("#editProduct").modal("hide");
    //             location.reload();
    //         }
    //     })
    // })

    // Delete Modal
    $(document).on("click", ".deleteProduct", function(event) {

        event.preventDefault();

        let productID = $(this).attr("id");
        //console.log(arID)
        $.ajax({

            url: "product_del.asp",
            type: "POST",
            data: {productID: productID},
            success: function(data) {
                $("#deleteModalBody").html(data);
                $("#deleteProductModal").modal("show");

           }
        })

    }); 

     //Delete Product
    $(document).on('click', '#btnDeleteProduct', function(event){

        event.preventDefault();

        let result = confirm("Want to delete?");

        if(result) {
            $.ajax({
                url: "product_del2.asp",
                type: "POST",
                data: $("#deleteForm").serialize(),
                success: function(data) {
                    alert("Product Deleted Successfully!");
                    $("#deleteProductModal").modal("hide");
                    location.reload();
                }
            })
        }
    })

    // function dailyMeal() {

        
    // }



});

</script>
</body>
</html>