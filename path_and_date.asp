<!--#include file="dbConnect.asp"-->
<%

    sqlGetDate = "SELECT MAX(date) AS date FROM system_date" 
    set objAccess = cnroot.execute(sqlGetDate)

    sqlGetDate = "SELECT MAX(date) AS date FROM system_date" 
    set objAccess = cnroot.execute(sqlGetDate)

    if not objAccess.EOF then
        systemDate = CDate(objAccess("date").value)
    else
        systemDate = CDate(Date)
    end if  

    sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
        set objAccess = cnroot.execute(sqlQuery)
            Dim currDate, maxDailyDate, schedID, dateClosed, isStoreClosed
            currDate = systemDate

            if not objAccess.EOF then
                schedID = CInt(objAccess("sched_id"))
                isStoreClosed = CStr(objAccess("status"))
                dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
                'currDate = CDate(Date)
            else
                isStoreClosed = "open"
                dateClosed = CDate(Date)
                'currDate = CDate(Date)
            end if

        set objAccess = nothing

        if dateClosed < currDate then
            sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
            cnroot.execute(sqlUpdate)
        end if
        




%>