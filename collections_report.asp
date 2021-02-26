<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Collections Report</title>
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

            /* .main-heading {
                font-family: 'Kulim Park', sans-serif;
            } */

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
            displayDate1 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else

            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = MonthName(Month(queryDate1)) & " " & Day(queryDate1) & ", " & Year(queryDate1)

        end if   
        
        if endDate="" then

            queryDate2 = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else 

            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = MonthName(Month(endDate)) & " " & Day(endDate) & ", " & Year(endDate)

        end if  

        Dim monthsDiff

        monthsDiff = DateDiff("m",queryDate1,queryDate2) 
%>

<div id="main">

    <div id="content">

    <div class="container">
        <div class="mt-3 mb-2 d-flex justify-content-between">
            <form action="collections_report.asp" method="POST" id="allData" class="">
                
                <label>Start</label>
                <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
            
                <label class="ml-3">End&nbsp;</label>
                <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                
                <button type="submit" class="btn btn-outline-dark btn-sm mb-1" id="generateReport">Generate</button>
            </form>
            <p><a href="collections_report_per_ref.asp" class="btn btn-sm btn-outline-dark">Detailed Collections Report</a></p>
        </div>

        <h1 class="h2 text-center mb-4 mt-3 main-heading" style="font-weight: 400">Collections Report</h1>

        <%
 
            Response.Write("<p><strong> Date: </strong>")
            Response.Write(displayDate1 & " - ")
            Response.Write(displayDate2)
            Response.Write "</p>"
                
        %>

        <table class="table table-hover table-bordered table-sm" id="myTable">
            <thead class="thead-bg">
                <th>ID</th>
                <th>Customer Name</th>
                <th>Department</th>
                <th>Invoice</th>
                <th>Reference No.</th>
                <th>Date</th>
                <th>Total</th>
                <th>Cash Paid</th>
                <th>AR Paid</th>
            </thead>
        <%
            Dim fs
            set fs=Server.CreateObject("Scripting.FileSystemObject")

            Dim collectID, cash_paid, ar_paid, custID, referenceNo

            for i=0 to monthsDiff

                monthLength = Month(DateAdd("m",i,queryDate1))
                if Len(monthLength) = 1 then
                    monthPath = "0" & CStr(Month(DateAdd("m",i,queryDate1)))
                else
                    monthPath = Month(DateAdd("m",i,queryDate1))
                end if

                yearPath = Year(DateAdd("m",i,queryDate1))

                collectionsFile = "\collections.dbf"
                folderPath = mainPath & yearPath & "-" & monthPath
                collectionsPath = folderPath & collectionsFile

                Do 

                    if fs.FolderExists(folderPath) <> true then EXIT DO
                    if fs.FileExists(collectionsPath) <> true then EXIT DO

                    rs.Open "SELECT * FROM "&collectionsPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY id", CN2
            %>
                    <%do until rs.EOF%>

                        <% collectID = rs("id").value %>
                    <tr>
                        <%
                            myDate = CDATE(rs("date"))
                            myYear = Year(myDate)
                            myDay = Day(myDate)
                            if Len(myDay) = 1 then
                                myDay = "0" & myDay
                            end if

                            myMonth = Month(myDate)
                            if Len(myMonth) = 1 then
                                myMonth = "0" & myMonth
                            end if

                            dateFormat = myMonth & "/" & myDay & "/" & Mid(myYear, 3)
                            d = CDate(rs("date"))
                            d  = FormatDateTime(d, 2)
                        %>
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
                            <a class="text-dark" target="_blank" href='ob_invoice_records.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'>
                                <%=rs("invoice")%> 
                            </a>
                        </td>
                        <% else %>
                        <td class="text-darker">
                            <a class="text-dark" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'>
                                <%=rs("invoice")%> 
                            </a>
                        </td>
                        <% end if %>

                        <% if Trim(rs("p_method").value) <> Trim("cash") then %>
                        <td class="text-darker">
                            <a class="text-dark" target="_blank" href='receipt_ar_reports.asp?ref_no=<%=Trim(rs("ref_no"))%>&date=<%=d%>'>
                                <%Response.Write(rs("ref_no"))%>
                            </a>
                        </td> 
                        <% else %>
                        <td class="text-darker">
                            <a class="text-dark" target="_blank" href='receipt_reports.asp?invoice=<%=rs("invoice")%>&date=<%=d%>'>
                                <%Response.Write(rs("ref_no"))%>
                            </a>
                        </td>
                        <% end if %>

                        <% referenceNo = rs("ref_no").value %>

                        <td class="text-darker">
                            <%Response.Write(dateFormat)%>
                        </td> 

                        <td class="text-darker">
                            <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&rs("tot_amount"))%>
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
                            <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&cash_paid)%>
                        </td> 

                        <td class="text-darker">
                            <%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&ar_paid)%>
                        </td> 

                    <%rs.MoveNext%>
                    <%loop%>
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
        scrollY: "28vh",
        scroller: true,
        scrollCollapse: true,
        "order": [],
        dom: "<'row'<'col-sm-12 col-md-4'l><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-light' },
            { extend: 'excel', className: 'btn btn-sm btn-light' },
            { extend: 'pdf', className: 'btn btn-sm btn-light' },
            { extend: 'print', className: 'btn btn-sm btn-light' }
        ]
    });

}); 


</script>
</body>
</html>