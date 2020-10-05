<!--#include file="dbConnect.asp"-->

<%
    Dim systemDate

    systemDate = CDate("08/31/2020")
    'systemDate = CDate(Application("date"))

    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim arFile, adjustmentFile, collectionsFile, obFile, salesFile, salesOrderFile, transactionsFile, ordersHolderFile

    arFile = "\accounts_receivables.dbf" 
    adjustmentFile = "\adjustments.dbf" 
    collectionsFile = "\collections.dbf" 
    obFile = "\ob_test.dbf" 
    salesFile = "\sales.dbf" 
    salesOrderFile = "\sales_order.dbf" 
    transactionsFile = "\transactions.dbf" 
    ordersHolderFile = "\orders_holder.dbf" 

    Dim arPath, adjustmentPath, collectionsPath, obPath, salesPath, salesOrderPath, transactionsPath, ordersHolderPath

    arPath = mainPath & yearPath & "-" & monthPath & arFile
    adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile
    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
    obPath = mainPath & yearPath & "-" & monthPath & obFile
    salesPath = mainPath & yearPath & "-" & monthPath & salesFile
    salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    Dim newYearPath, newMonthPath

    newYearPath = Year(systemDate + 1)
    newMonthPath = Month(systemDate + 1)

    if Len(newMonthPath) = 1 then
        newMonthPath = "0" & CStr(newMonthPath)
    end if

    Dim newFolderPath

    newFolderPath = mainPath & newYearPath & "-" & newMonthPath
    'Response.Write newFolderPath
    Dim fs, folder
    Set fs = Server.CreateObject("Scripting.FileSystemObject")

    if fs.FolderExists(newFolderPath) <> true then

        Set folder = fs.CreateFolder(newFolderPath)

        Dim arBlankFile, adjustmentBlankFile, collectionsBlankFile, obBlankFile
        Dim salesBlankFile, salesOrderBlankFile, transactionsBlankFile, ordersHolderBlankFile

        arBlankFile = mainPath & "tbl_blank" & arFile
        adjustmentBlankFile = mainPath & "tbl_blank" & adjustmentFile
        collectionsBlankFile = mainPath & "tbl_blank" & collectionsFile
        obBlankFile = mainPath & "tbl_blank" & obFile
        salesBlankFile = mainPath & "tbl_blank" & salesFile
        salesOrderBlankFile = mainPath & "tbl_blank" & salesOrderFile
        transactionsBlankFile = mainPath & "tbl_blank" & transactionsFile
        ordersHolderBlankFile = mainPath & "tbl_blank" & ordersHolderFile

        Dim newArPath, newAdjustmentPath, newCollectionsPath, newObPath
        Dim newSalesPath, newSalesOrderPath, newTransactionsPath, newOrdersHolderPath

        newArPath = newFolderPath & arFile
        newAdjustmentPath = newFolderPath & adjustmentFile
        newCollectionsPath = newFolderPath & collectionsFile
        newObPath = newFolderPath & obFile
        newSalesPath = newFolderPath & salesFile
        newSalesOrderPath = newFolderPath & salesOrderFile
        newTransactionsPath = newFolderPath & transactionsFile
        newOrdersHolderPath = newFolderPath & ordersHolderFile

        if fs.FileExists(newArPath) <> true AND fs.FileExists(newAdjustmentPath) <> true AND _ 
           fs.FileExists(newCollectionsPath) <> true AND fs.FileExists(newObPath) <> true AND _
           fs.FileExists(newSalesPath) <> true AND fs.FileExists(newSalesOrderPath) <> true AND _
           fs.FileExists(newTransactionsPath) <> true AND fs.FileExists(newOrdersHolderPath) <> true _
        then 

            fs.CopyFile arBlankFile, newArPath
            fs.CopyFile adjustmentBlankFile, newAdjustmentPath
            fs.CopyFile collectionsBlankFile, newCollectionsPath
            fs.CopyFile obBlankFile, newObPath
            fs.CopyFile salesBlankFile, newSalesPath
            fs.CopyFile salesOrderBlankFile, newSalesOrderPath
            fs.CopyFile transactionsBlankFile, newTransactionsPath
            fs.CopyFile transactionsBlankFile, newOrdersHolderPath
            set fs = nothing
            Response.Write "Files successfully copied!"

            rs.Open "SELECT MAX(ar_id) FROM "&arPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxArId = x.value
                next
                rs.MoveNext
            loop
            maxArId = CDbl(maxArId) + 1

            rs.close 

            rs.open "SELECT * FROM "&arPath&" WHERE balance > 0 ", CN2

            do until rs.EOF 

            sqlArAdd = "INSERT INTO "&newArPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate) "&_
            "VALUES ("&maxArId&", "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("cust_dept")&"', '"&rs("ref_no")&"', "&rs("invoice_no")&", "&rs("receivable")&", "&rs("balance")&", ctod(["&rs("date_owed")&"]), 'yes')"
            cnroot.execute(sqlArAdd)

            maxArId = maxArId + 1

            rs.movenext
            loop

            rs.close

        else

            Response.Write "Copy failed"

        end if  

    else   

        Response.Write "Folder already exist!"

    end if
        ' blankObFileCopy = currentPath & "ob_test.dbf"
        ' newObFileLocation = currentPath & newFolderName & newObFileName
        'obFileLocationFolder = path1 & folderName & fileName

    '     if fs.FileExists(newObFileLocation) <> true then 

    '         fs.CopyFile blankObFileCopy, newObFileLocation
    '         set fs=nothing


    ' recentObRececordPath = currentPath & Year(systemDate) & "-" & recentMonthPath & "\ob_test.dbf" 
    ' yearPath = CStr(Year(systemDate + 1))
    ' monthPath = CStr(Month(systemDate + 1))

    ' if Len(monthPath) = 1 then
    '     monthPath = "0" & CStr(monthPath)
    ' end if

    ' newFolderName = yearPath & "-" & monthPath
    ' newObFileName = "\ob_test.dbf"
    ' newFolderPath = currentPath & newFolderName

    ' if fs.FolderExists(newFolderPath) <> true then

    '     set f=fs.CreateFolder(newFolderPath)
    '     'set f=nothing

    '     blankObFileCopy = currentPath & "ob_test.dbf"
    '     newObFileLocation = currentPath & newFolderName & newObFileName
    '     'obFileLocationFolder = path1 & folderName & fileName

    '     if fs.FileExists(newObFileLocation) <> true then 

    '         fs.CopyFile blankObFileCopy, newObFileLocation
    '         set fs=nothing
            
    '         rs.open "SELECT * FROM "&recentObRececordPath&" WHERE id IN (SELECT MAX(id) FROM ob_test GROUP BY cust_id)", CN2

    '         ' file = "\ob_test.dbf"
    '         ' folderPath = path1 & folderName
    '         ' filePath = yearPath & "-" & monthPath & file

    '         if not rs.EOF then

    '             do until rs.EOF
                
    '                 sqlAdd2 = "INSERT INTO "&newObFileLocation&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status) "&_
    '                         "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&" , "&rs("balance")&", ctod(["&rs("date")&"]), '"&rs("status")&"')"
    '                 cnroot.execute(sqlAdd2)

    '             rs.movenext
    '             loop
        

    '         end if

    '         rs.close

    '     else

    '         Response.Write "File already exist!"

    '     end if

    ' else    

    '     Response.Write "Folder already exist!"

    ' end if

    'REMINDER!!! DROP THE ORDERS_HOLDER TABLE'

    ' if fs.FileExists(folderPath & file) <> true then EXIT DO

    ' set f=fs.CreateFolder(path1 & folderName)
    ' set f=nothing

    ' rs.open "SELECT * FROM ob_test WHERE id IN (SELECT MAX(id) FROM ob_test GROUP BY cust_id)", CN2

    

    ' file = "\ob_test.dbf"
    ' folderPath = "C:\www\www.testjet4419.com\fastfood_f\pos_test\2020-09"
    ' filePath = "2020-09" & file

    ' ' do until rs.EOF 


    ' '     for each x in rs.fields

    ' '         Response.Write x.name & ": " & x.value & "<br>"


    ' '     next
    ' '     rs.movenext

    ' ' loop

    ' if not rs.EOF then

    '     do until rs.EOF
        
    '     sqlAdd2 = "INSERT INTO "&filePath&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status) "&_
    '               "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&" , "&rs("balance")&", ctod(["&rs("date")&"]), '"&rs("status")&"')"
    '     cnroot.execute(sqlAdd2)

    '     rs.movenext
    '     loop
       

    ' end if

    ' rs.close



%>