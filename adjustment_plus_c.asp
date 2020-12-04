<!--#include file="dbConnect.asp"-->

<%

    ' if Session("type") = "" then
    '     Response.Redirect("canteen_login.asp")
    ' end if

    Dim custID, custName, cash, invoice

    invoice = CDbl(Request.Form("invoice"))
    adjustmentValue = CDbl(Request.Form("adjustmentValue"))
    custID = CLng(Request.Form("custID"))
    custName = CStr(Request.Form("custName"))
    department = CStr(Request.Form("department"))
    receivable = CDbl(Request.Form("receivable"))
    balance = CDbl(Request.Form("balance"))
    dateOwed = CDate(Request.Form("dateOwed"))

    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & "AD" & referenceNo)

    remarks = CStr(Request.Form("remarks"))
    balance = balance + adjustmentValue
    
    Dim isValidRef
    isValidRef = true

    sqlCheckRef = "SELECT ref_no FROM adjustment_ref_no WHERE ref_no='"&referenceNo&"'"
    set objAccess = cnroot.execute(sqlCheckRef)

        if not objAccess.EOF then

            isValidRef = false
            Response.Write("false")

        end if

    set objAccess = nothing

    if isValidRef = true then

        Dim yearPath, monthPath, arYearPath, arMonthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))
        arYearPath = CStr(Year(dateOwed))
        arMonthPath = CStr(Month(dateOwed))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        if Len(arMonthPath) = 1 then
            arMonthPath = "0" & arMonthPath
        end if

        Dim arFile, transactionsFile, adjustmentFile

        arFile = "\accounts_receivables.dbf"
        transactionsFile = "\transactions.dbf"
        adjustmentFile = "\adjustments.dbf"

        Dim arOrigPath, arPath, transactionsPath, adjustmentPath

        arOrigPath = mainPath & arYearPath & "-" & arMonthPath & arFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile
        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile

        Dim maxArId
        rs.Open "SELECT MAX(ar_id) FROM "&arPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxArId = x.value
                next
                rs.MoveNext
            loop
            maxArId = CDbl(maxArId) + 1
        rs.close

        Dim maxID, transact_type, credit
        transact_type = "A-plus"
        debit = 0.00
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

        isDuplicate = "yes"

        sqlArUpdate = "UPDATE "&arOrigPath&" SET balance = balance + "&adjustmentValue&" WHERE invoice_no="&invoice
        cnroot.execute(sqlArUpdate)

        sqlAdd2 = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
        "VALUES ("&maxID&" ,'"&referenceNo&"', '"&transact_type&"', "&custID&" , "&invoice&", "&debit&", " &adjustmentValue&", ctod(["&systemDate&"]), '"&status&"', '')"
        cnroot.execute(sqlAdd2)

        maxID = maxID + 1

        cashPaid = cashPaid + adjustmentValue
        
        cust_type = "in"

        sqlAdd3 = "INSERT INTO "&adjustmentPath&" (id, cust_id, cust_name, department, invoice, ref_no, date, a_type, amount, balance, remarks, duplicate)"&_
        "VALUES ("&maxADid&", "&custID&", '"&custName&"', '"&department&"', "&invoice&", '"&referenceNo&"', ctod(["&systemDate&"]), '"&transact_type&"', "&adjustmentValue&", "&balance&", '"&remarks&"', '')"
        set objAccess = cnroot.execute(sqlAdd3)
        set objAccess = nothing  

        maxADid = maxADid + 1

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

        newOB = currOB + cashPaid
        

        rs.Open "SELECT MAX(id) FROM "&obPath&";", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxOBtestID = x.value
            next
            rs.MoveNext
        loop
        maxOBtestID = CLng(maxOBtestID) + 1
        rs.close

        sqlAdd2 = "INSERT INTO "&obPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate)"&_
                "VALUES ("&maxObTestID&", '"&referenceNo&"', "&custID&", '"&custName&"', '"&department&"', '"&transact_type&"', '"&cust_type&"', "&cashPaid&", "&newOB&", ctod(["&systemDate&"]), '"&status&"', '')"
        set objAccess = cnroot.execute(sqlAdd2)
        set objAccess = nothing  
        
        Dim maxAdRefId 

        rs.Open "SELECT MAX(id) AS id FROM adjustment_ref_no;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxAdRefId = x.value
                next
                rs.MoveNext
            loop
            maxAdRefId = CDbl(maxAdRefId) + 1
        rs.close

        sqlRefAdd = "INSERT INTO adjustment_ref_no (id, ref_no) "&_
                    "VALUES ("&maxAdRefId&", '"&referenceNo&"')"
        cnroot.execute(sqlRefAdd)   

        'To send the referenceNo to the Adjustment receipt'
        Response.Write(referenceNo)
    end if
%>