<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Adjustment Minus</title>
        <link rel="stylesheet" href="css/homepage_style.css">
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
                margin-bottom: 45px;
                border-radius: 10px;
            }

            .total-payment-container {
                /* border: 1px solid #ccc; */
                padding: 5px;
                /* border-radius: 10px; */
            }

            .cust_name {
                color: #463535;
                font-size: 32px;
            }

            .order_of {
                font-weight: 400;
                color: #333;
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
                font-size: 16px;
                font-weight: 500;
            }

            .total-balance {
                /* border: 1px solid #ccc; */
                padding: 5px;
                border-radius: 5px;
            }

            input {
                background: #eee;
                border-radius: 5px;
                border: none;
                padding: 3px 5px ;
                outline: none;
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

            .item {
                width: 250px !important;
            }

            .remarks-container {
                display: flex;
                justify-content: center;
                /* align-items: center; */
            }

        </style>
        
        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>
 
    </head>

    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>

<body>
    <script src="tail.select-master/js/tail.select-full.min.js"></script>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

    <%
        Dim custID, ref_no, custName, department
        custID = CLng(Request.Form("cust_id"))

        if Request.Form("cust_id") = "" then
            Response.Redirect("canteen_homepage.asp")
        end if

        invoice = CDbl(Request.Form("arInvoice"))
        custName = CStr(Request.Form("cust_name"))
        department = CStr(Request.Form("department"))
        transactDate = FormatDateTime(systemDate, 2)

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim adReferenceNoFile
        adReferenceNoFile = "\adjustment_ref_no.dbf" 

        Dim adReferenceNoPath
        adReferenceNoPath = mainPath & yearPath & "-" & monthPath & adReferenceNoFile

        Dim minAdRefNo
        rs.Open "SELECT TOP 1 ref_no FROM "&adReferenceNoPath&" ORDER BY id ASC;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    minAdRefNo = x.value
                next
                rs.MoveNext
            loop
        rs.close  

        if minAdRefNo = "" then
            minAdRefNo = CLNG(minAdRefNo) + 1
        else
            minAdRefNo = CLNG(Mid(minAdRefNo, 8)) + 1
        end if

        Dim maxAdRefNoChar, maxAdRefNo
        rs.Open "SELECT TOP 1 ref_no FROM "&adReferenceNoPath&" ORDER BY id DESC;", CN2

            do until rs.EOF
                for each x in rs.Fields

                    maxAdRefNoChar = x.value

                next
                rs.MoveNext
            loop
            Response.Write maxAdRefNoChar
            if maxAdRefNoChar <> "" then
                maxAdRefNo = Mid(maxAdRefNoChar, 8) + 1
            else
                maxAdRefNo = "000000000" + 1
            end if
            
        rs.close  

        Const NUMBER_DIGITS = 9
        Dim formatedInteger

        formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxAdRefNo, NUMBER_DIGITS)
        maxAdRefNo = formattedInteger

    %>

<div id="main">

    <%if custID<>0  then%>

    <div id="content">
        <div class="container mb-5">

            <div class="users-info mb-5">
                <h1 class="h2 text-center main-heading mt-0"> 
                    <span class="order_of">(-) Adjustment for</span>
                    <span class="customer-name"><%=custName%></span> 
                </h1>

                <h1 class="h5 text-center main-heading my-0"> 
                    <span class="department_lbl"><%=department%></span> 
                </h1>
            </div>  

            <%       

                Dim arFile

                arFile = "\accounts_receivables.dbf"

                Dim folderPath, arFolderPath, arMonthPath, arYearPath

                folderPath = mainPath & yearPath & "-" & monthPath
        
                arFolderPath = folderPath
                arMonthPath = monthPath
                arYearPath = yearPath

                arPath = arFolderPath & arFile

                rs.open "SELECT cust_id, date_owed, ref_no, invoice_no, receivable, balance FROM "&arPath&" WHERE cust_id="&custID&" AND invoice_no="&invoice, CN2
            %>    
                          
            <form id="myForm" method="POST">
                <input type="text" name="cust_name" id="cust_name" value="<%=custName%>" hidden>
                <input type="text" name="department" id="department" value="<%=department%>" hidden>

                <div class="table-responsive-sm">

                    <table class="table table-bordered table-sm" id="myTable">

                        <thead class="thead-bg">
                            <th>Date</th>
                            <th>Reference No</th>
                            <th>Invoice</th>
                            <th>Amount Credit</th>
                            <th>Balance</th>
                            <th>Adjustment</th>
                        </thead>

                        <% Dim totalCashPaid
                        totalCashPaid = 0.00 
                        %>
                        <%do until rs.EOF%>
                        <tr>
                            <%invoice = rs("invoice_no").value%>
                            <% 
                                myDate = CDATE(rs("date_owed"))
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
                                refDate = CDate(rs("date_owed"))
                            %>
                            <td class="text-darker">
                                <%=dateFormat%>
                            </td>

                            <td class="text-darker">
                                <%=(rs("ref_no"))%>
                            </td>

                            <td class="text-darker">
                                <a target="_blank" class="text-info" href='ob_invoice_records.asp?invoice=<%=invoice%>&date=<%=refDate%>'><%=(rs("invoice_no"))%></a>
                            </td>

                            <td class="text-darker">
                                <span class="currency-sign">&#8369;</span> <%=(formatNumber(rs("receivable")))%>
                            </td>

                            <td class="text-darker">
                                <span class="currency-sign">&#8369;</span> <%=(formatNumber(rs("balance")))%>
                            </td>

                            <td>
                                <div class="input-group input-group-sm py-1">
                                    <div class="input-group-prepend">
                                        <span class="input-group-text bg-success text-light" id="inputGroup-sizing-sm">&#8369;</span>
                                    </div>
                                    <input id="receivable" value = "<%=rs("receivable").value%>" hidden>
                                    <input id="balance" value = "<%=rs("balance").value%>" hidden>
                                    <input id="transact_date" value="<%=transactDate%>" hidden>
                                    <input onblur="findTotal()" type="number" id="<%=invoice%>" name="adjustment_value" step="any" class="form-control" aria-label="Small" aria-describedby="inputGroup-sizing-sm" min="0.1" max="<%=CDbl(rs("balance"))%>">
                                </div>
                            </td>

                        </tr>
                        <%rs.MoveNext%>
                        <%loop%>
    
                        <%rs.close%>
                        <%CN2.close%>

                    </table>

                    <%
                        Function formatNumber(myNum)

                            Dim i, counter, numFormat
                            counter = 1
                            numFormat = ""

                            for i = Len(myNum) to 1 step -1

                                ' Response.Write "<br>" & i & "<br>"
                                if counter mod 3 = 0 then
                                    if counter = Len(myNum) then
                                        numFormat = Mid(myNum, i, 1) & numFormat
                                    else
                                        numFormat = "," & Mid(myNum, i, 1) & numFormat
                                    end if
                                else
                                    numFormat = Mid(myNum, i, 1) & numFormat
                                end if

                                counter = counter + 1

                            next

                            formatNumber = numFormat

                        End Function

                    %>

                    <div class="total-payment-container mt-5">

                        <div class="item item-left form-group ">
                            <label class="d-block total-text text-center">Reference No</label>
                            <input class="form-control form-control-sm" style="font-weight: 600;" type="text" id="reference_no" name="reference_no" value="<%=maxAdRefNo%>" min="<%=minAdRefNo%>" pattern="[0-9]{9}" minlength="9" maxlength="9" required/>
                        </div>
                        
                        <div class="item item-left form-group">
                            <label class="d-block total-text text-center">Total Adjustment
                                <span class="currency-sign">&#8369;</span>
                            </label>
                            <input class="input-total cash-input form-control form-control-sm" type="number" value="0" min="0.1" max="0" name="total_adjustment" step="any"  id="total_adjustment" step="any" required data-readonly/>
                        </div>

                        <div class="item item-right form-group">
                            <label class="d-block total-text text-center">Remarks</label>
                            <input class="item form-control form-control-sm" type="text" name="remarks" id="remarks" pattern="[a-zA-Z0-9 ' . - : ,]+" required>
                        </div>

                    </div>

                    <div class="d-flex justify-content-center">
                        <input type="hidden" name="cust_id" id="cust_id" value="<%=custID%>">
                        <button type="submit" class="btn btn-primary" id="myBtn">Submit</button>
                    </div>
                </div>
            </form>

        </div>    
    </div>

    <%else%>

        <h1 class="h1 no-records"> NO RECORDS </h1>

    <%end if%>

</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

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

<!--#include file="cashier_login_logout.asp"-->

<script src="js/main.js"></script> 
<script>  

    $(document).ready( function () {
        $('#myTable').DataTable({
            scrollY: "36vh",
            scroller: true,
            "paging": false,
            scrollCollapse: true,
            dom: "<'row'<'col-sm-12 col-md-4'i><'col-sm-12 col-md-4'B><'col-sm-12 col-md-4'f>>" +
                "<'row'<'col-sm-12'tr>>",
            buttons: [
                { extend: 'copy', className: 'btn btn-sm btn-light' },
                { extend: 'excel', className: 'btn btn-sm btn-light' },
                { extend: 'pdf', className: 'btn btn-sm btn-light' },
                { extend: 'print', className: 'btn btn-sm btn-light' }
            ]
        });
    }); 

    // Date Generator
    $(document).on("click", ".date_transact", function() {
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


    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

    function monthEnd(nId, nCreditBal, nDebitBal) {

        if(confirm('Are you sure to cutoff on this date?'))
        {
            window.location.href='a_ob_month_end.asp?cust_id='+nId+'&credit_bal='+nCreditBal+'&debit_bal='+nDebitBal;
        }

    }

    $(document).on("click", "#myBtn", function(event) {

        var valid = this.form.checkValidity();

        if (valid) {

            event.preventDefault();

            var adjustmentValue = $('input[name="adjustment_value"]').val();
            var invoice = $('input[name="adjustment_value"]').attr('id')

            var custID = $("#cust_id").val()
            var custName = $("#cust_name").val()
            var department = $("#department").val()
            var receivable = $("#receivable").val()
            var balance = $("#balance").val()
            var totalAdjustment = $("#total_adjustment").val()
            var referenceNo = $("#reference_no").val()
            var remarks = $("#remarks").val()
            var transactDate = $("#transact_date").val()
            
            $.ajax({
                url: "adjustment_minus_c.asp",
                type: "POST",
                data: {
                       invoice: invoice, adjustmentValue: adjustmentValue,
                       custID: custID, custName: custName, department: department,
                       receivable: receivable, balance: balance,
                       referenceNo : referenceNo, remarks: remarks
                      },
                
                success: function(data) {

                    if (data=='false') {
                        
                        alert('Error: Reference already exist!');
                        location.reload();
                    }

                    else if (data=='invalid adjustment') {
                        alert('Error: Invalid Adjustment');
                        location.reload();
                    }

                    else {

                        alert("Adjustment Submitted Successfully!");
                        location.replace("receipt_adjustment.asp?ref_no="+data+"&date="+transactDate);
                    }

                }
            });

        }
    });

    function findTotal(){
        var adjustmentInput = document.getElementsByName('adjustment_value');
        var total = 0;

        total = parseFloat(adjustmentInput[0].value)
        total = total.toFixed(2)

        document.querySelector('input#total_adjustment').value = total;
        document.querySelector('input#total_adjustment').min = total;
        document.querySelector('input#total_adjustment').max = total;

    }
</script>


</body>
</html>    