<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="css/homepage_style.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">

        <script type="text/javascript" >
        function preventBack(){window.history.forward();}
            setTimeout("preventBack()", 0);
            window.onunload=function(){null};
        </script>

        <style>
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

            .users-info {
                font-family: 'Kulim Park', sans-serif;
                border: 1px solid #aaa;
                padding: 5px;
                border-radius: 10px;
            }

            .cust_name {
                color: #438a5e;
            }

            .department_lbl {
                color: #b49c73;
            }

            .order_of {
                color: #333;
            }

        </style>
    </head>
<body>

<%  'if Session("store")="closed" then%>
    <!--    <script>
            document.body.classList.add('closed')    
            document.body.innerHTML = "<a href='store_open.asp'><span class='unlock'>X</span></a><p class='center cursive'>Sorry, We're CLOSED</p>"
        </script> 
    -->
<%'else%>

<% 
    if Request.QueryString("cust_id") = "" or Request.QueryString("unique_num") = "" then
        Response.Redirect("customer_my_orders.asp")
    end if

    if IsNumeric(Request.QueryString("cust_id")) = false or IsNumeric(Request.QueryString("unique_num")) = false then
        Response.Redirect("customer_my_orders.asp")
    end if

    Dim custID, uniqueNum

    custID = CInt(Request.QueryString("cust_id"))
    uniqueNum = CInt(Request.QueryString("unique_num"))
%>


<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

        <% sqlGetInfo = "SELECT * FROM customers WHERE cust_id="&custID
           set objAccess = cnroot.execute(sqlGetInfo)
           if not objAccess.EOF then

                custFname = CStr(objAccess("cust_fname"))
                custLname = CStr(objAccess("cust_lname"))
                custFullName = custLname & " " & custFname
                department = CStr(objAccess("department"))

           end if
        %>
<div id="main">
    <div class="container p-3">
        
        <div class="users-info mb-5">
            <h1 class="h1 text-center main-heading my-0"> <strong><span class="order_of">Order of</span> <span class="cust_name"><%=custFullName%></span></strong> </h1>
            <h1 class="h3 text-center main-heading my-0"> <span class="department_lbl"><strong><%=department%></strong></span> </h1>
        </div>

        <%  
            Dim yearPath, monthPath

            yearPath = CStr(Year(systemDate))
            monthPath = CStr(Month(systemDate))
            

            if Len(monthPath) = 1 then
                monthPath = "0" & monthPath
            end if

            Dim ordersHolderFile
            ordersHolderFile = "\orders_holder.dbf"

            Dim ordersHolderPath
            ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

            productID = CInt(Request.QueryString("productID"))
            productQty = CInt(Request.QueryString("prodQty"))
            productsIDs = ""
            ordersIDs = ""
            sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""Pending"" GROUP BY prod_id ORDER BY prod_brand, prod_name"
            set objAccess  = cnroot.execute(sqlAccess)
            
                do while not objaccess.eof 

                    ordersIDs = ordersIDs & " " & objAccess("prod_id")
                
                objaccess.movenext
                loop  	
            set objAccess = nothing
            ids = ltrim(ordersIDs)
            orderIDS = Split(ids, " ")
            ' for each x in orderIDS
            '     Response.Write("Orders ID value: " & x)
            '     Response.Write("<br>")
            ' next
            'Response.Write("Length of Array Order IDS: " & Ubound(orderIDS) & "<br>")
            'Response.Write( "Order ID#: " & orderIDS(0) & "<br>")

            'Response.Write(objAccess("qty"))
            rs.open "SELECT COUNT(prod_id) AS recordCount FROM products", CN2

            rsCount = CInt(rs("recordCount"))
            rs.close

            'Response.Write("Record Count: " & rsCount & "<br>")%>

            <!-- ORDER FORM -->
            
            <!-- END OF ORDER FORM -->
            <%'Response.Write(Session("cust_id"))%>
            <!-- ORDER TABLE --> 
            <table class="table table-striped table-bordered table-sm"> 
            <caption>List of orders</caption>
                <thead class="thead-dark">
                    <th>Brand Name</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Qty</th>
                    <th>Amount</th>
                </thead>
            
                <tbody>
                    
                    <%	
                        'invoice = CInt(Request.QueryString("invoice_number"))
                        'productID = CInt(Request.QueryString("product_id"))
                        'productQty = CInt(Request.QueryString("prodQty"))
                        Dim totalAmount, totalProfit
                        totalAmount = 0.00
                        totalProfit = 0.00
                  
                        rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum, CN2
 
                    %>
                        
                            <%do until rs.EOF%>
                                
                                <tr>
                                <td><%=rs("prod_brand")%> </td>
                                <td><%=rs("prod_name")%> </td>
                                <td><span class='text-primary' >&#8369; </span><%=rs("price")%> </td>
                                <td><%=rs("qty")%> </td>
                                <td><span class='text-primary' >&#8369; </span><%=rs("amount")%> </td>
                                </tr>
                            <%totalAmount = totalAmount + CDbl(rs("amount"))
                                rs.MoveNext
                            loop%>
                        
                                <tr>
                                    <td colspan="6"><h1 class="lead"><strong>Total Amount</h1></strong> <h4>  &#8369; <%=totalAmount%></h4> </td>
                                </tr>
                                
                </tbody>
            </table>
            <!-- END OF ORDER TABLE -->
            <%
                rs.close
                CN2.close
            %>

    </div>
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

    <!-- Login -->
    <div id="login" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <form action="cust_login_auth.asp" method="POST">
                <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Customer Login</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" class="form-control" name="email" id="email" placeholder="Email">
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" name="password" id="password" placeholder="Password">
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button type="submit" class="btn btn-sm btn-success" name="btn-login" value="login" >Login</button>
                </div>
                </div>
            </form>
        </div>
    </div>
<!-- End of Login -->

<!-- Logout -->
        <div id="logout" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="cust_logout.asp">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Logout</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure to logout?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Yes</button>
                        <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    <!-- End of Logout -->  

<!-- Confirm Day End -->
        <div id="confirmOpenStore" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="store_open.asp" method="POST">
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

<!--<script src="js/script.js"></script> -->
<script src="js/main.js"></script>   
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>  

<script>

   

</script> 

</body>
</html>   
