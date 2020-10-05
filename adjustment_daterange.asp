<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="tail.select-default.css">
    

        <style>
        
            span.option-description {
                font-size: .75rem !important;
                color: #007bff !important;
            }

            div.tail-select.no-classes {
                width: 400px !important;
            }

        </style>

        <!--
        <link rel="stylesheet" href="select2/css/select2.min.css">
        <script src="select2/js/select2.min.js"></script>
        -->
    </head>

<body>    
<script src="tail.select-master/js/tail.select-full.min.js"></script>
<%

    custID = CDbl(Request.Form("custID"))
    startDate = CDate(Request.Form("startDate"))
    endDate = CDate(Request.Form("endDate"))

    

    sqlGetInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
    set objAccess = cnroot.execute(sqlGetInfo)

    if not objAccess.EOF then

        cust_name = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
        department = Trim(objAccess("department").value)

    end if

    set objAccess = nothing
   ' CN2.close
   
%>    
        <!--<input type="number" class="form-control" name="arID" id="arID" value="<'%=arID%>" placeholder="ID" readonly> -->

    <div class="form-group">   
        <input type="text" name="department" id="department" value="<%=department%>" hidden>      
        <label class="ml-1" style="font-weight: 500"> Customer Name </label>
        <input type="text" class="form-control" name="cust_name" id="cust_name" value="<%=cust_name%>" readonly>
        <input type="hidden" name="cust_id" id="cust_id" value="<%=custID%>" >
    </div>

    <div class="form-group"> 
        <label class="ml-1 d-block" style="font-weight: 500"> Reference Number </label>
        <!--
        <select class="form-control select-adjustment" style="width: 100%" name="invoice_ref_no" placeholder="Select Invoice" required>
        -->
        <select id="ref_no" class="form-control mr-2" name="arInvoice" style="width:650px; "class="chzn-select" required placeholder="Select Invoice No.">
        <option value="" disabled selected>Select Available Invoice No.</option>
        <%
            Dim monthLength, monthPath, yearPath

            monthLength = Month(startDate)

            if Len(monthLength) = 1 then
                monthPath = "0" & CStr(Month(startDate))
            else
                monthPath = CStr(Month(startDate))
            end if

            yearPath = Year(startDate)

            Dim mainPath, transactionsFile, folderPath, transactionsPath

            mainPath = CStr(Application("main_path"))
            ' arFile = "\accounts_receivables.dbf"
            ' folderPath = mainPath & yearPath & "-" & monthPath
            ' arPath =  folderPath & arFile
            transactionsFile = "\transactions.dbf"
            folderPath = mainPath & yearPath & "-" & monthPath
            transactionsPath =  folderPath & transactionsFile

            rs.Open "SELECT invoice "&_
                    "FROM "&transactionsPath&" "&_
                    "WHERE duplicate!='yes' and t_type!='OTC' and cust_id="&custID&" AND date BETWEEN CTOD('"&startDate&"') AND CTOD('"&endDate&"') GROUP BY invoice", CN2

            if not rs.EOF then

                do until rs.EOF


                'ref_no = CStr(rs("ref_no"))
                invoice = CStr(rs("invoice"))
                ' arDate = CDate(rs("date_owed"))
                ' arDate = FormatDateTime(arDate,2)

        %>
                <option value="<%=invoice%>"> <%="Invoice No: "&invoice%> </option>
             <% rs.movenext%>  
             <% loop %>
        
           <% else %>
                 <option disabled> No Available Adjustments</option>
           <% end if             
            rs.close
        %>

        
    </select>
    </div>

<script>

    tail.select("#ref_no", {
        search: true,
        deselect: true,
        descriptions: true,
    });

</script>

</body>
</html>