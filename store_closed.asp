<!--#include file="dbConnect.asp"-->

<%

    On Error Resume Next 

    Dim isClosed, currDate, isDayEnded

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile
    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" GROUP BY unique_num", CN2

    if not rs.EOF then

        Response.Write("<script>")
        Response.Write("alert('Invalid: There are pending orders. \n \t\t\t\t   Go to cashier order page or customers order')")
        Response.Write("</script>")
        isDayEnded = false

        rs.close

        if isDayEnded = false then
            Response.Write("<script>")
            Response.Write("window.location.href=""customers_order.asp"";")
            Response.Write("</script>")
        end if

    else
        
        rs.close
        if (Month(systemDate) <> Month(systemDate + 1)) then

            Response.Write("<script>")
            Response.Write("alert('Invalid: Needs to month end')")
            Response.Write("</script>")
            isDayEnded = false

            if isDayEnded = false then
                Response.Write("<script>")
                Response.Write("window.location.href=""sales_report_daily.asp"";")
                Response.Write("</script>")
            end if

        else 

            if Err.Number = 0 And CN2.Errors.Count = 0 Then

                sqlDateUpdate = "UPDATE system_date SET date = date + 1"
                cnroot.execute(sqlDateUpdate)
                'systemDate = systemDate + 1
                'Response.Write("Day end")    

                Dim maxSchedID
                rs.Open "SELECT MAX(sched_id) FROM store_schedule;", CN2
                    do until rs.EOF
                        for each x in rs.Fields
                            maxSchedID = x.value
                        next
                        rs.MoveNext
                    loop
                    maxSchedID = CInt(maxSchedID) + 1
                rs.close

                isClosed = CStr(Request.Form("isClosed"))
                systemDate = CStr(systemDate & " " & Time)
                if isClosed = "yes" then

                    sqlAdd = "INSERT INTO store_schedule (sched_id, date_time, status) VALUES ("&maxSchedID&",'"&systemDate&"', ""closed"")"
                    cnroot.execute(sqlAdd)
                    
                    CN2.close
                    Response.Redirect("cashier_order_page.asp")
                end if

            end if


            'Deleting temporary table of sales reports'
            Dim fs
            Set fs = Server.CreateObject("Scripting.FileSystemObject")

            tempSalesReportTbl = Server.MapPath("./temp_folder/sales_report_container.dbf")
            tempCollectionsReportTbl = Server.MapPath("./temp_folder/collections_report_container.dbf")
            
            if fs.FileExists(tempSalesReportTbl) then
                fs.DeleteFile(tempSalesReportTbl)
                ' if Err.Number = 0 then
                ' Response.Write "File was deleted"
                ' else
                ' Response.Write "<br> No permission to delete. Error: " & Err.description & "<br>"
                ' end if
            end if

            if fs.FileExists(tempCollectionsReportTbl) then
                fs.DeleteFile(tempCollectionsReportTbl)
            end if
            
            set fs=nothing

        end if

    end if
%>