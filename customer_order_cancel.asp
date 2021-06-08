<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    Dim isDayEnded

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

    Dim cashierID, uniqueNum

    cashierID = CInt(Request.Form("cashierID"))
    uniqueNum = CInt(Request.QueryString("unique_num"))


    ' Dim prodIDs, qtys
    ' rs.open "SELECT prod_id, prod_name, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE unique_num ="&uniqueNum&" GROUP BY prod_id", CN2
    
    ' do until rs.EOF

    '     prodIDs = prodIDs & rs("prod_id").value & ","
    '     qtys = qtys & rs("qty").value & ","

    ' rs.movenext
    ' loop

    ' rs.close

    ' 'Response.Write(prodIDs & "<br>" & qtys & "<br>")
    ' prodIDs = Split(prodIDs, ",")
    ' qtys = Split(qtys, ",")
    ' 'Response.Write(prodIDs(0) & "<br>" & qtys(0) & "<br>")

    ' for i=0 to Ubound(prodIDs) - 1

    '     sqlUpdate = "UPDATE daily_meals SET qty = qty + " &qtys(i)& " WHERE prod_id="&prodIDs(i) 
    '     cnroot.execute(sqlUpdate)

    ' next
	
    sqlUpdate = "UPDATE "&ordersHolderPath&" SET cashier_id="&cashierID&", status= 'Cancelled', is_edited = 'true' WHERE unique_num="&uniqueNum

    set objAccess = cnroot.execute(sqlUpdate)
    set objAccess = nothing

	' rs.open "SELECT * FROM "&ordersHolderPath&"", CN2
	' sqlDelete = "DELETE FROM "&ordersHolderPath&" WHERE unique_num="&uniqueNum
	' set objAccess  = cnroot.execute(sqlDelete)
	' set objAccess = nothing

	if err<>0 THEN
		Response.Write("<script language=""javascript"">")
        Response.Write("alert('Error: No update permission!')")
        Response.Write("</script>")
        isError = true

        'rs.close
        CN2.close

        if isError = true then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""customers_order.asp"";")
            Response.Write("</script>")
        end If
	else
    	
        'rs.close 
        CN2.close
        Response.Write("<script language=""javascript"">")
        Response.Write("alert('Order has been cancelled successfully!')")
        Response.Write("</script>")
        isProcessed = true

        if isProcessed = true then
        ' Response.Redirect("bootSales.asp")
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""customers_order.asp"";")
            Response.Write("</script>")
        end If

  	end if



%>
