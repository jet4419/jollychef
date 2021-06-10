<!--#include file="dbConnect.asp"-->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>

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
    %>
    
        <div class="table-responsive-sm mt-4">
            <table class="table table-bordered table-sm" id="myTable">
                <thead class="thead-dark">
                    <th>Unique Num</th>
                    <th>Customer</th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Editted Price</th>
                    <th>Amount</th>
                    <th>Editted Amount</th>
                    <th>Qty</th>
                    <th>Editted Qty</th>
                    <th>Status</th>
                    <th>Is Added</th>
                </thead>

                <tbody>

                    <%

                    rs.open "SELECT unique_num, cust_name, prod_name, price, upd_price, qty, upd_qty, amount, upd_amount, status, is_added FROM "&ordersHolderPath&" WHERE (is_edited='true' OR is_added='true') AND cust_id=9 ORDER BY unique_num", CN2
                    
                    do until rs.EOF%>

                        <tr>

                        <%for each x in rs.fields%>

                            <td> <%=x.value%></td>

                        <%next%>

                        </tr>

                        <%rs.movenext
                    loop

                    rs.close

                    
                    %>

                </tbody>

            </table>
        </div>


</body>
</html>



