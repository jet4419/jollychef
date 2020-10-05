<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%
    Dim myInvoices, myValues, subTotal, cashPayment, custID, strInvoices 
    Dim strValues, values, invoices, systemDate, referenceNo, isValidRef

    isValidRef = true
    myInvoices = Request.Form("myInvoices")
    myValues = Request.Form("myValues")
    subTotal = CDbl(Request.Form("subTotal"))
    cashPayment = CDbl(Request.Form("cashPayment"))
    custID = CDbl(Request.Form("custID"))

    systemDate = CDate(Application("date"))
    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)

    values = Split(myValues,",")
    invoices = Split(myInvoices,",")

    sqlCheckRef = "SELECT ref_no FROM reference_no WHERE ref_no='"&referenceNo&"'"
    set objAccess = cnroot.execute(sqlCheckRef)

        if not objAccess.EOF then

            isValidRef = false
            Response.Write("false")

        end if

    set objAccess = nothing


    if isValidRef = true then

        'Customer's info'
        Dim custName, custDepartment, paymentMethod
        paymentMethod = "ar"


        sqlCustInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
        set objAccess = cnroot.execute(sqlCustInfo)

        if not objAccess.EOF then

            custName = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
            custDepartment = objAccess("department").value

        end if

        set objAccess = nothing


        Dim mainPath, yearPath, monthPath

        mainPath = CStr(Application("main_path"))
        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim salesFile, salesOrderFile, collectionsFile, transactionsFile

        transactionsFile = "\transactions.dbf"
        obFile = "\ob_test.dbf"
        salesFile = "\sales.dbf"
        collectionsFile = "\collections.dbf"
        arFile = "\accounts_receivables.dbf"
        

        Dim salesPath, salesOrderPath, collectionsPath, transactionsPath

        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        obPath = mainPath & yearPath & "-" & monthPath & obFile
        salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile
    
        Dim maxID, transact_type, credit, currDate, invoice, status
            transact_type = "Pay"
            credit = 0.00
            invoice = 0
            status = ""
            maxID = 0

            rs.Open "SELECT MAX(id) AS id FROM "&transactionsPath&";", CN2
                do until rs.EOF
                    for each x in rs.Fields
                        maxID = x.value
                    next
                    rs.MoveNext
                loop
                maxID = CDbl(maxID) + 1

            rs.close 

            rs.Open "SELECT MAX(id) FROM "&obPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxOBtestID = x.value
                next
                rs.MoveNext
            loop
            maxOBtestID = CDbl(maxOBtestID) + 1
            rs.close

        Dim currOB
        currOB = 0.00
        sqlGetOB = "SELECT balance FROM "&obPath&" WHERE cust_id="&custID&" GROUP BY cust_id"
        set objAccess = cnroot.execute(sqlGetOB)

        if not objAccess.EOF then
            currOB = CDbl(objAccess("balance").value)
        end if
        set objAccess = nothing

        Dim newOB, cust_type, newBal
        newOB = currOB - subTotal
        
        cust_type = "in"
        newBal = currOB

        Dim isDuplicate
        isDuplicate = ""

        sqlAdd2 = "INSERT INTO "&obPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate) "&_
        "VALUES ("&maxObTestID&", '"&referenceNo&"', "&custID&", '"&custName&"', '"&custDepartment&"', '"&transact_type&"', '"&cust_type&"', "&cashPayment&" , "&newOB&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
        set objAccess = cnroot.execute(sqlAdd2)
        set objAccess = nothing   

        ' Dim maxArId
        ' rs.Open "SELECT MAX(ar_id) FROM "&arPath&";", CN2
        '     do until rs.EOF
        '         for each x in rs.Fields
        '             maxArId = x.value
        '         next
        '         rs.MoveNext
        '     loop
        '     maxArId = CDbl(maxArId) + 1
        ' rs.close
        
        Dim maxCollectID
        rs.Open "SELECT MAX(id) FROM "&collectionsPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields

                    maxCollectID = x.value

                next
                rs.MoveNext
            loop
            maxCollectID = CDbl(maxCollectID) + 1
            

        rs.close  
        

        for i=0 to Ubound(invoices) - 1

            ' sqlUpdate = "UPDATE "&arPath&" SET balance=balance-"&values(i)&" WHERE invoice_no="&invoices(i)
            ' cnroot.execute(sqlUpdate)

            sqlGetAr = "SELECT balance, date_owed, duplicate FROM "&arPath&" WHERE invoice_no = "&invoices(i)&" GROUP BY invoice_no"
            set objAccess = cnroot.execute(sqlGetAr)

            if not objAccess.EOF then

                balance = CDbl(objAccess("balance"))
                arDate = CDate(objAccess("date_owed"))
                duplicate = Trim(CStr(objAccess("duplicate")))
    
            end if
            
            set objAccess = nothing

            balance = balance - values(i)
            

            sqlUpdate = "UPDATE "&arPath&" SET balance = balance-"&values(i)&" WHERE invoice_no="&invoices(i)
            cnroot.execute(sqlUpdate)

            if duplicate = "yes" then

                arYear = Year(arDate)
                arMonth = Month(arDate)

                if Len(arMonth) = 1 then
                    arMonth = "0" & arMonth
                end if

                arOrigPath = mainPath & arYear & "-" & arMonth & arFile

                sqlArUpdate = "UPDATE "&arOrigPath&" SET balance = balance-"&values(i)&" WHERE invoice_no="&invoices(i)
                cnroot.execute(sqlArUpdate)

            end if 

            sqlCollectAdd = "INSERT INTO "&collectionsPath&""&_ 
            "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate)"&_
            "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&invoices(i)&", '"&referenceNo&"', ctod(["&systemDate&"]), "&values(i)&", "&values(i)&", "&balance&", '"&paymentMethod&"', '"&isDuplicate&"')"
            cnroot.execute(sqlCollectAdd)

            maxCollectID = maxCollectID + 1

            'Balance per paid invoices
        
            sqlAdd2 = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
            "VALUES ("&maxID&" , '"&referenceNo&"', '"&transact_type&"', "&custID&" , "&invoices(i)&", "&values(i)&", " &credit&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
            cnroot.execute(sqlAdd2)

            maxID = maxID + 1

        next

        Dim maxRefId 

        rs.Open "SELECT MAX(id) AS id FROM reference_no;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxRefId = x.value
                next
                rs.MoveNext
            loop
            maxRefId = CDbl(maxRefId) + 1
        rs.close

        sqlRefAdd = "INSERT INTO reference_no (id, ref_no) "&_
                    "VALUES ("&maxRefId&", '"&referenceNo&"')"
        cnroot.execute(sqlRefAdd)            

        CN2.close
        
        Response.Write(referenceNo)

    end if

%>