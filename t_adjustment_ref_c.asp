<!--#include file="dbConnect.asp"-->

<%
    Dim custID, custName, cash, invoice

    myInvoices = Request.Form("myInvoices")
    myAdjustments = Request.Form("myAdjustments")
    custID = CLng(Request.Form("custID"))
    custName = CStr(Request.Form("custName"))
    department = CStr(Request.Form("department"))
    ref_no = CStr(Request.Form("referenceNo"))

    adjustments = Split(myAdjustments,",")
    invoices = Split(myInvoices,",")
    systemDate = CDate(Application("date"))
    remarks = CStr(Request.Form("remarks"))

   Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = CStr(Year(ref_date))
    monthPath = CStr(Month(ref_date))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    ' Dim transactionsFile

    ' transactionsFile = "\transactions.dbf"

    Dim collectionsFile, arFile

    collectionsFile = "\collections.dbf"
    arFile = "\accounts_receivables.dbf"
    transactionsFile = "\transactions.dbf"
    adjustmentFile = "\adjustments.dbf"

    Dim collectionsPath, arPath

    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
    arPath = mainPath & yearPath & "-" & monthPath & arFile
    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
    adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile

    Dim maxID, transact_type, credit
    transact_type = "A-plus"
    debit = 0.00
    'currDate = CDate(Date)
    status = ""

    maxID = 0
    rs.Open "SELECT MAX(id) FROM "&transactionsPath&";", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxID = x.value

            next
            rs.MoveNext
        loop
        maxID = CLng(maxID) + 1
    rs.close 

    Dim maxADid
    rs.Open "SELECT MAX(id) FROM "&adjustmentPath&";", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxADid = x.value
            next
            rs.MoveNext
        loop
    maxADid = CLng(maxADid) + 1
    rs.close

    Dim newOB, cust_type, newBal, cashPaid
    newOB = 0.00
    cashPaid = 0

    for i=0 to Ubound(invoices) - 1

        sqlUpdate = "UPDATE accounts_receivables SET balance = balance + "&adjustments(i)&" WHERE invoice_no="&invoices(i)
        cnroot.execute(sqlUpdate)

        sqlAdd2 = "INSERT INTO transactions (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status)"&_
        "VALUES ("&maxID&" ,'"&ref_no&"', '"&transact_type&"', "&custID&" , "&invoices(i)&", "&debit&", " &adjustments(i)&", ctod(["&systemDate&"]), '"&status&"')"
        cnroot.execute(sqlAdd2)

        maxID = maxID + 1

        cashPaid = cashPaid + adjustments(i)
        
        cust_type = "in"

        sqlAdd3 = "INSERT INTO adjustments (id, cust_id, cust_name, department, invoice, ref_no, date, a_type, amount, remarks)"&_
        "VALUES ("&maxADid&", "&custID&", '"&custName&"', '"&department&"', "&invoices(i)&", '"&ref_no&"', ctod(["&systemDate&"]), '"&transact_type&"', "&adjustments(i)&", '"&remarks&"')"
        set objAccess = cnroot.execute(sqlAdd3)
        set objAccess = nothing  

        maxADid = maxADid + 1

    next

    Dim currOB
        currOB = 0.00

    sqlGetOB = "SELECT id, balance FROM ob_test WHERE cust_id="&custID&" GROUP BY cust_id"
    set objAccess = cnroot.execute(sqlGetOB)

    if not objAccess.EOF then
        currOB = CDbl(objAccess("balance").value)
    end if
    set objAccess = nothing

    newOB = currOB + cashPaid
    

    rs.Open "SELECT MAX(id) FROM ob_test;", CN2
    do until rs.EOF
        for each x in rs.Fields
            maxOBtestID = x.value
        next
        rs.MoveNext
    loop
    maxOBtestID = CLng(maxOBtestID) + 1
    rs.close

    sqlAdd2 = "INSERT INTO ob_test (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status)"&_
              "VALUES ("&maxObTestID&", '"&ref_no&"', "&custID&", '"&transact_type&"', '"&cust_type&"', "&cashPaid&", "&newOB&", ctod(["&systemDate&"]), '"&status&"')"
    set objAccess = cnroot.execute(sqlAdd2)
    set objAccess = nothing   

%>