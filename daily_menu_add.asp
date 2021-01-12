<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    ' if Session("type") = "" then
    '     Response.Redirect("canteen_login.asp")
    ' end if
%>    

<!DOCTYPE html>
<html>
    <head>
        
        <title>Add Daily Meals</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/homepage_style.css">
        <!--<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">-->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/twitter-bootstrap.css"/>
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/dataTables.bootstrap4.min.css"/>
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">

        <link type="text/css" href="datatablescheckbox/css/dataTables.checkboxes.css" rel="stylesheet" />
        <script src="./jquery/jquery_uncompressed.js"></script>
        <script src="./bootstrap/js/bootstrap.min.js"></script>
           
        <script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
        <script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>
        
        
        <script type="text/javascript" src="datatablescheckbox/js/dataTables.checkboxes.min.js"></script>

        <style>
            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }    

            .title-flex {
                display: flex;
                justify-content: space-between;
            }
        </style>

    </head>
<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->


    <!--<div class=" d-flex justify-content-end mr-5">
        <a class="btn btn-success btn-sm text-white" href="javascript:Clickheretoprint()"> Print </a>
    </div> -->
<div id="main">

    <form id="myForm"  method="POST">

        <div class="container pt-3">
        
            <h1 class="text-center mb-4 mt-4 title-flex"> 
                
                <p>
                    <a href="daily_menu_list.asp" class="btn btn-outline-dark"> Menu List </a>
                </p>
                <span class="h1 main-heading" style="font-weight: 400">Choose Products</span> 
                <p><button class="btn btn-outline-dark"> <span class="pr-1">Submit</span> <i class="fas fa-share-square"></i></button></p>
                
                <!--<a href="bootDailyMeal.asp" id="btnAddDailyMeal" class="btn btn-success float-right">
                    <i class="text-white icon-plus-sign"></i> Add Daily Meal
                </a> -->
            </h1>
        
        </div>    
    
    <div id="content">
    <div class="container mb-5">

    
        <!--<p><strong>Selected rows data</strong></p>
        <pre id="view-rows"></pre>
        <pre id="view-form"></pre>
        <p><strong>Form data as submitted to the server</strong></p> -->
        <% rs.open "SELECT prod_id, prod_name, orig_price, price, category, qty FROM products WHERE products.prod_id "&_
                   "NOT IN (SELECT prod_id FROM daily_meals) ORDER BY prod_id", CN2
        %>

        <table class="table table-striped table-bordered table-sm" id="myTable">
            <thead class="thead-dark">
                <th>Product ID</th>
                <th>Product Name</th>
                <th>Original Price</th>
                <th>Sale Price</th>
                <th>Category</th>
                <th>Quantity</th>
            </thead>

                <%do until rs.EOF%>

                    <tr>   
                        <td class="text-darker"><%Response.Write(rs("prod_id"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("prod_name"))%></td> 
                        <td class="text-darker"><%Response.Write("<strong class='currency-sign' >&#8369; </strong>"& rs("orig_price"))%></td> 
                        <td class="text-darker"><%Response.Write("<strong class='currency-sign' >&#8369; </strong>"& rs("price"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("category"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("qty"))%></td> 
                    </tr>  

                <%rs.movenext%> 
                <%loop%>

        </table>
        </form>
    </div>    
    </div>
</div>
    <%
        rs.close
        CN2.close
    %>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>    
<script>  
 $(document).ready( function () {
    // $('#myTable').DataTable({
    //     scrollY: "50vh",
    //     scroller: true
    // });

   var table = $('#myTable').DataTable({
      scrollY: "38vh",
      scroller: true,
      scrollCollapse: true,
      'columnDefs': [
         {
            'targets': 0,
            'checkboxes': true
         }
      ],
      "order": [1, "asc"],
   });

   $('#myForm').on('submit', function(event) {
       event.preventDefault();

       var form = this
       var rowsel = table.column(0).checkboxes.selected();
       var stringData = "" 
       $.each(rowsel, function(index, rowId) {
           stringData= stringData + rowId + ","
           $(form).append(
               $('<input>').attr('type', 'hidden').attr('name', 'id[]').val(rowId)
           )
       })
       $('#view-rows').text(rowsel.join(','))
       $('#view-form').text($(form).serialize())
       var allData = rowsel
        $.ajax({
                url: "daily_menu_add2.asp",
                type: "POST",
                data: {myTable_length: stringData},
                success: function(data) {
                    if(data==='true') {
                        alert('Daily Meals Successfully Added!');
                        location.reload();
                        // location.href="a_cashier_order_page.asp";
                    }
                    else {
                        alert('No Meals Added!');
                        location.reload();
                    }
                    // alert("Product Deleted Successfully!");
                    // $("#deleteProductModal").modal("hide");
                    // location.reload();
                }
            }) 

    //    window.location.href="dailyMealTest.asp?myTable_length="+stringData
    //    $('input[name="id\[\]"]', form).remove()
    //    e.preventDefault()
   })

});

</script>
</body>
</html>