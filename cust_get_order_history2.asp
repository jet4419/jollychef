<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

    Dim fs

    ' custID = CLng(Request.Form("custID"))
    ' orderDate = Request.Form("orderDate")

    Set fs=Server.CreateObject("Scripting.FileSystemObject")

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)


    'Start
        startDate = Request.Form("startDate")
        endDate = Request.Form("endDate")

        if startDate="" then

            queryDate1 = CDate(FormatDateTime(systemDate, 2))
            displayDate1 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else

            queryDate1 = CDate(FormatDateTime(startDate, 2))
            displayDate1 = MonthName(Month(queryDate1)) & " " & Day(queryDate1) & ", " & Year(queryDate1)

        end if   

        if endDate="" then

            queryDate2 = CDate(FormatDateTime(systemDate, 2))
            displayDate2 = MonthName(Month(systemDate)) & " " & Day(systemDate) & ", " & Year(systemDate)

        else 

            queryDate2 = CDate(FormatDateTime(endDate, 2))
            displayDate2 = MonthName(Month(endDate)) & " " & Day(endDate) & ", " & Year(endDate)

        end if   

        Dim monthsDiff

        monthsDiff = DateDiff("m",queryDate1,queryDate2) 
    'End

    ' if Len(monthPath) = 1 then
    '     monthPath = "0" & CStr(monthPath)
    ' end if

    Dim ordersHolderFile

    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ' Dim isOrdersHolderExist
    ' isOrdersHolderExist = fs.FolderExists(ordersHolderPath)

    Dim counter
    counter = 0

        Set oJSON = New aspJSON

            With oJSON.data

                oJSON.Collection()

                'if isOrdersHolderExist = true then
                for i = 0 To monthsDiff 

                    monthLength = Month(DateAdd("m",i,queryDate1))
                    if Len(monthLength) = 1 then
                        monthPath = "0" & CStr(Month(DateAdd("m",i,queryDate1)))
                    else
                        monthPath = Month(DateAdd("m",i,queryDate1))
                    end if

                    yearPath = Year(DateAdd("m",i,queryDate1))
            
                    folderPath = mainPath & yearPath & "-" & monthPath
                    ordersHolderPath =  folderPath & ordersHolderFile

                    Do 

                        if fs.FolderExists(folderPath) <> true then EXIT DO
                        if fs.FileExists(ordersHolderPath) <> true then EXIT DO

                        getOrders = "SELECT invoice_no, unique_num, cust_name, prod_name, price, upd_price, qty, upd_qty, amount, upd_amount, status, is_added, date FROM "&ordersHolderPath&" WHERE (is_edited='true' OR is_added='true') AND date BETWEEN CTOD('"&queryDate1&"') and CTOD('"&queryDate2&"') ORDER BY date, unique_num"
                        set objAccess = cnroot.execute(getOrders)

                        do until objAccess.EOF

                            .Add counter, oJSON.Collection()
                            With .item(counter)      
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
                                .Add "date", CDate(objAccess("date").value)
                            End With

                            counter = counter + 1

                            objAccess.MoveNext
                        loop

                    Loop While False

                next 

            End With

    Response.Write(oJSON.JSONoutput())


%>