<!--#include file="dbConnect.asp"-->

<%
    if Request.Form("orderID") = "" then
        Response.Redirect("customer_order_process.asp")
    end if

    if IsNumeric(Request.Form("orderID")) = false then
        Response.Redirect("customer_order_process.asp")
    end if

	orderID = CInt(Request.Form("orderID"))
	uniqueNum = CLng(Request.Form("unique_num"))
	custID = CLng(Request.Form("cust_id"))
	cashierEmail = CStr(Request.Form("cashierEmail"))
    cashierType = CStr(Request.Form("cashierType"))
	tokenID = CStr(Request.Form("tokenID"))

    Dim isValidCashier

    validateCashier = "SELECT email, user_type, token_id, log_status FROM users "&_
                      "WHERE email='"&cashierEmail&"' AND user_type='"&cashierType&"' "&_
                      "AND token_id='"&tokenID&"' AND log_status='active'"
    set objAccess = cnroot.execute(validateCashier)

    if not objAccess.EOF then

        isValidCashier = true
        
    else
        isValidCashier = false
        Response.Write "invalid cashier"

    end if
	
    if isValidCashier = true then

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

        rs.open "SELECT * FROM "&ordersHolderPath&"", CN2
        sqlDelete = "DELETE FROM "&ordersHolderPath&" WHERE id="&orderID
        set objAccess  = cnroot.execute(sqlDelete)
        set objAccess = nothing
        rs.close
        CN2.close

        if err<>0 then

            Response.Write("no update permission")

        else
            
            Response.Write "order cancelled"
            ' Response.Write("<script language=""javascript"">")
            ' Response.Write("alert('Order has been cancelled!')")
            ' Response.Write("</script>")
            ' isProcessed = true

            ' if isProcessed = true then
    
            '     Response.Write("<script language=""javascript"">")
            ' 	Response.Write("window.location.href=""customer_order_process.asp?unique_num="&uniqueNum&"&cust_id="&custID&"&userType="&userType&" "";")
            '     Response.Write("</script>")
            ' end if
            
        end if
	
    end if

%>

