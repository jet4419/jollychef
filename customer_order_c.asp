<!--#include file="dbConnect.asp"-->

<%

if Request.Form("customerID") = "" then

    Response.Write("<script language=""javascript"">")
    Response.Write("window.location.href=""customer_ordering_page.asp"";")
    Response.Write("</script>")

end if

customerID = CInt(Request.Form("customerID"))



Dim yearPath, monthPath

yearPath = CStr(Year(systemDate))
monthPath = CStr(Month(systemDate))

if Len(monthPath) = 1 then
    monthPath = "0" & monthPath
end if

Dim folderPath

folderPath = mainPath & yearPath & "-" & monthPath

Dim ordersHolderFile, ordersHolderPath, newQty, isProcessed
newQty = 0
isProcessed = true

ordersHolderFile = "\orders_holder.dbf"
ordersHolderPath = folderPath & ordersHolderFile

rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.qty AS qty1, SUM(orders_holder.qty) AS qty2 FROM daily_meals JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.status = 'Pending' AND orders_holder.cust_id="&customerID&" GROUP BY daily_meals.prod_id", CN2


'Check if the ordered QTY is valid'
if not rs.EOF then

    do until rs.EOF 

        newQty = CLng(rs("qty1")) - CLng(rs("qty2"))

        if newQty < 0 then

            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Error: Insufficient product stock!')")
            Response.Write("</script>")
            isProcessed = false

            if isProcessed = false then

                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""customer_ordering_page.asp"";")
                Response.Write("</script>")

            end if

        ' else

        '     sqlDailyMeal = "UPDATE daily_meals SET qty = qty - "&CLng(rs("qty2"))&" WHERE prod_id="&rs("prod_id")
        '     cnroot.execute(sqlDailyMeal)

        end if
    
    rs.MoveNext
    loop

else
    isProcessed = false
end if

rs.close
set objAccess = nothing
'END OF DECREASING THE ORDERED PRODUCTS QTY'

if isProcessed = true then

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
    sqlHolderUpdate = "UPDATE "&ordersHolderPath&" SET status=""On Process"", unique_num="&maxUniqueNum&", date = CTOD('"&systemDate&"') WHERE cust_id="&customerID&" and status=""Pending"""
    set objAccess = cnroot.execute(sqlHolderUpdate)
    set objAccess = nothing
    'END OF SENDING ORDERS TO CASHIER'

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Your order is on the process!')")
    Response.Write("</script>")
    isValidTransact = false

    if isValidTransact = false then
    ' Response.Redirect("bootSales.asp")
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""customer_ordering_page.asp"";")
        Response.Write("</script>")
    end If
    'Response.Redirect("a_sales.asp")
else

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Sorry, Invalid transactions')")
    Response.Write("</script>")
    isAdded = true
    'invoiceNumber = invoiceNumber + 1
    if isAdded = true then
    ' Response.Redirect("bootSales.asp")
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""customer_ordering_page.asp"";")
        Response.Write("</script>")
    end If

end if

%>