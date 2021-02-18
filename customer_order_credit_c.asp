<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%

    Dim arReferenceNo, isValidRef

    arReferenceNo = CStr(Request.Form("arReferenceNo"))
    arReferenceNo = Trim(CStr(Year(systemDate)) & "-" & "AR" & arReferenceNo)
    isValidRef = true

    Dim customerID, custName, customerDepartment, uniqueNum, customerType, transact_type

    customerID = CLng(Request.Form("cust_id"))
    custName = CStr(Request.Form("cust_name"))
    customerDepartment = CStr(Request.Form("cust_dept"))
    uniqueNum = CLng(Request.Form("unique_num"))
    customerType = CStr(Request.Form("customerType"))
    transact_type = "Buy"

    Dim userType, userEmail
    userType = CStr(Request.Form("userType"))
    userEmail = CStr(Request.Form("userEmail"))
    cashierName = CStr(Request.Form("cashierName"))

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim arReferenceNoFile
    arReferenceNoFile = "\ar_reference_no.dbf" 

    Dim arReferenceNoPath
    arReferenceNoPath = mainPath & yearPath & "-" & monthPath & arReferenceNoFile

    Dim minArRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&arReferenceNoPath&" ORDER BY id ASC;", CN2
        do until rs.EOF
            for each x in rs.Fields
                minArRefNo = x.value
            next
            rs.MoveNext
        loop
    rs.close  

    if minArRefNo = "" then
        minArRefNo = CLNG(minArRefNo) + 1
    else
        minArRefNo = CLNG(Mid(minArRefNo, 8)) + 1
    end if

    if CLNG(Request.Form("arReferenceNo")) < minArRefNo then

        isValidRef = false
        Response.Write("<script language=""javascript"">")
        Response.Write("alert('Error: Reference already exist!')")
        Response.Write("</script>")

        if isValidRef = false then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&customerID&"&userType="&userType&" "";")
            Response.Write("</script>")
        end if

    else

        sqlCheckRef = "SELECT ref_no FROM "&arReferenceNoPath&" WHERE ref_no='"&arReferenceNo&"'"
        set objAccess = cnroot.execute(sqlCheckRef)

            if not objAccess.EOF then

                isValidRef = false
                Response.Write("<script language=""javascript"">")
                Response.Write("alert('Error: Reference already exist!')")
                Response.Write("</script>")

            end if

            if isValidRef = false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&customerID&"&userType="&userType&" "";")
                Response.Write("</script>")
            end if

        set objAccess = nothing

    end if


    if isValidRef = true then    

        Dim ordersHolderFile

        ordersHolderFile = "\orders_holder.dbf" 

        Dim ordersHolderPath

        ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

        Dim totalProfit, totalAmount, isOrderExist
        isOrderExist = true

        'Getting the total profit and amount'
        sqlGetSum = "SELECT DISTINCT unique_num, SUM(qty) AS qty, SUM(amount) AS amount, SUM(profit) AS profit FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum&" GROUP BY unique_num"
        set objAccess  = cnroot.execute(sqlGetSum)

        if not objAccess.EOF then

            totalProfit = CDbl(objAccess("profit"))
            totalAmount = CDbl(objAccess("amount"))

        else

            Response.Write("<script language=""javascript"">")
            Response.Write("alert('Order doesn\'t exist!')")
            Response.Write("</script>")
            isOrderExist = false

            if isOrderExist = false then

                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href='customers_order.asp';")
                Response.Write("</script>")
            end if

        end if

        set objAccess = nothing
        'End of Getting the total Amount and Profit'

        if isOrderExist = true then

            rs.Open "SELECT * FROM products", CN2
            sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum&" GROUP BY prod_id" 
            set objAccess  = cnroot.execute(sqlAccess)

            'DECREASING THE ORDERED PRODUCTS QTY'
            if objAccess.EOF >= 0 then

                do until objAccess.EOF

                    do until rs.EOF

                        if CLng(objAccess("prod_id")) = CLng(rs("prod_id")) then 
                            'Response.Write(CLng(objAccess("prod_id")) = CLng(rs("prod_id")))
                            currQty = CLng(rs("qty")) - CLng(objAccess("qty"))
                            qtySold = CLng(objAccess("qty")) + CLng(rs("qty_sold"))

                            if CLng(currQty) < 0 then
                                Response.Write("<script language=""javascript"">")
                                Response.Write("alert('Error: Insufficient product stock!')")
                                Response.Write("</script>")
                                isProcessed = false
                                If isProcessed = false then
                                ' Response.Redirect("bootSales.asp")
                                    Response.Write("<script language=""javascript"">")
                                    'Response.Write("window.location.href=""a_sales.asp"";")
                                    Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&customerID&"&userType="&userType&" "";")
                                    Response.Write("</script>")
                                end If
                            
                            else
                                sqlUpdate = "UPDATE products SET qty="&currQty&", qty_sold="&qtySold&" WHERE prod_id="&rs("prod_id")
                                sqlDailyMeal = "UPDATE daily_meals SET qty="&currQty&" WHERE prod_id="&rs("prod_id")
                                cnroot.execute(sqlUpdate)
                                cnroot.execute(sqlDailyMeal)
                                Exit Do 
                            end if
                        end if  
                            
                        rs.MoveNext
                        

                    loop
                    objAccess.MoveNext
                loop


            end if

            rs.close
            set objAccess = nothing
            'END OF DECREASING THE ORDERED PRODUCTS QTY'

                Dim customerCash
                customerCash = 0.00
                balance = totalAmount - customerCash
                totalReceivable = totalAmount
                ' if balance = totalReceivable then
                '     arStatus = "Unpaid"
                ' end if


                email = userEmail
                'Set the user type of the cashier's currently logged in'
                ' sqlGetInfo = "SELECT * FROM users WHERE email='"&email&"'"    
                ' set objAccess = cnroot.execute(sqlGetInfo)

                ' if not objAccess.EOF then

                '     cashierName = Trim(objAccess("first_name")) & " " & Trim(objAccess("last_name"))

                ' end if

                ' set objAccess = nothing

                Dim payment
                payment = "Credit"


                Dim salesFile, salesOrderFile, transactionsFile, obFile, arFile

                salesFile = "\sales.dbf"
                salesOrderFile = "\sales_order.dbf"
                transactionsFile = "\transactions.dbf"
                obFile = "\ob_test.dbf"
                arFile = "\accounts_receivables.dbf"

                Dim salesPath, salesOrderPath, transactionsPath, obPath, arPath

                salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
                salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
                transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile
                obPath = mainPath & yearPath & "-" & monthPath & obFile
                arPath = mainPath & yearPath & "-" & monthPath & arFile


                'ORDERS REPORT'
                Dim maxInvoice
                maxInvoice = 0
                rs.Open "SELECT MAX(invoice_no) AS invoice FROM "&salesPath&";", CN2
                    if not rs.EOF then
                        maxInvoice = CLng(rs("invoice").value)
                    end if
                rs.close
                maxInvoice = maxInvoice + 1
                'END OF ORDERS REPORT'

                'SALES'
                Dim maxTransactID
                maxTransactID = 0
                rs.open "SELECT MAX(transactid) AS transactid FROM "&salesPath&"", CN2
                    if not rs.EOF then
                        maxTransactID = CLng(rs("transactid").value)
                    end if
                rs.close
                maxTransactID= CLng(maxTransactID) + 1

                Dim maxID  
                maxID = 0
                rs.Open "SELECT MAX(id) AS id FROM "&transactionsPath&";", CN2
                    if not rs.EOF then
                        maxID = CLng(rs("id").value)
                    end if
                    maxID = CLng(maxID) + 1
                rs.close

                Dim isDuplicate
                isDuplicate = ""

                sqlAdd = "INSERT INTO "&salesPath&" (transactid, ref_no, invoice_no, cust_id, cust_name, cashier, date, cash_paid, amount, profit, payment, duplicate)"&_ 
                "VALUES ("&maxTransactID&", '"&arReferenceNo&"' ,"&maxInvoice&", "&customerID&", '"&custName&"', '"&cashierName&"', ctod(["&systemDate&"]), "&customerCash&", "&totalAmount&", "&totalProfit&", '"&payment&"', '"&isDuplicate&"')"

                set objAccess = cnroot.execute(sqlAdd)
                set objAccess = nothing 

                'END OF SALES'
                Dim maxOHid
                maxOHid = 0
                rs.open "SELECT MAX(transactid) AS transactid FROM "&salesOrderPath&"", CN2
                    if not rs.EOF then
                        maxOHid = CLng(rs("transactid").value)
                    end if
                rs.close
                'maxOHid = CLng(maxOHid) 

                'GETTING THE On Process ORDERS FROM ORDERS_HOLDER and SENDING IT TO SALES_ORDER'
                salesDate = CDate(Date)
                rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum, CN2
                i = 0
                
                do until rs.EOF
                    maxOHid = maxOHid + 1
                    sqlSOAdd = "INSERT INTO "&salesOrderPath&""&_ 
                    "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate)"&_
                    "VALUES ("&maxOHid&", '"&arReferenceNo&"', "&maxInvoice&", "&customerID&", '"&custName&"', "&rs("prod_id")&", '"&rs("prod_brand")&"', '"&rs("prod_name")&"', "&rs("price")&", "&rs("amount")&", "&rs("qty")&", "&rs("profit")&", ctod(["&systemDate&"]), '"&payment&"', '"&isDuplicate&"')"
                    cnroot.execute sqlSOAdd
                    rs.MoveNext
                loop    
                rs.close
                'FLUSHING THE PENDING ORDERS'
                sqlHolderDelete = "DELETE FROM "&ordersHolderPath&" WHERE unique_num="&uniqueNum
                set objAccess = cnroot.execute(sqlHolderDelete)
                set objAccess = nothing
                'END OF GETTING THE PENDING ORDERS FROM ORDERS_HOLDER and SENDING IT TO SALES_ORDER'

                Dim maxObTestID, cust_type
                maxObTestID = 0
                'arReferenceNo = 0
                rs.Open "SELECT MAX(id) AS id FROM "&obPath&";", CN2
                    if not rs.EOF then
                        maxObTestID = CLng(rs("id").value)
                    end if
                    maxObTestID = CLng(maxObTestID) + 1
                rs.close

                Dim currOB, cashPaid
                currOB = 0.00
                cashPaid = 0.00
                status = ""

                rs.open "SELECT MAX(id), balance FROM "&obPath&" WHERE cust_id="&customerID, CN2

                if not rs.EOF then
                    currOB = CDbl(rs("balance").value)
                end if

                currOB = currOB + totalAmount

                sqlAdd = "INSERT INTO "&obPath&" (id, ref_no, cust_id, cust_name, department, t_type, cust_type, cash_paid, balance, date, status, duplicate)"&_
                "VALUES ("&maxObTestID&", '"&arReferenceNo&"', "&customerID&", '"&custName&"', '"&customerDepartment&"', '"&transact_type&"', '"&customerType&"', "&cashPaid&", "&currOB&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
                set objAccess = cnroot.execute(sqlAdd)
                set objAccess = nothing

                rs.close

                Dim arMaxValue
                arMaxValue = 0
                rs.Open "SELECT MAX(ar_id) AS id FROM "&arPath&";", CN2

                if not rs.EOF then
                    arMaxValue = CLng(rs("id").value)
                end if

                arMaxValue= arMaxValue + 1

                sqlAdd = "INSERT INTO "&arPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, duplicate)"&_ 
                "VALUES ("&arMaxValue&","&customerID&", '"&custName&"', '"&customerDepartment&"', '"&arReferenceNo&"', "&maxInvoice&", "&totalReceivable&", "&balance&" ,ctod(["&systemDate&"]), '"&isDuplicate&"')"

                set objAccess = cnroot.execute(sqlAdd)
                set objAccess = nothing 
                rs.close

                Dim isAdded
                
                'status = ""
                isAdded = false

                sqlAdd = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
                "VALUES ("&maxID&", '"&arReferenceNo&"', '"&transact_type&"', "&customerID&" , "&maxInvoice&", "&customerCash&", " &totalAmount&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
                set objAccess = cnroot.execute(sqlAdd)
                set objAccess = nothing

                ' sqlUpdateRef = "UPDATE reference_no SET ref_no = ref_no + 1"
                ' cnroot.execute(sqlUpdateRef)

                Dim maxArRefId 
                maxArRefId = 0

                rs.Open "SELECT MAX(id) AS id FROM "&arReferenceNoPath&";", CN2
                    if not rs.EOF then
                        maxArRefId = CDbl(rs("id").value)
                    end if
                    maxArRefId = maxArRefId + 1
                rs.close

                sqlRefAdd = "INSERT INTO "&arReferenceNoPath&" (id, ref_no, duplicate) "&_
                            "VALUES ("&maxArRefId&", '"&arReferenceNo&"', '')"
                cnroot.execute(sqlRefAdd)   


                CN2.close    
                Response.Write("<script language=""javascript"">")
                Response.Write("alert('Order Completed!')")
                Response.Write("</script>")
                isAdded = true

                Dim transactDate
                transactDate = FormatDateTime(systemDate)

                If isAdded = true then

                    Response.Write("<script language=""javascript"">")
                ' Response.Write("window.location.href=""a_customers_order.asp"";")
                    Response.Write("window.location.href=""receipt_ar_order.asp?invoice="&maxInvoice&"&date="&transactDate&""";")
                    Response.Write("</script>")
                end If
        end if

    end if
%>