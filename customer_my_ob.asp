<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>
    <head>

        <title>My Reports</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <!--<link rel="stylesheet" href="tail.select-master\css\default\tail.select-light-feather.min.css">-->
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

        </style>

    </head>
<body>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

<div id="main">    
    <h1 class="h1 text-center mt-3 mb-4 main-heading" style="font-weight: 400"> Outstanding Balance</h1>
    <div id="content">
        <div class="container mb-5">

            <% sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
                set objAccess = cnroot.execute(sqlQuery)
                if not objAccess.EOF then
                    isStoreClosed = CStr(objAccess("status"))
                    dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
                    set objAccess = nothing
                else
                    isStoreClosed = "open"
                    dateClosed = CDate(Date)
                end if
            %>

            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Department</th>
                    <th>Credit Balance</th>
                    <th>Transactions</th>     
                </thead>

                

            </table>
        </div>    
    </div> 
    

    <!-- Date Range of Transactions -->
            <div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <form action="customer_my_transactions.asp" method="POST" id="allData" class="">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Date Range of Transaction <i class="far fa-calendar-check"></i></h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body" id="daterange_modal_body">
                            <!-- Modal Body (Contents) -->
                            
                                
                        </div>    
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm mb-1 bg-dark" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-success btn-sm mb-1" id="generateReport">Generate Report</button>
                                </div>        
                        </form>
                            
                    </div>
                </div>
            </div>
        <!-- End of Date Range of Transactions -->

        <!-- Date Range of Sales -->
            <div class="modal fade" id="date_sales" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <form action="customer_my_sales_reports.asp" method="POST" id="allData2" class="">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Date Range of Transaction <i class="far fa-calendar-check"></i></h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body" id="datesales_modal_body">
                            <!-- Modal Body (Contents) -->
                            
                                
                        </div>    
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm mb-1 bg-dark" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-success btn-sm mb-1" id="generateReport2">Generate Report</button>
                                </div>        
                        </form>
                            
                    </div>
                </div>
            </div>
        <!-- End of Date Range of Sales -->

</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!--#include file="cust_login_logout.asp"-->


<script src="js/main.js"></script>  
<script src="tail.select-full.min.js"></script>
<script>  
let j = 0

const custID = localStorage.getItem('cust_id');

 $(document).ready( function () {
    $('#myTable').DataTable({
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //scrollY: 430,
        scrollY: "auto",
        scroller: true,
        ajax: {
            'url': 'customer_get_main_ob.asp',
            'type': 'POST',
            'data': {'custID': custID},
            "dataSrc": function (json) {
            var return_data = new Array();
            
                for(var i=0;i< json.length; i++){

                    return_data.push({
                        'id': `<span class='text-darker'>${json[i].id} </span>` ,
                        'name'  : `<span class='text-darker'> ${json[i].name}`,
                        'department' :`<span class='text-darker'> ${json[i].department}`,
                        'balance' : `<span class='text-darker'> <span class='text-primary'> &#8369; </span> ${json[i].balance} </span>`,
                        'buttons' : `<button type='button' id='${json[i].id}' class='btn btn-sm btn-success mx-auto mb-2 date_sales w-100' data-toggle='modal' data-target='#date_sales'  title='View Transactions' data-toggle='tooltip' data-placement='top'>
                            Cash
                        </button>
                        
                        <button type='button' id='${json[i].id}' class='btn btn-sm btn-dark mx-auto mb-2 date_transact w-100' data-toggle='modal' data-target='#date_transactions'  title='View Transactions' data-toggle='tooltip' data-placement='top'>
                            Credit
                        </button>
                        ` 
                    });
                    
                    // custOB += json[i].balance;
                    // console.log(custOB);

                    
                }
  
                return return_data;
            
            }
        },
        "columns": [
            {"data": "id"},
            {"data": "name"},
            {"data": "department"},
            {"data": "balance"},
            {"data": "buttons"},
        ],
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

    // Date Transactions Generator
        $(document).on("click", ".date_transact", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            $.ajax({

            url: "ar_card_daterange2.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Transactions Generator  

    // Date Transactions Generator
        $(document).on("click", ".date_sales", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            $.ajax({

            url: "customer_my_sales_daterange.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#datesales_modal_body").html(data);
                $("#date_sales").modal("show");
            }
        })    
    }) // End of Date Transactions Generator  

    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

});
    
</script>

</body>
</html>    