<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->
<%

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

    Dim cashierID
    cashierID = CLng(Request.Form("cashierID"))

    if cashierID <> "" then

        rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.prod_price, daily_meals.qty - (IIF(ISNULL(orders_holder.qty), 0, SUM(orders_holder.qty))) AS qty, daily_meals.category, orders_holder.id FROM daily_meals LEFT JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND (orders_holder.status = 'Pending' OR orders_holder.status = 'On Process') AND orders_holder.cashier_id = "&cashierID&" GROUP BY daily_meals.prod_id ORDER BY daily_meals.prod_brand, daily_meals.prod_name", CN2

        if not rs.EOF then

            Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

            Dim i
            i = 0

                do until rs.EOF 

                    .Add i, oJSON.Collection()
                
                    With .item(i)    

                        .Add "prodID", CLng(rs("prod_id").value)
                        .Add "prodName", CStr(rs("prod_name").value)
                        .Add "prodPrice", CDbl(rs("prod_price").value)
                        .Add "qty", CLng(rs("qty").value)
                        .Add "category", Trim(rs("category").value)

                    End With

                    i = i + 1

                    rs.MoveNext

                loop

            End With

            Response.Write(oJSON.JSONoutput())

        else
            Response.Write("no meals")
        end if

    else
        
        Response.Write("invalid customer")

    end if

%>