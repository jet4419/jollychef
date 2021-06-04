<!--#include file="dbConnect.asp"-->


<%

    Dim prodID, cashierID, qty

    ' prodID = CInt(Request.Form("prodID"))
    ' cashierID = CInt(Request.Form("cashierID"))
    ' qty = CInt(Request.Form("qty"))

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

    rs.open "UPDATE "&ordersHolderPath&" SET qty=10 WHERE prod_id=-1000", CN2
    'set objAccess = cnroot.execute(sqlUpdate)

    for each objErr in CN2.Errors
        response.write("<p>")
        response.write("Description: ")
        response.write(objErr.Description & "<br>")
        response.write("Help context: ")
        response.write(objErr.HelpContext & "<br>")
        response.write("Help file: ")
        response.write(objErr.HelpFile & "<br>")
        response.write("Native error: ")
        response.write(objErr.NativeError & "<br>")
        response.write("Error number: ")
        response.write(objErr.Number & "<br>")
        response.write("Error source: ")
        response.write(objErr.Source & "<br>")
        response.write("SQL state: ")
        response.write(objErr.SQLState & "<br>")
        response.write("</p>")
    next





%>