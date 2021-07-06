<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

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

            <div class="mt-5 d-flex justify-content-between">
                <form id="formReportDate">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date" required> 
                    
                    <input type="hidden" id="currentDate" value="<%=systemDate%>"> 
                    
                    <button type="submit" class="btn btn-sm btn-outline-dark mb-1 " id="btnGenerateReport">Generate</button>
                </form>

                

            </div>

            <h1 id="order-history-heading" class="main-heading-text-p h1 text-center main-heading my-0"> Edited Orders </h1>

            <div class="table-responsive-sm mt-4">
                <p>
                    <strong>Date: </strong> 
                    <span class="reportDate"></span>
                </p>

                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Invoice</th>
                        <th>OrderID</th>
                        <!--<th>Customer</th>-->
                        <th>Product</th>
                        <th>Price</th>
                        <th>Amount</th>
                        <th>Qty</th>
                        <th>Status</th>
                        <th>Added by Cashier</th>
                        <th>Date</th>
                    </thead>

                    <tbody>



                    </tbody>

                </table>
            </div>
        </div>

    </main>


    <!--#include file="cust_login_logout.asp"-->
    <!--#include file="footer.asp"-->

    <script src="js/main.js"></script>
    <script>

        const custID = localStorage.getItem('cust_id');
        const currentDate = document.getElementById('currentDate').value;
        console.log(`Current Date: ${currentDate}`);

        $(document).ready( function () {

            function getOrderHistory(startDate = currentDate, endDate = currentDate) { 

                console.log('Start Date:', startDate);
                console.log('End Date:', endDate);

                $('#myTable').DataTable({
                    scrollY: "36vh",
                    scroller: true,
                    // "paging": false,
                    "order": [],
                    scrollCollapse: true,
                    ajax: {
                        'url': 'cust_get_order_history.asp',
                        'type': 'POST',
                        'data': {'custID': custID, startDate: startDate, endDate: endDate},
                        'dataSrc': function (json) {
                            const return_data = new Array();
                            let reportDate;

                            startDate = new Date(startDate);
                            endDate = new Date(endDate);

                            if (json.length !== 0) {
                                
                                // reportDate = new Date(json[0].date);

                                for (let i=0; i < json.length; i++) {
                                    
                                    return_data.push({
                                        'invoice': json[i].invoiceNo === 0 ? `` : `<a class='text-info' target='_blank' href='receipt_reports.asp?invoice=${json[i].invoiceNo}&date=${json[i].date}'>${json[i].invoiceNo}`,
                                        'orderid': `${json[i].uniqueNum}` ,
                                        // 'customer': `${json[i].customerName}` ,
                                        'product': `${json[i].prodName}` ,
                                        'price': json[i].price === json[i].updPrice ? `${json[i].price}` : `<span class='recent-val'>${json[i].price}</span> - <span class='new-val'>(${json[i].updPrice})</span>`,
                                        'amount': json[i].amount === json[i].updAmount ? `${json[i].amount}` :  `<span class='recent-val'>${json[i].amount}</span> - <span class='new-val'>(${json[i].updAmount})</span>`,
                                        'qty': json[i].qty === json[i].updQty ? `${json[i].qty}` : `<span class='recent-val'>${json[i].qty}</span> - <span class='new-val'>(${json[i].updQty})</span>` ,
                                        'status': json[i].status === 'Finished' ? `Processed` : `${json[i].status}`,
                                        'added': json[i].isAdded === 'true' ? `yes` : `no` ,
                                        //'date': `${json[i].date}`,
                                        'date': dateFormat(new Date(json[i].date)),
                                    });

                                }

                                // console.log(reportDate);
                                // if (reportDate.getMonth() < 9) {
                                //     console.log(`Month: 0${reportDate.getMonth() + 1}`);
                                // } else {
                                //     console.log(`Month: ${reportDate.getMonth() + 1}`);
                                // }
                            }

                            const startDateMonth = getMonthName(startDate.getMonth());
                            const startDateDay = startDate.getDate();
                            const startDateYear = startDate.getFullYear();
                            const startFullDate = `${startDateMonth} ${startDateDay}, ${startDateYear}`;

                            const endDateMonth = getMonthName(endDate.getMonth());
                            const endDateDay = endDate.getDate();
                            const endDateYear = endDate.getFullYear();
                            const endFullDate = `${endDateMonth} ${endDateDay}, ${endDateYear}`;

                            document.querySelector('.reportDate').innerText = `${startFullDate} - ${endFullDate}`;

                            function getMonthName(month){

                                monthNamelist = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];

                                return monthNamelist[month];
                            };

                            function dateFormat(dateReport) {
                                day = dateReport.getDate();
                                month = dateReport.getMonth() + 1;
                                year = dateReport.getFullYear().toString().slice(2);

                                
                                if (day < 10) {
                                    day = "0" + day
                                }

                                if (month < 10) {
                                    month = "0" + month
                                }
                                // console.log(`Year: ${year.toString().slice(2)}`);
                                // console.log(`Date: ${month} - ${day} - ${year}`);
                                return `${month}/${day}/${year}`
                            }

                            return return_data;
                        }
                    },
                    "columns": [
                        {"data": "invoice"},
                        {"data": "orderid"},
                        // {"data": "customer"},
                        {"data": "product"},
                        {"data": "price"},
                        {"data": "amount"},
                        {"data": "qty"},
                        {"data": "status"},
                        {"data": "added"},
                        {"data": "date"},
                    ],   
                });

            }

            getOrderHistory();

            const formDateReport = document.getElementById('formReportDate');

            $('#btnGenerateReport').click(function (event) {
                
                if (formDateReport.checkValidity()) {

                    event.preventDefault();

                    const startDate = document.getElementById('startDate').value;
                    const endDate = document.getElementById('endDate').value;
                    console.log(`Start Date: ${new Date(startDate)}`);
                    console.log(`End Date: ${new Date(endDate)}`);
                    $('#myTable').DataTable().destroy();
                    getOrderHistory(startDate, endDate);
                    
                    // getOrderHistory(startDate, endDate);
                    // $('#myTable').DataTable({
                    //     'url': 'cust_get_order_history.asp',
                    //     'type': 'POST',
                    //     'data': {'custID': custID, startDate: startDate, endDate: endDate},
                    // }).ajax.reload();

                }

            });

        }); 

    </script>

</body>
</html>



