<!--#include file="dbConnect.asp"-->


<%
    Dim myInvoices, myValues, values, invoices, isValidRef, referenceNo, arReferenceNo, isValidTransact
    isValidTransact = true

    myInvoices = Request.Form("myInvoices")
    myValues = Request.Form("myValues")
    values = Split(myValues,",")
    invoices = Split(myInvoices,",")

    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)
    arReferenceNo = Trim(CStr(Request.Form("arReferenceNo")))
    isValidRef = true
    subTotal = CDbl(Request.Form("subTotal"))
    cashPayment = CDbl(Request.Form("cashPayment"))

    if subTotal <=0 or cashPayment <=0 or cashPayment < subTotal then

        isValidTransact = false

    else

        if myInvoices = "" or myValues = "" then
            isValidTransact = false
        end if

    end if

    Dim totalPaymentValue
    totalPaymentValue = 0

    for i=0 to Ubound(invoices) - 1

        totalPaymentValue = totalPaymentValue + CDbl(values(i))

    next

    if totalPaymentValue <> subTotal then
        isValidTransact = false
    end if


    if isValidTransact = true then

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim referenceNoFile
        referenceNoFile = "\reference_no.dbf" 

        Dim referenceNoPath
        referenceNoPath = mainPath & yearPath & "-" & monthPath & referenceNoFile

        Dim minRefNo
        rs.Open "SELECT TOP 1 ref_no FROM "&referenceNoPath&" ORDER BY id ASC;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    minRefNo = x.value
                next
                rs.MoveNext
            loop
        rs.close   

        if minRefNo = "" then
            minRefNo = CLNG(minRefNo) + 1
        else
            minRefNo = CLNG(Mid(minRefNo, 6)) + 1
        end if

        if CLNG(Request.Form("referenceNo")) < minRefNo then

            isValidRef = false
            Response.Write("false")

        else

            sqlCheckRef = "SELECT ref_no FROM "&referenceNoPath&" WHERE ref_no='"&referenceNo&"'"
            set objAccess = cnroot.execute(sqlCheckRef)

            if not objAccess.EOF then

                isValidRef = false
                Response.Write("false")

            end if

        end if

        if isValidRef = true then

            'Customer's info'
            Dim custName, custDepartment, paymentMethod
            paymentMethod = "ar"

            Dim subTotal, cashPayment, custID, strInvoices 

            custID = CDbl(Request.Form("custID"))
            custName = CStr(Request.Form("custName"))
            custDepartment = CStr(Request.Form("custDepartment"))
            ' creditDate = CStr(Request.Form("creditDate"))
            ' Response.Write myInvoices

            ' Response.Write invoices

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

            Dim invoiceBalance     

            'To prevent negative values'
            for i=0 to Ubound(invoices) - 1

                sqlGetAr = "SELECT balance FROM "&arPath&" WHERE invoice_no = "&invoices(i)&" and cust_id="&custID&" GROUP BY invoice_no"
                set objAccess = cnroot.execute(sqlGetAr)

                if not objAccess.EOF then

                    invoiceBalance = CDbl(objAccess("balance"))

                else
                        
                    isValidTransact = false
                    EXIT FOR
                    'Previous Code'
                    ' invoiceBalance = 0

                end if

                invoiceBalance = invoiceBalance - values(i)

                if invoiceBalance < 0 then

                    isValidTransact = false
                    EXIT FOR

                end if

            next

            

            'if no negative values payment will be processed'
            if isValidTransact = true then

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

                Dim counter, balance
                counter = 0
                balance = 0

                for i=0 to Ubound(invoices) - 1

                    counter = counter + 1

                    sqlGetAr = "SELECT balance, date_owed FROM "&arPath&" WHERE invoice_no = "&invoices(i)&" and cust_id="&custID&" GROUP BY invoice_no"
                    set objAccess = cnroot.execute(sqlGetAr)

                    if not objAccess.EOF then

                        balance = CDbl(objAccess("balance"))
                        arDate = CDate(objAccess("date_owed"))
            
                    end if

                    balance = balance - values(i)

                    sqlArUpdate = sqlArUpdate & "UPDATE "&arPath&" SET balance = "&balance&" WHERE invoice_no="&invoices(i)&"; "

                    sqlCollectAdd = sqlCollectAdd & "INSERT INTO "&collectionsPath&""&_ 
                    "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate)"&_
                    "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&invoices(i)&", '"&referenceNo&"', ctod(["&systemDate&"]), "&values(i)&", "&values(i)&", "&balance&", '"&paymentMethod&"', '"&isDuplicate&"'); "
                    'cnroot.execute(sqlCollectAdd)

                    maxCollectID = maxCollectID + 1

                    sqlAddTransactions = sqlAddTransactions & "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
                    "VALUES ("&maxID&" , '"&referenceNo&"', '"&transact_type&"', "&custID&" , "&invoices(i)&", "&values(i)&", " &credit&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"'); "
                    'cnroot.execute(sqlAdd2)

                    maxID = maxID + 1

                next
                ' updateStr = updateStr & iifs & endingIf & parens
                ' cnroot.execute(updateStr)

                'Updating data'
                cnroot.execute(sqlArUpdate)
                cnroot.execute(sqlCollectAdd)
                cnroot.execute(sqlAddTransactions)

                Dim maxRefId 
                maxRefId = 0

                getMaxRefID = "SELECT MAX(id) AS id FROM "&referenceNoPath&";"
                set objAccess = cnroot.execute(getMaxRefID)

                if not objAccess.EOF then
                    maxRefId = CDbl(objAccess("id"))
                end if

                maxRefId = maxRefId + 1

                sqlRefAdd = "INSERT INTO "&referenceNoPath&" (id, ref_no, duplicate) "&_
                            "VALUES ("&maxRefId&", '"&referenceNo&"', '')"
                cnroot.execute(sqlRefAdd) 


                set objAccess = nothing
                CN2.close
                
                Response.Write(referenceNo)

            else 
                Response.Write "invalid transactions"
            end if

        end if
    else
        Response.Write "invalid transactions"
    end if
%>