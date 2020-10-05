<!--#include file="dbConnect.asp"-->

<%
    Dim data, ids, idsLen, prodID, prodBrand, prodName, prodQty, prodPrice, category, currDate, maxDMid, systemDate
    data = Request.Form("myTable_length")
    'Response.Write(data) 
    'systemDate = CDate(Application("date"))
    ids = Split(data, ",")
    idsLen = Ubound(ids)
    
    if data<>"" then

        rs.Open "SELECT MAX(dm_id) FROM daily_meals", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxValue = x.value
            next
            rs.MoveNext
        loop

        maxValue= CInt(maxValue) + 1
        maxDMid = maxValue   
        rs.close
        'Response.Write("Length:" & idsLen & "<br>")

        for i = 0 to idsLen-1
            'Response.Write(ids(i) & "<br>")
            sqlQuery = "SELECT * FROM products WHERE prod_id="&ids(i)
            set objAccess = cnroot.execute(sqlQuery)
            prodID = objAccess("prod_id")
            prodBrand = objAccess("prod_brand")
            prodName = objAccess("prod_name")
            prodQty = objAccess("qty")
            prodPrice = objAccess("price")
            category = objAccess("category")
            'status = "available"
            set objAccess = nothing
            'Response.Write(objAccess("prod_name") & "<br>")
            'Response.Write(objAccess("price") & "<br>")
            sqlAdd = "INSERT INTO daily_meals (dm_id, prod_id, prod_brand, prod_name, qty, prod_price, category)"&_
            "VALUES ("&maxDMid&", "&prodID&", '"&prodBrand&"', '"&prodName&"', "&prodQty&", "&prodPrice&", '"&category&"')"
            cnroot.execute(sqlAdd)
            
            maxDMid = maxDMid + 1
            
        next 

            Response.Write "true"
        ' Response.Write("<script language=""javascript"">")
        ' Response.Write("alert('Daily Meals Successfully Added!')")
        ' Response.Write("</script>")
        ' isAdded = true
        ' 'invoiceNumber = invoiceNumber + 1
        ' If isAdded = true then
        ' ' Response.Redirect("bootSales.asp")
        '     Response.Write("<script language=""javascript"">")
        '     Response.Write("window.location.href=""a_cashier_order_page.asp"";")
        '     Response.Write("</script>")
        ' end If

    else
        Response.Write "false"
        ' Response.Write("<script language=""javascript"">")
        ' Response.Write("alert('No Meals Added!')")
        ' Response.Write("</script>")
        ' isAdded = true
        ' 'invoiceNumber = invoiceNumber + 1
        ' If isAdded = true then
        ' ' Response.Redirect("bootSales.asp")
        '     Response.Write("<script language=""javascript"">")
        '     Response.Write("window.location.href=""bootDailyMeal.asp"";")
        '     Response.Write("</script>")
        ' end If

    end if

%>