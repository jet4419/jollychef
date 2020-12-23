<!--#include file="dbConnect.asp"-->


<%
    Dim isValidRef, referenceNo

    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)

    isValidRef = true

    sqlCheckRef = "SELECT ref_no FROM reference_no WHERE ref_no='"&referenceNo&"'"
    set objAccess = cnroot.execute(sqlCheckRef)

        if not objAccess.EOF then

            isValidRef = false
            Response.Write("false")

        end if

    if isValidRef = true then

        'Customer's info'
        Dim custName, custDepartment, paymentMethod
        paymentMethod = "ar"

        Dim myInvoices, myValues, subTotal, cashPayment, custID, strInvoices 
        Dim strValues, values, invoices

        myInvoices = Request.Form("myInvoices")
        myValues = Request.Form("myValues")
        subTotal = CDbl(Request.Form("subTotal"))
        cashPayment = CDbl(Request.Form("cashPayment"))
        custID = CDbl(Request.Form("custID"))
        custName = CStr(Request.Form("custName"))
        custDepartment = CStr(Request.Form("custDepartment"))
        ' creditDate = CStr(Request.Form("creditDate"))

        values = Split(myValues,",")
        invoices = Split(myInvoices,",")

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim collectionsFile, transactionsFile

        transactionsFile = "\transactions.dbf"
        obFile = "\ob_test.dbf"
        collectionsFile = "\collections.dbf"
        arFile = "\accounts_receivables.dbf"
        

        Dim collectionsPath, transactionsPath

        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        obPath = mainPath & yearPath & "-" & monthPath & obFile
        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile
    
        Dim maxID, maxOBtestID, transact_type, credit, currDate, invoice, status

            transact_type = "Pay"
            credit = 0.00
            invoice = 0
            status = ""
            maxID = 0
            maxOBtestID = 0

            getMaxTransactID = "SELECT MAX(id) AS id FROM "&transactionsPath&";"
            set objAccess = cnroot.execute(getMaxTransactID)

            if not objAccess.EOF then
                maxID = CDbl(objAccess("id"))
            end if

            maxID = maxID + 1

            getMaxObID = "SELECT MAX(id) AS id FROM "&obPath&";"
            set objAccess = cnroot.execute(getMaxObID)

            if not objAccess.EOF then
                maxOBtestID = CDbl(objAccess("id"))
            end if

            maxOBtestID = maxOBtestID + 1

        Dim currOB
        currOB = 0.00

        sqlGetOB = "SELECT balance FROM "&obPath&" WHERE cust_id="&custID&" GROUP BY cust_id"
        set objAccess = cnroot.execute(sqlGetOB)

        if not objAccess.EOF then
            currOB = CDbl(objAccess("balance").value)
        end if

        Dim newOB, cust_type, newBal
        newOB = currOB - subTotal
        
        cust_type = "in"
        newBal = currOB

        Dim isDuplicate
        isDuplicate = ""

        sqlAdd2 = "INSERT INTO "&obPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate) "&_
        "VALUES ("&maxObTestID&", '"&referenceNo&"', "&custID&", '"&custName&"', '"&custDepartment&"', '"&transact_type&"', '"&cust_type&"', "&cashPayment&" , "&newOB&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
        set objAccess = cnroot.execute(sqlAdd2) 

        Dim maxCollectID
        maxCollectID = 0

        getMaxCollectID = "SELECT MAX(id) AS id FROM "&collectionsPath&";"
        set objAccess = cnroot.execute(getMaxCollectID)

        if not objAccess.EOF then
            maxCollectID = CDbl(objAccess("id"))
        end if

        maxCollectID = maxCollectID + 1

        Dim updateStr, iifs, endingIf, parens, counter
        updateStr = "UPDATE "&arPath&" SET balance = "
        iifs = ""
        endingIf = "balance"
        parens = ""
        counter = 0

        for i=0 to Ubound(invoices) - 1

            counter = counter + 1

            sqlGetAr = "SELECT balance, date_owed FROM "&arPath&" WHERE invoice_no = "&invoices(i)&" GROUP BY invoice_no"
            set objAccess = cnroot.execute(sqlGetAr)

            if not objAccess.EOF then

                balance = CDbl(objAccess("balance"))
                arDate = CDate(objAccess("date_owed"))
    
            end if

            balance = balance - values(i)
            
            iifs = iifs & "iif(invoice_no = "&invoices(i)&", "&balance&", "
            parens = parens & ")"
    

            if counter = 10 then

                updateStr = updateStr & iifs & endingIf & parens
                cnroot.execute(updateStr)
                counter = 0
                updateStr = "UPDATE "&arPath&" SET balance = "
                iifs = ""
                parens = ""

            end if

            sqlCollectAdd = "INSERT INTO "&collectionsPath&""&_ 
            "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate)"&_
            "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&invoices(i)&", '"&referenceNo&"', ctod(["&systemDate&"]), "&values(i)&", "&values(i)&", "&balance&", '"&paymentMethod&"', '"&isDuplicate&"')"
            cnroot.execute(sqlCollectAdd)

            maxCollectID = maxCollectID + 1

            sqlAdd2 = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
            "VALUES ("&maxID&" , '"&referenceNo&"', '"&transact_type&"', "&custID&" , "&invoices(i)&", "&values(i)&", " &credit&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
            cnroot.execute(sqlAdd2)

            maxID = maxID + 1

        next

        updateStr = updateStr & iifs & endingIf & parens
        cnroot.execute(updateStr)

        Dim maxRefId 
        maxRefId = 0

        getMaxRefID = "SELECT MAX(id) AS id FROM reference_no;"
        set objAccess = cnroot.execute(getMaxRefID)

        if not objAccess.EOF then
            maxRefId = CDbl(objAccess("id"))
        end if

        maxRefId = maxRefId + 1

        sqlRefAdd = "INSERT INTO reference_no (id, ref_no) "&_
                    "VALUES ("&maxRefId&", '"&referenceNo&"')"
        cnroot.execute(sqlRefAdd) 


        set objAccess = nothing
        CN2.close
        
        Response.Write(referenceNo)

    end if

%>