<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%
    Dim mainPath, yearPath, monthPath, systemDate

    systemDate = CDate(Application("date"))
    mainPath = CStr(Application("main_path"))
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

            .Add i, oJSON.Collection()
            With .item(i)       
                .Add "id", CLng(rs("id").value)
                .Add "prodBrand", CStr(rs("prod_brand").value)
                .Add "prodName", CStr(rs("prod_name").value)
                .Add "price", CDbl(rs("price").value)
                .Add "qty", CLng(rs("qty").value)
                .Add "amount", CDbl(rs("amount").value)
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