<!--#include file="dbConnect.asp"-->

<%
    Dim collectID, custName, invoice, ref_no, collectDate, cash_paid, ar_paid, editCash, isAR
    collectID = CInt(Request.Form("collectionID"))
    Dim yearPath, monthPath
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))
    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if
    Dim collectionsFile, salesFile
    collectionsFile = "\collections.dbf"
    salesFile = "\sales.dbf"
    Dim collectionsPath, salesPath
    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
    salesPath = mainPath & yearPath & "-" & monthPath & salesFile
    rs.open "SELECT * FROM "&collectionsPath&" WHERE id="&collectID, CN2
    if not rs.EOF then
        custID = rs("cust_id").value
        custName = rs("cust_name").value
        invoice = rs("invoice").value
        ref_no = rs("ref_no").value
        collectDate = rs("date").value
        cash_paid = CDbl(rs("cash").value)
        'ar_paid = CDbl(rs("ar_paid").value)
    end if
    sqlGetCashPaid = "SELECT cash_paid FROM "&salesPath&" WHERE invoice_no="&invoice
    set objAccess = cnroot.execute(sqlGetCashPaid)
    if not objAccess.EOF then
        previousCashPaid = CDbl(objAccess("cash_paid").value)        
    end if
    collectDate = FormatDateTime(collectDate, 2)
    ' if ar_paid > CDbl(0.00) then
    '     editCash = ar_paid
    '     isAR = true
    ' else
    '     editCash = cash_paid
    '     isAR = false
    ' end if
    rs.close
    CN2.close
%>

    <div class="form-group mb-1">   
        <input type="number" name="collectID" value="<%=collectID%>" hidden> 
        <input type="number" name="custID" value="<%=custID%>" hidden> 
        <label class="ml-1" style="font-weight: 500"> Customer Name </label>
        <input type="text" class="form-control form-control-sm" name="custName" id="custName" value="<%=custName%>" readonly>
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Invoice No. </label>
        <input type="number" class="form-control form-control-sm" name="invoice" id="invoice" value="<%=invoice%>" readonly>   
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Reference No. </label>
        <input type="text" class="form-control form-control-sm" name="ref_no" id="ref_no" value="<%=ref_no%>" readonly>   
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Previously Cash Paid (&#8369;)</label>
        <input type="number" class="form-control form-control-sm" value="<%=previousCashPaid%>" readonly>   
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Date</label>
        <input type="text" class="form-control form-control-sm" name="collectDate" id="collectDate" value="<%=collectDate%>" readonly>
    </div>

    <div class="form-group mt-3">         
        <label class="ml-1" style="font-weight: 500"> Paid Money </label>
        <select name="paymentMethod">
            <option selected value="cash">Cash</option>
        </select>
        <div class="input-group input-group-sm mb-3">
            <div class="input-group-prepend">
                <span class="input-group-text bg-primary text-light" id="inputGroup-sizing-sm">&#8369;</span>
            </div>
            <input id="cash" type="number" name="cash" min="<%=cash_paid%>" step="any" class="form-control" value="<%=editCash%>" min="0.1" required>
        </div>
    </div>