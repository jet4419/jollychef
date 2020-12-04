<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%

		btnAdd = Request.Form("btnAdd")
		
		if btnAdd<>"" then

			productID = CInt(Request.Form("productID"))
			salesQty = CInt(Request.Form("salesQty"))
			userType = CStr(Request.Form("userType"))
			custID = Request.Form("cust_id")
			uniqueNum = Request.Form("unique_num")

			salesDate = CDate(Date)
			status= Trim("On Process")

			Dim yearPath, monthPath

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

			rs.open "SELECT daily_meals.prod_name, daily_meals.qty - SUM(orders_holder.qty) AS qty FROM daily_meals INNER JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id WHERE daily_meals.prod_id ="&productID, CN2

			Dim holderCurrQty

			if not rs.EOF then

				holderCurrQty = CInt(rs("qty"))

			else 

				getQty = "SELECT qty FROM daily_meals WHERE prod_id = "&productID
				set objAccess = cnroot.execute(getQty)

				if not objAccess.EOF then

					holderCurrQty = CInt(objAccess("qty"))

				end if

			end if

			rs.close

			Dim isValidQty, currentQty
			isValidQty = true

			currentQty = holderCurrQty - salesQty

			if currentQty <  0 then

				Response.Write("<script language=""javascript"">")
				Response.Write("alert(""Error: Insufficient quantity stocks"")")
				Response.Write("</script>")

				isValidQty = false

				if isValidQty=false then

					Response.Write("<script language=""javascript"">")
					Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
					Response.Write("</script>")

				end if

			end if

			if isValidQty = true then

				rs.Open "SELECT prod_brand, prod_name, prod_price, orig_price FROM daily_meals WHERE prod_id="&productID, CN2
			
				if not rs.EOF then

					productBrand = rs("prod_brand")
					productName = rs("prod_name")
					price = CDbl(rs("prod_price"))
					origPrice = CDbl(rs("orig_price"))

				end if

				rs.close

				rs.Open "SELECT * FROM products WHERE prod_id="&productID, CN2

					isValidQty = true
					holderQty = CInt(rs("qty"))
					productBrand = rs("prod_brand")
					productName = rs("prod_name")
					price = CDbl(rs("price"))
					origPrice = CDbl(rs("orig_price"))

				holderCurrQty = holderQty - salesQty
				
				
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

				isRedirect = true

				if isRedirect = true then
					Response.Write("<script language=""javascript"">")
					Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
					Response.Write("</script>")
				end if

			end if

		end if
%>
