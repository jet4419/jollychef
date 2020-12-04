<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Credit Balance</title>
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

            .invisible {
                opacity: 0;
            }

            div.tail-select.no-classes {
                width: 450px !important;
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

<% 

    'if (Month(systemDate) <> Month(systemDate + 1)) then

    sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
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

<div id="main">    
    
    <div id="content">
        <div class="container mb-5">
            <h1 class="h1 text-center mt-5 mb-5 main-heading" style="font-weight: 400"> 
                Credit Balance
            </h1>

            <%  

                Dim monthLength, monthPath, yearPath

                monthLength = Month(systemDate)
                if Len(monthLength) = 1 then
                    monthPath = "0" & CStr(Month(systemDate))
                else
                    monthPath = Month(systemDate)
                end if

                yearPath = Year(systemDate)

                Dim obFile, folderPath, obPath

                obFile = "\ob_test.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                obPath = folderPath & obFile

                rs.open "SELECT id, ref_no, cust_id, balance, cust_name, department "&_
                        "FROM "&obPath&" "&_
                        "GROUP BY cust_id ORDER BY cust_name", CN2

               
            %>
            
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Customer ID</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Credit Balance</th>
                    <th>Payment</th>
                    <th>Transactions</th>
                    
                </thead>

                <%do until rs.EOF%>
                <tr>
                
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td>
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_name")))%></td>
                    <td class="text-darker"><%Response.Write(rs("department"))%></td>
                    <%
                        Dim creditBal, debitBal
                        if CDbl(rs("balance").value) < 0 then
                            creditBal = 0
                            debitBal = ABS(CDbl(rs("balance").value))
                        else
                            creditBal = rs("balance").value
                            debitBal = 0
                        end if
                    %>
                    <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(creditBal)%></td>
  
                    
                        <%if CDbl(creditBal) <= 0 then%>

                            <td>
                                <button class="btn btn-sm btn-outline-dark mx-auto mb-2 btnPayDebt"  title="The store is closed or zero balance" data-toggle="tooltip" data-placement="top" title="Tooltip on top" disabled>
                                    Pay Credit
                                </button>
                            </td>

                        <%else%>

                            <td>
                                <button id="<%=rs("cust_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 btnPayDebt" data-toggle="modal" data-target="#pay_debt_modal"  >
                                    Pay Credit
                                </button>
                            </td>

                        <%end if%>
                       
                    <td>
                        <button type="button" id="<%=rs("cust_id")%>" class="btn btn-sm btn-outline-dark mx-auto mb-2 date_transact w-100" data-toggle="modal" data-target="#date_transactions"  title="View Transactions" data-toggle="tooltip" data-placement="top">
                            Transactions
                        </button>
                    </td>
                    
                </tr>
                <%rs.MoveNext%>
                <%loop%>
                <%rs.close%>

            </table>
        </div>    
    </div>

</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <!-- Pay Debt -->
        <div class="modal fade" id="pay_debt_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <form action="ar_lists.asp" class="form-group mb-3" id="payDebtForm" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Pay Current Credit </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="payDebtBody">
                        <!-- Modal Body (Contents) -->
                        
                    
                    </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary bg-dark" data-dismiss="modal">Close</button>
                                <button type="submit" id="payDebtCash" class="btn btn-primary">Save changes</button>
                            </div>
                        </form>  
                </div>
            </div>
        </div> 
      <!-- END OF Pay Debt -->    

   

    <!-- Date Range of Transactions -->
            <div class="modal fade" id="date_transactions" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <form action="ar_card_report.asp" method="POST" id="allData2" class="">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exampleModalLabel">Date Range of Transaction </h5>
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

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>  
<script src="tail.select-full.min.js"></script>
<script>  
let j = 0
 $(document).ready( function () {
    $('#myTable').DataTable({
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //scrollY: 430,
        scrollY: "50vh",
        scroller: true,
        scrollCollapse: true,
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

        
    // Pay Debt
    $(document).on("click", ".btnPayDebt", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            $.ajax({

            url: "ar_list_datepicker.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#payDebtBody").html(data);
                $("#pay_debt_modal").modal("show");
            }
        })    
    }) // End of Pay Debt    

    // Date Transactions Generator
        $(document).on("click", ".date_transact", function(event) {

            event.preventDefault();

            let custID = $(this).attr("id");
            $.ajax({

            url: "ar_card_daterange.asp",
            type: "POST",
            data: {custID: custID},
            success: function(data) {
                $("#daterange_modal_body").html(data);
                $("#date_transactions").modal("show");
            }
        })    
    }) // End of Date Transactions Generator  

    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

});

// function payDebt(id) {

//     window.location.href='ar_lists.asp?cust_id='+id;

// }
    
</script>

</body>
</html>    