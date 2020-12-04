<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Transaction</title>
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

    displayDate1 = Day(systemDate) & " " & MonthName(Month(systemDate)) & " " & Year(systemDate)

    Dim yearPath, monthPath

    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim collectionsFile

    collectionsFile = "\collections.dbf"

    Dim collectionsPath, arPath

    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
%>

<div id="main">

    
    <div id="content">
    <div class="container mb-5">
        <h1 class="h2 text-center mt-4 mb-5 main-heading pt-4">Edit Current Day Collection</h1>
        <% rs.Open "SELECT * FROM "&collectionsPath&" WHERE duplicate!='yes' and date=CTOD('"&systemDate&"') ORDER BY id", CN2 %>

        <%
 
            Response.Write("<p><strong> Date: </strong>")
            Response.Write(displayDate1)
                
        %>

        <table class="table table-hover table-bordered table-sm" id="myTable">
            <thead class="thead-dark">
                <th>ID</th>
                <th>Customer Name</th>
                <th>Department</th>
                <th>Invoice</th>
                <th>Reference No.</th>
                <th>Date</th>
                <th>Total</th>
                <th>Cash Paid</th>
                <th>AR Paid</th>
                <th>Action</th>
            </thead>
            <%
                Dim collectID, cash_paid, ar_paid, custID, referenceNo
            %>
            <%do until rs.EOF%>

                <% collectID = rs("id").value %>
            <tr>
                <% d = CDate(rs("date"))%>
                <td class="text-darker">
                    <%Response.Write(rs("cust_id"))%>
                </td>
                <% custID = rs("cust_id").value %>

                <td class="text-darker">
                    <%Response.Write(rs("cust_name"))%>
                </td> 

                <td class="text-darker">
                    <%Response.Write(rs("department"))%>
                </td> 
                <% if Trim(rs("p_method").value) <> Trim("cash") then %>
                <td class="text-darker">
                    <a class="text-info" target="_blank" href='ob_invoice_records.asp?invoice=<%=rs("invoice")%>&date=<%=FormatDateTime(d, 2)%>'>
                        <%=rs("invoice")%>
                        <%arInvoice = CDbl(rs("invoice").value)%> 
                    </a>
                </td>
                <% else %>
                <td class="text-darker">
                    <a class="text-info" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=FormatDateTime(d, 2)%>'>
                        <%=rs("invoice")%> 
                    </a>
                </td>
                <% end if %>

                <% if Trim(rs("p_method").value) <> Trim("cash") then %>
                <td class="text-darker">
                    <a class="text-info" target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=FormatDateTime(d, 2)%>'>
                        <%Response.Write(rs("ref_no"))%>
                    </a>
                </td> 
                <% else %>
                <td class="text-darker">
                    <a class="text-info" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=FormatDateTime(d, 2)%>'>
                        <%Response.Write(rs("ref_no"))%>
                    </a>
                </td>
                <% end if %>

                <% referenceNo = Trim(CStr(rs("ref_no").value)) %>

                <td class="text-darker">
                    <%Response.Write(FormatDateTime(d,2))%>
                </td> 

                <td class="text-darker">
                    <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&rs("tot_amount"))%>
                </td> 
                <% if Trim(rs("p_method").value) = Trim("ar") then 
                    cash_paid = 0.00
                    ar_paid = rs("cash").value

                   else  
                    ar_paid = 0.00
                    cash_paid = rs("cash").value
                   end if
                %>
                <td class="text-darker">
                    <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&cash_paid)%>
                </td> 

                <td class="text-darker">
                    <%Response.Write("<strong class='text-primary' >&#8369; </strong>"&ar_paid)%>
                </td> 

                <td>
                    <!--
                    <button type="button" id="<'%='collectID%>" class="btn btn-sm btn-warning mx-auto mb-2 updateTransaction" style="max-width: 50px;" data-toggle="modal" data-target="#editProduct">
                        <i class="fas fa-edit text-white"></i>
                    </button>
                    -->
                    <% if d = systemDate then %>
                        <% if Trim(rs("p_method").value) <> Trim("cash") then %>
                            <button class="btn btn-sm btn-warning mx-auto mb-2" onClick="edit_transact(<%=arInvoice%>, <%=collectID%>,<%=custID%>,'<%=referenceNo%>')">
                                <i class="fas fa-edit text-white"></i>
                            </button>
                        <% else %>
                            <button type="button" id="<%=collectID%>" class="btn btn-sm btn-warning mx-auto mb-2 updateTransaction" style="max-width: 50px;" data-toggle="modal" data-target="#editTransact">
                                <i class="fas fa-edit text-white"></i>
                            </button>
                        <% end if %>
                    <% else %>        
                        <button class="btn btn-sm btn-dark">
                            <i class="fas fa-plus"></i>
                        </button>
                        <button class="btn btn-sm btn-danger" title="Sales is ongoing" data-toggle="tooltip" data-placement="top" title="Tooltip on top">
                            <i class="fas fa-minus"></i>
                        </button>
                        
                    <% end if %>
                </td>

            <%rs.MoveNext%>
            <%loop%>
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
                <form action="sales_current_cash_c.asp" class="form-group mb-3" id="updateForm" method="POST">
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

function edit_transact(arInvoice, collectID, custID, referenceNo) {
    let isEdit = confirm("Are you sure to update this Reference No: "+referenceNo);
	
    if (isEdit) {
        window.location.href='sales_current_credit.asp?collectID='+collectID+'&custID='+custID+'&ref_no='+referenceNo+'&ar_invoice='+arInvoice;
    }
		
	
}


</script>
</body>
</html>