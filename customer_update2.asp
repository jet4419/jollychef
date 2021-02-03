<!--#include file="dbConnect.asp"-->

<%
    customerID = Request.Form("customerID")
    firstName = Trim(Request.Form("firstName"))
    lastName = Trim(Request.Form("lastName"))
    address = Trim(Request.Form("address"))
    contactNo = Trim(Request.Form("contactNo"))
    department = Trim(Request.Form("department"))
    email = Trim(CStr(Request.Form("email")))

    sqlUpdate = "UPDATE customers SET cust_fname='"&firstName&"', cust_lname='"&lastName&"', address='"&address&"', contact_no='"&contactNo&"', department='"&department&"', email='"&email&"' WHERE cust_id="&customerID
   
    cnroot.execute sqlUpdate 

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Customer\'s info updated successfully!')")
    Response.Write("</script>")
    isUpdated=true
    if isUpdated = true then
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""customers_list_prog.asp"";")
        Response.Write("</script>")
    end if


%>