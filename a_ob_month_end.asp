<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    Dim fs
    Set fs = Server.CreateObject("Scripting.FileSystemObject")

    'Deleting Temporary Report Tables'
    tempSalesReportTbl = Server.MapPath("./temp_folder/sales_report_container.dbf")
    tempCollectionsReportTbl = Server.MapPath("./temp_folder/collections_report_container.dbf")
    
    On Error Resume Next

        if fs.FileExists(tempSalesReportTbl) then
            
                fs.DeleteFile(tempSalesReportTbl)
        end if

        if fs.FileExists(tempCollectionsReportTbl) then
            fs.DeleteFile(tempCollectionsReportTbl)
        end if
        'End of Deleting Temporary Report Tables'

        if CN2.Errors.Count <> 0 then
            Response.Write "<br> There's a connection error Error: " & CN2.Error & "<br>"
        else 
            Response.Write "<br> No Error <br>"
        end if

    On Error Goto 0

    Dim isDayEnded

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim arFile, adjustmentFile, collectionsFile, obFile, salesFile, salesOrderFile, transactionsFile, ordersHolderFile, ebFile, referenceNoFile, arReferenceNoFile, adReferenceNoFile

    arFile = "\accounts_receivables.dbf" 
    adjustmentFile = "\adjustments.dbf" 
    collectionsFile = "\collections.dbf" 
    obFile = "\ob_test.dbf" 
    salesFile = "\sales.dbf" 
    salesOrderFile = "\sales_order.dbf" 
    transactionsFile = "\transactions.dbf" 
    ordersHolderFile = "\orders_holder.dbf" 
    ebFile = "\eb_test.dbf" 
    referenceNoFile = "\reference_no.dbf" 
    arReferenceNoFile = "\ar_reference_no.dbf" 
    adReferenceNoFile = "\adjustment_ref_no.dbf" 

    Dim arPath, adjustmentPath, collectionsPath, obPath, salesPath, salesOrderPath, transactionsPath, ordersHolderPath, ebPath, referenceNoPath, arReferenceNoPath, adReferenceNoPath

    arPath = mainPath & yearPath & "-" & monthPath & arFile
    adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile
    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
    obPath = mainPath & yearPath & "-" & monthPath & obFile
    salesPath = mainPath & yearPath & "-" & monthPath & salesFile
    salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile
    ebPath = mainPath & yearPath & "-" & monthPath & ebFile
    referenceNoPath = mainPath & yearPath & "-" & monthPath & referenceNoFile
    arReferenceNoPath = mainPath & yearPath & "-" & monthPath & arReferenceNoFile
    adReferenceNoPath = mainPath & yearPath & "-" & monthPath & adReferenceNoFile

    'Check if there is pending orders'
    rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" OR status=""Pending"" GROUP BY unique_num", CN2

    'Month End won't process when there are a pending orders.'
    if not rs.EOF then

        Response.Write("<script>")
        Response.Write("alert('Invalid: There are pending orders. \n \t\t\t\t   Go to cashier order page or customers order')")
        Response.Write("</script>")
        isDayEnded = false

        rs.close

        if isDayEnded = false then
            Response.Write("<script>")
            Response.Write("window.location.href=""customers_order.asp"";")
            Response.Write("</script>")
        end if

    else
        'Processing of Month End'
        rs.close

        Dim isNewFolderExist, isFileExist
        isNewFolderExist = false
        isFileExist = false

        Response.Write ebPath

        rs.Open "SELECT MAX(id) FROM "&ebPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxEbID = x.value
                next
                rs.MoveNext
            loop
        rs.close

        'This id will use when inserting records in new EB table'
        'Also it will increment until the loop stops'
        maxEbID = CInt(maxEbID) + 1
        'Get all the latest records of each customer's OB and insert to EB tbl.'
        'So that it becomes so easy to get the ending balance from previous month'
        'I used fdate as an alias to insert to the fdate of eb table'
        'and use the system_date for the ending_date which is the last day of the month'
        rs.open "SELECT MIN(date) AS fdate, cust_id, cust_type, balance FROM "&obPath&" WHERE status!='completed' and cust_type='in' GROUP BY cust_id", CN2

        if Err.Number = 0 and CN2.Errors.Count = 0 then

            'If the records are not yet completed, month end process will continue'
            if not rs.eof then

                Dim newYearPath, newMonthPath

                newYearPath = Year(systemDate + 1)
                newMonthPath = Month(systemDate + 1)

                if Len(newMonthPath) = 1 then
                    newMonthPath = "0" & CStr(newMonthPath)
                end if

                Dim newFolderPath

                newFolderPath = mainPath & newYearPath & "-" & newMonthPath
                'Response.Write newFolderPath
                Dim folder

                if fs.FolderExists(newFolderPath) <> true then

                    Set folder = fs.CreateFolder(newFolderPath)

                    Dim ebBlankFile, newEbPath
                    ebBlankFile = mainPath & "tbl_blank" & ebFile
                    newEbPath = newFolderPath & ebFile

                    if fs.FileExists(newEbPath) <> true then
                        fs.CopyFile ebBlankFile, newEbPath
                    else
                        isFileExist = true
                        error = "File already exists!"
                        Response.Redirect("error_page.asp?error="&error)
                    end if

                else

                    rs.close
                    Dim error
                    isNewFolderExist = true
                    error = "Folder already exists!"
                    Response.Redirect("error_page.asp?error="&error)

                end if

                if isNewFolderExist = false or isFileExist = false then
                
                    do until rs.EOF

                        custId = rs("cust_id").value
                        fdate = CDate(rs("fdate"))
                        ldate = systemDate

                        if CDbl(rs("balance").value) < 0 then
                            creditBal = 0
                            debitBal = ABS(CDbl(rs("balance").value))
                        else
                            creditBal = CDbl(rs("balance").value)
                            debitBal = 0.00
                        end if     

                        cust_type = Trim(CStr(rs("cust_type").value))

                        'Get the customer's info
                        Dim custName, custDepartment, paymentMethod
                        paymentMethod = "ar"

                        sqlCustInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
                        set objAccess = cnroot.execute(sqlCustInfo)

                        if not objAccess.EOF then

                            custName = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
                            custDepartment = objAccess("department").value

                        end if

                        set objAccess = nothing

                        ' sqlAddEb = "INSERT INTO "&ebPath&" (id, cust_id, cust_name, department, cust_type, credit_bal, debit_bal, first_date, end_date, duplicate)"&_
                        ' "VALUES ("&maxEbID&", "&custId&" , '"&custName&"', '"&custDepartment&"', '"&cust_type&"', "&creditBal&", " &debitBal&", ctod(["&fdate&"]), ctod(["&ldate&"]), '')"
                        ' cnroot.execute sqlAddEb
                        
                        sqlAdd = "INSERT INTO "&newEbPath&" (id, cust_id, cust_name, department, cust_type, credit_bal, debit_bal, first_date, end_date, duplicate)"&_
                        "VALUES ("&maxEbID&", "&custId&" , '"&custName&"', '"&custDepartment&"', '"&cust_type&"', "&creditBal&", " &debitBal&", ctod(["&fdate&"]), ctod(["&ldate&"]), 'yes')"
                        cnroot.execute sqlAdd

                        maxEbID = maxEbID + 1

                        sqlUpdate = "UPDATE "&obPath&" SET status='completed' WHERE cust_id="&custId&" and date between CTOD(["&fdate&"]) and CTOD(["&ldate&"])"
                        cnroot.execute sqlUpdate

                        rs.MoveNext
                        
                    loop

                    rs.close


                    Dim arBlankFile, adjustmentBlankFile, collectionsBlankFile, obBlankFile
                    Dim salesBlankFile, salesOrderBlankFile, transactionsBlankFile, ordersHolderBlankFile, referenceNoBlankFile, arReferenceNoBlankFile, adReferenceNoBlankFile

                    arBlankFile = mainPath & "tbl_blank" & arFile
                    adjustmentBlankFile = mainPath & "tbl_blank" & adjustmentFile
                    collectionsBlankFile = mainPath & "tbl_blank" & collectionsFile
                    obBlankFile = mainPath & "tbl_blank" & obFile
                    salesBlankFile = mainPath & "tbl_blank" & salesFile
                    salesOrderBlankFile = mainPath & "tbl_blank" & salesOrderFile
                    transactionsBlankFile = mainPath & "tbl_blank" & transactionsFile
                    ordersHolderBlankFile = mainPath & "tbl_blank" & ordersHolderFile
                    referenceNoBlankFile = mainPath & "tbl_blank" & referenceNoFile
                    arReferenceNoBlankFile = mainPath & "tbl_blank" & arReferenceNoFile
                    adReferenceNoBlankFile = mainPath & "tbl_blank" & adReferenceNoFile

                    Dim newArPath, newAdjustmentPath, newCollectionsPath, newObPath
                    Dim newSalesPath, newSalesOrderPath, newTransactionsPath, newOrdersHolderPath, newReferenceNoPath, newArReferenceNoPath, newAdReferencePath

                    newArPath = newFolderPath & arFile
                    newAdjustmentPath = newFolderPath & adjustmentFile
                    newCollectionsPath = newFolderPath & collectionsFile
                    newObPath = newFolderPath & obFile
                    newSalesPath = newFolderPath & salesFile
                    newSalesOrderPath = newFolderPath & salesOrderFile
                    newTransactionsPath = newFolderPath & transactionsFile
                    newOrdersHolderPath = newFolderPath & ordersHolderFile
                    newReferenceNoPath = newFolderPath & referenceNoFile
                    newArReferenceNoPath = newFolderPath & arReferenceNoFile
                    newAdReferencePath = newFolderPath & adReferenceNoFile

                    if fs.FileExists(newArPath) <> true AND fs.FileExists(newAdjustmentPath) <> true AND _ 
                    fs.FileExists(newCollectionsPath) <> true AND fs.FileExists(newObPath) <> true AND _
                    fs.FileExists(newSalesPath) <> true AND fs.FileExists(newSalesOrderPath) <> true AND _
                    fs.FileExists(newTransactionsPath) <> true AND fs.FileExists(newOrdersHolderPath) <> true AND _
                    fs.FileExists(newReferenceNoPath) <> true AND _
                    fs.FileExists(newArReferenceNoPath) <> true AND _
                    fs.FileExists(newAdReferencePath) <> true _
                    then 

                        fs.CopyFile arBlankFile, newArPath
                        fs.CopyFile adjustmentBlankFile, newAdjustmentPath
                        fs.CopyFile collectionsBlankFile, newCollectionsPath
                        fs.CopyFile obBlankFile, newObPath
                        fs.CopyFile salesBlankFile, newSalesPath
                        fs.CopyFile salesOrderBlankFile, newSalesOrderPath
                        fs.CopyFile transactionsBlankFile, newTransactionsPath
                        fs.CopyFile ordersHolderBlankFile, newOrdersHolderPath
                        fs.CopyFile referenceNoBlankFile, newReferenceNoPath
                        fs.CopyFile arReferenceNoBlankFile, newArReferenceNoPath
                        fs.CopyFile adReferenceNoBlankFile, newAdReferencePath

                        set fs = nothing
                        Response.Write "Files successfully copied!"

                        'Get all the records that have a remaining balance'
                        rs.open "SELECT * FROM "&arPath&" WHERE balance > 0 ", CN2

                        do until rs.EOF 
                        
                            sqlArAdd = "INSERT INTO "&newArPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate) "&_
                            "VALUES ("&rs("ar_id")&", "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("cust_dept")&"', '"&rs("ref_no")&"', "&rs("invoice_no")&", "&rs("receivable")&", "&rs("balance")&", ctod(["&rs("date_owed")&"]), 'yes')"
                            cnroot.execute(sqlArAdd)

                            rs.movenext
                        loop
                        rs.close

                        'Getting the AR TBL Max record
                        rs.open "SELECT TOP 1 ar_id, date_owed FROM "&arPath&" ORDER BY ar_id DESC", CN2
                        
                        do until rs.EOF 

                            addMaxDuplicate = "INSERT INTO "&newArPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate) "&_
                            "VALUES ("&rs("ar_id")&", 0, 'top-record', 'top-record', 'top-record', 0, 0, 0, ctod(["&rs("date_owed")&"]), 'yes')"
                            cnroot.execute(addMaxDuplicate)

                            rs.movenext
                        loop

                        rs.close

                        'Getting the Adjustments TBL Max record
                        rs.open "SELECT TOP 1 * FROM "&adjustmentPath&" ORDER BY id DESC", CN2
                        
                        do until rs.EOF 

                            addMaxAdjustment = "INSERT INTO "&newAdjustmentPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, a_type, amount, balance, remarks, duplicate) "&_
                            "VALUES ("&rs("id")&", 0, '', '', 0, '', ctod(["&rs("date")&"]), '', 0, 0, '', 'yes')"
                            cnroot.execute(addMaxAdjustment)

                            rs.movenext
                        loop

                        rs.close

                        'Getting the Collections TBL Max record
                        rs.open "SELECT TOP 1 * FROM "&collectionsPath&" ORDER BY id DESC", CN2
                        
                        do until rs.EOF 

                            addMaxCollections = "INSERT INTO "&newCollectionsPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate) "&_
                            "VALUES ("&rs("id")&", 0, '', '', 0, '', ctod(["&rs("date")&"]), 0, 0, 0, '', 'yes')"
                            cnroot.execute(addMaxCollections)

                            rs.movenext
                        loop

                        rs.close

                        'Getting the latest OB of each customer and the MAX ID'
                        'And save it to the new OB TBL'
                        'This will be the reference of the previous month ob'
                        'when processing month end to the following month.'
                        'So you will get the ending balance even though they dont'
                        'have a transaction to the following month'
                        rs.open "SELECT * FROM "&obPath&" GROUP BY cust_id ORDER BY id", CN2
                        
                        do until rs.EOF 
                            addMaxOb = "INSERT INTO "&newObPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate) "&_
                            "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("department")&"', '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&", "&rs("balance")&", ctod(["&systemDate&"]), '', 'yes')"
                            cnroot.execute(addMaxOb)
                            rs.movenext
                        loop
                        rs.close

                        'Getting the Sales TBL Max record
                        rs.open "SELECT TOP 1 * FROM "&salesPath&" ORDER BY transactid DESC", CN2
                        
                        do until rs.EOF 

                            addMaxSales = "INSERT INTO "&newSalesPath&" (transactid, ref_no, invoice_no, cust_id, cust_name, cashier, date, cash_paid, amount, profit, payment, duplicate) "&_
                            "VALUES ("&rs("transactid")&", '"&rs("ref_no")&"', "&rs("invoice_no")&", 0, '', '', ctod(["&rs("date")&"]), 0, 0, 0, '', 'yes')"
                            cnroot.execute(addMaxSales)

                            rs.movenext
                        loop

                        rs.close

                        'Getting the Sales Order TBL Max record
                        rs.open "SELECT TOP 1 * FROM "&salesOrderPath&" ORDER BY transactid DESC", CN2
                        
                        do until rs.EOF 

                            addMaxSalesOrder = "INSERT INTO "&newSalesOrderPath&" (transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate) "&_
                            "VALUES ("&rs("transactid")&", '"&rs("ref_no")&"', "&rs("invoice_no")&", 0, '', 0, '', '', 0, 0, 0, 0, ctod(["&rs("date")&"]), '', 'yes')"
                            cnroot.execute(addMaxSalesOrder)

                            rs.movenext
                        loop

                        rs.close

                        'Getting the Transactions TBL Max record
                        rs.open "SELECT TOP 1 * FROM "&transactionsPath&" ORDER BY id DESC", CN2
                        
                        do until rs.EOF 

                            addMaxTransactions = "INSERT INTO "&newTransactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate) "&_
                            "VALUES ("&rs("id")&", '', '', 0, 0, 0, 0, ctod(["&rs("date")&"]), '', 'yes')"
                            cnroot.execute(addMaxTransactions)

                            rs.movenext
                        loop

                        rs.close     

                        'Getting the top reference number within the year'
                        'Reset if it is new year or do nothing'
                        if Year(systemDate) = Year(systemDate + 1) then

                            rs.Open "SELECT TOP 1 * FROM "&referenceNoPath&" ORDER BY id DESC;", CN2
                                do until rs.EOF
                                   
                                    addMaxRefNo = addMaxRefNo & "INSERT INTO "&newReferenceNoPath&" (id, ref_no, duplicate) "&_
                                    "VALUES ("&rs("id")&", '"&rs("ref_no")&"', 'yes'); "

                                    rs.MoveNext
                                loop

                                cnroot.execute(addMaxRefNo)

                            rs.close  

                            rs.Open "SELECT TOP 1 * FROM "&arReferenceNoPath&" ORDER BY id DESC;", CN2
                                do until rs.EOF
                                   
                                    addMaxArRefNo = addMaxArRefNo & "INSERT INTO "&newArReferenceNoPath&" (id, ref_no, duplicate) "&_
                                    "VALUES ("&rs("id")&", '"&rs("ref_no")&"', 'yes'); "

                                    rs.MoveNext
                                loop

                                cnroot.execute(addMaxArRefNo)

                            rs.close  

                            rs.Open "SELECT TOP 1 * FROM "&adReferenceNoPath&" ORDER BY id DESC;", CN2
                                do until rs.EOF
                                   
                                    addMaxAdRefNo = addMaxAdRefNo & "INSERT INTO "&newAdReferencePath&" (id, ref_no, duplicate) "&_
                                    "VALUES ("&rs("id")&", '"&rs("ref_no")&"', 'yes'); "

                                    rs.MoveNext
                                loop

                                cnroot.execute(addMaxAdRefNo)

                            rs.close  

                        end if
                        'End of Getting the top reference number within the year'

                        'Updating the system date'
                        sqlDateUpdate = "UPDATE system_date SET date = date + 1"
                        cnroot.execute(sqlDateUpdate)
                        systemDate = systemDate + 1  

                        Dim maxSchedID, systemDateTime
                        rs.Open "SELECT MAX(sched_id) FROM store_schedule;", CN2
                            do until rs.EOF
                                for each x in rs.Fields
                                    maxSchedID = x.value
                                next
                                rs.MoveNext
                            loop
                            maxSchedID = CInt(maxSchedID) + 1
                        rs.close

                        systemDateTime = CStr(systemDate & " " & Time)
                    
                        sqlAdd = "INSERT INTO store_schedule (sched_id, date_time, status) VALUES ("&maxSchedID&",'"&systemDateTime&"', ""closed"")"
                        cnroot.execute(sqlAdd)
                        
                    
                        Response.Redirect("cashier_order_page.asp")

                        CN2.close
                        Response.Write("<script language=""javascript"">")
                        Response.Write("alert('Month End completed!')")
                        Response.Write("</script>")  

                    else

                        error = "Other files already exists!"
                        Response.Redirect("error_page.asp?error="&error)

                    end if  

                else

                    error = "Folder or file already exists!"
                    Response.Redirect("error_page.asp?error="&error)

                end if

            else

                Response.Write("<script language=""javascript"">")
                Response.Write("alert(""Error: Reports already cut off"")")
                Response.Write("</script>")
                rs.close
                CN2.close
                isValidTransact = false
                if isValidTransact=false then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""ob_main.asp"";")
                    Response.Write("</script>")
                end if

            end if

        end if

    end if
    
%>

<!-- git branch fix-eb-tbl-flow -->