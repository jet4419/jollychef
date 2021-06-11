<!--#include file="dbConnect.asp"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Orders History</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="css/customer_style.css">
        <!--<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">-->
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

</head>
<body>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

    <%

        Dim yearPath, monthPath

        yearPath = Year(systemDate)
        monthPath = Month(systemDate)

        if Len(monthPath) = 1 then
            monthPath = "0" & CStr(monthPath)
        end if

        Dim ordersHolderFile

        ordersHolderFile = "\orders_holder.dbf" 

        Dim ordersHolderPath

        ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile
    %>

    <main id="main">

        <div class="container">

            <div class="users-info mb-5">
            
                <h1 class="main-heading-text-p h1 text-center main-heading my-0"> Order History </h1>
                <h1 class="h5 text-center main-heading my-0"> <span class="department_lbl"><strong></strong></span> </h1>
                
            </div>

            <div class="table-responsive-sm mt-4">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Invoice</th>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Product</th>
                        <th>Price - (New Price)</th>
                        <th>Amount - (New Amount)</th>
                        <th>Qty - (New Qty)</th>
                        <th>Status</th>
                        <th>Added by Cashier</th>
                    </thead>

                    <tbody>



                    </tbody>

                </table>
            </div>
        </div>

    </main>


    <!--#include file="cust_login_logout.asp"-->
    <!--#include file="footer.asp"-->

    <script>

        const custID = localStorage.getItem('cust_id');


        $(document).ready( function () {

            // function getOrderHistory() { 

                $('#myTable').DataTable({
                    scrollY: "36vh",
                    scroller: true,
                    "paging": false,
                    "order": [[1, "asc"]],
                    scrollCollapse: true,
                    ajax: {
                        'url': 'cust_get_order_history.asp',
                        'type': 'POST',
                        'data': {'custID': custID},
                        'dataSrc': function (json) {
                            const return_data = new Array();

                            if (json.length !== 0) {

                                for (let i=0; i < json.length; i++) {
                                    
                                    return_data.push({
                                        'invoice': json[i].invoiceNo === 0 ? `` : `${json[i].invoiceNo}`,
                                        'orderid': `${json[i].uniqueNum}` ,
                                        'customer': `${json[i].customerName}` ,
                                        'product': `${json[i].prodName}` ,
                                        'price': `${json[i].price} - (${json[i].updPrice})` ,
                                        'amount': `${json[i].amount} - (${json[i].updAmount})` ,
                                        'qty': `${json[i].qty} - (${json[i].updQty})` ,
                                        'status': `${json[i].status}` ,
                                        'added': `${json[i].isAdded}` ,
                                    });

                                }
                            }

                            return return_data;
                        }
                    },
                    "columns": [
                        {"data": "invoice"},
                        {"data": "orderid"},
                        {"data": "customer"},
                        {"data": "product"},
                        {"data": "price"},
                        {"data": "amount"},
                        {"data": "qty"},
                        {"data": "status"},
                        {"data": "added"},
                    ],   
                });

            // }

            // getOrderHistory();


        }); 

    </script>

</body>
</html>



