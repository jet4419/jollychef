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
    remarks = CStr(Request.Form("remarks"))

    Dim yearPath, monthPath

    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim arFile, transactionsFile, adjustmentsFile

    arFile = "\accounts_receivables.dbf"
    transactionsFile = "\transactions.dbf"
    adjustmentsFile = "\adjustments.dbf"

    Dim folderPath, transactionsPath, adjustmentsPath

    folderPath = mainPath & yearPath & "-" & monthPath
    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
    adjustmentsPath = mainPath & yearPath & "-" & monthPath & adjustmentsFile


    Dim maxID, transact_type, credit
    transact_type = "A-minus"
    credit = 0.00
    'debit = 0.00
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
    rs.Open "SELECT MAX(id) FROM "&adjustmentsPath&";", CN2
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
    cashPaid = 0.00

    Dim fs
    set fs=Server.CreateObject("Scripting.FileSystemObject")

    Dim isFolderExist
    isFolderExist = fs.FolderExists(folderPath)

    Dim arPath

    for i=0 to Ubound(invoices) - 1   

        folderPath = mainPath & yearPath & "-" & monthPath
        
        arFolderPath = folderPath
        arMonthPath = monthPath
        arYearPath = yearPath
        isArFolderExist = fs.FolderExists(arFolderPath)

        arPath = mainPath & yearPath & "-" & monthPath & arFile

        do until isArFolderExist = false

            isArFileExist = fs.FileExists(arPath)

            if isArFileExist = true then

            getMaxVal = "SELECT ref_no, invoice_no FROM "&arPath&" WHERE invoice_no="&invoices(i)&" GROUP BY invoice_no"
            set objAccess = cnroot.execute(getMaxVal)

                if not objAccess.EOF then

                    ref_no = CStr(objAccess("ref_no"))
                    sqlUpdate = "UPDATE "&arPath&" SET balance = balance - "&adjustments(i)&" WHERE invoice_no="&invoices(i)&" and ref_no='"&ref_no&"'"
                    cnroot.execute(sqlUpdate) 
                    isArFolderExist = false
                end if

            set objAccess = nothing   

            end if

            arMonthPath = CInt(arMonthPath) - 1

            if arMonthPath = 0 then
                    arMonthPath = 12
                    arYearPath = CInt(arYearPath) - 1
            end if

            if Len(arMonthPath) = 1 then
                    arMonthPath = "0" & arMonthPath
            end if

            arPath = mainPath & arYearPath & "-" & arMonthPath & arFile
            arFolderPath = mainPath & yearPath & "-" & arMonthPath

            if fs.FolderExists(arFolderPath) <> true then 
                isArFolderExist = false
            end if
        
        loop


        ' sqlUpdate = "UPDATE "&arPath&" SET balance = balance - "&adjustments(i)&" WHERE invoice_no="&invoices(i)&" and ref_no='"&ref_no&"'"
        ' cnroot.execute(sqlUpdate) 

        sqlAdd2 = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status)"&_
        "VALUES ("&maxID&" ,'"&ref_no&"', '"&transact_type&"', "&custID&" , "&invoices(i)&", "&adjustments(i)&", " &credit&", ctod(["&systemDate&"]), '"&status&"')"
        cnroot.execute(sqlAdd2)

        maxID = maxID + 1

        cashPaid = cashPaid + adjustments(i)
        'newOB = newOB + obContainer
        
        cust_type = "in"
        'newBal = currOB

        sqlAdd3 = "INSERT INTO "&adjustmentsPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, a_type, amount, remarks)"&_
        "VALUES ("&maxADid&", "&custID&", '"&custName&"', '"&department&"', "&invoices(i)&", '"&ref_no&"', ctod(["&systemDate&"]), '"&transact_type&"', "&adjustments(i)&", '"&remarks&"')"
        set objAccess = cnroot.execute(sqlAdd3)
        set objAccess = nothing  

        maxADid = maxADid + 1

    next

    Dim currOB
        currOB = 0.00

    Dim obFile, obPath

    obFile = "\ob_test.dbf"
    obPath = mainPath & yearPath & "-" & monthPath & obFile 

    sqlGetOB = "SELECT id, balance FROM "&obPath&" WHERE cust_id="&custID&" GROUP BY cust_id"
    set objAccess = cnroot.execute(sqlGetOB)

    if not objAccess.EOF then
        currOB = CDbl(objAccess("balance").value)
    end if
    set objAccess = nothing

    newOB = currOB - cashPaid
    

    rs.Open "SELECT MAX(id) FROM "&obPath&";", CN2
    do until rs.EOF
        for each x in rs.Fields
            maxOBtestID = x.value
        next
        rs.MoveNext
    loop
    maxOBtestID = CLng(maxOBtestID) + 1
    rs.close

    sqlAdd2 = "INSERT INTO "&obPath&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status)"&_
              "VALUES ("&maxObTestID&", '"&ref_no&"', "&custID&", '"&transact_type&"', '"&cust_type&"', "&cashPaid&", "&newOB&", ctod(["&systemDate&"]), '"&status&"')"
    set objAccess = cnroot.execute(sqlAdd2)
    set objAccess = nothing   

%>