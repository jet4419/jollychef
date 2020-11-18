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
    ' if Session("cust_id") = "" then
    '     Response.Redirect("cust_login.asp")
    ' else
%>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

<main id="main">

    <h1 class="h2 text-center pt-3 mb-4 main-heading"> <strong>My Pending Orders</strong> </h1>
    <div id="content">
        <div class="container mb-5">
            <%
                Dim yearPath, monthPath

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

                
            </table>
        </div>    
    </div>
    
        
	
</main>

<footer class="footer">
    <p> <span class="copyright"> All rights reserved &copy </span> <script>document.write(new Date().getFullYear())</script> </p>
    <p>Feel free to contact me via email at:<span class="email">curiosojet@gmail.com</span></p>

    <div class="footer__social-media">
        <a href="https://twitter.com/devjet04" target="_blank"><i class="fab fa-twitter"></i></a>
        <a href="https://www.facebook.com/DevJet04" target="_blank"><i class="fab fa-facebook"></i></a>
        <a href="#"><i class="fab fa-instagram"></i></a>

    </div>
</footer>

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

var custID = localStorage.getItem('cust_id');

$(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
        ajax: {
            'url': 'customer_get_pending_orders.asp',
            'type': 'POST',
            'data': {'custID': custID},
            "dataSrc": function (json) {
            var return_data = new Array();

            if (json.length !== 0) {
            
                for(var i=0;i< json.length; i++){

                    return_data.push({
                        'order': `<span class='text-bold'>${json[i].orderNumber} </span>` ,
                        'name'  : `<span class='text-darker'> ${json[i].custName} </span> `,
                        'department' :`<span class='text-darker'>${json[i].department} </span> ` ,
                        'amount' : `<strong class='text-darker'>&#8369; </strong> ${json[i].amount}`,
                        'date' : `<span class='text-darker'>${json[i].date} </span> `,
                        'button' : `<a href='customer_my_orders_list.asp?unique_num=${json[i].uniqueNum}&cust_id=${json[i].custID}' class='btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct'>
                        View Orders
                        </a>`

                    });
                    
                    // custOB += json[i].balance;
                    // console.log(custOB);
                    
                }

            }
        
                // const td1 = document.createElement('td');
                // td1.setAttribute('colspan', '3');
                // td1.innerHTML = '<strong>Total Balance<strong>'
                // const td2 = document.createElement('td');
                // td2.setAttribute('colspan', '1');
                // td2.innerHTML = `<strong> <span class='text-primary'> &#8369; </span> ${custOB} </strong>`;
                // tr.appendChild(td1);
                // tr.appendChild(td2);

                // document.querySelector('.cust_name').textContent = json[0].name;
                // document.querySelector('.department_lbl').textContent = json[0].department;

                // time()
                return return_data;
            
            }
        },
        "columns": [
            {"data": "order"},
            {"data": "name"},
            {"data": "department"},
            {"data": "amount"},
            {"data": "date"},
            {"data": "button"},
        ],
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

// function getPendingOrders () {

//     var URL = 'customer_get_pending_orders.asp';
//     var custID = localStorage.getItem('cust_id');
    
//     $.ajax({
//         url: URL,
//         type: 'POST',
//         data: {custID: custID},
//         //data: {},
//     })
//     .done(function(data) {
//         // console.log(data)
//         if (data!=="no data") {

//             let jsonObject = JSON.parse(data)

//             let output = '';

//             for (let i in jsonObject) {
//                 output += ` <tr>
//                                 <td class='text-bold'> ${jsonObject[i].orderNumber} </td>
//                                 <td class='text-darker'> ${jsonObject[i].custName} </td>
//                                 <td class='text-darker'> ${jsonObject[i].department} </td> 
//                                 <td class='text-darker'> <strong class='text-primary'> &#8369; </strong> ${jsonObject[i].amount} </td> 
//                                 <td class='text-darker'> ${jsonObject[i].date} </td> 
//                                 <td class='m-0'>
//                                     <a href='customer_my_orders_list.asp?unique_num=${jsonObject[i].uniqueNum}&cust_id=${jsonObject[i].custID}' class='btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct'>
//                                         View Orders
//                                     </a>
//                                 </td>
//                             </tr>        
//                         `;
//             }

//             $('td.dataTables_empty').attr('hidden', 'hidden');
//             $('#myTable tr:last').after(output);

//         } else {
//             console.log("no new data");
//         }
//     })
//     .fail(function() {
//         console.log("error");
//     });
// }

// getPendingOrders();

</script>

<%'end if%>

</body>
</html>
