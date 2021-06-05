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

    sqlGetPrice = "SELECT price FROM "&ordersHolderPath&" WHERE id="&prodID
    set objAccess = cnroot.execute(sqlGetPrice)

    Dim prodPrice

    if not objAccess.EOF then
        prodPrice = CDbl(objAccess("price").value)
    end if

    if qty > 0 and cashierID > 0 and prodID > 0 then

        sqlUpdate = "UPDATE "&ordersHolderPath&" SET qty = "&qty&", amount = amount + price WHERE cashier_id="&cashierID&" AND cust_id=0 AND id="&prodID
        set objAccess = cnroot.execute(sqlUpdate)

        Response.Write prodPrice

    else

        Response.Write "data not updated"

    end if


%>