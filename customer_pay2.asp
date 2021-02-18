<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%

Dim userType
userType = CStr(Request.Form("userType"))

if userType = "" then

    Response.Redirect("canteen_login.asp")

else

    Dim custID, uniqueNum, custName, custDepartment, isValidRef
    isValidRef = true

    custID = CLng(Request.Form("custID"))
    custName = CStr(Request.Form("cust_name"))
    custDepartment = CStr(Request.Form("cust_dept"))
    uniqueNum = CLng(Request.Form("uniqueNum"))

    Dim totalProfit, totalAmount, customerCash, userPayment, email, cashierName, referenceNo

    totalProfit = CDbl(Request.Form("totalProfit"))
    totalAmount = CDbl(Request.Form("totalAmount"))
    customerCash = CDbl(Request.Form("customerMoney"))
    userPayment = "Cash"
    referenceNo = CStr(Request.Form("referenceNo"))
    referenceNo = Trim(CStr(Year(systemDate)) & "-" & referenceNo)

    email = CStr(Request.Form("userEmail"))
    cashierName = CStr(Request.Form("cashierName"))

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
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
        Response.Write("<script language=""javascript"">")
        Response.Write("alert('Error: Reference already exist!')")
        Response.Write("</script>")

        if isValidRef = false then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
            Response.Write("</script>")
        end if

    else    

        sqlCheckRef = "SELECT ref_no FROM "&referenceNoPath&" WHERE ref_no='"&referenceNo&"'"
        set objAccess = cnroot.execute(sqlCheckRef)

            if not objAccess.EOF then

                isValidRef = false
                Response.Write("<script language=""javascript"">")
                Response.Write("alert('Error: Reference already exist!')")
                Response.Write("</script>")

                if isValidRef = false then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
                    Response.Write("</script>")
                end if

            end if

        set objAccess = nothing

    end if


    if isValidRef = true then

        Dim ordersHolderFile

        ordersHolderFile = "\orders_holder.dbf" 

        Dim ordersHolderPath

        ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

        Dim isOrderExist
        isOrderExist = true

        sqlGetAmount = "SELECT SUM(amount) AS amount FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum
        set objAccess = cnroot.execute(sqlGetAmount)

        if not objAccess.EOF then

            realAmount = CDbl(objAccess("amount").value)

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

        if isOrderExist = true then

            if customerCash < realAmount then

                Response.Write("<script language=""javascript"">")
                Response.Write("alert('Error: Insufficient cash!')")
                Response.Write("</script>")
                isValidT = false

                if isValidT = false then
                    Response.Write("<script language=""javascript"">")
                    Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
                    Response.Write("</script>")
                end if

            else

                rs.Open "SELECT * FROM products", CN2
                sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum&" GROUP BY prod_id" 
                set objAccess  = cnroot.execute(sqlAccess)


                if objAccess.EOF >= 0 then

                    do until objAccess.EOF

                        do until rs.EOF

                            if CLng(objAccess("prod_id")) = CLng(rs("prod_id")) then 
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
                                        Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
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

                'Response.Write salesPath

                Dim isDuplicate
                isDuplicate = ""

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
                    rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum, CN2

                    do until rs.EOF
                    maxOHid = maxOHid + 1

                    sqlSOAdd = "INSERT INTO "&salesOrderPath&""&_ 
                    "(transactid, ref_no, invoice_no, cust_id, cust_name, product_id, prod_brand, prod_gen, prod_price, prodamount, prod_qty, profit, date, payment, duplicate)"&_
                    "VALUES ("&maxOHid&", '"&referenceNo&"', "&maxInvoice&", "&custID&", '"&custName&"', "&rs("prod_id")&", '"&rs("prod_brand")&"', '"&rs("prod_name")&"', "&rs("price")&", "&rs("amount")&", "&rs("qty")&", "&rs("profit")&", ctod(["&systemDate&"]), '"&userPayment&"', '"&isDuplicate&"')"
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

                    Dim transact_type, credit, status
                    transact_type = Trim("OTC")
                    credit = 0.00
                    status = ""

                    sqlAdd = "INSERT INTO "&transactionsPath&" (id, ref_no, t_type, cust_id, invoice, debit, credit, date, status, duplicate)"&_
                    "VALUES ("&maxID&", '"&referenceNo&"', '"&transact_type&"', "&custID&" , "&maxInvoice&", "&totalAmount&", " &credit&", ctod(["&systemDate&"]), '"&status&"', '"&isDuplicate&"')"
                    set objAccess = cnroot.execute(sqlAdd)
                    set objAccess = nothing

                    Dim cash_paid, paymentMethod, collectionBal
                    cash_paid = totalAmount
                    collectionBal = 0.00
                    paymentMethod = Trim("cash")

                    sqlCollectAdd = "INSERT INTO "&collectionsPath&""&_ 
                    "(id, cust_id, cust_name, department, invoice, ref_no, date, tot_amount, cash, balance, p_method, duplicate)"&_
                    "VALUES ("&maxCollectID&", "&custID&", '"&custName&"', '"&custDepartment&"', "&maxInvoice&", '"&referenceNo&"', ctod(["&systemDate&"]), "&totalAmount&", "&totalAmount&", "&collectionBal&", '"&paymentMethod&"', '"&isDuplicate&"')"
                    cnroot.execute(sqlCollectAdd)

                    ' sqlUpdateRef = "UPDATE reference_no SET ref_no = ref_no + 1"
                    ' cnroot.execute(sqlUpdateRef)

                    Dim maxRefId 

                    rs.Open "SELECT MAX(id) AS id FROM "&referenceNoPath&";", CN2
                        do until rs.EOF
                            for each x in rs.Fields
                                maxRefId = x.value
                            next
                            rs.MoveNext
                        loop
                        maxRefId = CDbl(maxRefId) + 1
                    rs.close

                    sqlRefAdd = "INSERT INTO "&referenceNoPath&" (id, ref_no, duplicate) "&_
                                "VALUES ("&maxRefId&", '"&referenceNo&"', '')"
                    cnroot.execute(sqlRefAdd)   

                    CN2.close
                    sqlHolderDelete = "DELETE FROM "&ordersHolderPath&" WHERE unique_num="&uniqueNum
                    set objAccess = cnroot.execute(sqlHolderDelete)
                    set objAccess = nothing

                    Response.Redirect("receipt_customer_cash.asp?invoice="&maxInvoice)

            end if

        end if    

    end if
    
end if    
%>