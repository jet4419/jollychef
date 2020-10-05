<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->
<!--#include file="session_cashier.asp"-->
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

Dim ordersHolderFile

ordersHolderFile = "\orders_holder.dbf" 

Dim ordersHolderPath

ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

Dim orderID, orderNumber

orderID = Request.Form("orderID")
orderNumber = Request.Form("orderNumber")
hasNewData = true

    if orderID = "" then
        hasNewData = false
    end if

    if orderNumber = "" then
        hasNewData = false
    end if


    if hasNewData = true then 

        rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" and id > "&orderID&" GROUP BY unique_num", CN2

        Dim i
        i = 0
        
        

        if not rs.EOF then

            Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

                    do until rs.EOF        

                    'Response.Write("<tr>")

                        orderNumber = orderNumber + 1

                        .Add i, oJSON.Collection()
                        With .item(i)
                            .Add "id", CLng(rs("id").value)
                            .Add "orderNumber", orderNumber
                            .Add "uniqueNum", CLng(rs("unique_num").value)
                            .Add "custID", CLng(rs("cust_id").value)
                            .Add "custName", CStr(rs("cust_name").value)
                            .Add "department", CStr(rs("department").value)
                            .Add "amount", CDbl(rs("amount").value)
                            .Add "date", CDate(rs("date").value)
                        End With

                        i = i + 1

                        rs.movenext

                    loop 

            End With
            
            Response.Write(oJSON.JSONoutput())                   'Return json string

        else

            Response.Write("no new data")

        end if  

        rs.close 
        CN2.close

    else
        Response.Write("no new data")
    end if
    
%>