<!--#include file="dbConnect.asp"-->

<%
    ' Dim str

    ' str = "string"
    ' Response.Write str
    ' str = left(str,len(str)-1)
    ' Response.Write str

    ' sqlInsert = "INSERT INTO test_tbl (id, str1, num1) VALUES (1, '1', 1) INSERT INTO test_tbl (id, str1, num1) VALUES (2, '2', 2)"

    ' Response.Write sqlInsert
    ' cnroot.execute(sqlInsert)

    ' num1 = "5"
    ' num2 = 3

    ' Response.Write num1 - num2

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

    ' rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.qty - (IIF(ISNULL(orders_holder.qty), 0, SUM(orders_holder.qty))) AS qty FROM daily_meals   LEFT JOIN 2020-10/orders_holder.dbf ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.status = 'Pending' OR orders_holder.status = 'On Process' GROUP BY daily_meals.prod_id", CN2
    ' rs.open "SELECT * FROM daily_meals", CN2
    'set objAccess = cnroot.execute(sqlGet)

   ' Get the total QTY in orders_holder TBL'
    ' rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, SUM(orders_holder.qty) AS qty FROM daily_meals JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.status = 'Pending' GROUP BY daily_meals.prod_id", CN2

    rs.open "SELECT daily_meals.prod_name, daily_meals.qty - SUM(orders_holder.qty) AS qty FROM daily_meals INNER JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id WHERE daily_meals.prod_id = 73", CN2

    if not rs.EOF then

        do until rs.EOF 
            for each x in rs.fields

                Response.Write x.name & ": " & x.value & "<br>"
                
            next
            Response.Write "<br>"
        rs.MoveNext
        loop

    else

        Response.Write "eyah"

    end if
    'objAccess.MoveNext

    

%>