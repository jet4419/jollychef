<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->
<%
	Dim custID 
	custID = CLng(Request.Form("custID"))

		productID = CInt(Request.Form("prodID"))
		salesQty = CInt(Request.Form("prodQty"))
		'salesDate = CDate(Date)
		status= "Pending"

		Response.Write custID
		Response.Write productID
		Response.Write salesQty


		Dim yearPath, monthPath

		yearPath = CStr(Year(systemDate))
		monthPath = CStr(Month(systemDate))

		if Len(monthPath) = 1 then
			monthPath = "0" & monthPath
		end if

		Dim folderPath

		folderPath = mainPath & yearPath & "-" & monthPath

		rs.Open "SELECT * FROM products WHERE prod_id="&productID, CN2
		
			isValidQty = true
			holderQty = CInt(rs("qty"))
			productBrand = rs("prod_brand")
			productName = rs("prod_name")
			price = CDbl(rs("price"))
			origPrice = CDbl(rs("orig_price"))
			holderCurrQty = holderQty - salesQty
	

		if custID = "" then
			custID = 0
		end if

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

		if salesQty>holderQty then
			
			Response.Write("<script language=""javascript"">")
			Response.Write("alert(""Error: Insufficient quantity stocks"")")
			Response.Write("</script>")
			isValidQty = false
			if isValidQty=false then
				Response.Write("<script language=""javascript"">")
				Response.Write("window.location.href=""customer_ordering_page.asp"";")
				Response.Write("</script>")
			end if

		else

			qtySold = CInt(rs("qty_sold")) + salesQty
			amount = price * salesQty	
			profit = (price - origPrice) * salesQty
			uniqueNum = 0
			
			rs.close

			Dim ordersHolderFile, ordersHolderPath

			ordersHolderFile = "\orders_holder.dbf"
			ordersHolderPath = folderPath & ordersHolderFile

			rs.open "SELECT MAX(id) FROM "&ordersHolderPath&"", CN2
				do until rs.EOF
				for each x in rs.Fields
					maxID = x.value
				next
				rs.MoveNext
			loop
			rs.close
			maxID= CInt(maxID) + 1

			Dim salesOrderFile, salesOrderPath

			salesOrderFile = "\sales_order.dbf"
			salesOrderPath = folderPath & salesOrderFile

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
			sqlAdd = "INSERT INTO "&ordersHolderPath&""&_ 
			"(id, cust_id, unique_num, cust_name, department, transactid, prod_id, prod_brand, prod_name, price, qty, amount, profit, status, date)"&_
			"VALUES ("&maxID&", "&custID&", "&uniqueNum&", '"&fullName&"', '"&department&"', "&salesOrderID&", "&productID&" , '"&productBrand&"', '"&productName&"', "&price&", "&salesQty&", "&amount&", "&profit&", '"&status&"', ctod(["&systemDate&"]))"
			set objAccess = cnroot.execute(sqlAdd)
			set objAccess = nothing
			rs.close

			CN2.close

		
		end if

	
%>
