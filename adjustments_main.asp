<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lists of OB</title>
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
                width: 400px !important;
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

        <h1 class="h2 text-center mt-5 mb-5 main-heading" style="font-weight: 400"> 
                Select Adjustment
        </h1>

        <div class="container mb-5 pt-3">

            <%  

                monthLength = Month(systemDate)
                if Len(monthLength) = 1 then
                    monthPath = "0" & CStr(Month(systemDate))
                else
                    monthPath = Month(systemDate)
                end if

                yearPath = Year(systemDate)

                file = "\ob_test.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                filePath = folderPath & file

                rs.open "SELECT OB_TEST.id, OB_TEST.ref_no, OB_TEST.cust_id, CUSTOMERS.cust_fname, CUSTOMERS.cust_lname, CUSTOMERS.department "&_
                "FROM "&filePath&" "&_
                "INNER JOIN CUSTOMERS ON OB_TEST.cust_id = CUSTOMERS.cust_id "&_
                "WHERE CUSTOMERS.cust_type='in' and id IN ( SELECT MAX(OB_TEST.id) FROM "&filePath&" GROUP BY OB_TEST.cust_id) ORDER BY CUSTOMERS.cust_lname, CUSTOMERS.cust_fname", CN2
            %>
            
            <table class="table table-hover table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Customer ID</th>
                    <th>Last Name</th>
                    <th>First Name</th>
                    <th>Department</th>
                    <th>Adjustment</th>  
                </thead>

                <%do until rs.EOF%>
                <tr>
                
                    <td class="text-darker"><%Response.Write(rs("cust_id"))%></td>
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_lname")))%></td>
                    <td class="text-darker"><%Response.Write(Trim(rs("cust_fname")))%></td>
                    <td class="text-darker"><%Response.Write(rs("department"))%></td>
                    <td>
                        <button type="button" onClick="adjustmentListFunc(<%=rs("cust_id")%>)" class="btn btn-sm btn-outline-dark mx-auto mb-2 date_transact w-100" title="View Transactions" data-toggle="tooltip" data-placement="top">
                            Receivable Card
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

    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

});

function adjustmentListFunc(id) {

    window.location.href='ar_card_report2.asp?cust_id='+id;

}
    
</script>

</body>
</html>    