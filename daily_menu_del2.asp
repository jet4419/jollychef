<!--#include file="dbConnect.asp"-->

<%

    productID = Request.Form("productID")


    sqlDelete = "DELETE FROM daily_meals WHERE prod_id="&productID

    cnroot.execute sqlDelete 

%>