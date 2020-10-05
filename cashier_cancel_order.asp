<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<%
	if Request.QueryString("transact_id") = "" or Request.QueryString("salesQty") = "" or Request.QueryString("product_id") = "" then
        Response.Redirect("cashier_order_page.asp")
    end if

    if IsNumeric(Request.QueryString("transact_id")) = false or IsNumeric(Request.QueryString("salesQty")) = false  or IsNumeric(Request.QueryString("product_id")) = false then
        Response.Redirect("cashier_order_page.asp")
    end if

	transactID = CInt(Request.QueryString("transact_id"))
	salesQty = CInt(Request.QueryString("salesQty"))
	productID = CInt(Request.QueryString("product_id"))

	Dim mainPath, systemDate, yearPath, monthPath

	mainPath = CStr(Application("main_path"))
	systemDate = CDate(Application("date"))
	yearPath = CStr(Year(systemDate))
	monthPath = CStr(Month(systemDate))
	

	if Len(monthPath) = 1 then
		monthPath = "0" & monthPath
	end if

	Dim ordersHolderFile
	ordersHolderFile = "\orders_holder.dbf"

	Dim ordersHolderPath
	ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

	rs.open "SELECT * FROM "&ordersHolderPath&"", CN2
	sqlDelete = "DELETE FROM "&ordersHolderPath&" WHERE id="&transactID
	set objAccess  = cnroot.execute(sqlDelete)
	set objAccess = nothing
	rs.close
	CN2.close	

	if err<>0 THEN
		response.write("No update permissions!")
	else
		Response.Write("<script language=""javascript"">")
        Response.Write("alert('One order has been cancelled!')")
        Response.Write("</script>")
        isProcessed = true

        if isProcessed = true then
  
            Response.Write("<script language=""javascript"">")
			Response.Write("window.location.href=""cashier_order_page.asp"";")
            Response.Write("</script>")
        end if

  	end if
	
	
	'Response.Redirect("a_cashier_order_page.asp")
	%>

