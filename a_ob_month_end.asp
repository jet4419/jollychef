<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%

    Dim isDayEnded

    Dim yearPath, monthPath

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

    rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" OR status=""Pending"" GROUP BY unique_num", CN2

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

        rs.close

        rs.Open "SELECT MAX(id) FROM eb_test;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxEbID = x.value
                next
                rs.MoveNext
            loop
        rs.close

        maxEbID = CInt(maxEbID) + 1

        rs.open "SELECT MIN(date) AS fdate, cust_id, cust_type, balance FROM "&obPath&" WHERE duplicate!='yes' and status!='completed' and cust_type='in' GROUP BY cust_id", CN2

        if not rs.eof then

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
                ' creditBal = CDbl(rs("credit_bal").value)
                ' debitBal = CDbl(rs("debit_bal").value)
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
                
                sqlAdd = "INSERT INTO eb_test (id, cust_id, cust_name, department, cust_type, credit_bal, debit_bal, first_date, end_date)"&_
                "VALUES ("&maxEbID&", "&custId&" , '"&custName&"', '"&custDepartment&"', '"&cust_type&"', "&creditBal&", " &debitBal&", ctod(["&fdate&"]), ctod(["&ldate&"]))"
                cnroot.execute sqlAdd

                maxEbID = maxEbID + 1

                sqlUpdate = "UPDATE "&obPath&" SET status='completed' WHERE cust_id="&custId&" and date between CTOD(["&fdate&"]) and CTOD(["&ldate&"])"
                cnroot.execute sqlUpdate

                rs.MoveNext

                if rs.EOF then

                    rs.close

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
                            fs.CopyFile ordersHolderBlankFile, newOrdersHolderPath
                            set fs = nothing
                            Response.Write "Files successfully copied!"

                            'Getting the AR TBL Max record
                            rs.open "SELECT TOP 1 ar_id, date_owed FROM "&arPath&" ORDER BY ar_id DESC", CN2
                            
                            do until rs.EOF 

                            addMaxDuplicate = "INSERT INTO "&newArPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate) "&_
                            "VALUES ("&rs("ar_id")&", 0, '', '', '', 0, 0, 0, ctod(["&rs("date_owed")&"]), 'yes')"
                            cnroot.execute(addMaxDuplicate)

                            rs.movenext
                            loop

                            rs.close

                            'Getting the Adjustments TBL Max record
                            rs.open "SELECT TOP 1 * FROM "&adjustmentPath&" ORDER BY id DESC", CN2
                            
                            do until rs.EOF 

                            ' addMaxAdjustment = "INSERT INTO "&newAdjustmentPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, a_type, amount, remarks, duplicate) "&_
                            ' "VALUES ("&rs("id")&", "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("department")&"', "&rs("invoice")&", '"&rs("ref_no")&"', ctod(["&rs("date")&"]), '"&rs("a_type")&"', "&rs("amount")&", '"&rs("remarks")&"', 'yes')"
                            ' cnroot.execute(addMaxAdjustment)

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

                            'Getting the OB TBL Max record
                            rs.open "SELECT * FROM "&obPath&" GROUP BY cust_id", CN2
                            
                            do until rs.EOF 

                            addMaxOb = "INSERT INTO "&newObPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate) "&_
                            "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("department")&"', '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&", "&rs("balance")&", ctod(["&systemDate&"]), '"&rs("status")&"', 'yes')"
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

                            ' Dim dropOrdersHolder
                            ' dropOrdersHolder = "DROP TABLE "&ordersHolderPath
                            ' cnroot.execute(dropOrdersHolder)

                        else

                            Response.Write "Copy failed"

                        end if  

                    else   

                        Response.Write "Folder already exist!"

                    end if

                    sqlDateUpdate = "UPDATE system_date SET date = date + 1"
                    cnroot.execute(sqlDateUpdate)
                    systemDate = systemDate + 1
                    'Response.Write("Day end")    

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

                end if

                
            loop
        
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
    
    'Response.Write(creditBal)
    'Response.Write("<br>")
    'Response.Write(debitBal)
    
%>