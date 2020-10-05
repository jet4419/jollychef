<!--#include file="dbConnect.asp"-->

<%

    if Session("type") = "" then
        Response.Redirect("canteen_login.asp")
    end if


    brandName = Trim(Request.Form("brandName"))

    if brandName = "" then
        brandName = "None"
    end if

    productName = Trim(Request.Form("productName"))
    price = CDbl(Request.Form("price"))
    origPrice = CDbl(Request.Form("origPrice"))
    qty = Trim(CInt(Request.Form("qty")))
    qtySold = 0
    category = Trim(CStr(Request.Form("particulars")))
    isFixMenu = Trim(CStr(Request.Form("isFixMenu")))
   ' cost = CDbl(origPrice) * CInt(qty)

    rs.Open "SELECT MAX(prod_id) FROM products", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxValue = x.value
            next
            rs.MoveNext
        loop

        maxValue= CInt(maxValue) + 1
        productID = maxValue   

        rs.close
        CN2.close  

        sqlAdd = "INSERT INTO products (prod_id, prod_brand, prod_name, price, orig_price, qty, qty_sold, category, fix_menu)"&_ 
            "VALUES ("&productID&",'"&brandName&"','"&productName&"', "&price&", "&origPrice&", "&qty&", "&qtySold&", '"&category&"', '"&isFixMenu&"')"
            set objAccess = cnroot.execute(sqlAdd)
            set objAccess = nothing

        Response.Write("<script language=""javascript"">")
        Response.Write("alert('New Product Added successfully!')")
        Response.Write("</script>")
        isAdded = true

        if isAdded = true then
            Response.Write("<script language=""javascript"">")
            Response.Write("window.location.href=""products.asp"";")
            Response.Write("</script>")
        end if        
             

%>