<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%
    if Request.QueryString("transact_id") = "" or Request.QueryString("unique_num") = "" or Request.QueryString("cust_id") = "" or Request.QueryString("userType") = "" then
        Response.Redirect("customer_order_process.asp")
    end if

    if IsNumeric(Request.QueryString("transact_id")) = false or IsNumeric(Request.QueryString("unique_num")) = false  or IsNumeric(Request.QueryString("cust_id")) = false then
        Response.Redirect("customer_order_process.asp")
    end if

	transactID = CInt(Request.QueryString("transact_id"))
	uniqueNum = CLng(Request.QueryString("unique_num"))
	custID = CLng(Request.QueryString("cust_id"))
	userType = CStr(Request.QueryString("userType"))

    Dim systemDate, isDayEnded
    systemDate = CDate(Application("date"))

    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile

    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile


	Dim prodIDs, qtys
    rs.open "SELECT prod_id, prod_name, qty FROM "&ordersHolderPath&" WHERE id="&transactID, CN2
    
    do until rs.EOF

        prodIDs = prodIDs & rs("prod_id").value & ","
        qtys = qtys & rs("qty").value & ","

    rs.movenext
    loop

    rs.close

    prodIDs = Split(prodIDs, ",")
    qtys = Split(qtys, ",")


    for i=0 to Ubound(prodIDs) - 1

        sqlUpdate = "UPDATE daily_meals SET qty = qty + " &qtys(i)& " WHERE prod_id="&prodIDs(i) 
        cnroot.execute(sqlUpdate)

    next

	rs.open "SELECT * FROM "&ordersHolderPath&"", CN2
	sqlDelete = "DELETE FROM "&ordersHolderPath&" WHERE id="&transactID
	set objAccess  = cnroot.execute(sqlDelete)
	set objAccess = nothing
	rs.close
	CN2.close
	if err<>0 then
		response.write("No update permissions!")
	else

		Response.Write("<script language=""javascript"">")
        Response.Write("alert('One order has been cancelled!')")
        Response.Write("</script>")
        isProcessed = true

        if isProcessed = true then
  
            Response.Write("<script language=""javascript"">")
			Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
            Response.Write("</script>")
        end if
        
  	end if
	

%>

