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

            .main-heading {
                font-family: 'Kulim Park', sans-serif;
            }

            .blank_row {
                height: 30px !important;
                background-color: #FFFFFF;
            }

            .final-total {
                font-weight: 600;
            }

            th {
                display: table-cell !important;
                padding: .3rem;
            }

            .bold-text {
                font-weight: 500;
            }

            .date-range-print {
                display: inline-block;
                padding-left: .5rem;
            }

            .heading-print {
                display: none;
            }

            .final-total {
                font-weight: 600;
                font-size: 13pt;
                border-bottom: #000 1px solid !important;
            }
/* 
            thead { display: table-header-group !important}
            tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}
            
            #myTable {
                overflow: visible !important;
            }

            tr { 
                page-break-inside: avoid !important;
            }

            td { 
                page-break-inside: avoid !important;
            } */

            /* .table-responsive { overflow-x: visible !important; } */

        @media print {

            * {
                font-family: monospace;
                font-size: 12pt;
            }

            thead { 
                display: table-header-group !important;
            }
            
            tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}
            /* thead {   
                position: fixed !important;
                display: block;
                height: auto;
                width: 100%;
            } */
            /* tfoot { display: table-row-group !important}
            tr { page-break-inside: avoid !important}

            #myTable {
                overflow: visible !important;
            }

            tr { 
                page-break-inside: avoid !important;
            }

            td { 
                page-break-inside: avoid !important;
            } */

            /* .tbl-responsive { overflow-x: visible !important; } */

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
            <div class="mt-3 mb-3 d-flex justify-content-between">
                <form action="collections_report_per_date.asp" method="POST" id="allData" class="">
                    
                    <label>Start</label>
                    <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date" required> 
                
                    <label class="ml-3">End&nbsp;</label>
                    <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
                    
                    <button type="submit" class="btn btn-dark btn-sm mb-1" id="generateReport">Generate</button>
                </form>
                <p>
                    <a href="collections_report_per_ref.asp" class="btn btn-sm btn-outline-dark">Collections Report by Ref</a>
                    <a href="collections_report_sum.asp" class="btn btn-sm btn-outline-dark">Collections Report Summary</a>
                </p>
            </div>

            <h1 class="h2 text-center mb-4 mt-3 main-heading" style="font-weight: 400">Collections Report <p class="report-type">per Date</p></h1>

            <div>
                <%
        
                    Response.Write("<p class='float-left'><strong> Date: </strong>")
                    Response.Write(displayDate1 & " - ")
                    Response.Write(displayDate2)
                    Response.Write "</p>"
                        
                %>
                <button id="printMe" class="btn btn-sm btn-light float-right mr-1">Print</button>
            </div>

            <div id="printData"> 

                <div class="print-main-heading">
                    <p class="print-heading-company">JollyChef Inc.</p> 
                    <p class="heading-print"> Collections Report per Customer/Date: <span class="date-range-print"> <%=displayDate1 & " to " & displayDate2 %></span>
                    </p>
                </div>

                <table class="table table-hover table-bordered table-sm" id="myTable">
                    <thead class="thead-bg">
                        <tr>
                            <th>Customer Name</th>
                            <th>Date</th>
                            <th>Amount</th>
                            <th>Cash</th>
                            <th>Charge</th>
                        </tr>
                    </thead>
                <%
                    Dim fs
                    set fs=Server.CreateObject("Scripting.FileSystemObject")

                    Dim collectID, cash_paid, ar_paid, custID, referenceNo

                    printTototal = false

                    Dim customerTotalAmount, customerTotalCash, customerTotalCharge
                    customerTotalAmount = 0
                    customerTotalCash = 0
                    customerTotalCharge = 0

                    Dim collectionsReportFile, prevCollectionsReportPath, collectionsReportPath

                    collectionsReportFile = "collections_report_container.dbf"
                    prevCollectionsReportPath = mainPath & "tbl_blank\" & collectionsReportFile
                    collectionsReportPath = tempFolderPath & collectionsReportFile

                    if fs.FolderExists(tempFolderPath) <> true then
                        fs.CreateFolder(tempFolderPath)
                    end if

                    Dim userSessionID
                    userSessionID = CDBL(Session.SessionID)

                    On Error Resume Next

                        if fs.FileExists(collectionsReportPath) then

                            fs.DeleteFile(collectionsReportPath)
                            
                        end if

                        if fs.FileExists(collectionsReportPath) <> true then 

                            fs.CopyFile prevCollectionsReportPath, collectionsReportPath
                        
                        end if

                    On Error GoTo 0

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

                            rs.Open "SELECT * FROM "&collectionsPath&" WHERE duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') GROUP BY id, cust_id ORDER BY cust_name, cust_id", CN2
                    
                            do until rs.EOF

                                insertCollections = insertCollections & "INSERT INTO "&collectionsReportPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate, session_id) "&_
                                "VALUES ("&rs("id")&", "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("department")&"', "&rs("invoice")&", '"&rs("ref_no")&"', ctod(["&rs("date")&"]), "&rs("tot_amount")&", "&rs("cash")&", "&rs("balance")&", '"&rs("p_method")&"', '"&rs("duplicate")&"', "&userSessionID&");"

                                rs.MoveNext

                            loop

                            rs.close

                        Loop While False  
                            
                    next  

                    'INSERTING Collections RECORDS'
                    if insertCollections <> "" then
                        cnroot.execute(insertCollections)
                    end if

                    if fs.FileExists(collectionsReportPath) = true then

                        'Start of Displaying reports'
                        rs.Open "SELECT cust_id, cust_name, date, SUM(tot_amount) AS tot_amount, SUM(cash) AS cash, p_method FROM "&collectionsReportPath&" WHERE session_id="&userSessionID&" and duplicate!='yes' and date between CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') GROUP BY date, cust_id, p_method ORDER BY cust_name, cust_id, date", CN2

                        Dim customerCounter, printBlankRow
                        customerCounter = 1
                        printBlankRow = false

                        do until rs.EOF 

                            Response.Flush
                            
                            totalSales = totalSales + CDBL(rs("tot_amount"))
                            paymentType = Trim(CSTR(rs("p_method")))

                            if custIdCont <> "" AND custIdCont <> CLNG(rs("cust_id")) then

                                isCustomerChanged = true
                                printTotal = true
                                printBlankRow = true
                                'customerCounter = 1

                            end if

                            'Same date'
                            if dateCont = "" or dateCont = CDATE(rs("date")) then
                                
                                'Same date but the customer has been changed'
                                if isCustomerChanged = true then%>

                                    <tr>
                                        <%if customerCounter < 2 then%>
                                            <td class="bold-text"><%=custName%></td>
                                        <%else%>
                                            <td></td>  
                                        <%end if%>
                                        <td><%=dateFormat%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>

                                    <%if printBlankRow = true then%>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                    <%
                                    printBlankRow = false
                                    end if

                                    isCustomerChanged = false
                                    customerTotalAmount = 0
                                    customerTotalCash = 0
                                    customerTotalCharge = 0
                                    customerCounter = 1

                                    'if Same date but no changing of customer => do nothing'

                                end if
                                

                            'Date has been changed'
                            else%>
                                
                                <!-- Date has been changed and also the customer -->
                                <%if isCustomerChanged = true then%>

                                    <tr>
                                        <%if customerCounter < 2 then%>
                                            <td class="bold-text"><%=custName%></td>
                                        <%else%>
                                            <td></td>
                                        <%end if%>
                                        <td><%=dateFormat%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>

                                    <%if printBlankRow = true then%>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                    <%
                                    printBlankRow = false
                                    end if

                                    isCustomerChanged = false
                                    customerTotalAmount = 0
                                    customerTotalCash = 0
                                    customerTotalCharge = 0
                                    customerCounter = 1

                                'Date has been changed but not the customer'
                                else%>

                                    <tr>
                                        <%if customerCounter < 2 then%>
                                            <td class="bold-text"><%=custName%></td>
                                        <%else%>
                                            <td></td>
                                        <%end if%>
                                        <td><%=dateFormat%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                        <td><span class="currency-sign">&#8369; </span><%=customerTotalCash%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>

                                    <%if printBlankRow = true then%>
                                        <tr>
                                            <td class="blank_row" colspan="7"></td>
                                        </tr>
                                    <%
                                    printBlankRow = false
                                    end if
                                    
                                    customerTotalAmount = 0
                                    customerTotalCash = 0
                                    customerTotalCharge = 0
                                    customerCounter = customerCounter + 1

                                end if

                            end if

                            custIdCont = CLNG(rs("cust_id"))
                            custName = TRIM(CSTR(rs("cust_name")))
                            'customerCounter = customerCounter + 1
                            dateCont = CDATE(rs("date"))

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
                            
                                if paymentType = "ar" then
                                    customerTotalCharge = customerTotalCharge + CDBL(rs("cash"))
                                    totalCharge = totalCharge + CDBL(rs("cash"))
                                else
                                    customerTotalCash = customerTotalCash + CDBL(rs("cash"))
                                    totalCash = totalCash + CDBL(rs("cash"))
                                end if

                            customerTotalAmount = customerTotalAmount + CDBL(rs("tot_amount"))    
                                
                            %>

                            <%rs.MoveNext

                                if rs.EOF then%>
                                    <tr> 
                                        <%if customerCounter = "" or customerCounter = 1 then%>
                                            <td class="bold-text"><%=custName%></td>
                                        <%else%>
                                            <td></td>
                                        <%end if%>
                                        <td><%=dateFormat%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalAmount%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCash%></td>
                                        <td><span class="currency-sign">&#8369;</span> <%=customerTotalCharge%></td>
                                    </tr>
                                <%end if

                                'Response.Write "<br>Customer Counter: " & customerCounter & "<br>"
                                i = i + 1
                        loop
                        rs.close
                        %>

                        <%if customerCounter > 1 then%>

                            <%if isTotalPrinted = false then%>
                                <tr class="final-total"> 
                                    <td>Total</td>
                                    <td></td>
                                    <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalSales%></td>
                                    <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalCash%></td>
                                    <td class="final-total"><span class="currency-sign">&#8369;</span> <%=totalCharge%></td>
                                </tr>  
                            <%end if%>

                        <%end if%>

                    <%end if%>        

                </table>

                <!-- DELETING sales_report_container -->
                <%  
                    if fs.FileExists(collectionsReportPath) = true then

                        deleteReport = "DELETE FROM "&collectionsReportPath&" WHERE session_id="&userSessionID
                        set objAccess = cnroot.execute(deleteReport)
                        set objAccess = nothing

                    end if

                    set rs = nothing
                    CN2.close
                    
                %>


            </div>
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
<script src="./js/print.js"></script> 

</body>
</html>