<!--#include file="dbConnect.asp"-->

<%
	if Trim(isStoreClosed) = "open" then

		Dim custID 
		custID = CLng(Request.Form("custID"))

		productID = CInt(Request.Form("prodID"))
		salesQty = CInt(Request.Form("prodQty"))
		status= "Pending"

		Dim yearPath, monthPath

		yearPath = CStr(Year(systemDate))
		monthPath = CStr(Month(systemDate))

		if Len(monthPath) = 1 then
			monthPath = "0" & monthPath
		end if

		Dim folderPath, holderCurrQty, isProductExist
		isProductExist = true

		folderPath = mainPath & yearPath & "-" & monthPath

		Dim ordersHolderFile, ordersHolderPath

		ordersHolderFile = "\orders_holder.dbf"
		ordersHolderPath = folderPath & ordersHolderFile

		rs.open "SELECT daily_meals.prod_name, daily_meals.qty - SUM(orders_holder.qty) AS qty FROM daily_meals INNER JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.cust_id="&custID&" WHERE daily_meals.prod_id ="&productID, CN2

		if not rs.EOF then

			holderCurrQty = CInt(rs("qty"))

		else 

			getQty = "SELECT qty FROM daily_meals WHERE prod_id = "&productID
			set objAccess = cnroot.execute(getQty)

			if not objAccess.EOF then

				holderCurrQty = CInt(objAccess("qty"))

			else
				Response.Write "product does not exist"
				isProductExist = false
			end if

		end if

		rs.close

		if isProductExist = true then

			Dim isValidQty, currentQty
			isValidQty = true

			currentQty = holderCurrQty - salesQty

			if currentQty <  0 then

				isValidQty = false
				Response.Write "invalid qty"

			end if


			if isValidQty = true then

				rs.Open "SELECT prod_brand, prod_name, prod_price, orig_price FROM daily_meals WHERE prod_id="&productID, CN2
				
				if not rs.EOF then

					productBrand = rs("prod_brand")
					productName = rs("prod_name")
					price = CDbl(rs("prod_price"))
					origPrice = CDbl(rs("orig_price"))

				end if

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


				amount = price * salesQty	
				profit = (price - origPrice) * salesQty
				uniqueNum = 0
				
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
				"(id, cashier_id, cust_id, unique_num, cust_name, department, transactid, prod_id, prod_brand, prod_name, price, upd_price, qty, upd_qty, amount, upd_amount, profit, upd_profit, status, is_edited, is_added, date)"&_
				"VALUES ("&maxID&", 0, "&custID&", "&uniqueNum&", '"&fullName&"', '"&department&"', "&salesOrderID&", "&productID&" , '"&productBrand&"', '"&productName&"', "&price&", "&price&", "&salesQty&", "&salesQty&", "&amount&", "&amount&", "&profit&", "&profit&", '"&status&"', 'false', 'false', ctod(["&systemDate&"]))"
				set objAccess = cnroot.execute(sqlAdd)
				set objAccess = nothing
				rs.close

				CN2.close


				Response.Write "valid qty"

			end if

		end if

	else
		Response.Write "store closed"
	end if

%>
