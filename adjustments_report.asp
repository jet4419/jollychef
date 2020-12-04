<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Adjustments Report</title>
        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        
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

            a.link-or {
                color: #206a5d;
                text-decoration: none;
            }

            a.link-or:hover {
                color: #557571;
                text-decoration: underline;
            }

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

    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>    

<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%

        Dim startDate, endDate

        startDate = Request.Form("startDate")
        endDate = Request.Form("endDate")

        if startDate="" then
            
            queryDate1 = CDate(FormatDateTime(systemDate, 2))
            displayDate1 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else

            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = Day(queryDate1) & " " &  MonthName(Month(queryDate1)) & " " & Year(queryDate1)

        end if   

        if endDate="" then

            queryDate2 = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

        else 

            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)

        end if   

        Dim monthsDiff

        monthsDiff = DateDiff("m",queryDate1,queryDate2) 

    %>

<div id="main">

    <div id="content">

        <div class="container">

            <div class="mt-3 mb-2 d-flex justify-content-between">
                <form action="adjustments_report.asp" method="POST" id="allData" class="">
                    
                    <label>Start Date</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End Date&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Generate Report</button>
                </form>
                <p></p>
            </div>

            <h1 class="h2 text-center mb-4 main-heading" style="font-weight: 400">Adjustments Report </h1>

            <%
    
                Response.Write("<p><strong> Date Range: </strong>")
                Response.Write(displayDate1 & " - ")
                Response.Write(displayDate2)
                Response.Write "</p>"
                    
            %>

            <table class="table table-hover table-bordered table-sm" id="myTable">

                <thead class="thead-dark">
                    <th>ID</th>
                    <th>Customer Name</th>
                    <th>Department</th>
                    <th>Invoice</th>
                    <th>Reference No.</th>
                    <th>Date</th>
                    <th>Type</th>
                    <th>Amount</th>
                    <th>Remarks</th>
                </thead>

                <%
                    Dim fs
                    set fs=Server.CreateObject("Scripting.FileSystemObject")

                    for i=0 to monthsDiff

                        monthLength = Month(DateAdd("m",i,queryDate1))
                        if Len(monthLength) = 1 then
                            monthPath = "0" & CStr(Month(DateAdd("m",i,queryDate1)))
                        else
                            monthPath = Month(DateAdd("m",i,queryDate1))
                        end if

                        yearPath = Year(DateAdd("m",i,queryDate1))
                        
                        adjustmentsFile = "\adjustments.dbf"
                        folderPath = mainPath & yearPath & "-" & monthPath
                        adjustmentsPath = folderPath & adjustmentsFile

                        Do 

                            if fs.FolderExists(folderPath) <> true then EXIT DO
                            if fs.FileExists(adjustmentsPath) <> true then EXIT DO

                            rs.Open "SELECT * FROM "&adjustmentsPath&" WHERE date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY id", CN2

                            do until rs.EOF%>

                                <tr>
                                    <% d = CDate(rs("date"))
                                    d = FormatDateTime(d, 2)
                                    %>
                                    <td class="text-darker">
                                        <%Response.Write(rs("cust_id"))%>
                                    </td>

                                    <td class="text-darker">
                                        <%Response.Write(rs("cust_name"))%>
                                    </td> 

                                    <td class="text-darker">
                                        <%Response.Write(rs("department"))%>
                                    </td> 

                                    <td class="text-darker">
                                        <%Response.Write(rs("invoice"))%>
                                    </td> 

                                    <td class="text-darker">
                                        <a class="link-or" target="_blank" href='receipt_adjustment.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'><%Response.Write(Trim(rs("ref_no")))%></a>
                                    </td> 

                                    <td class="text-darker">
                                        <%Response.Write(d)%>
                                    </td> 

                                    <td class="text-darker">
                                        <%Response.Write(rs("a_type"))%>
                                    </td> 

                                    <td class="text-darker">
                                        <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("amount"))%>
                                    </td>

                                    <td class="text-darker">
                                        <%Response.Write(rs("remarks"))%>
                                    </td>              
                                </tr>
                                <%rs.MoveNext
                            loop%>

                            <%rs.close
                        Loop While False  
                        
                    next%>   
            </table>
        </div>    
    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<!-- Edit Transact Modal -->
<div class="modal fade" id="editTransact" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form action="t_edit_transaction_c.asp" class="form-group mb-3" id="updateForm" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel"> Edit Transaction <i class="fas fa-shopping-cart"></i></h5>
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
<!-- END OF Edit Transact MODAL -->  


<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script>    
<script>  
 $(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "38vh",
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

    // Edit Transaction
    $(document).on("click", ".updateTransaction", function(event) {

        event.preventDefault();

        let collectionID = $(this).attr("id");
        //console.log(arID)
        $.ajax({

            url: "t_edit_transaction.asp",
            type: "POST",
            data: {collectionID: collectionID},
            success: function(data) {
                $("#collect_details").html(data);
                $("#editProduct").modal("show");

            }

        });

    }); 

}); 

function edit_transact(collectID, custID, referenceNo) {
    let isEdit = confirm("Are you sure to update this Reference No: "+referenceNo);
	
    if (isEdit) {
        window.location.href='t_edit_transaction2.asp?collectID='+collectID+"&custID="+custID+"&ref_no="+referenceNo;
    }
		
	
}


</script>
</body>
</html>