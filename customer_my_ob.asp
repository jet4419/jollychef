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
    <h1 class="h1 text-center mt-3 mb-4 main-heading"> <strong>Outstanding Balance</strong> </h1>
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
            <%' rs.Open "SELECT cust_id, cust_name, department, credit_bal, debit_bal FROM ob_tbl WHERE cust_id="&Session("cust_id")&" GROUP BY cust_id", CN2 %>
            <%  
                Dim mainPath, systemDate

                mainPath = CStr(Application("main_path"))
                systemDate = CDate(Application("date"))
                
                Dim userID
                userID = CInt(Session("cust_id"))

                'Response.Write userID

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

                'Check if table has a data record'
                isThereObData = "SELECT id FROM "&obPath&""
                set objAccess = cnroot.execute(isThereObData)


                if objAccess.EOF then

                    Dim recentMonthPath, recentYearPath

                    recentMonthPath = CInt(monthPath) - 1
                    recentYearPath = CInt(yearPath)

                    Dim fs
                    Set fs = Server.CreateObject("Scripting.FileSystemObject")

                    if recentMonthPath = 0 then

                        recentMonthPath = 12
                        recentYearPath = CInt(yearPath) - 1

                    end if

                    if Len(recentMonthPath) = 1 then

                        recentMonthPath = "0" & recentMonthPath

                    end if

                    Dim recentFolderPath

                    recentFolderPath = mainPath & recentYearPath & "-" & recentMonthPath

                    Dim isFolderExist, recentObPath, isFileExist

                    isFolderExist = fs.FolderExists(recentFolderPath)         
                    
                    do until isFolderExist = false 

                        recentObPath = recentFolderPath & obFile
                        isFileExist = fs.FileExists(recentObPath)     

                        if isFileExist <> true then EXIT DO   

                        'Check if table has a data record'
                        checkRecord = "SELECT id FROM "&recentObPath&""
                        set objAccess = cnroot.execute(checkRecord)

                        if objAccess.EOF then

                            recentMonthPath = CInt(recentMonthPath) - 1
                            recentYearPath = CInt(recentYearPath)

                            if recentMonthPath = 0 then

                                recentMonthPath = 12
                                recentYearPath = CInt(recentYearPath) - 1

                            end if

                            if Len(recentMonthPath) = 1 then
                                recentMonthPath = "0" & recentMonthPath
                            end if

                            recentFolderPath = mainPath & recentYearPath & "-" & recentMonthPath
                            isFolderExist = fs.FolderExists(recentFolderPath)

                        else

                            obPath = recentObPath
                            EXIT DO

                        end if

                    loop

                end if

                ' Response.Write obPath

                ' getCustId = "SELECT cust_lname, cust_fname, department FROM customers WHERE cust_id="&userID
                ' set objAccess = cnroot.execute(getCustId)

                ' if not objAccess.EOF then

                '     custFullName = Trim(CStr(objAccess("cust_lname").value)) & " " & Trim(CStr(objAccess("cust_fname").value))
                '     department = Trim(CStr(objAccess("department")))

                ' end if

                ' rs.open "SELECT id, ref_no, cust_id, balance "&_
                ' "FROM "&obPath&" "&_
                ' "WHERE cust_id="&userID&" and id IN ( SELECT MAX(id) FROM "&obPath&" GROUP BY cust_id)", CN2

                'Response.Write obPath

                rs.open "SELECT OB_TEST.id, OB_TEST.ref_no, OB_TEST.cust_id, OB_TEST.balance, CUSTOMERS.cust_fname, CUSTOMERS.cust_lname, CUSTOMERS.department "&_
                "FROM "&obPath&" "&_
                "INNER JOIN CUSTOMERS ON OB_TEST.cust_id = CUSTOMERS.cust_id "&_
                "WHERE CUSTOMERS.cust_id="&userID&" and id IN ( SELECT MAX(OB_TEST.id) FROM "&obPath&" GROUP BY OB_TEST.cust_id)", CN2
            %>
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Customer ID</th>
                    <th>Customer Name</th>
                    <th>Department</th>
                    <th>Credit Balance</th>
                    <th>Transactions</th>     
                </thead>

                <%do until rs.EOF%>
                <tr>
                
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td>
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_lname")) & " " & Trim(rs("cust_fname")))%></td>
                    <td class="text-darker"><%Response.Write(rs("department"))%></td>
                    <td class="text-darker"><span class="text-primary">&#8369;</span><%Response.Write(rs("balance"))%></td>

                    <td>

                        <button type="button" id="<%=rs("cust_id")%>" class="btn btn-sm btn-success mx-auto mb-2 date_sales w-100" data-toggle="modal" data-target="#date_sales"  title="View Transactions" data-toggle="tooltip" data-placement="top">
                            Cash
                        </button>

                        <button type="button" id="<%=rs("cust_id")%>" class="btn btn-sm btn-dark mx-auto mb-2 date_transact w-100" data-toggle="modal" data-target="#date_transactions"  title="View Transactions" data-toggle="tooltip" data-placement="top">
                            Credit
                        </button>
                        
                    </td>

                     
                </tr>
                <%rs.MoveNext%>
                <%loop%>
                <%rs.close%>

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


<script src="js/main.js"></script>  
<script src="tail.select-full.min.js"></script>
<script>  
let j = 0
 $(document).ready( function () {
    $('#myTable').DataTable({
        "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
        //scrollY: 430,
        scrollY: "auto",
        scroller: true,
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