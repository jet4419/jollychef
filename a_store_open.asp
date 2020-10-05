<!--#include file="dbConnect.asp"-->

<%
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

    currDateTime = CStr(Application("date") & " " & Time)
    sqlAdd = "INSERT INTO store_schedule (sched_id, date_time, status) VALUES ("&maxSchedID&",'"&currDateTime&"', ""open"")"
    cnroot.execute(sqlAdd)
    CN2.close
    Response.Redirect("cashier_order_page.asp")

%>