<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%

    Dim custName, ref_no, totalCashPayment, dateTransact, isValidRef, userPayment
    Dim totalProfit, cashierName, custDepartment

    custName = Trim("Offline-T")
    custDepartment = Trim("none")
    isValidRef = true
    dateTransact = CDate(Request.Form("date"))
    userPayment = "Cash"
    referenceNo = CStr(Request.Form("ref_no"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)

    totalCashPayment = CDbl(Request.Form("total_payment"))
    
    totalProfit = 0.00
    email = CStr(Request.Form("cashierEmail"))
    'Set the user type of the cashier's currently logged in'
    sqlGetInfo = "SELECT * FROM users WHERE email='"&email&"'"    
    set objAccess = cnroot.execute(sqlGetInfo)

    if not objAccess.EOF then

        cashierName = Trim(objAccess("first_name")) & " " & Trim(objAccess("last_name"))

    end if

    set objAccess = nothing

    sqlCheckRef = "SELECT ref_no FROM reference_no WHERE ref_no='"&referenceNo&"'"
    set objAccess = cnroot.execute(sqlCheckRef)

        if not objAccess.EOF then

            isValidRef = false
            'Response.Write("false")
            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Error: Reference already exist!')")
            Response.Write("</script>")

            if isValidRef = false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""t_offline_transact.asp"";")
                Response.Write("</script>")
            end if

        end if

    set objAccess = nothing

    if isValidRef = true then

        Dim yearPath, monthPath

        yearPath = CStr(Year(systemDate))
        monthPath = CStr(Month(systemDate))

        if Len(monthPath) = 1 then
            monthPath = "0" & monthPath
        end if

        Dim salesFile, collectionsFile, transactionsFile

        transactionsFile = "\transactions.dbf"
        salesFile = "\sales.dbf"
        collectionsFile = "\collections.dbf"
        

        Dim salesPath, collectionsPath, transactionsPath

        transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
        salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
        collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile

        Dim maxInvoice, maxTransactID
        rs.open "SELECT MAX(invoice_no) AS invoice, MAX(transactid) AS transactid FROM "&salesPath&"", CN2

            do until rs.EOF
                for each x in rs.Fields

                    if x.name = "invoice" then
                        maxInvoice = x.value
                    end if

                    if x.name = "transactid" then
                        maxTransactID = x.value
                    end if

                next
                rs.MoveNext
            loop
            
            maxInvoice = CLng(maxInvoice) + 1  
            maxTransactID= CLng(maxTransactID) + 1  

        rs.close


        sqlAdd = "INSERT INTO "&salesPath&" (transactid, ref_no, invoice_no, cashier, date, cash_paid, amount, profit, payment)"&_ 
        "VALUES ("&maxTransactID&", "&referenceNo&", "&maxInvoice&", '"&cashierName&"', ctod(["&dateTransact&"]), "&totalCashPayment&", "&totalCashPayment&", "&totalProfit&", '"&userPayment&"')"

        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing 

        Dim maxCollectID, maxCRefNo
        rs.Open "SELECT MAX(id) FROM "&collectionsPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields

                    maxCollectID = x.value
    
                next
                rs.MoveNext
            loop
            maxCollectID = CLng(maxCollectID) + 1
            'maxCRefNo = CLng(maxCRefNo) + 1
            

        rs.close  

        Dim maxID  
        rs.Open "SELECT MAX(id) AS id FROM "&transactionsPath&";", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxID = x.value
                next
                rs.MoveNext
            loop
            maxID = CLng(maxID) + 1
        rs.close

        Dim transact_type, credit, status, custID
        custID = 0
        transact_type = "Cash"
        credit = 0.00
        status = ""

        sqlAdd = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status)"&_
        "VALUES ("&maxID&", "&referenceNo&", '"&transact_type&"', "&custID&" , "&maxInvoice&", "&totalCashPayment&", " &credit&", ctod(["&dateTransact&"]), '"&status&"')"
        set objAccess = cnroot.execute(sqlAdd)
        set objAccess = nothing

        Dim cash_paid, paymentMethod
        cash_paid = totalCashPayment
        paymentMethod = Trim("cash")

        sqlCollectAdd = "INSERT INTO "&collectionsPath&""&_ 
        "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, p_method)"&_
        "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&maxInvoice&", "&referenceNo&", ctod(["&dateTransact&"]), "&totalCashPayment&", "&totalCashPayment&", '"&paymentMethod&"')"
        cnroot.execute(sqlCollectAdd)

        ' sqlUpdateRef = "UPDATE reference_no SET ref_no = ref_no + 1"
        ' cnroot.execute(sqlUpdateRef)

        CN2.close

        Response.Write("<script language=""javascript"">")
        Response.Write("alert('Transaction Completed!')")
        Response.Write("</script>")
        isCompleted = true

        if isCompleted = true then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""t_offline_transact.asp"";")
            Response.Write("</script>")
        end if

    end if

%>