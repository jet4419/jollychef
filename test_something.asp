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

    sqlGet = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM daily_meals WHERE EXISTS IN (SELECT prod_id, qty FROM products WHERE products.prod_id = daily_meals.prod_id)"
    set objAccess = cnroot.execute(sqlGet)

    for each x in objAccess.fields

        Response.Write x.name & ": " & x.value & "<br>"

        objAccess.movenext
    next

    

%>