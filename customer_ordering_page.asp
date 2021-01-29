<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>
    <head>

        <title>Ordering Page</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/customer_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <!--
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
        -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="css/customStyles.css">
        <link rel="stylesheet" href="tail.select-default.css">
        <!--<link rel="stylesheet" href="tail.select-master\css\default\tail.select-light-feather.min.css">-->
        <!--<link href="https://fonts.googleapis.com/css2?family=Sedgwick+Ave&display=swap" rel="stylesheet">
        <script src="https://use.fontawesome.com/82e5eda0f4.js"></script> -->
        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

        <style>
  
            div.tail-select.no-classes {
                width: 400px !important;
            }
            .closed {
                height: 100vh;
                background: rgba(0,0,0,.7);
                content: "STORE CLOSED";
                z-index: 1000;
            }

            .center {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                text-align: center;
            }

            .cursive {
                font-family: 'Sedgwick Ave', cursive;
                font-size: 8rem;
            }

            .unlock {
                position: absolute;
                top: 1rem;
                left: 1rem;
                font-size: 2.5rem;
                color: #ccc;
            }

            .optgroup-title b {
                font-weight: bold !important; 
                color: rgba(0,0,0,.8)
            }

            .store-icon {
                /*color: #5e6f64;*/
                color: #52575d;
            }

            .home-link {
                position: absolute;
                top: 1rem;
                left: 1rem;
                font-size: 2.5rem;
                color: #ccc;
            }
            
        </style>

    </head>
<body>

<% Response.Write isStoreClosed %>
<%if systemDate >= dateClosed then%>

    <%if ASC(isStoreClosed) <> ASC("closed") then%>

        <!--#include file="customer_navbar.asp"-->
        <!--#include file="customer_sidebar.asp"-->

        <%
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

            Dim fs
            Set fs = Server.CreateObject("Scripting.FileSystemObject")
        %>

        <div id="main">

            <div class="container">

                <p class="h1 mb-5 p-3 text-center" style="font-weight: 400">Ordering Page <i class="fas fa-store store-icon"></i> 
                </p>

                <%if fs.FileExists(ordersHolderPath) = true then%>
                    <!-- ORDER FORM -->
                    <form class="form-group form-inline mainForm">
                        <select id="products" class="form-control mr-2" name="productID" style="width:650px; "class="chzn-select" required placeholder="Select Product">

                        <% 
                            rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.prod_price, daily_meals.qty - (IIF(ISNULL(orders_holder.qty), 0, SUM(orders_holder.qty))) AS qty, daily_meals.category, orders_holder.id FROM daily_meals LEFT JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND (orders_holder.status = 'Pending' OR orders_holder.status = 'On Process') GROUP BY daily_meals.prod_id ORDER BY daily_meals.prod_brand, daily_meals.prod_name", CN2

                            if not rs.EOF then%>

                                <option value="" disabled selected>Select a product</option>

                                <%do until rs.EOF 

                                    if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>

                                    <optgroup label="Lunch">
                                        <option value="<%=rs("prod_id")%>"> 
                                            <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                        </option>   
                                    </optgroup>

                                    <%elseif Trim(rs("category").value) = "breakfast" then%>       
                                        <optgroup label="Breakfast">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "rice" then%>       
                                        <optgroup label="Rice">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "drinks" then%>       
                                        <optgroup label="Drinks">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "dessert" then%>       
                                        <optgroup label="Dessert">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "snacks" then%>       
                                        <optgroup label="Snacks">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "candies" then%>       
                                        <optgroup label="Candies">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "groceries" then%>       
                                        <optgroup label="Groceries">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                                        <optgroup label="Fresh Meat">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
                                            </option>
                                        </optgroup>

                                    <%elseif Trim(rs("category").value) = "others" then%>       
                                        <optgroup label="Others">    
                                            <option value="<%=rs("prod_id")%>"> 
                                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & rs("qty")%>
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

                        <input type="number" class="form-control" id="quantity" name="salesQty"  min="1" placeholder="Qty" autocomplete="off" style="width: 68px; height:30px; padding-top:6px; padding-bottom: 4px; margin-right: 4px; font-size:15px;" required>
                        <button name="btnAdd" value="btnAddDetails" class="btn btnAdd btn-primary" min="1" max="100" >Add</button>
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

                    <button type="button" class="btn btnPayment btn-primary btn-block text-white mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#paymentMethodModal">
                    Process Order
                    </button> 

                <%end if%>
  
                <!--<button type="button" class="btn btn-danger btn-block btn-sm text-white mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#confirmDayEnd">
                Day End
                </button>-->
                <!-- END OF MODAL BUTTONS -->

                <!-- Payment Method Modal -->
                <div class="modal fade" id="paymentMethodModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <form action="customer_order_c.asp" method="POST">
                            <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Pay Later <i class="fas fa-tags"></i></h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <input type="number" name="customerID" id="customerID" hidden>
                                <p>Are you sure to process your order?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="submit" class="btn btn-primary">Yes</button>
                                <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                            </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- END OF Payment Method MODAL -->

            </div>
    </div>
    
    <!--#include file="footer.asp"-->
            
    <%else%>   
        <body class="closed">     
        <%if currDate = dateClosed then%>
            <a href="default.asp"> 
                <i class="fas fa-home home-link"></i> 
            </a>
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%else%>
            <a href="default.asp"> 
                <i class="fas fa-home home-link"></i> 
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

<!-- Confirm Day End -->
        <div id="confirmOpenStore" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="a_store_open.asp" method="POST">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmation</h5>
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
    <!-- End of Confirm Day End -->

<!--#include file="cust_login_logout.asp"-->

<script src="js/main.js"></script>  
<script src="./jquery/jquery_uncompressed.js"></script>
<!--
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
-->
<!--
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>   
-->
<script src="bootstrap/js/bootstrap.min.js"></script>
<script src="tail.select-full.min.js"></script>
 
<script>

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

    const products = document.querySelector('#products');
    const quantity = document.querySelector('#quantity');

    $('.btnAdd').click(function() {

        if(products.checkValidity() && quantity.checkValidity()) {
            //your form execution code
            event.preventDefault();

            var URL = 'customer_incoming.asp';
            var custID = Number(localStorage.getItem('cust_id'));
            var prodID = Number(document.querySelector('#products').value);
            var prodQty = Number(document.querySelector('#quantity').value);;
            // console.log(prodID);
            $.ajax({
                url: URL,
                type: 'POST',
                data: {custID: custID, prodID: prodID, prodQty: prodQty},
                //data: {},
            })
            .done(function(data) { 
                // console.log(data);
                //console.log(custID, prodID, prodQty);
                if (data !== 'invalid qty') location.reload();
                else if (data == 'store closed') alert('Sorry, the store is closed.');
                else alert('Error: Insufficient quantity stocks');    
            })
            .fail(function() {
                console.log("Response Error");
            });

        }
    })

    
    function getOrders () {
            
        var URL = 'customer_get_orders.asp';
        var custID = Number(localStorage.getItem('cust_id'));
        var totAmount = 0;
        var totalAmountStr = "";
        
        $.ajax({
            url: URL,
            type: 'POST',
            data: {custID: custID},
            //data: {},
        })
        .done(function(data) {
            //console.log(data)
            if (data!=="no data") {

                let jsonObject = JSON.parse(data)

                let output = '';

                for (let i in jsonObject) {
                    output += ` <tr>
                                    <td> ${jsonObject[i].prodBrand} </td>
                                    <td> ${jsonObject[i].prodName} </td>
                                    <td> <span class='text-primary'>&#8369; </span> ${jsonObject[i].price} </td> 
                                    <td> <span class='text-primary'></span> ${jsonObject[i].qty} </td> 
                                    <td> <strong class='text-primary'> &#8369; </strong> ${jsonObject[i].amount} </td> 
                                    <td width="90">
                                        <button onClick="delete_order(${jsonObject[i].id})" class='btn btn-sm btn-warning'>
                                            Cancel
                                        </button>
                                    </td>
                                </tr>    

                                
                            `;

                        totAmount += jsonObject[i].amount;
                }  

                
                totalAmountStr = `<tr>
                                    <td colspan="6"> 
                                        <h1 class="lead"><strong>Total Amount</h1></strong> <h4>  <span class="text-primary">&#8369;</span> ${totAmount} </h4> 
                                    </td> 
                                </tr>    `
                $('td.dataTables_empty').attr('hidden', 'hidden');
                $('#myTable tr:last').after(output + totalAmountStr);
                
                document.querySelector('#customerID').value = Number(localStorage.getItem('cust_id'));

            } else {
                console.log("no new data");
                $('.btnPayment').attr('disabled', "");
            }
        })
        .fail(function() {
            console.log("error");
        });
        
    }

    setTimeout( () => getOrders(), 100 )
    

    function delete_order(transactID) {

        if(confirm('Are you sure that you want to cancel this order?'))
        {
            window.location.href='customer_cancel_order.asp?transact_id='+transactID;
            //window.location.href='delete.asp?delete_id='+id;
        }

    }

</script> 

</body>
</html>   
