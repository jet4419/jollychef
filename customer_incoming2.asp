<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
	'if Session("name")<>"" then
		btnAdd = Request.Form("btnAdd")
		
		if btnAdd<>"" then
		'invoiceNumber = Request.Form("invoiceNumber")
		productID = CInt(Request.Form("productID"))
		salesQty = CInt(Request.Form("salesQty"))
		userType = CStr(Request.Form("userType"))
		salesDate = CDate(Date)
		status= Trim("On Process")

		Dim systemDate
		systemDate = CDate(Application("date"))

		Dim mainPath, yearPath, monthPath

		mainPath = CStr(Application("main_path"))
		yearPath = CStr(Year(systemDate))
		monthPath = CStr(Month(systemDate))

		if Len(monthPath) = 1 then
			monthPath = "0" & monthPath
		end if

		Dim salesOrderFile, ordersHolderFile

		salesOrderFile = "\sales_order.dbf"
		ordersHolderFile = "\orders_holder.dbf" 

		Dim salesOrderPath, ordersHolderPath

		salesOrderPath = mainPath & yearPath & "-" & monthPath & salesOrderFile
		ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

		rs.Open "SELECT * FROM products WHERE prod_id="&productID, CN2

			isValidQty = true
			holderQty = CInt(rs("qty"))
			productBrand = rs("prod_brand")
			productName = rs("prod_name")
			price = CDbl(rs("price"))
			origPrice = CDbl(rs("orig_price"))

		holderCurrQty = holderQty - salesQty
		custID = Request.Form("cust_id")
		uniqueNum = Request.Form("unique_num")
		

		
		sqlGetInfo = "SELECT * FROM customers WHERE cust_id="&custID
		set objAccess = cnroot.execute(sqlGetInfo)

		if not objAccess.EOF then
			custFname = CStr(Trim(objAccess("cust_fname")))
			custLname = CStr(Trim(objAccess("cust_lname")))
			fullName = custFname & " " & custLname
			department = objAccess("department")
		else 
			fullName = ""
			department = ""
		end if

		If salesQty>holderQty then
			
			Response.Write("<script language=""javascript"">")
			Response.Write("alert(""Error: Insufficient quantity stocks"")")
			Response.Write("</script>")
			isValidQty = false
			if isValidQty=false then
				Response.Write("<script language=""javascript"">")
				Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
				Response.Write("</script>")
			end if

		else

		qtySold = CInt(rs("qty_sold")) + salesQty
		amount = price * salesQty	
		profit = (price - origPrice) * salesQty
		'uniqueNum = 0
		'productID = CInt(rs("prod_id"))
		'productBrand = rs("prof_code")
		'productGenName = rs("prod_name")
		'productPrice = CDbl(rs("price"))
		
		rs.close
		rs.open "SELECT MAX(id) FROM "&ordersHolderPath&"", CN2
			do until rs.EOF
			for each x in rs.Fields
				maxID = x.value
			next
			rs.MoveNext
		loop
		rs.close
		maxID= CInt(maxID) + 1
		'transact_id = transact_id + 1
		'transact_id = 0
		rs.open "SELECT MAX(transactid) FROM "&salesOrderPath&"", CN2
			do until rs.EOF
			for each x in rs.Fields
				maxTransactID = x.value
			next
			rs.MoveNext
		loop
		rs.close
		salesOrderID = CInt(maxTransactID) + 1

		rs.Open "SELECT * FROM "&ordersHolderPath&"", CN2
		'transact_id= CInt(rs("transactid"))
		'transact_id = transact_id + 1
		sqlAdd = "INSERT INTO "&ordersHolderPath&""&_ 
		"(id, cust_id, unique_num, cust_name, department, transactid, prod_id, prod_brand, prod_name, price, qty, amount, profit, status, date)"&_
		"VALUES ("&maxID&", "&custID&", "&uniqueNum&", '"&fullName&"', '"&department&"', "&salesOrderID&", "&productID&" , '"&productBrand&"', '"&productName&"', "&price&", "&salesQty&", "&amount&", "&profit&", '"&status&"', ctod(["&systemDate&"]))"
		set objAccess = cnroot.execute(sqlAdd)
		set objAccess = nothing
		rs.close
		CN2.close

		isRedirect = true

			if isRedirect = true then
				Response.Write("<script language=""javascript"">")
				Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
				Response.Write("</script>")
			end if
		
		end if


		end if

	' else
	' 	Response.Write("<script language=""javascript"">")
	' 	Response.Write("alert('Your session timed out!')")
	' 	Response.Write("</script>")
    '     isActive = false
 
    '         if isValidQty=false then
    '             Response.Write("<script language=""javascript"">")
    '             Response.Write("window.location.href=""canteen_login.asp"";")
    '             Response.Write("</script>")
    '         end if


	' end if
	
%>
