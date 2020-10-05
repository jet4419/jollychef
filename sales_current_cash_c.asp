<!--#include file="dbConnect.asp"-->

<%

    Dim collectID, custName, invoice, ref_no, collectDate, cash_paid, ar_paid, editCash, paymentMethod, newBal

    collectID = Request.Form("collectID")
    custID = Request.Form("custID")
    invoice = Request.Form("invoice")
    ref_no = CStr(Request.Form("ref_no"))
    cash_paid = CDbl(Request.Form("cash"))
    paymentMethod = CStr(Request.Form("paymentMethod"))

    ' sqlUpdateCollection = "UPDATE collections SET cash="&cash_paid&", tot_amount="&cash_paid&" "&_
    '                       "WHERE id="&collectID  
    ' cnroot.execute(sqlUpdateCollection)

    Dim systemDate

    systemDate = CDate(Application("date"))

    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim salesFile

    salesFile = "\sales.dbf"

    Dim salesPath

    salesPath = mainPath & yearPath & "-" & monthPath & salesFile

    sqlSalesUpdate = "UPDATE "&salesPath&" SET cash_paid="&cash_paid&" WHERE ref_no='"&ref_no&"' and invoice_no="&invoice
    cnroot.execute(sqlSalesUpdate)

    ' if Trim(paymentMethod) = "AR" then
    '     sqlUpdateCollection = "UPDATE collections SET ar_paid="&cash_paid&", tot_amount="&cash_paid&" "&_
    '                           "WHERE id="&collectID  
    '     cnroot.execute(sqlUpdateCollection)

    '     rs.open "SELECT debit FROM transactions WHERE ref_no="&ref_no&" and invoice="&invoice, CN2

        ' if not rs.EOF then
            'tID = rs("id").value
        '     newBal = cash_paid - CDbl(rs("debit").value)
        ' end if

        ' rs.close

        ' sqlTransactUpdate = "UPDATE transactions SET debit="&cash_paid&" WHERE ref_no="&ref_no&" and invoice="&invoice  
        ' cnroot.execute(sqlTransactUpdate)

        ' sqlTransactUpdate2 = "UPDATE transactions SET balance = balance - ("&newBal&") WHERE id > "&tID&" and cust_id="&custID  
        ' cnroot.execute(sqlTransactUpdate2)

    '     sqlOBid = "SELECT id FROM ob_test WHERE ref_no="&ref_no&" and cust_id="&custID
    '     set objAccess = cnroot.execute(sqlOBid)

    '     Dim obID
    '     if not objAccess.EOF then
    '         obID = CInt(objAccess("id").value)
    '     end if

    '     set objAccess = nothing

    '     sqlObUpdate = "UPDATE ob_test SET balance = balance - ("&newBal&") WHERE id >= "&obID&" and cust_id="&custID
    '     cnroot.execute(sqlObUpdate)

    '     sqlArUpdate = "UPDATE accounts_receivables SET balance = balance - ("&newBal&") WHERE invoice_no="&invoice
    '     cnroot.execute(sqlArUpdate)

    '     sqlSalesUpdate = "UPDATE sales SET cash_paid="&cash_paid&", amount="&cash_paid&" WHERE ref_no="&ref_no&" and invoice_no="&invoice

    ' else
    '     sqlUpdateCollection = "UPDATE collections SET cash_paid="&cash_paid&", tot_amount="&cash_paid&" "&_
    '                           "WHERE id="&collectID
    '     cnroot.execute(sqlUpdateCollection)
    ' end if

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Transaction updated successfully!')")
    Response.Write("</script>")
    isUpdated=true
    if isUpdated = true then
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""sales_current_edit.asp"";")
        Response.Write("</script>")
    end if


%>