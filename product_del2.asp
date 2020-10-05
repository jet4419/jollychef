<!--#include file="dbConnect.asp"-->

<%

    productID = Request.Form("productID")


    sqlDelete = "DELETE FROM products WHERE prod_id="&productID

    cnroot.execute sqlDelete 

%>