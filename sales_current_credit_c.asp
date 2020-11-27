<!--#include file="dbConnect.asp"-->

<%
    Dim myInvoices, myValues, subTotal, cashPayment, custID, strInvoices 
    Dim strValues, values, invoices, referenceNo, paymentMethod

    myInvoices = Request.Form("myInvoices")
    myValues = Request.Form("myValues")
    subTotal = CDbl(Request.Form("subTotal"))
    cashPayment = CDbl(Request.Form("cashPayment"))
    custID = CLng(Request.Form("custID"))
    referenceNo = Request.Form("referenceNo")
    paymentMethod = CStr(Request.Form("paymentMethod"))
    arPath = CStr(Request.Form("arPath"))

    values = Split(myValues,",")
    invoices = Split(myInvoices,",")

    'Start of the update

    Dim yearPath, monthPath

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
    'arFile = "\accounts_receivables.dbf"
    

    Dim salesPath, salesOrderPath, collectionsPath, transactionsPath

    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
    obPath = mainPath & yearPath & "-" & monthPath & obFile
    salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
    'arPath = mainPath & yearPath & "-" & monthPath & arFile

    Dim newBal, invoiceNewPayment
    newBal = 0.00
    invoiceNewPayment = 0.00

    Dim collectionID

    for i=0 to Ubound(invoices) - 1                         
        
        sqlGetNewBal = "SELECT debit FROM "&transactionsPath&" WHERE ref_no='"&referenceNo&"' and invoice="&invoices(i)
        set objAccess = cnroot.execute(sqlGetNewBal)

        if not objAccess.EOF then
            'tID = rs("id").value
            invoiceNewPayment = CDbl(values(i)) - CDbl(objAccess("debit").value)
            newBal = newBal +  (CDbl(values(i)) - CDbl(objAccess("debit").value))
        end if

        set objAccess = nothing

        'When getting this ID you will be able to update the other collections record.'

        getCollectID = "SELECT id FROM "&collectionsPath&" WHERE ref_no='"&referenceNo&"' and invoice="&invoices(i) 
        set objAccess = cnroot.execute(getCollectID)

        if not objAccess.EOF then
            collectionID = CDbl(objAccess("id"))
        end if

        set objAccess = nothing
        'Wrong update. Cause of bug'
        sqlUpdateCollection = "UPDATE "&collectionsPath&" SET balance = balance - ("&invoiceNewPayment&") "&_
                              "WHERE id >= "&collectionID&" AND invoice="&invoices(i) 
        cnroot.execute(sqlUpdateCollection)  

        sqlUpdateCollection2 = "UPDATE "&collectionsPath&" SET cash="&values(i)&", tot_amount="&values(i)&" "&_
                               "WHERE ref_no='"&referenceNo&"' AND invoice = "&invoices(i) 
        cnroot.execute(sqlUpdateCollection2)

        sqlTransactUpdate = "UPDATE "&transactionsPath&" SET debit="&values(i)&" WHERE ref_no='"&referenceNo&"' and invoice="&invoices(i)  
        cnroot.execute(sqlTransactUpdate)    

        'Getting the Ar record to be able to update the original AR record.'
        ' sqlGetAr = "SELECT date_owed, duplicate FROM "&arPath&" WHERE invoice_no = "&invoices(i)&" GROUP BY invoice_no"
        ' set objAccess = cnroot.execute(sqlGetAr)

        ' if not objAccess.EOF then

        '     arDate = CDate(objAccess("date_owed"))
        '     duplicate = Trim(CStr(objAccess("duplicate")))
 
        ' end if
        
        ' set objAccess = nothing    

        ' if duplicate = "yes" then

        '     arYear = Year(arDate)
        '     arMonth = Month(arDate)

        '     if Len(arMonth) = 1 then
        '         arMonth = "0" & arMonth
        '     end if

        '     arOrigPath = mainPath & arYear & "-" & arMonth & arFile

        '     sqlArUpdate = "UPDATE "&arOrigPath&" SET balance = balance - ("&invoiceNewPayment&") WHERE invoice_no="&invoices(i)
        '     cnroot.execute(sqlArUpdate)

        ' end if                       

        sqlArUpdate = "UPDATE "&arPath&" SET balance = balance - ("&invoiceNewPayment&") WHERE invoice_no="&invoices(i)
        cnroot.execute(sqlArUpdate)

        sqlSalesUpdate = "UPDATE "&salesPath&" SET cash_paid="&values(i)&", amount="&values(i)&" WHERE ref_no='"&referenceNo&"' and invoice_no="&invoices(i)
        cnroot.execute(sqlSalesUpdate)

    next

    Dim obID

    sqlOBid = "SELECT id FROM "&obPath&" WHERE ref_no='"&referenceNo&"' and cust_id="&custID
    set objAccess = cnroot.execute(sqlOBid)
    
    if not objAccess.EOF then
        obID = CLng(objAccess("id").value)
    end if

    set objAccess = nothing

    sqlObUpdate = "UPDATE "&obPath&" SET balance = balance - ("&newBal&"), cash_paid="&cashPayment&" WHERE id >= "&obID&" and cust_id="&custID
    cnroot.execute(sqlObUpdate)

    ' sqlUpdateRef = "UPDATE reference_no SET ref_no = ref_no + 1"
    ' cnroot.execute(sqlUpdateRef)

   

    
    
    Response.Write(referenceNo)



%>