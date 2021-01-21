<!--#include file="dbConnect.asp"-->

<%
    productID = Request.Form("productID")

    rs.open "SELECT prod_brand, prod_name, price, orig_price, qty, category, fix_menu FROM products WHERE prod_id="&productID, CN2

    brandName = Trim(CStr(rs("prod_brand")))
    productName = Trim(CStr(rs("prod_name")))
    price = CDbl(rs("price"))
    origPrice = CDbl(rs("orig_price"))
    qty = CInt(rs("qty"))
    category = Trim(CStr(rs("category")))
    fixMenu = Trim(CStr(rs("fix_menu").value))
    

    rs.close
    CN2.close
%>

    <div class="form-group mb-1">    
        <input type="number" class="form-control form-control-sm" name="productID" id="productID" value="<%=productID%>" placeholder="ID" hidden>  
        <input type="hidden" class="form-control form-control-sm" name="brandName" id="brandName" value="<%=brandName%>" hidden>
    </div>

     <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Product Name </label>
        <input type="text" class="form-control form-control-sm" name="productName" id="productName" value="<%=productName%>">
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Selling Price </label>
        <input type="number" class="form-control form-control-sm" name="price" id="price" value="<%=price%>">
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500" hidden> Original Price </label>
        <input type="number" class="form-control form-control-sm" name="origPrice" id="origPrice" value="<%=origPrice%>" hidden>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Quantity </label>
        <input type="number" class="form-control form-control-sm" name="qty" id="qty" value="<%=qty%>">
    </div>

    <div class="form-group mb-1"> 
        <label class="form-label" style="font-weight: 500" for="particulars">Particulars</label>
        <select class="form-control form-control-sm" name="particulars" id="particulars" required>
            <option value="<%=category%>" selected><%=category%></option>
            <option value="breakfast">Breakfast</option>
            <option value="lunch">Meat</option>
            <option value="vegetable">Vegetable</option>
            <option value="fish">Fish</option>
            <option value="chicken">Chicken</option>
            <option value="rice">Rice</option>
            <option value="dessert">Dessert</option>
            <option value="snacks">Snacks</option>
            <option value="drinks">Drinks</option>
            <option value="candies">Candies</option>
            <option value="groceries">Groceries</option>
            <option value="fresh-meat">Fresh Meat</option>
            <option value="others">Others</option>
        </select>
    </div>

    <!--
    <div class="form-group mt-3">
        <label class="form-label" style="font-weight: 500" for="particulars">Track this on inventory report? </label>

        <%' if fixMenu = "yes" then %>
            <div class="form-check form-check-inline ml-2">
                <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu1" value="yes" checked required>
                <label class="form-check-label" for="isFixMenu1">Yes</label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu2" value="no">
                <label class="form-check-label" for="isFixMenu2">No</label>
            </div>
        <%' else %>
            <div class="form-check form-check-inline ml-2">
                <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu1" value="yes" required>
                <label class="form-check-label" for="isFixMenu1">Yes</label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="isFixMenu" id="isFixMenu2" value="no" checked>
                <label class="form-check-label" for="isFixMenu2">No</label>
            </div>
        <%' end if %>   
        --> 
    </div>  
     


