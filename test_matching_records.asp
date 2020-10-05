<!--#include file="dbConnect.asp"-->

<%  
'     SELECT test1.* FROM test1 INNER JOIN test2 ON test1.name = test2.name 
' AND test1.age <> test2.age 

' SELECT test1.id as id1, test2.id as id2, test1.name, test1.age as age1, test2.age as age2
' FROM test1,test2
' WHERE test1.name = test2.name 
' AND test1.age != test2.age

    ' rs.open "SELECT Products.prod_id AS id1, Products.prod_name AS prod1, Daily_Meals.prod_id AS id2, Daily_Meals.prod_name AS prod2 "&_
    '         "FROM Products, Daily_Meals "&_
    '         "WHERE Products.prod_id != Daily_Meals.prod_id",CN2

    rs.open "select prod_id, prod_name from products WHERE products.fix_menu='no' and products.prod_id NOT IN (select prod_id from daily_meals) ORDER BY prod_id",CN2

            do until rs.EOF

                for each x in rs.fields
                    Response.Write  x.name & " - " & x.value & "<br>"
                next
                rs.movenext
            loop

    ' rs.open "SELECT COUNT(prod_id) AS count FROM products WHERE", CN2

    ' if not rs.EOF then
    '     response.write(rs("count"))
    ' end if

    rs.close

%>