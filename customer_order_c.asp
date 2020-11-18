<!--#include file="dbConnect.asp"-->

<%
customerID = CInt(Request.Form("customerID"))

rs.Open "SELECT * FROM daily_meals", CN2

Dim yearPath, monthPath

yearPath = CStr(Year(systemDate))
monthPath = CStr(Month(systemDate))

if Len(monthPath) = 1 then
    monthPath = "0" & monthPath
end if

Dim folderPath

folderPath = mainPath & yearPath & "-" & monthPath

Dim ordersHolderFile, ordersHolderPath

ordersHolderFile = "\orders_holder.dbf"
ordersHolderPath = folderPath & ordersHolderFile

sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""Pending"" and cust_id="&customerID&" GROUP BY prod_id" 
set objAccess  = cnroot.execute(sqlAccess)

'DECREASING THE ORDERED PRODUCTS QTY'
if objAccess.EOF >= 0 then

    do until objAccess.EOF

        do until rs.EOF

            if CInt(objAccess("prod_id")) = CInt(rs("prod_id")) then 

                currQty = CInt(rs("qty")) - CInt(objAccess("qty"))

                if CInt(currQty) < 0 then

                    Response.Write("<script language=""javascript"">")
                    Response.Write("alert('Error: Insufficient product stock!')")
                    Response.Write("</script>")
                    isProcessed = false

                    If isProcessed = false then

                        Response.Write("<script language=""javascript"">")
                        Response.Write("window.location.href=""customer_ordering_page.asp"";")
                        Response.Write("</script>")

                    end If
                
                else

                    sqlDailyMeal = "UPDATE daily_meals SET qty="&currQty&" WHERE prod_id="&rs("prod_id")
                    cnroot.execute(sqlDailyMeal)
                    Exit Do 

                end if

            end if  
                
            rs.MoveNext
            

        loop
        objAccess.MoveNext
    loop


end if

rs.close
set objAccess = nothing
'END OF DECREASING THE ORDERED PRODUCTS QTY'

rs.open "SELECT MAX(unique_num) AS unique_num FROM "&ordersHolderPath&"", CN2
    do until rs.EOF
        for each x in rs.Fields
            maxUniqueNum = x.value
        next
    rs.MoveNext
    loop
    rs.close
    maxUniqueNum = CInt(maxUniqueNum) + 1

'SENDING ORDERS TO CASHIER'
    sqlHolderUpdate = "UPDATE "&ordersHolderPath&" SET status=""On Process"", unique_num="&maxUniqueNum&" WHERE cust_id="&customerID&" and status=""Pending"""
    set objAccess = cnroot.execute(sqlHolderUpdate)
    set objAccess = nothing
'END OF SENDING ORDERS TO CASHIER'

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Your order is on the process!')")
    Response.Write("</script>")
    isAdded = true
    'invoiceNumber = invoiceNumber + 1
    If isAdded = true then
    ' Response.Redirect("bootSales.asp")
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""customer_ordering_page.asp"";")
        Response.Write("</script>")
    end If
    'Response.Redirect("a_sales.asp")
%>