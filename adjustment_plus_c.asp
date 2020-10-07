<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
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
    systemDate = CDate(Application("date"))
    'Response.Write dateOwed
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

        Dim mainPath, yearPath, monthPath, arYearPath, arMonthPath

        mainPath = CStr(Application("main_path"))
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

        ' Dim transactionsFile

        ' transactionsFile = "\transactions.dbf"

        Dim arFile, transactionsFile, adjustmentFile

        arFile = "\accounts_receivables.dbf"
        transactionsFile = "\transactions.dbf"
        adjustmentFile = "\adjustments.dbf"

        Dim arOrigPath, arPath, transactionsPath, adjustmentPath

        arOrigPath = mainPath & arYearPath & "-" & arMonthPath & arFile
        arPath = mainPath & yearPath & "-" & monthPath & arFile
        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        adjustmentPath = mainPath & yearPath & "-" & monthPath & adjustmentFile

        'Response.Write arPath
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

        isDuplicate = "yes"

        sqlArUpdate = "UPDATE "&arOrigPath&" SET balance = balance + "&adjustmentValue&" WHERE invoice_no="&invoice
        cnroot.execute(sqlArUpdate)

        if arOrigPath <> arPath then

        sqlGetAr = "SELECT * FROM "&arPath&" WHERE invoice_no = "&invoice
        set objAccess = cnroot.execute(sqlGetAr)

            if not objAccess.EOF then

                ' rs.open "SELECT balance FROM "&arPath&" WHERE invoice_no="&invoice, CN2
                ' newArBal = adjustmentValue + CDbl(rs("balance"))
                ' rs.close

                ' sqlUpdate = "UPDATE "&arPath&" SET balance = "&newArBal&" WHERE invoice_no="&invoice&" AND ref_no='"&referenceNo&"'"
                ' cnroot.execute(sqlUpdate)
                sqlUpdate = "UPDATE "&arPath&" SET balance = balance + "&adjustmentValue&" WHERE invoice_no="&invoice
                cnroot.execute(sqlUpdate)

            else
                
                rs.open "SELECT * FROM "&arOrigPath&" WHERE invoice_no = "&invoice, CN2

                do until rs.EOF
                    
                    addArDuplicate = "INSERT INTO "&arPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate) "&_
                    "VALUES ("&maxArId&", "&rs("cust_id")&", '"&rs("cust_name")&"', '"&rs("cust_dept")&"', '"&rs("ref_no")&"', "&rs("invoice_no")&" , "&rs("receivable")&", "&rs("balance")&", ctod(["&rs("date_owed")&"]), '"&isDuplicate&"')"
                    cnroot.execute(addArDuplicate)

                rs.movenext
                loop
                
                rs.close
    
            end if

        set objAccess = nothing    

        maxArId = maxArId + 1

        end if
        ' sqlAddAr = "INSERT INTO "&arPath&" "&_
        ' "(ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, status) "&_
        ' "VALUES ("&maxArId&", "&custID&", '"&custName&"', '"&department&"', '"&referenceNo&"', "&invoice&", "&receivable&", "&balance&", ctod(["&systemDate&"]), '"&arStatus&"')"
        ' cnroot.execute(sqlAddAr)

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

        Response.Write(referenceNo)
    end if
%>