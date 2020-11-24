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
            width: 70% !important;
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
    <select id="selectRecords" class="form-control" name="date_records" placeholder="Select Credit Date" required>
        <option value="" disabled selected>Credit Date</option>
        <%

            Dim monthLength, monthPath, yearPath

            monthLength = Month(systemDate)
            if Len(monthLength) = 1 then
                monthPath = "0" & CStr(Month(systemDate))
            else
                monthPath = Month(systemDate)
            end if

            yearPath = Year(systemDate)

            Dim arFile, arFolderPath, arPath

            arFile = "\accounts_receivables.dbf"
            arFolderPath = mainPath & yearPath & "-" & monthPath
            arPath = arFolderPath & arFile

            Dim isThereBalance
            isThereBalance = false

            Dim fs
            Set fs=Server.CreateObject("Scripting.FileSystemObject")

            ' Response.Write fs.FolderExists(arFolderPath) = true AND fs.FileExists(arPath) = true
            
            'This will loop until to the very last end of generated table'
            'to check if there's a remaining balance'
            do until fs.FolderExists(arFolderPath) = false or _ 
                     fs.FileExists(arPath) = false
            
                getCreditMonth = "SELECT CMONTH(date_owed) AS m_string, Year(date_owed) AS y_str, MONTH(date_owed) AS m_number FROM "&arPath&" WHERE balance > 0 DISTINCT GROUP BY date_owed"

                set objAccess = cnroot.execute(getCreditMonth)
                Response.Write objAccess("m_string").value

                do until objAccess.EOF 
                    
                    monthStr = CStr(objAccess("m_string").value)
                    yearStr = CSTr(objAccess("y_str").value)
                    monthNum = CStr(objAccess("m_number").value)

                    if Len(monthNum) = 1 then
                        monthNum = "0" & monthNum
                    end if %>

                    <option value="<%=yearStr &"-"&monthNum%>" data-description="<%="Current Credit Date"%>"> <%=monthStr & " " & yearStr%> <!--<span>Current Date of Transactions</span>--></option>
                   <%objAccess.MoveNext

                    isThereBalance = true

                loop

                    monthPath = monthPath - 1

                    if monthPath = 0 then
                        monthPath = 12
                        yearPath = yearPath - 1
                    end if
                    
                    if Len(monthPath) = 1 then
                        monthPath = "0" & monthPath
                    end if

                    arFolderPath = mainPath & yearPath & "-" & monthPath 
                    arPath = arFolderPath & arFile

            loop
            
            if isThereBalance = false then%>
                <option disabled> No Credits </option>  
            <%end if%>    
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