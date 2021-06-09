<!--#include file="dbConnect.asp"-->

<%

    Dim cashierID, cahierEmail, customerCash, referenceNo

    cashierID = CInt(Request.Form("cashierID"))
    cahierEmail = CStr(Request.Form("cashierEmail"))
    customerCash = CDbl(Request.Form("customerMoney"))
    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)

    Dim custID, custName, custDepartment, isValidRef
    isValidRef = true

    custID = CLng(Request.Form("custID"))

    if custID = "" then

        custID = 0

    else

        sqlCustomerInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
        set objAccess = cnroot.execute(sqlCustomerInfo)

        if not objAccess.EOF then
            custName = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
            custDepartment = Trim(objAccess("department").value)
        else
            custName = Trim("OTC-Customer")
            custDepartment = Trim("unknown")
        end if

    end if

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile

    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    Dim isValidQty
    isValidQty = true

    rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.qty AS qty1, SUM(orders_holder.upd_qty) AS qty2 FROM daily_meals JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.status = 'On Process' AND orders_holder.cashier_id="&cashierID&" AND orders_holder.cust_id=0 GROUP BY daily_meals.prod_id", CN2

    'Check if the ordered QTY is valid'
    if not rs.EOF then

        do until rs.EOF 

            newQty = CLng(rs("qty1")) - CLng(rs("qty2"))

            if newQty < 0 then

                isValidQty = false
                EXIT DO

            end if
        
            rs.MoveNext
        loop

    else
        isValidQty = false
    end if

    if isValidQty = false then
        Response.Write "invalid ordered qty"
    end if

    rs.close

    if isValidQty = true then

        Dim totalProfit, totalAmount, userPayment, email, cashierName

        'GETTING THE totalProfit and totalAmount
        sqlQuery = "SELECT SUM(upd_amount) AS amount, SUM(upd_profit) AS profit FROM "&ordersHolderPath&" WHERE cashier_id="&cashierID&" AND cust_id=0 AND status='On Process'"
        set objAccess = cnroot.execute(sqlQuery)

        if not objAccess.EOF then

            totalAmount = CDbl(objAccess("amount").value)
            totalProfit = CDbl(objAccess("profit").value)

        else

            totalAmount = 0
            totalProfit = 0

        end if

        'userType = "Cashier"
        'currDate = CDate(Date)
        userPayment = "Cash"
        status = "On Process"

        email = cahierEmail

        'Set the user type of the cashier's currently logged in'
        sqlGetInfo = "SELECT * FROM users WHERE email='"&email&"'"    
        set objAccess = cnroot.execute(sqlGetInfo)

        if not objAccess.EOF then

            cashierName = Trim(objAccess("first_name")) & " " & Trim(objAccess("last_name"))

        end if

        set objAccess = nothing

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
            
            Response.Write "invalid reference number"

        else

            sqlCheckRef = "SELECT ref_no FROM "&referenceNoPath&" WHERE ref_no='"&referenceNo&"'"
            set objAccess = cnroot.execute(sqlCheckRef)

            if not objAccess.EOF then

                isValidRef = false
                Response.Write "invalid reference number"

            end if

            set objAccess = nothing

        end if
    

        if isValidRef = true then


            Dim isOrderExist
            isOrderExist = true

            sqlGetAmount = "SELECT SUM(upd_amount) AS amount FROM "&ordersHolderPath&" WHERE status='"&status&"' AND cashier_id="&cashierID&" and cust_id=0"
            set objAccess = cnroot.execute(sqlGetAmount)

            if not objAccess.EOF then

                realAmount = CDbl(objAccess("amount").value)

            else

                isOrderExist = false
                Response.Write "order does not exist"       

            end if
            
            set objAccess = nothing

            if isOrderExist = true then

                if customerCash < realAmount then

                    isValidT = false
                    Response.Write "insufficient cash"

                elseif totalAmount <> realAmount then

                    isValidT = false
                    Response.Write "invalid transactions"

                else

                    rs.Open "SELECT * FROM products", CN2
                    sqlAccess = "SELECT DISTINCT prod_id, SUM(upd_qty) AS qty FROM "&ordersHolderPath&" WHERE status='"&status&"' AND cashier_id="&cashierID&" AND cust_id=0 GROUP BY prod_id" 
                    set objAccess  = cnroot.execute(sqlAccess)


                    if objAccess.EOF >= 0 then

                        do until objAccess.EOF

                            do until rs.EOF

                                if CLng(objAccess("prod_id")) = CLng(rs("prod_id")) then 
                                    currQty = CLng(rs("qty")) - CLng(objAccess("qty"))
                                    qtySold = CLng(objAccess("qty")) + CLng(rs("qty_sold"))

                                    if CLng(currQty) < 0 then

                                        isProcessed = false
                                        Response.Write "insufficient product stock"
                                    
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

                    ' rs.movefirst
                    ' objAccess.movefirst
                    rs.close
                    set objAccess = nothing


                    Dim salesFile, salesOrderFile, collectionsFile, transactionsFile

                    salesFile = "\sales.dbf"
                    salesOrderFile = "\sales_order.dbf"
                    collectionsFile = "\collections.dbf"
                    transactionsFile = "\transactions.dbf"

                    Dim salesPath, salesOrderPath, collectionsPath, transactionsPath

                    salesPath = mainPath & yearPath & "-" & monthPath & salesFile 
                    salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
                    collectionsPath = mainPath & yearPath & "-" & monthPath & collectionsFile
                    transactionsPath = mainPath & yearPath & "-" & monthPath & transactionsFile

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

                    Dim isDuplicate
                    isDuplicate = ""

                    sqlAdd = "INSERT INTO "&salesPath&" (transactid, ref_no, invoice_no, cust_id, cust_name, cashier, date, cash_paid, amount, profit, payment, duplicate)"&_ 
                    "VALUES ("&maxTransactID&", '"&referenceNo&"', "&maxInvoice&", "&custID&", '"&custName&"', '"&cashierName&"', ctod(["&systemDate&"]), "&customerCash&", "&totalAmount&", "&totalProfit&", '"&userPayment&"', '"&isDuplicate&"')"

                    set objAccess = cnroot.execute(sqlAdd)
                    set objAccess = nothing 

                    rs.open "SELECT MAX(transactid) AS transactid FROM "&salesOrderPath&"", CN2
                            do until rs.EOF
                                for each x in rs.Fields
                                    maxOHid = x.value
                                next
                                rs.MoveNext
                            loop
                    rs.close
                    maxOHid = CLng(maxOHid)    

                    'rs.Open "SELECT MAX(transactid) AS id FROM sales_order", CN2
                    'salesDate = CDate(Date)
                    rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status='"&status&"' AND cashier_id="&cashierID&" AND cust_id=0", CN2

                    do until rs.EOF

                        maxOHid = maxOHid + 1

                        sqlSOAdd = "INSERT INTO "&salesOrderPath&""&_ 
                        "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate)"&_
                        "VALUES ("&maxOHid&", '"&referenceNo&"', "&maxInvoice&", "&custID&", '"&custName&"', "&rs("prod_id")&", '"&rs("prod_brand")&"', '"&rs("prod_name")&"', "&rs("upd_price")&", "&rs("upd_amount")&", "&rs("upd_qty")&", "&rs("upd_profit")&", ctod(["&systemDate&"]), '"&userPayment&"', '"&isDuplicate&"')"
                        cnroot.execute sqlSOAdd
                        
                        rs.MoveNext
                    loop

                    rs.close

                    Dim maxCollectID, maxCRefNo
                    rs.Open "SELECT MAX(id) FROM "&collectionsPath&";", CN2
                        do until rs.EOF
                            for each x in rs.Fields

                                maxCollectID = x.value
                
                            next
                            rs.MoveNext
                        loop
                        maxCollectID = CLng(maxCollectID) + 1

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

                    Dim transact_type, credit, status
                    transact_type = "Cash"
                    credit = 0.00
                    status = ""

                    sqlAdd = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
                    "VALUES ("&maxID&", '"&referenceNo&"', '"&transact_type&"', "&custID&" , "&maxInvoice&", "&totalAmount&", " &credit&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
                    set objAccess = cnroot.execute(sqlAdd)
                    set objAccess = nothing

                    Dim cash_paid, collectionsBal, paymentMethod
                    cash_paid = totalAmount
                    collectionsBal = 0.00
                    paymentMethod = Trim("cash")

                    sqlCollectAdd = "INSERT INTO "&collectionsPath&""&_ 
                    "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate)"&_
                    "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&maxInvoice&", '"&referenceNo&"', ctod(["&systemDate&"]), "&totalAmount&", "&totalAmount&", "&collectionsBal&", '"&paymentMethod&"', '"&isDuplicate&"')"
                    cnroot.execute(sqlCollectAdd)

                    Dim maxRefId 

                    rs.Open "SELECT MAX(id) AS id FROM "&referenceNoPath&";", CN2
                        do until rs.EOF
                            for each x in rs.Fields
                                maxRefId = x.value
                            next
                            rs.MoveNext
                        loop
                        maxRefId = CLNG(maxRefId) + 1
                    rs.close

                    sqlRefAdd = "INSERT INTO "&referenceNoPath&" (id, ref_no, duplicate) "&_
                                "VALUES ("&maxRefId&", '"&referenceNo&"', '')"
                    cnroot.execute(sqlRefAdd)            

                    ' sqlUpdateRef = "UPDATE reference_no SET ref_no = ref_no + 1"
                    ' cnroot.execute(sqlUpdateRef)

                    CN2.close
                    sqlHolderDelete = "UPDATE "&ordersHolderPath&" SET status='Finished' WHERE cashier_id="&cashierID&" AND cust_id=0"
                    set objAccess = cnroot.execute(sqlHolderDelete)
                    set objAccess = nothing

                    Dim transactDate
                    transactDate = FormatDateTime(systemDate, 2)
                    
                    Response.Write maxInvoice & "," & transactDate
                    ' Response.Redirect("receipt.asp?invoice="&maxInvoice&"&date="&transactDate)

                end if

            end if    

        end if

    end if
  
%>