<!--#include file="dbConnect.asp"-->

<%

    Dim prodID, cashierID, qty

    prodID = CInt(Request.Form("prodID"))
    cashierID = CInt(Request.Form("cashierID"))
    qty = CInt(Request.Form("qty"))

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

    if qty > 0 and cashierID > 0 and prodID > 0 then

        sqlUpdate = "UPDATE "&ordersHolderPath&" SET qty = "&qty&" WHERE cashier_id="&cashierID&" AND cust_id=0 AND id="&prodID
        set objAccess = cnroot.execute(sqlUpdate)

        Response.Write "data updated"

    else

        Response.Write "data not updated"

    end if


%>