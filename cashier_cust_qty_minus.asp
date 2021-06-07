<!--#include file="dbConnect.asp"-->

<%

    Dim cashierID, prodID, customerID, qty

    cashierID = CInt(Request.Form("cashierID"))
    prodID = CInt(Request.Form("prodID"))
    customerID = CInt(Request.Form("custID"))
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

    sqlGetPrice = "SELECT upd_price FROM "&ordersHolderPath&" WHERE id="&prodID
    set objAccess = cnroot.execute(sqlGetPrice)

    Dim prodPrice

    if not objAccess.EOF then
        prodPrice = CDbl(objAccess("upd_price").value)
    end if

    if qty > 0 and customerID > 0 and prodID > 0 then

        sqlUpdate = "UPDATE "&ordersHolderPath&" SET upd_qty = upd_qty - 1, upd_amount = upd_amount - upd_price, cashier_id = "&cashierID&", is_edited = 'true' WHERE cust_id="&customerID&" AND id="&prodID&" AND status=""On Process"""
        set objAccess = cnroot.execute(sqlUpdate)

        Response.Write prodPrice

    else

        Response.Write "data not updated"

    end if


%>