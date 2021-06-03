<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    
    ' Session.Timeout=1

    ' if Session("name") = "" then

    '     Response.Write("<script language=""javascript"">")
	' 	Response.Write("alert('Your session timed out!')")
	' 	Response.Write("</script>")
    '     isActive = false
 
    '         if isValidQty=false then
    '             Response.Write("<script language=""javascript"">")
    '             Response.Write("window.location.href=""canteen_login.asp"";")
    '             Response.Write("</script>")
    '         end if

    
    ' else
%>
<!DOCTYPE html>
<html>

    <head>

        <title>Ordering Page</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="./css/main.css">
        <link rel="stylesheet" href="./css/staff/cashier_order_page.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <!--<link rel="stylesheet" href="tail.select-master\css\default\tail.select-default.min.css">-->

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">

        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

    </head>

<%  'if Session("store")="closed" then%>
    <!--    <script>
            document.body.classList.add('closed')    
            document.body.innerHTML = "<a href='store_open.asp'><span class='unlock'>X</span></a><p class='center cursive'>Sorry, We're CLOSED</p>"
        </script> 
    -->
<%'else%>

<%  
    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
    set objAccess = cnroot.execute(sqlQuery)
    Dim maxDailyDate

    if not objAccess.EOF then

        schedID = CInt(objAccess("sched_id"))
        isStoreClosed = Trim(objAccess("status").value)
        dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))

    else

        isStoreClosed = "open"
        dateClosed = CDate(Date)
        
    end if

    set objAccess = nothing

    if dateClosed < systemDate then
        sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
        cnroot.execute(sqlUpdate)
    end if

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

    'Response.Write "Minimum ref number: " & minimumRefNo
    

    Dim maxRefNoChar, maxRefNo
    rs.Open "SELECT TOP 1 ref_no FROM "&referenceNoPath&" ORDER BY id DESC;", CN2
        do until rs.EOF
            for each x in rs.Fields
                maxRefNoChar = x.value
            next
            rs.MoveNext
        loop
    rs.close  


    if maxRefNoChar <> "" then
        maxRefNo = Mid(maxRefNoChar, 6) + 1
    else
        maxRefNo = "000000000" + 1
    end if


    Const NUMBER_DIGITS = 9
    Dim formattedInteger

    formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxRefNo, NUMBER_DIGITS)
    maxRefNo = formattedInteger

%>

<%if systemDate >= dateClosed then%>

    <%if isStoreClosed <> "closed" then%>

        <body>   

        <!--#include file="cashier_navbar.asp"-->
        <!--#include file="cashier_sidebar.asp"-->

        <%

            Dim ordersHolderFile
            ordersHolderFile = "\orders_holder.dbf" 

            Dim ordersHolderPath
            ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

            Dim fs
            Set fs = Server.CreateObject("Scripting.FileSystemObject")

        %>

        <div id="main">

            <div class="container mb-5">

                <section class="main-heading--container">

                    <p class="main-heading--text mb-5 pb-3 h1 p-0 text-center">Ordering Page 
                        <img class="order-icon" src="./img/shop.svg">
                    </p>

                </section>
               
                <%
                    ' Response.Write ordersHolderPath
                    ' Response.Write fs.FileExists(ordersHolderPath)
                %>
                <%if fs.FileExists(ordersHolderPath) = true then%>
                    <!-- ORDER FORM -->
                    <form id="form-meal" class="form-group form-inline" method="POST">
                        <select id="products" class="form-control mr-2" name="productID" style="width:650px; "class="chzn-select" required placeholder="Select Product">
                                
                        
                                
                        </select>

                        <input type="number" class="form-control" id="quantity" name="salesQty"  min="1" placeholder="Qty" autocomplete="off" style="width: 68px; height:30px; padding-top:6px; padding-bottom: 4px; margin-right: 4px; font-size:15px;" max="999999" required>
                        <button name="btnAdd" value="btnAddDetails" type="submit" class="btn btn-success btnAdd" min="1" max="100" >Add</button>
                    </form>
                    <!-- END OF ORDER FORM -->

                    <!-- ORDER TABLE --> 
                    <table id="myTable" class="table table-striped table-bordered table-sm"> 
                        <caption>List of orders</caption>
                        <thead class="thead-dark">
                            <th>Brand Name</th>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th>Qty</th>
                            <th>Amount</th>
                            <!--<th>Profit</th>-->
                            <th>Action</th>
                        </thead>
                    
                        <tbody>
                                          
                                        
                        </tbody>
                    </table>
                    <!-- END OF ORDER TABLE -->
    
                        <button type="button" class="btn btnPayment btn-success btn-block mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal">
                        Pay Cash
                        </button>    
                
                <%end if%>
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
                                        <form action="cashier_pay.asp" method="POST">

                                            <div class="form-group mb-3">    
                                                <label class="ml-1" style="font-weight: 500"> Reference No. </label>
                                                <input type="text" style="color: #ec7b1c; font-weight: 600;" class="form-control" name="referenceNo" id="referenceNo" value="<%=maxRefNo%>" pattern="[0-9]{9}" min="<%=minRefNo%>" minlength="9" maxlength="9" required>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label class="ml-1" style="font-weight: 500"> Cash Payment </label>
                                                <div class="input-group mb-3">
                                                    <div class="input-group-prepend">
                                                        <span class="input-group-text bg-primary text-light">&#8369;</span>
                                                    </div>
                                                    <!--<input type="hidden" name="invoiceNumber" value="<'%=invoice%>"> -->
                                                    <input type="text" id="userEmail" name="userEmail" value="" hidden>
                                                    <input type="number" name="totalProfit" value="<%=totalProfit%>" hidden>
                                                    <input type="number" name="totalAmount" value="<%=totalAmount%>" hidden>
                                                    <input type="number" name="customerMoney" class="form-control" aria-label="Amount (to the nearest dollar)" min="<%=totalAmount%>" required>
                            
                                                </div>

                                            </div>
                                    
                                    </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary btn-dark" data-dismiss="modal">Close</button>
                                                <button type="submit" class="btn btn-primary">Submit</button>
                                            </div>
                                        </form>  
                                </div>
                            </div>
                        </div>
                        <!-- END OF PAY CASH MODAL -->

            </div>
        </div>   

        <!--#include file="cashier_login_logout.asp"-->

        <!-- FOOTER -->

        <!--#include file="footer.asp"-->

        <!-- End of FOOTER -->

        </body>  
     
    <%else%>   
        <body class="closed">     

            <%if currDate = dateClosed then%>
                <a href="#">
                    <span class='unlock' data-toggle="modal" data-target="#confirmOpenStore">
                        <i class="fas fa-lock"></i>
                    </span>
                </a>
                <a href="canteen_homepage.asp"> 
                    <i class="fas fa-home home-link"></i> 
                </a>
                <p class='center cursive'>Sorry :( , We're CLOSED</p>
            <%else%>

                <a href="#">
                    <span class='unlock' data-toggle="modal" data-target="#confirmOpenStore">
                        <i class="fas fa-lock"></i>
                    </span>
                </a>
                <a href="canteen_homepage.asp"> 
                    <i class="fas fa-home home-link"></i> 
                </a>

                <p class='center cursive'>Sorry :( , We're CLOSED</p>
                
            <%end if%>
        </body>
    <%end if%>
<%else%>

    <body class="closed">
        <a href="#">
            <span class='unlock' data-toggle="modal" data-target="#confirmOpenStore">
                <i class="fas fa-lock"></i>
            </span>
        </a>
        <a href="canteen_homepage.asp"> 
            <i class="fas fa-home home-link"></i> 
        </a>
        <p class='center cursive'>Sorry :( , We're CLOSED</p>
    </body>

<%end if%>      


<!-- Confirm Open Store-->
        <div id="confirmOpenStore" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="a_store_open.asp" method="POST">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmation <i class="fas fa-unlock-alt"></i> </h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure to open the store?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Yes</button>
                        <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    <!-- End of Confirm Open Store -->
<script src="js/main.js"></script> 
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>
<script src="tail.select-full.min.js"></script>

<script>

function tailSelect() {

    tail.select("#select1", {
        width: "auto",
        animate: true,
        search: true,
        deselect: true,
        descriptions: true
    });

    tail.select("#products", {
        search: true,
        deselect: true,    
    });

}

const userEmail = localStorage.getItem('email');
const cashierID = localStorage.getItem('id');
const formMeal = document.getElementById('form-meal');

const selectTagMeal = document.getElementById('products');
const quantity = document.getElementById('quantity');

// console.log(`ID: ${cashierID}, Email: ${userEmail}`);

if (userEmail) {

    const userEmailContainer = document.querySelector('#userEmail');

    if (userEmailContainer) {
        userEmailContainer.value = userEmail;
    }
    

    // tail.select("#products", {
    //     search: true,
    //     deselect: true,    
    // });

    function delete_order(transactID , qty, productID, uniqueNum) {

        if(confirm('Are you sure that you want to cancel this order?'))
        {
            window.location.href='cashier_cancel_order.asp?transact_id='+transactID;
            //window.location.href='delete.asp?delete_id='+id;
        }

    }
    /*
    const idRef = document.getElementById('referenceNo')
    idRef.value = idRef.value.padStart(9, '0')
    */
   

    $('.btnAdd').click(function(event) {

    //    event.preventDefault();

        if(selectTagMeal.checkValidity() && quantity.checkValidity()) {
            //your form execution code
            event.preventDefault();

            const URL = 'cashier_incoming.asp';
            // var custID = Number(localStorage.getItem('cust_id'));
            const prodID = Number(document.querySelector('#products').value);
            const prodQty = Number(document.querySelector('#quantity').value);;
            // console.log(prodID);
            $.ajax({
                url: URL,
                type: 'POST',
                data: {cashierID: cashierID, prodID: prodID, prodQty: prodQty},
                //data: {},
            })
            .done(function(data) { 
                // console.log(data);
                //console.log(custID, prodID, prodQty);
                if (data !== 'invalid qty') location.reload();
                else if (data == 'store closed') {
                    alert('Sorry, the store is closed.');
                    location.reload();
                } 
                else if (data == 'product does not exist') alert('Sorry, Product does not exist.');
                else alert('Error: Insufficient quantity stocks');    
            })
            .fail(function() {
                console.log("Response Error");
            });

        }

    });
}

function getMeals () {
        
    const URL = 'cashier_get_meals.asp';

    $.ajax({
        url: URL,
        type: 'POST',
        data: {cashierID: cashierID},
    })
    .done(function(data) {
        // console.log(data)

        html = '';

        if (data === 'no meals') {
            html += `<option value="" disabled selected>No available product</option>`
            selectTagMeal.insertAdjacentHTML('beforeend', html);
            // formMeal.insertAdjacentHTML('afterbegin', selectTagMeal);
            
        } else if (data === 'invalid customer') {
            console.log('invalid customer');
        } 
        
        else  {

            const json = JSON.parse(data)
            html += `<option value="" disabled selected>Select a product</option>`
            for (let i in json) {
                // console.log(json[i]);
                const category = json[i].category;
                
                if (category === 'lunch' || category === 'meat' ||
                    category === 'vegetable' || category === 'fish' ||
                    category === 'chicken' 
                    ) {
                    
                    
                    html += `
                        <optgroup label='Lunch'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                    // console.log(html);

                } 
                
                else if (category === 'breakfast') {

                    html += `
                        <optgroup label='Breakfast'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'rice') {

                    html += `
                        <optgroup label='Rice'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'drinks') {

                    html += `
                        <optgroup label='Drinks'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'dessert') {

                    html += `
                        <optgroup label='Dessert'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'snacks') {

                    html += `
                        <optgroup label='Snacks'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'candies') {

                    html += `
                        <optgroup label='Candies'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'groceries') {

                    html += `
                        <optgroup label='Groceries'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'fresh-meat') {

                    html += `
                        <optgroup label='Fresh Meat'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                else if (category === 'others') {

                    html += `
                        <optgroup label='Others'>
                            <option value=${json[i].prodID}>
                                <span>&#8369;</span> ${json[i].prodPrice} / ${json[i].prodName} / Qty Left: ${json[i].qty}
                            </option>
                        </optgroup>
                    
                    `
                }

                

            }

            selectTagMeal.insertAdjacentHTML('beforeend', html);
            // formMeal.prepend(selectTagMeal);

            tailSelect();

        } 
    })
    .fail(function() {
        console.log("error");
    });
}

function getOrders () {
            
    const URL = 'cashier_get_orders.asp';
    var totAmount = 0;
    var totalAmountStr = "";
    
    $.ajax({
        url: URL,
        type: 'POST',
        data: {cashierID: cashierID},
        //data: {},
    })
    .done(function(data) {

        // console.log(data)

        if (data!=="no data") {

            let jsonObject = JSON.parse(data)

            let output = '';

            for (let i in jsonObject) {
                
                tr = "<tr>"

                if (jsonObject[i].isValidQty === 'false') {
                    tr = "<tr style='background: #ff5d5d'>"
                }

                output += ` ${tr}
                                <td> ${jsonObject[i].prodBrand} </td>
                                <td> ${jsonObject[i].prodName} </td>
                                <td> <span class='currency-sign'>&#8369; </span> ${jsonObject[i].price}</span>
                                </td> 
                                <td class='td-qty'> 
                                    <span class="d-inline-block qty-value">${jsonObject[i].qty}</span>
                                    <span class="ml-3 d-inline-flex flex-column"> 
                                        <button class="btn btn-sm btn-qty btn-qty--plus">+</button> <button class="mt-1 btn btn-sm btn-qty btn-qty--minus">-</button>
                                    </span>
                                </td> 
                                
                                <td> <strong class='currency-sign'> &#8369; </strong> ${jsonObject[i].amount} </td> 
                                <td width="90">
                                    <button onClick="delete_order(${jsonObject[i].id})" class='btn btn-sm btn-warning'>
                                        Cancel
                                    </button>
                                </td>
                            </tr>    

                            
                        `;
                    // console.log(jsonObject[i].isValidQty);
                    totAmount += jsonObject[i].amount;
            }  

            
            totalAmountStr = `<tr>
                                <td colspan="6"> 
                                    <h1 class="lead"><strong>Total Amount</h1></strong> <h4>  <span class="currency-sign">&#8369;</span> ${totAmount} </h4> 
                                </td> 
                            </tr>    `
            $('td.dataTables_empty').attr('hidden', 'hidden');
            $('#myTable tr:last').after(output + totalAmountStr);

            $('.btn-qty--plus').click(function(e) {

                const qtyValue = e.target.parentElement.previousElementSibling
                let newVal = 0
                newVal = parseInt(qtyValue.innerText) + 1
                qtyValue.innerText = newVal

                // console.log(qtyValue.innerText);

            });

            $('.btn-qty--minus').click(function(e) {

                const qtyValue = e.target.parentElement.previousElementSibling
                let newVal = 0

                if (parseInt(qtyValue.innerText) > 1) {
                    newVal = parseInt(qtyValue.innerText) - 1
                    qtyValue.innerText = newVal
                }

                // console.log(qtyValue.innerText);

            });
            
            // document.querySelector('#customerID').value = Number(localStorage.getItem('cust_id'));

        } else {
            // console.log("no new data");
            $('.btnPayment').attr('disabled', "");
        }
    })
    .fail(function() {
        console.log("error");
    });
    
}

setTimeout( () => getMeals());
setTimeout( () => getOrders());



</script> 
</html>   
