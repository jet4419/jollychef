<!--#include file="dbConnect.asp"-->

<%
    productID = Request.Form("productID")
    brandName = Trim(Request.Form("brandName"))
    productName = Trim(Request.Form("productName"))
    price = Request.Form("price")
    origPrice = CDbl(Request.Form("origPrice"))
    qty = CInt(Request.Form("qty"))
    category = Trim(CStr(Request.Form("particulars")))
    isFixMenu  = Trim(CStr(Request.Form("isFixMenu")))

    rs.open "SELECT * FROM products WHERE prod_id="&productID, CN2
     
     currentQty = CInt(rs("qty"))
     'currentCost = CDbl(rs("cost"))
     updatedQty = ABS(currentQty - qty)
     'updatedCost = (origPrice * updatedQty) + currentCost

    rs.close
    CN2.close
   
   'if qty = currentQty then
    '    cost = currentCost
   'else
   '     cost = updatedCost
  ' end if     

    sqlUpdate = "UPDATE products SET prod_brand='"&brandName&"', prod_name='"&productName&"', price="&price&", orig_price="&origPrice&", qty="&qty&", category='"&category&"', fix_menu='"&isFixMenu&"' WHERE prod_id="&productID
    sqlDailyMeal = "UPDATE daily_meals SET prod_brand='"&brandName&"', prod_name='"&productName&"', prod_price="&price&", qty="&qty&", category='"&category&"' WHERE prod_id="&productID
    cnroot.execute sqlUpdate 
    cnroot.execute sqlDailyMeal

    Response.Write("<script language=""javascript"">")
    Response.Write("alert('Product updated successfully!')")
    Response.Write("</script>")
    isUpdated=true
    if isUpdated = true then
        Response.Write("<script language=""javascript"">")
        Response.Write("window.location.href=""products.asp"";")
        Response.Write("</script>")
    end if


%>