<!--#include file="dbConnect.asp"-->

<!DOCTYPE html>
<html>

    <head>
        <!--
        <link rel="stylesheet" href="tail.select-master\css\default\tail.select-light-feather.min.css">
        -->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <style>

            span.option-description {
                /* font-size: .75rem !important; */
                color: #007bff !important;
            }

            div.tail-select.no-classes {
                width: 400px !important;
            }

        </style>
    </head>

<body>    
<script src="tail.select-master/js/tail.select-full.min.js"></script>
<%

    custID = CInt(Request.Form("custID"))

    sqlGetInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
    set objAccess = cnroot.execute(sqlGetInfo)

    if not objAccess.EOF then

        cust_name = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
        department = objAccess("department").value

    end if

    set objAccess = nothing
   ' CN2.close
   
%>
 
    <div class="form-group">    
        <label class="ml-1" style="font-weight: 500"> Customer ID </label>
        <input type="number" class="form-control" name="cust_id" id="cust_id" value="<%=custID%>" placeholder="ID" readonly>
    </div>    
        <!--<input type="number" class="form-control" name="arID" id="arID" value="<'%=arID%>" placeholder="ID" readonly> -->
    <div class="form-group">         
        <label class="ml-1" style="font-weight: 500"> Customer Name </label>
        <input type="text" class="form-control" name="cust_name" id="cust_name" value="<%=cust_name%>" readonly>
        <input type="hidden" name="department" id="department" value="<%=department%>">
    </div>

    <div class="form-group"> 
    <select id="selectRecords" class="form-control" name="date_records" placeholder="Select Date of Records" required>
        <option value="" disabled selected>Select Date of Records</option>
        <%
            Dim systemDate, isDayEnded
            systemDate = CDate(Application("date"))

            Dim mainPath, yearPath, monthPath

            mainPath = CStr(Application("main_path"))
            yearPath = Year(systemDate)
            monthPath = Month(systemDate)

            if Len(monthPath) = 1 then
                monthPath = "0" & CStr(monthPath)
            end if

            Dim obFile

            obFile = "\ob_test.dbf" 

            Dim obPath

            obPath = mainPath & yearPath & "-" & monthPath & obFile

            'status !='completed' means the transaction is still not month ended.
            rs.Open "SELECT MIN(date) AS first_date, MAX(date) AS end_date FROM "&obPath&" WHERE duplicate!='yes' and cust_id="&custID&" and status!=""completed""", CN2

            if not rs.EOF then
                currentSdate = CDate(rs("first_date"))
                currentEdate = CDate(rs("end_date"))
                'department = CStr(rs("department"))
                displaySdate = Day(currentSdate) & " " & MonthName(Month(currentSdate)) & " " & Year(currentSdate)
                displayEdate = Day(currentEdate) & " " & MonthName(Month(currentEdate)) & " " & Year(currentEdate) %>
                <option value="<%=currentSdate &","&currentEdate%>" data-description="<%="Current Date of Transactions"%>"> <%=""&displaySdate&" - "&displayEdate%> <!--<span>Current Date of Transactions</span>--></option>
                
           <% else %>
                 <option disabled> No Ongoing Records</option>
           <% end if             
            rs.close
        %>

        <%
            sqlAccess = "SELECT * FROM eb_test WHERE cust_id="&custID&" ORDER BY id DESC"
            set objAccess  = cnroot.execute(sqlAccess)	

            if not objAccess.EOF then 
                          
                do while not objAccess.eof 
                firstDate = CDate(objAccess("first_date"))
                displayDate1 = Day(firstDate) & " " & MonthName(Month(firstDate)) & " " & Year(firstDate)
                'firstDate = FormatDateTime(firstDate, 2)
                endDate = CDate(objAccess("end_date"))
                displayDate2 = Day(endDate) & " " & MonthName(Month(endDate)) & " " & Year(endDate)
                %>
                    <option value="<%=firstDate&","&endDate%>" data-description="<%="Month Ended Date"%>"> <%=""&displayDate1&" - "&displayDate2%> </option>
                    <%objaccess.movenext
                loop
                SET objAccess = nothing
            else %>
                <option disabled> No Completed Records </option>  
            <%end if  

        %>
    </select>
    </div>

<script>

    tail.select("#selectRecords", {
        search: true,
        deselect: true,
        descriptions: true
    });

</script>

</body>
</html>