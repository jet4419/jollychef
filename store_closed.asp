<!--#include file="dbConnect.asp"-->

<%

    Dim isClosed, currDate, systemDate, isDayEnded
    systemDate = CDate(Application("date"))

    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile
    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" OR status=""Pending"" GROUP BY unique_num", CN2

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

            sqlDateUpdate = "UPDATE system_date SET date = date + 1"
            cnroot.execute(sqlDateUpdate)
            Application("date") = CDate(Application("date")) + 1
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

    end if
%>