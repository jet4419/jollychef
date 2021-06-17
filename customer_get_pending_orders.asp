<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

Dim custID

custID = CLng(Request.Form("custID"))

Dim yearPath, monthPath

yearPath = CStr(Year(systemDate))
monthPath = CStr(Month(systemDate))


if Len(monthPath) = 1 then
    monthPath = "0" & monthPath
end if

Dim ordersHolderFile
ordersHolderFile = "\orders_holder.dbf"

Dim ordersHolderPath
ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

rs.Open "SELECT DISTINCT unique_num, cust_id, cust_name, department, SUM(upd_amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" and cust_id="&custID&" GROUP BY unique_num", CN2 

Dim i, orderNumber
i = 0
orderNumber = 0

Set oJSON = New aspJSON

if not rs.EOF then 

    With oJSON.data

    oJSON.Collection() 

    do until rs.EOF

        orderNumber = orderNumber + 1

        .Add i, oJSON.Collection()
        With .item(i)
            .Add "orderNumber", orderNumber
            .Add "uniqueNum", CLng(rs("unique_num").value)
            .Add "custID", CLng(rs("cust_id").value)
            .Add "custName", CStr(rs("cust_name").value)
            .Add "department", CStr(rs("department").value)
            .Add "amount", CDbl(rs("amount").value)
            .Add "date", CDate(FormatDateTime(rs("date").value, 2))
        End With

        i = i + 1

        rs.MoveNext

    loop

    End With

    Response.Write(oJSON.JSONoutput())

    

else    

    Response.Write(oJSON.JSONoutput())

end if

    rs.close
    CN2.close
%>