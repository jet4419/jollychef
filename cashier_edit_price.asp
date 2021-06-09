<!--#include file="dbConnect.asp"-->

<%

    Dim cashierID, customerID, prodID, uniqueNum, newPrice

    cashierID = CInt(Request.Form("cashierID"))
    customerID = 0
    prodID = CInt(Request.Form("prodID"))
    uniqueNum = 0
    newPrice = CDbl(Request.Form("newPrice"))

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

    sqlGetQty = "SELECT upd_qty FROM "&ordersHolderPath&" WHERE id="&prodID
    set objAccess = cnroot.execute(sqlGetQty)

    Dim prodQty

    if not objAccess.EOF then
        prodQty = CDbl(objAccess("upd_qty").value)
    end if

    if uniqueNum = 0 and customerID = 0 and prodID > 0 and newPrice > 0 then

        sqlUpdate = "UPDATE "&ordersHolderPath&" SET upd_price = "&newPrice&", upd_amount = "&newPrice&" * upd_qty, cashier_id = "&cashierID&", is_edited='true' WHERE cust_id="&customerID&" AND id="&prodID&" AND unique_num = "&uniqueNum&" AND status=""On Process"""
        set objAccess = cnroot.execute(sqlUpdate)

        Response.Write prodQty

    else

        Response.Write "data not updated"

    end if


%>