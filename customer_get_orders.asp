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

    Dim custID
    custID = CLng(Request.Form("custID"))

    if custID <> "" then
        rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""Pending"" and cust_id="&custID, CN2
    else
        rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""Pending"" and cust_id=-100", CN2
    end if

    Dim i
    i = 0

    if not rs.EOF then

        Set oJSON = New aspJSON

        With oJSON.data

        oJSON.Collection()

            do until rs.EOF

                orderProdID = CInt(rs("prod_id"))
                orderQty = CInt(rs("qty"))

                checkQty = "SELECT prod_id, qty FROM daily_meals WHERE prod_id ="&orderProdID
                set objAccess = cnroot.execute(checkQty)

                if not objAccess.EOF then

                    currentQty = CInt(objAccess("qty").value) - orderQty

                end if

                .Add i, oJSON.Collection()
                With .item(i)       
                    .Add "id", CLng(rs("id").value)
                    .Add "prodBrand", CStr(rs("prod_brand").value)
                    .Add "prodName", CStr(rs("prod_name").value)
                    .Add "price", CDbl(rs("price").value)
                    .Add "qty", CLng(rs("qty").value)
                    .Add "amount", CDbl(rs("amount").value)

                    if currentQty < 0 then
                        .Add "isValidQty", "false"
                    else
                        .Add "isValidQty", "true"
                    end if


                End With

                i = i + 1

                rs.MoveNext

            loop
        
        End With

        Response.Write(oJSON.JSONoutput())

    else 

        Response.Write "no data"

    end if 





%>