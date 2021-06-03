<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Orders List</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="./css/main.css">
        <link rel="stylesheet" href="./css/staff/customer_order_process.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">


        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

    </head>

    <%
        Dim userType
        userType = CStr(Request.Form("userType"))

        if userType = "" then
            Response.Redirect("canteen_login.asp")
        end if
    %> 

<% 
    Dim custID, uniqueNum, customerType, isValidOrder

    if Request.Form("cust_id") = "" or Request.Form("unique_num") = "" then
        Response.Redirect("customers_order.asp")
    end if

    ' if IsNumeric(Request.Form("cust_id")) = false or IsNumeric(Request.Form("unique_num")) = false then
    '     Response.Redirect("customers_order.asp")
    ' end if

   custID = CLng(Request.Form("cust_id"))
   uniqueNum = CLng(Request.Form("unique_num"))
   isValidOrder = false

    Dim isDayEnded

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

   sqlCheckOrder = "SELECT id FROM "&ordersHolderPath&" "&_
   "WHERE cust_id="&custID&" and unique_num="&uniqueNum&" and cust_id>0"
   set objAccess = cnroot.execute(sqlCheckOrder)

   if not objAccess.EOF then
        isValidOrder = true
   end if

   set objAccess = nothing

   if isValidOrder = true then

   sqlGetType = "SELECT cust_type FROM customers WHERE cust_id="&custID
   set objAccess = cnroot.execute(sqlGetType)
   if not objAccess.EOF then
        customerType = CStr(objAccess("cust_type"))
   end if
   set objAccess = nothing

    Dim referenceNoFile
    referenceNoFile = "\reference_no.dbf" 

    Dim referenceNoPath
    referenceNoPath = mainPath & yearPath & "-" & monthPath & referenceNoFile

    Dim minRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&referenceNoPath&" ORDER BY id ASC;", CN2
        do until rs.EOF
            for each x in rs.Fields
                minRefNo = x.value
            next
            rs.MoveNext
        loop
    rs.close  

    if minRefNo = "" then
        minRefNo = CLNG(minRefNo) + 1
    else
        minRefNo = CLNG(Mid(minRefNo, 6)) + 1
    end if

    Dim maxRefNoChar, maxRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&referenceNoPath&" ORDER BY id DESC;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxRefNoChar = x.value

            next
            rs.MoveNext
        loop

    rs.close  

    'Cash Reference No
    if maxRefNoChar <> "" then
        maxRefNo = Mid(maxRefNoChar, 6) + 1
    else
        maxRefNo = "000000000" + 1
    end if

    
    Dim arReferenceNoFile
    arReferenceNoFile = "\ar_reference_no.dbf" 

    Dim arReferenceNoPath
    arReferenceNoPath = mainPath & yearPath & "-" & monthPath & arReferenceNoFile

    Dim minArRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&arReferenceNoPath&" ORDER BY id ASC;", CN2
        do until rs.EOF
            for each x in rs.Fields
                minArRefNo = x.value
            next
            rs.MoveNext
        loop
    rs.close  

    if minArRefNo = "" then
        minArRefNo = CLNG(minArRefNo) + 1
    else
        minArRefNo = CLNG(Mid(minArRefNo, 8)) + 1
    end if

    Dim maxArRefChar, maxArRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&arReferenceNoPath&" ORDER BY id DESC;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxArRefChar = x.value

            next
            rs.MoveNext
        loop
        
    rs.close  

    'Response.Write maxArRefChar & "<br>"

    'AR Reference No
    if maxArRefChar <> "" then
        maxArRefNo = Mid(maxArRefChar, 8) + 1
    else
        maxArRefNo = "000000000" + 1
    end if

    Const NUMBER_DIGITS = 9
    Dim formattedInteger, formattedIntegerAR

    formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxRefNo, NUMBER_DIGITS)
    formattedIntegerAR = Right(String(NUMBER_DIGITS, "0") & maxArRefNo, NUMBER_DIGITS)

    maxRefNo = formattedInteger
    maxArRefNo = formattedIntegerAR

    ' Response.Write maxRefNo & "<br>"
    ' Response.Write maxArRefNo & "<br>"
%>

<body>

<%if systemDate >= dateClosed then%>

    <%if ASC(isStoreClosed) <> ASC("closed") then%>

        <!--#include file="cashier_navbar.asp"-->
        <!--#include file="cashier_sidebar.asp"-->

        <% 
            sqlGetInfo = "SELECT * FROM customers WHERE cust_id="&custID
            set objAccess = cnroot.execute(sqlGetInfo)
            if not objAccess.EOF then

                    custFname = Trim(CStr(objAccess("cust_fname")))
                    custLname = Trim(CStr(objAccess("cust_lname")))
                    custFullName = custLname & " " & custFname
                    department = CStr(objAccess("department"))

            end if
        %>

        <div id="main">
            <div class="container mb-5">
              
                <section class="main-heading--container mb-5">
                    <h1 class="text-center main-heading--text mt-0"> <span class="order_of">Order of</span> <span class="customer-name"><%=custFullName%></span> </h1>
                    <h1 class="h3 text-center main-heading my-0"> <span class="department_lbl"><%=department%></span> </h1>
                </section>

                <!-- 3 important parametes --> 
                <input type="number" name="cust_id" id="cust_id" value="<%=custID%>" hidden>
                <input type="number" name="unique_num" id="unique_num" value="<%=uniqueNum%>" hidden>
                <input type="text" name="userType" id="userType" value="<%=userType%>" hidden>
                <!-- ************************************* -->

                <%if userType = "admin" or userType = "programmer" then%>
                    <!-- ORDER FORM -->
                    <form id="orderFormAdmin" class="form-group form-inline" method="POST">

                        <select id="products" class="form-control mr-2" name="product_id" style="width:650px; "class="chzn-select" placeholder="Select Product" required>
                    
                        <% 
                            rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.prod_price, daily_meals.qty - (IIF(ISNULL(orders_holder.qty), 0, SUM(orders_holder.qty))) AS qty, daily_meals.category, orders_holder.id FROM daily_meals LEFT JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND orders_holder.status = 'On Process' AND orders_holder.cust_id="&custID&" GROUP BY daily_meals.prod_id ORDER BY daily_meals.prod_brand, daily_meals.prod_name", CN2

                            if not rs.EOF then%>

                                <option value="" disabled selected>Select a product</option>

                                <%do until rs.EOF 

                                    if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>

                                    <optgroup label="Lunch">
                                        <option value="<%=rs("prod_id")%>"> 
                                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                        </option>   
                                    </optgroup>

                                    <%elseif Trim(rs("category").value) = "breakfast" then%>       
                                        <optgroup label="Breakfast">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "rice" then%>       
                                        <optgroup label="Rice">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "drinks" then%>       
                                        <optgroup label="Drinks">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "dessert" then%>       
                                        <optgroup label="Dessert">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "snacks" then%>       
                                        <optgroup label="Snacks">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "candies" then%>       
                                        <optgroup label="Candies">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "groceries" then%>       
                                        <optgroup label="Groceries">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                                        <optgroup label="Fresh Meat">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "others" then%>       
                                        <optgroup label="Others">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>
                                    <%end if%>

                                    <%
                                    rs.MoveNext
                                loop 

                            else%>

                                <option value="" disabled selected>No available product</option>

                            <%end if

                            rs.close
                        %>

                        </select>

                        <input type="number" class="form-control" id="quantity" name="salesQty"  min="1" placeholder="Qty" autocomplete="off" style="width: 68px; height:30px; padding-top:6px; padding-bottom: 4px; margin-right: 4px; font-size:15px;" max="999999" required>
                        <button name="btnAdd" type="submit" value="btnAddDetails" class="btnAdd btn  btn-success" min="1" max="100" >Add</button>
                    </form>
                    <!-- END OF ORDER FORM -->

                <%end if%>

                <!-- ORDER TABLE --> 
                <table class="table table-striped table-bordered table-sm"> 
                    <caption>List of orders</caption>
                    <thead class="thead-bg">
                        <th>Brand Name</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Amount</th>
                        <th>Action</th>
                    </thead>
                
                    <tbody>
                        
                        <%	
                            Dim totalAmount, totalProfit
                            totalAmount = 0.00
                            totalProfit = 0.00
                    
                            rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum&" and cust_id="&custID, CN2
                        %>
                        
                            <%if not rs.EOF then
                                hasOrdered = true%>
                                <%do until rs.EOF

                                    orderProdID = CInt(rs("prod_id"))
                                    orderQty = CInt(rs("qty"))

                                    checkQty = "SELECT prod_id, qty FROM daily_meals WHERE prod_id ="&orderProdID
                                    set objAccess = cnroot.execute(checkQty)

                                    if not objAccess.EOF then

                                        currentQty = CInt(objAccess("qty").value) - orderQty

                                    end if

                                    if currentQty < 0 then%>

                                    <tr style="background: #ff5d5d">

                                    <%else%>
                                    <tr>
                                    <%end if%>                            
                                        <td><%=rs("prod_brand")%> </td>
                                        <td><%=rs("prod_name")%> </td>
                                        <td> <span class="currency-sign">&#8369;</span> <%=rs("price")%> </td>
                                        <td><%=rs("qty")%> </td>
                                        <td> <span class="currency-sign">&#8369; </span><%=rs("amount")%> </td>
                                        <%if userType = "admin" or userType = "programmer" then%>    
                                            <td width="90">
                                                <button value="<%=CLng(rs("id"))%>" class="btn btn-sm btn-warning btnCancel"> Cancel </button>
                                            </td>
                                        <%else%>    
                                            <td width="90"><a href="#" hidden><button class="btn btn-sm btn-outline-dark" disabled> Cancel </button></a></td>
                                        <%end if%>
                                    </tr>
                                    <%
                                        totalAmount = totalAmount + CDbl(rs("amount"))
                                        totalProfit = totalProfit + CDbl(rs("profit"))
                                    rs.MoveNext
                                loop%>
                            
                                    <tr>
                                        <td colspan="6"><h1 class="lead"><strong>Total Amount</h1></strong> <h4> <span class="currency-sign">&#8369;</span> <%=totalAmount%></h4> </td>
                                    </tr>
                            <%else
                                hasOrdered = false
                            end if
                            %>
                                    
                    </tbody>
                </table>
                <!-- END OF ORDER TABLE -->
                <%
                    rs.close
                    CN2.close
                %>

                <%if hasOrdered = true then%>
                <div class="d-flex justify-content-center">
                    <button type="button" class="btn btn-success btn-inline text-white mx-2 mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal">
                    Pay In Cash
                    </button>

                    <button type="button" class="btn btn-dark btn-inline text-white mx-2 mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#oweCashModal">
                    Pay In Credit
                    </button>
                </div>
                <%else%>
                <div class="d-flex justify-content-center">
                    <button type="button" class="btn btn-success btn-inline text-white mx-2 mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal" disabled>
                    Pay In Cash
                    </button>

                    <button type="button" class="btn btn-dark btn-inline text-white mx-2 mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#oweCashModal" disabled>
                    Pay In Credit
                    </button>
                </div>
                <%end if%>
                
                <input type="text" name="cust_name" id="cust_name" value="<%=custFullName%>" hidden>
                <input type="text" name="cust_dept" value="<%=department%>" id="cust_dept" hidden>
                <input type="number" name="totalProfit" value="<%=totalProfit%>" id="totalProfit" hidden>
                <input type="number" name="totalAmount" value="<%=totalAmount%>" id="totalAmount" hidden>

                <!-- Pay Cash Modal -->
                    <div class="modal fade" id="payCashModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="exampleModalLabel">Pay Cash <i class="fas fa-tags"></i></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <!-- Modal Body (Contents) -->
                                    <form id="formPayCash">
     
                                        <div class="form-group mb-3">    
                                            <label class="ml-1" style="font-weight: 500"> Reference No. </label>
                                            <input type="text" style="color: #ec7b1c; font-weight: 600;" pattern="[0-9]{9}" class="form-control" name="referenceNo" id="referenceNo" min="<%=minRefNo%>" value="<%=maxRefNo%>" minlength="9" maxlength="9" required>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label class="ml-1" style="font-weight: 500"> Cash Payment </label>
                                            <div class="input-group mb-3">
                                                <div class="input-group-prepend">
                                                    <span class="input-group-text bg-success text-light">&#8369;</span>
                                                </div>
                                                <!--<input type="hidden" name="invoiceNumber" value="<'%=invoice%>"> -->
                                                <input type="number" id="customerMoney" name="customerMoney" class="form-control" aria-label="Amount (to the nearest dollar)" min="<%=totalAmount%>" max="999999" required>
                        
                                            </div>

                                        </div>
                                
                                </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary btn-dark" data-dismiss="modal">Close</button>
                                            <button class="btn btn-success btnPayCash">Proceed</button>
                                        </div>
                                    </form>  
                            </div>
                        </div>
                    </div>
                <!-- END OF PAY CASH MODAL -->    

                <!-- CREDIT PAY MODAL -->
                    <div class="modal fade" id="oweCashModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <form id="formPayCredit">
                                <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Pay In Credit</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">

                                    <input type="text" name="customerType" id="customerType" value="<%=customerType%>" hidden>
                                    <!--
                                    <p>Are you sure to process your order?</p>
                                    -->
                                    <div class="form-group mb-3">    
                                        <label class="ml-1" style="font-weight: 500"> Reference No. </label>
                                        <input type="text" style="color: #ec7b1c; font-weight: 600;" class="form-control" name="arReferenceNo" id="arReferenceNo" min="<%=minArRefNo%>" value="<%=maxArRefNo%>" pattern="[0-9]{9}" minlength="9" maxlength="9" required>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-dark" data-dismiss="modal">Close</button>
                                    <button type="submit" class="btn btn-success btnPayCredit">Proceed</button>
                                </div>
                                </div>
                            </form>
                        </div>
                    </div>
                <!-- END OF CREDIT PAY MODAL -->

            </div>

        </div>

        <!-- FOOTER -->

        <!--#include file="footer.asp"-->

        <!-- End of FOOTER -->
            
            
    <%else%>   
        <body class="closed">     
        <%if systemDate = dateClosed then%>
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%else%>
            <a href="#">
                <span class='unlock' data-toggle="modal" data-target="#confirmOpenStore">
                    <i class="fas fa-lock"></i>
                </span>
            </a>
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%end if%>
        
        </body>
    <%end if%>

    
    <%else%>
        <body class="closed">
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        </body>

    <%end if%>

<%else
    Response.Redirect("customers_order.asp")
end if%>

<!--#include file="cashier_login_logout.asp"-->


<script src="js/main.js"></script> 
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>
<script src="tail.select-full.min.js"></script>

<script>

    const cashierID = localStorage.getItem('id');
    const cashierType = localStorage.getItem('type');
    const cashierEmail = localStorage.getItem('email');
    const cashierName = localStorage.getItem('fullname');
    const cashierTokenId = localStorage.getItem('tokenid');

    tail.select("#products", {
        search: true,
        deselect: true,    
    });

    const formOrderAdmin = document.getElementById('orderFormAdmin');

    if (formOrderAdmin !== null) {
        const productID = document.getElementById('products');
        const quantity = document.getElementById('quantity');
    }

    const custID = document.getElementById('cust_id').value;
    const uniqueNum = document.getElementById('unique_num').value;
    const userType = document.getElementById('userType').value;

    const custName = document.getElementById('cust_name').value;
    const custDept = document.getElementById('cust_dept').value;

    const formOrder = document.createElement('form');
    formOrder.setAttribute('action', 'customer_order_process.asp');
    formOrder.setAttribute('method', 'POST');

    const inputElCashierType = document.createElement('input');
    inputElCashierType.setAttribute('name', 'userType');
    inputElCashierType.setAttribute('value', cashierType);

    const inputElCashierEmail = document.createElement('input');
    inputElCashierEmail.setAttribute('name', 'cashierEmail');
    inputElCashierEmail.setAttribute('value', cashierEmail);

    const inputElUniqueNum = document.createElement('input');
    inputElUniqueNum.setAttribute('name', 'unique_num');
    inputElUniqueNum.setAttribute('value', uniqueNum);

    const inputElCustId = document.createElement('input');
    inputElCustId.setAttribute('name', 'cust_id');
    inputElCustId.setAttribute('value', custID);

    formOrder.appendChild(inputElCashierType);
    formOrder.appendChild(inputElUniqueNum);
    formOrder.appendChild(inputElCustId);

    const formPayCash = document.getElementById('formPayCash');
    const formPayCredit = document.getElementById('formPayCredit');

    $('.btnAdd').click(function(event) {

        if(formOrderAdmin.checkValidity()) {
            //your form execution code
            event.preventDefault();

            var URL = 'customer_incoming2.asp';

            const prodID = Number(document.getElementById('products').value);
            const prodQty = Number(quantity.value);;

            const inputElProdId = document.createElement('input');
            inputElProdId.setAttribute('name', 'productID');
            inputElProdId.setAttribute('value', prodID);

            const inputElQty = document.createElement('input');
            inputElQty.setAttribute('name', 'salesQty');
            inputElQty.setAttribute('value', prodQty);

            // console.log(prodID);
            $.ajax({
                url: URL,
                type: 'POST',
                data: {cashierID: cashierID,productID: prodID, salesQty: prodQty, cashierType: cashierType, cashierEmail: cashierEmail, cust_id: custID, unique_num: uniqueNum, tokenID: cashierTokenId},
            })
            .done(function(data) { 
                // console.log(data);
                //console.log(custID, prodID, prodQty);
                if (data === 'invalid cashier') alert('Invalid Cashier');
                else if (data === 'invalid quantity') alert('Invalid Quantity');
                else if (data == 'store closed') alert('Sorry, the store is closed.');
                else {
                    document.body.appendChild(formOrder);
                    formOrder.submit();
                }    
            })
            .fail(function() {
                console.log("Response Error");
            });

        }

    });


    $('.btnCancel').click(function(event) {

        if(confirm('Are you sure that you want to cancel this order?')) {

            const orderID = event.target.value;
        
            $.ajax({
                url: 'customer_order_process_cancel.asp',
                type: 'POST',
                data: {cashierID: cashierID, orderID: orderID, unique_num: uniqueNum, cust_id: custID, cashierEmail: cashierEmail, cashierType: cashierType, tokenID: cashierTokenId},
            })
            .done(function(data) { 

                if (data === 'invalid cashier') alert('Invalid Cashier');
                else if (data === 'no update permission') alert(`Sorry, You don't have a permission for this action.`);
                else {
                    alert('Order has been cancelled.')
                    document.body.appendChild(formOrder);
                    formOrder.submit();
                }    
            })
            .fail(function() {
                console.log("Response Error");
            });
        }
    });

    $('.btnPayCash').click(function(event) {

        if(formPayCash.checkValidity()) {

            event.preventDefault();
            
            const totalProfit = document.getElementById('totalProfit').value;
            const totalAmount = document.getElementById('totalAmount').value;
            const customerMoney = document.getElementById('customerMoney').value;
            const referenceNo = document.getElementById('referenceNo').value;

            $.ajax({
                url: 'customer_pay2.asp',
                type: 'POST',
                data: {cashierID: cashierID, custID: custID, custName: custName, custDept: custDept, uniqueNum: uniqueNum, totalProfit: totalProfit, totalAmount: totalAmount, customerMoney: customerMoney, referenceNo: referenceNo, cashierEmail: cashierEmail, cashierName: cashierName, cashierType: cashierType, tokenID: cashierTokenId},
            })
            .done(function(data) { 

                // console.log(data);

                // console.log(data);
                if (data === 'no cashier') {
                    alert('No Cashier');
                    localStorage.clear();
                    window.location = 'canteen_login.asp';
                }

                else if (data === 'invalid cashier') {
                    alert('Invalid Cashier');
                    localStorage.clear();
                    window.location.href='canteen_login.asp';
                }

                else if (data === 'invalid reference number') {
                    alert('Invalid Reference Number');
                }

                else if (data === 'order does not exist') {
                    alert('Order does not exist');
                    window.location.href = 'customer_orders.asp';
                }

                else if (data === 'insufficient cash') {
                    alert('Insufficient Cash');
                    document.body.appendChild(formOrder);
                    formOrder.submit();
                }

                else if (data === 'invalid ordered qty') {
                    alert('Invalid Ordered Quantity');
                    // document.body.appendChild(formOrder);
                    // formOrder.submit();
                }

                else if (data === 'insufficient product stock') {
                    alert('Insufficient Product Stock');
                    document.body.appendChild(formOrder);
                    formOrder.submit();
                }

                else {
                    alert('Order Completed!');
                    window.location.href = 'receipt_customer_cash.asp?invoice='+data;
                    
                }

            })
            .fail(function() {
                console.log("Response Error");
            });
        }

    });

    
    $('.btnPayCredit').click(function(event) {

        const totalProfit = document.getElementById('totalProfit').value;
        const totalAmount = document.getElementById('totalAmount').value;
        const customerMoney = document.getElementById('customerMoney').value;
        const customerType = document.getElementById('customerType').value;
        const arReferenceNo = document.getElementById('arReferenceNo').value;
        

        if (formPayCredit.checkValidity()) {
            
            event.preventDefault();

            $.ajax({
                url: 'customer_order_credit_c.asp',
                type: 'POST',
                data: {arReferenceNo: arReferenceNo, custID: custID, custName: custName, custDept: custDept, uniqueNum: uniqueNum, customerType: customerType, cashierID: cashierID, cashierType: cashierType, cashierEmail: cashierEmail, cashierName: cashierName,  tokenID: cashierTokenId},
            })
            .done(function(data) { 

                // console.log(data);
                if (data === 'no cashier') {
                    alert('No Cashier');
                    localStorage.clear();
                    window.location = 'canteen_login.asp';
                }

                if (data === 'invalid cashier') {
                    alert('Invalid Cashier');
                    localStorage.clear();
                    window.location.href='canteen_login.asp';
                }

                else if (data === 'invalid reference number') {
                    alert('Error: Reference number may already exist.');
                }

                else if (data === 'order does not exist') {
                    alert('Order does not exist');
                    window.location.href = 'customer_orders.asp';
                }

                else if (data === 'invalid ordered qty') {
                    alert('Invalid Ordered Quantity');
                    // document.body.appendChild(formOrder);
                    // formOrder.submit();
                }

                else if (data === 'insufficient product stock') {
                    alert('Insufficient Product Stock');
                    document.body.appendChild(formOrder);
                    formOrder.submit();
                }

                else {
                    alert('Order Completed!');
                    const orderData = data.split(',');
                    window.location.href = `receipt_ar_order.asp?invoice=${orderData[0]}&date=${orderData[1]}`;
                }

            })
            .fail(function() {
                console.log("Response Error");
            });
        }


    });

    // function delete_order(transactID , uniqueNum, custID) {

    //     if(confirm('Are you sure that you want to cancel this order?'))
    //     {
    //         window.location.href=`customer_order_process_cancel.asp?transact_id=${transactID}&unique_num=${uniqueNum}&cust_id=${custID}&userType=${cashierType}`;
    //         //window.location.href='delete.asp?delete_id='+id;
    //     }

    // }

</script> 

</body>
</html>   
