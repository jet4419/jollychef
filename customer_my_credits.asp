<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->


<!DOCTYPE html>
<html>
    <head>
        
        <title>Credits</title>

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

        <style>
            /* .dt-buttons {
                position: absolute;
                bottom: 10px;
                left: 40%;
                text-align: center;
            }    */

            .dt-buttons {
                position: absolute;
                top: -10px;
                left: 22%;
                margin-top: .5rem;
                text-align: left;
            }   

            .users-info {
                font-family: 'Kulim Park', sans-serif;
                padding: 23px 5px 5px 5px;
                border-radius: 10px;
            }

            .total-payment-container {
                /* border: 1px solid #ccc; */
                padding: 5px;
                /* border-radius: 10px; */
            }

            .order_of {
                font-weight: 400;
                color: #333;
            }

            .cust_name {
                color: #463535;
            }

            .department_lbl {
                color: #7d7d7d;
            }

            .total-value, .total-text {
                font-size: 18px;
                font-weight: 500;
            }

            .user-info-label, .user-info-balance {
                color: #074684;
                font-weight: 500;
                font-size: .85rem;
            }

            .no-records {
                height: 85vh;
                display:flex;
                justify-content: center;
                align-items: center;
                
            }

            p.display-date-container {
                margin-top: .5rem;
                padding: 0;
            }

            /* td {
                font-size: 1.1rem;
            } */

            .date-label-container {
                margin-top: 1rem;
                width: 100%;
                display: flex;
                justify-content: space-between;
            }

            .users-info--divider {
                min-height: 150px;
                width: auto;
                display: inline-flex;
                flex-direction: column;
                justify-content: space-evenly;
            }

            .user-info--text{
                border: 5px #000 black;
                white-space: nowrap;
                display: inline-block;
                width: 80px;
            }

            .user-info-balance {
                white-space: nowrap;
                display: inline-block;
                width: 150px;
            }

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

            .total-text {
                font-size: 20px;
                font-weight: 500;
            }

            .total-balance {
                /* border: 1px solid #ccc; */
                padding: 5px;
                border-radius: 5px;
            }

            input[data-readonly] {
                pointer-events: none;
            }

            a {
                color: #086972;
                text-decoration: none;
            }

            .total-payment-container {
                display: flex;
                justify-content: space-evenly;
                align-items: center;
                flex-wrap: wrap;
            }

            #main {
                padding-left: 50px;
            }

        </style>
        <!--<script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
        -->
    </head>

    <%

        ' Session("cust_id") = 12
        ' if Session("cust_id") = "" then
        '     Response.Redirect("cust_login.asp")
        ' end if

        Dim fs
        Set fs=Server.CreateObject("Scripting.FileSystemObject")

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim monthLength

        monthLength = Month(systemDate)
        if Len(monthLength) = 1 then
            monthPath = "0" & CStr(Month(systemDate))
        else
            monthPath = Month(systemDate)
        end if

        Dim folderPath

        folderPath = mainPath & yearPath & "-" & monthPath
    %>

<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

    <%

        Dim arFile

        arFile = "\accounts_receivables.dbf"

    %>

        <%'if custID<>0  then%>

<div id="main">

    <!--
    <h1 class="h1 text-center my-4 main-heading"> <strong><'%=custFullName&"'s"%> Receivable Lists</strong> </h1>
    -->
    <div id="content">
        <div class="container pb-3 mb-5">

            <div class="users-info mb-5">
                <h1 class="h1 text-center main-heading my-0"> <strong><span class="order_of">Credits of</span> <span class="cust_name"></span></strong> </h1>
                <h1 class="h5 text-center main-heading my-0"> <span class="department_lbl"><strong></strong></span> </h1>
                
            </div>

            <%  'sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
            '     set objAccess = cnroot.execute(sqlQuery)
            '     if not objAccess.EOF then
            '         isStoreClosed = CStr(objAccess("status"))
            '         set objAccess = nothing
            '     else 
            '         isStoreClosed = "open"
            '     end if    

            '    set objAccess = nothing

                Dim arFolderPath, arMonthPath, arYearPath

                folderPath = mainPath & yearPath & "-" & monthPath
        
                arFolderPath = folderPath
                arMonthPath = monthPath
                arYearPath = yearPath

                arPath = arFolderPath & arFile

                Dim isArFolderExist
                isArFolderExist = fs.FolderExists(arFolderPath)
            %>
   
                          
            <form id="myForm" method="POST">
 
            <div class="table-responsive-sm mt-4">
                <table class="table table-bordered table-sm" id="myTable">
                    <thead class="thead-dark">
                        <th>Date</th>
                        <th>Invoice</th>
                        <th>Amount Credit</th>
                        <th>Balance</th>
                    </thead>

                <tfoot>

                    <tr class="tfoot">

                    </tr>

                </tfoot>

                <tbody>


                </tbody>

                </table>

            </div>
            </form>

        </div>    
    </div>

    <%'else%>
    <!--
    <div id="main" class="mt-4 pt-4">
        <h1 class="h1 no-records"> NO RECORDS </h1>
    </div>
    -->
    <%'end if%>

</div>

    <!--#include file="footer.asp"-->
    
    <!-- Date Range of Transactions -->
        <div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="a_ob_records.asp" method="POST" id="allData2">
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
                                <button type="submit" class="btn btn-primary btn-sm mb-1" id="generateReport2">Generate Report</button>
                            </div>        
                    </form>
                        
                </div>
            </div>
        </div>
    <!-- End of Date Range of Transactions -->

<!--#include file="cust_login_logout.asp"-->

<script src="js/main.js"></script> 
<script>  
    const tr = document.querySelector('.tfoot');
    const custID = Number(localStorage.getItem('cust_id'));
    const custName = localStorage.getItem('fname') + ' ' + localStorage.getItem('lname');
    const department = localStorage.getItem('department');

    document.querySelector('.cust_name').textContent = custName;
    document.querySelector('.department_lbl').textContent = department;

    $(document).ready( function () {

    
    var custOB = 0;
    var obStr = '';
   
    // const tr = document.createElement('tr');

//     $("#myTable").append(
//        $('<tfoot/>').append( $("#example thead tr").clone() )
//    );

    $('#myTable').DataTable({
        scrollY: "36vh",
        scroller: true,
        "paging": false,
        scrollCollapse: true,
        ajax: {
            'url': 'customer_get_credits.asp',
            'type': 'POST',
            'data': {'custID': custID},
            "dataSrc": function (json) {
            var return_data = new Array();

                if(json.length !== 0) {
                    
                    for(var i=0;i< json.length; i++){

                        return_data.push({
                            'date': `<span class='text-darker'>${json[i].date} </span>` ,
                            'invoice'  : `<a target='_blank' href='ob_invoice_records.asp?invoice=${json[i].invoice}&date=${json[i].date}'> ${json[i].invoice} </a> `,
                            'receivable' :`<span class='currency-sign'>&#8369; </span> ${json[i].receivable}` ,
                            'balance' : `<span class='currency-sign'>&#8369; </span> ${json[i].balance}`
                        });
                        
                        custOB += json[i].balance;
                        
                    }

                    const td1 = document.createElement('td');
                    td1.setAttribute('colspan', '3');
                    td1.innerHTML = '<strong>Total Balance<strong>'
                    const td2 = document.createElement('td');
                    td2.setAttribute('colspan', '1');
                    td2.innerHTML = `<strong> <span class='currency-sign'>&#8369; </span> ${custOB} </strong>`;
                    tr.appendChild(td1);
                    tr.appendChild(td2);

                }
        
                

                // time()
                return return_data;
            
            }
        },
        "columns": [
            {"data": "date"},
            {"data": "invoice"},
            {"data": "receivable"},
            {"data": "balance"},
        ],
        "order": [],
        dom: "<'row'<'col-sm-12 col-md-4'i><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-light' },
            { extend: 'excel', className: 'btn btn-sm btn-light' },
            { extend: 'pdf', className: 'btn btn-sm btn-light' },
            { extend: 'print', className: 'btn btn-sm btn-light' }
        ]
        
    });

    
    // function time() {
                    
    //     setTimeout( () => {
    //         // $('tfoot').append(tr)
    //     }, 10);

    // }

    // $('#myTable').append(tr);

    // obStr = `<tr>
    //             <td colspan="3"> 
    //                 <strong>Total Balance<strong>
    //             </td>
    //             <td colspan="1"> <strong> <span class='currency-sign'> &#8369; </span> ${custOB} </strong> 
    //             </td>
    //         </tr>`
    // $('#myTable').append(tr);

}); 



    // Date Generator
    $(document).on("click", ".date_transact", function(event) {

            event.preventDefault();

            $.fn.dataTable.ext.classes.sPageButton = 'button primary_button';
            let custID = $(this).attr("id");
            $.ajax({

            url: "a_ob_daterange.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Generator  

    // getCredits();
    // // getOb();

    // function getCredits () {
            
    //     var URL = 'customer_get_credits.asp';
    //     var custID = Number(localStorage.getItem('cust_id'));
    //     var custName = "";
    //     var custDepartment = "";
    //     var custOB = 0;
    //     var obStr = "";
        
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
    //                                 <td class='text-darker'> ${jsonObject[i].date} </td>
    //                                 <td class='text-darker'> <a target='_blank' href='ob_invoice_records.asp?invoice=${jsonObject[i].invoice}&date=${jsonObject[i].date}'> ${jsonObject[i].invoice} </td>
    //                                 <td class='text-darker'> <span class='currency-sign'>&#8369; </span> ${jsonObject[i].receivable} </td> 
    //                                 <td class='text-darker'> <span class='currency-sign'>&#8369; </span> ${jsonObject[i].balance} </td> 

    //                             </tr>    

                                
    //                         `;
                        
    //                     custOB += jsonObject[i].balance;
    //             }  

    //             obStr = `<tr>
    //                         <td colspan="3"> 
    //                             <strong>Total Balance<strong>
    //                         </td>
    //                         <td colspan="1"> <strong> <span class='currency-sign'> &#8369; </span> ${custOB} </strong> 
    //                         </td>
    //                     </tr>`

    //             custName = jsonObject[0].name;
    //             custDepartment = jsonObject[0].department;

    //             // console.log(custName);

    //             document.querySelector('.cust_name').textContent = custName;
    //             document.querySelector('.department_lbl').textContent = custDepartment;       

    //             $('td.dataTables_empty').attr('hidden', 'hidden');
    //             $('#myTable tr:last').after(output + obStr);
    //             // document.querySelector('#customerID').value = Number(localStorage.getItem('cust_id'));
    //             // document.querySelector('#totalProfit').value = totProfit;
    //             // document.querySelector('#totalAmount').value = totAmount;

    //             // custName = jsonObject[0].name;
    //             // custDepartment = jsonObject[0].department;

    //             // document.querySelector('.cust_name').textContent = custName;
    //             // document.querySelector('.department_lbl').textContent = custDepartment;
    //             // document.querySelector('#totalAmount').value = totAmount;

    //         } else {
    //             console.log("no new data");
    //             // $('.btnPayment').attr('disabled', "");
    //         }
    //     })
    //     .fail(function() {
    //         console.log("error");
    //     });
        
    // }

</script>


</body>
</html>    