<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

    Dim fs, custID

    custID = CLng(Request.Form("custID"))
    ' orderDate = Request.Form("orderDate")

    Set fs=Server.CreateObject("Scripting.FileSystemObject")

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

    Dim isOrdersHolderExist
    isOrdersHolderExist = fs.FolderExists(ordersHolderPath)

    Dim i
    i = 0

        Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

        'if isOrdersHolderExist = true then

            getOrders = "SELECT invoice_no, unique_num, cust_name, prod_name, price, upd_price, qty, upd_qty, amount, upd_amount, status, is_added FROM "&ordersHolderPath&" WHERE (is_edited='true' OR is_added='true') AND cust_id="&custID&" ORDER BY unique_num"
            set objAccess = cnroot.execute(getOrders)

            do until objAccess.EOF

                .Add i, oJSON.Collection()
                With .item(i)      
                    .Add "invoiceNo", CLng(objAccess("invoice_no").value)
                    .Add "uniqueNum", CLng(objAccess("unique_num").value)
                    .Add "customerName", CStr(objAccess("cust_name").value)
                    .Add "prodName", CStr(objAccess("prod_name").value)
                    .Add "price", CDbl(objAccess("price").value)
                    .Add "updPrice", CDbl(objAccess("upd_price").value)
                    .Add "qty", CLng(objAccess("qty").value)
                    .Add "updQty", CLng(objAccess("upd_qty").value)
                    .Add "amount", CDbl(objAccess("amount").value)
                    .Add "updAmount", CDbl(objAccess("upd_amount").value)
                    .Add "status", CStr(objAccess("status").value)
                    .Add "isAdded", CStr(objAccess("is_added").value)
                End With

                i = i + 1

                objAccess.MoveNext
            loop

        'end if

            End With

    Response.Write(oJSON.JSONoutput())


%>