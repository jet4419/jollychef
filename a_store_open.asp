<!--#include file="dbConnect.asp"-->

<%
    
    'Deleting temporary table of sales reports'
    Dim fs
    Set fs = Server.CreateObject("Scripting.FileSystemObject")

    tempSalesReportTbl = Server.MapPath("./temp_folder/sales_report_container.dbf")
    tempCollectionsReportTbl = Server.MapPath("./temp_folder/collections_report_container.dbf")
    
    if fs.FileExists(tempSalesReportTbl) then

        On Error Resume Next 

            fs.DeleteFile(tempSalesReportTbl)

        On Error GoTo 0
        ' if Err.Number = 0 then
        ' Response.Write "File was deleted"
        ' else
        ' Response.Write "<br> No permission to delete. Error: " & Err.description & "<br>"
        ' end if
    end if

    if fs.FileExists(tempSalesReportTbl) then

        if fs.FileExists(tempCollectionsReportTbl) then

            On Error Resume Next 
                fs.DeleteFile(tempCollectionsReportTbl)
            On Error GoTo 0
            
        end if
        
        set fs=nothing

    end if

    Dim currDateTime, maxSchedID

    maxSchedID = 0
    rs.Open "SELECT MAX(sched_id) FROM store_schedule;", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxSchedID = x.value
            next
            rs.MoveNext
        loop
        maxSchedID = CInt(maxSchedID) + 1
    rs.close

    currDateTime = CStr(systemDate & " " & Time)
    sqlAdd = "INSERT INTO store_schedule (sched_id, date_time, status) VALUES ("&maxSchedID&",'"&currDateTime&"', ""open"")"
    cnroot.execute(sqlAdd)
    CN2.close
    Response.Redirect("cashier_order_page.asp")

%>