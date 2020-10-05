<!--#include file="dbConnect.asp"-->

<%
    productID = Request.Form("productID")

    rs.open "SELECT * FROM products WHERE prod_id="&productID, CN2

    brandName = CStr(rs("prod_brand"))
    productName = CStr(rs("prod_name"))
    price = CDbl(rs("price"))
    origPrice = CDbl(rs("orig_price"))
    qty = CInt(rs("qty"))

    rs.close
    CN2.close
%>

<style>

.form-inputs[readonly] {
    background-color: #e9ecef;
}
.btn-delete {
	background-color: #dc3545;
    border-color: #dc3545;
    outline: none;
}

.btn-delete:active {
    background-color: #dc3545;
    border-color: #dc3545;
    outline: none;
}    

</style>

<body>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Product ID</label>
        <input type="number" class="form-control form-control-sm" name="productID" id="productID" value="<%=productID%>" placeholder="ID" readonly>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Brand Name</label>
        <input type="text" class="form-control form-control-sm" name="brandName" id="brandName" value="<%=brandName%>" readonly>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Product Name </label>
        <input type="text" class="form-control form-control-sm" name="productName" id="productName" value="<%=productName%>" readonly>
    </div>

</body>


