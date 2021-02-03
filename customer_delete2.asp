<!--#include file="dbConnect.asp"-->

<%

    customerID = Request.Form("customerID")


    sqlDelete = "DELETE FROM customers WHERE cust_id="&customerID

    cnroot.execute sqlDelete 

%>