<!--#include file="dbConnect.asp"-->

<%

Dim arReferenceNo, isValidRef, totalCredits

arReferenceNo = CStr(Request.Form("arReferenceNo"))
totalCredits = CDbl(Request.Form("totalCredits"))
arReferenceNo = Trim(CStr(Year(systemDate)) & "-" & "AR" & arReferenceNo)
isValidRef = true

Dim customerID, custName, customerDepartment, uniqueNum, customerType, transact_type

customerID = CLng(Request.Form("custID"))
transact_type = "Buy"

Dim userType, userEmail

cashierName = CStr(Request.Form("cashierName"))

sqlCheckRef = "SELECT ref_no FROM ar_reference_no WHERE ref_no='"&arReferenceNo&"'"
    set objAccess = cnroot.execute(sqlCheckRef)

        if not objAccess.EOF then

            isValidRef = false
            Response.Write "invalid ref"

        end if


    set objAccess = nothing

    if isValidRef = true then   

        getCustomerInfo = "SELECT cust_lname, cust_fname, department, cust_type FROM customers WHERE cust_id="&customerID
        set objAccess = cnroot.execute(getCustomerInfo)

        if not objAccess.EOF then

            custName = Trim(objAccess("cust_lname")) & " " & Trim(objAccess("cust_fname"))
            customerDepartment = Trim(objAccess("department"))
            customerType = Trim(objAccess("cust_type"))

        end if

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

        Dim totalProfit, totalAmount

        totalProfit = 0
        totalAmount = totalCredits


        Dim customerCash
        customerCash = 0.00
        balance = totalAmount - customerCash
        totalReceivable = totalAmount

        Dim payment
        payment = "Credit"


        Dim salesFile, salesOrderFile, transactionsFile, obFile, arFile

        salesFile = "\sales.dbf"
        salesOrderFile = "\sales_order.dbf"
        transactionsFile = "\transactions.dbf"
        obFile = "\ob_test.dbf"
        arFile = "\accounts_receivables.dbf"

        Dim salesPath, salesOrderPath, transactionsPath, obPath, arPath

        salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
        salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        obPath = mainPath & yearPath & "-" & monthPath & obFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile


        'ORDERS REPORT'
        Dim maxInvoice
        maxInvoice = 0
        rs.Open "SELECT MAX(invoice_no) AS invoice FROM "&salesPath&";", CN2
            if not rs.EOF then
                maxInvoice = CLng(rs("invoice").value)
            end if
        rs.close
        maxInvoice = maxInvoice + 1
        'END OF ORDERS REPORT'

        'SALES'
        Dim maxTransactID
        maxTransactID = 0
        rs.open "SELECT MAX(transactid) AS transactid FROM "&salesPath&"", CN2
            if not rs.EOF then
                maxTransactID = CLng(rs("transactid").value)
            end if
        rs.close
        maxTransactID= CLng(maxTransactID) + 1

        Dim maxID  
        maxID = 0
        rs.Open "SELECT MAX(id) AS id FROM "&transactionsPath&";", CN2
            if not rs.EOF then
                maxID = CLng(rs("id").value)
            end if
            maxID = CLng(maxID) + 1
        rs.close

        Dim isDuplicate
        isDuplicate = ""

        sqlAdd = "INSERT INTO "&salesPath&" (transactid, ref_no, invoice_no, cust_id, cust_name, cashier, date, cash_paid, amount, profit, payment, duplicate)"&_ 
        "VALUES ("&maxTransactID&", '"&arReferenceNo&"' ,"&maxInvoice&", "&customerID&", '"&custName&"', '"&cashierName&"', ctod(["&systemDate&"]), "&customerCash&", "&totalAmount&", "&totalProfit&", '"&payment&"', '"&isDuplicate&"')"

        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing 

        'END OF SALES'
        Dim maxOHid
        maxOHid = 0
        rs.open "SELECT MAX(transactid) AS transactid FROM "&salesOrderPath&"", CN2
            if not rs.EOF then
                maxOHid = CLng(rs("transactid").value)
            end if
        rs.close

        maxOHid = maxOHid + 1

        sqlSOAdd = "INSERT INTO "&salesOrderPath&""&_ 
        "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate)"&_
        "VALUES ("&maxOHid&", '"&arReferenceNo&"', "&maxInvoice&", "&customerID&", '"&custName&"', 0, 'offline', 'offline', 0, "&totalAmount&", 0, 0, ctod(["&systemDate&"]), '"&payment&"', '"&isDuplicate&"')"
        cnroot.execute sqlSOAdd

        Dim maxObTestID, cust_type
        maxObTestID = 0
        'arReferenceNo = 0
        rs.Open "SELECT MAX(id) AS id FROM "&obPath&";", CN2
            if not rs.EOF then
                maxObTestID = CLng(rs("id").value)
            end if
            maxObTestID = CLng(maxObTestID) + 1
        rs.close

        Dim currOB, cashPaid
        currOB = 0.00
        cashPaid = 0.00
        status = ""

        rs.open "SELECT MAX(id), balance FROM "&obPath&" WHERE cust_id="&customerID, CN2

        if not rs.EOF then
            currOB = CDbl(rs("balance").value)
        end if

        currOB = currOB + totalAmount

        sqlAdd = "INSERT INTO "&obPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate)"&_
        "VALUES ("&maxObTestID&", '"&arReferenceNo&"', "&customerID&", '"&custName&"', '"&customerDepartment&"', '"&transact_type&"', '"&customerType&"', "&cashPaid&", "&currOB&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing

        rs.close

        Dim arMaxValue
        arMaxValue = 0
        rs.Open "SELECT MAX(ar_id) AS id FROM "&arPath&";", CN2

        if not rs.EOF then
            arMaxValue = CLng(rs("id").value)
        end if

        arMaxValue= arMaxValue + 1

        sqlAdd = "INSERT INTO "&arPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate)"&_ 
        "VALUES ("&arMaxValue&","&customerID&", '"&custName&"', '"&customerDepartment&"', '"&arReferenceNo&"', "&maxInvoice&", "&totalReceivable&", "&balance&" ,ctod(["&systemDate&"]), '"&isDuplicate&"')"

        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing 
        rs.close

        Dim isAdded

        isAdded = false

        sqlAdd = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
        "VALUES ("&maxID&", '"&arReferenceNo&"', '"&transact_type&"', "&customerID&" , "&maxInvoice&", "&customerCash&", " &totalAmount&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing


        Dim maxArRefId 
        maxArRefId = 0

        rs.Open "SELECT MAX(id) AS id FROM ar_reference_no;", CN2
            if not rs.EOF then
                maxArRefId = CDbl(rs("id").value)
            end if
            maxArRefId = maxArRefId + 1
        rs.close

        sqlRefAdd = "INSERT INTO ar_reference_no (id, ref_no) "&_
                    "VALUES ("&maxArRefId&", '"&arReferenceNo&"')"
        cnroot.execute(sqlRefAdd)   


        CN2.close    

        Response.Write "transaction completed"

    end if
%>