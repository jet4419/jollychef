<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="tail.select-default.css">
    

        <style>
            
            div.tail-select.no-classes {
                width: 400px !important;
            }

            span.option-description {
                font-size: .75rem !important;
                color: #007bff !important;
            }

        </style>
    </head>

<body>    
<script src="tail.select-master/js/tail.select-full.min.js"></script>
 
    <div class="form-group"> 
        <select id="selectRecords" class="form-control" name="ob_report_date" placeholder="Select Date of Records" required>
            <option value="" disabled selected>Select Date of Records</option>

            <%
                Dim yearPath, monthPath

                yearPath = CStr(Year(systemDate))
                monthPath = CStr(Month(systemDate))

                if Len(monthPath) = 1 then
                    monthPath = "0" & monthPath
                end if

                Dim arFile 

                folderPath = mainPath & yearPath & "-" & monthPath
                arFile = "\accounts_receivables.dbf"
                arPath = folderPath & arFile

                rs.Open "SELECT TOP 1 balance FROM "&arPath&" WHERE balance!=0 ORDER BY balance DESC", CN2

                if not rs.EOF then
                    obDate = systemDate
                    'department = CStr(rs("department"))
                    displayObDate = MonthName(Month(obDate)) & " " & Year(obDate) %>
                    <option value="<%=obDate%>" data-description="<%="Current Date of Transactions"%>"> <%=displayObDate%> <!--<span>Current Date of Transactions</span>--></option>
                    
            <% else %>
                    <option disabled> No Ongoing Records</option>
            <% end if             
                rs.close
            %>

            <%
                Dim fs
                Set fs = Server.CreateObject("Scripting.FileSystemObject")

                Dim ebFile, ebPath, ebMonthPath, ebYearPath, ebFolderPath, counter

                ebMonthPath = monthPath
                ebYearPath = yearPath
                ebFile = "\eb_test.dbf"
                ebFolderPath = mainPath & yearPath & "-" & monthPath
                ebPath = folderPath & ebFile
                counter = 0

                Do
                    
                    if fs.FolderExists(ebFolderPath) <> true then EXIT DO
                    if fs.FileExists(ebPath) <> true then EXIT DO

                    sqlAccess = "SELECT end_date FROM "&ebPath&" GROUP BY end_date ORDER BY end_date DESC"
                    set objAccess  = cnroot.execute(sqlAccess)	


                    if not objAccess.EOF then 
                        
                        counter = counter + 1

                        do while not objAccess.eof 

                            endDate = CDate(objAccess("end_date"))
                            displayDate = MonthName(Month(endDate)) & " " & Year(endDate)%>
                                <option value="<%=endDate%>" data-description="<%="Month Ended Date"%>"> <%=displayDate%> </option>
                            <%objaccess.movenext
                        loop

                        SET objAccess = nothing
                        
                    end if  

                    ebMonthPath = CINT(ebMonthPath) - 1

                    if ebMonthPath = 0 then
                        ebYearPath = CINT(ebYearPath) - 1
                    end if

                    if LEN(ebMonthPath) = 1 then
                        ebMonthPath = "0" & ebMonthPath
                    end if

                    ebFolderPath = mainPath & ebYearPath & "-" & ebMonthPath
                    ebPath = ebFolderPath & ebFile

                Loop While False
            %>

                <%if counter = 0 then%>
                    <option disabled> No Completed Records </option>
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
<!-- git branch fix-eb-tbl-flow -->