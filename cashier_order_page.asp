<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%
    
    ' Session.Timeout=1

    if Session("name") = "" then

        Response.Write("<script language=""javascript"">")
		Response.Write("alert('Your session timed out!')")
		Response.Write("</script>")
        isActive = false
 
            if isValidQty=false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""canteen_login.asp"";")
                Response.Write("</script>")
            end if

    
    else
%>
<!DOCTYPE html>
<html>
    <head>
        
        <title>Ordering Page</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="css/homepage_style.css">
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
                left: 1.2rem;
                font-size: 2.5rem;
                color: #ccc;
            }

            .home-link {
                position: absolute;
                top: 1rem;
                right: 1.2rem;
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

            .keys-container {
                display: flex;
                justify-content: center;
            }

        </style>
    </head>

<%  'if Session("store")="closed" then%>
    <!--    <script>
            document.body.classList.add('closed')    
            document.body.innerHTML = "<a href='store_open.asp'><span class='unlock'>X</span></a><p class='center cursive'>Sorry, We're CLOSED</p>"
        </script> 
    -->
<%'else%>

<%  sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
    set objAccess = cnroot.execute(sqlQuery)
    Dim systemDate, maxDailyDate
    systemDate = CDate(Application("date"))

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

    Dim maxRefNoChar, maxRefNo
    rs.Open "SELECT MAX(ref_no) FROM reference_no;", CN2
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
    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile
    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath
    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

%>

<div id="main">

    <div class="container">

        <p class="display-4 mb-5 p-0 text-center">Ordering Page <i class="fas fa-store store-icon"></i> </p>
        <%
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
%>

            <!-- ORDER FORM -->
            <form action="cashier_incoming.asp" class="form-group form-inline" method="POST">
                <select id="products" class="form-control mr-2" name="productID" style="width:650px; "class="chzn-select" required placeholder="Select Product">
                   
                    <!--<optgroup label="Group 1"> -->
            <%
            rs.open "SELECT prod_id FROM daily_meals", CN2
            if not rs.EOF then
                isThereProducts = true
            else
                isThereProducts = false
            end if
            rs.close
            
            if isThereProducts <> true then %>

                <option value="" disabled selected>No available product</option>

           <% else %> 
             <option value="" disabled selected>Select a product</option>
            <% 
            rs.Open "SELECT * FROM daily_meals ORDER BY prod_brand, prod_name", CN2

            sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""Pending"" GROUP BY prod_id ORDER BY prod_brand, prod_name"
            set objAccess  = cnroot.execute(sqlAccess)

                if objAccess.EOF >= 0 then
                    'objAccess.MoveFirst 
                    for i=0 to Ubound(orderIDS)
                    
                    isExitDo = false
                        do until rs.EOF %>
                            
                            <%  if CInt(objAccess("prod_id")) = CInt(rs("prod_id")) then 
                                qty = CInt(rs("qty")) - CInt(objAccess("qty")) %>
                                <%if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>
                                <optgroup label="Lunch">
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>   
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "breakfast" then%>       
                                <optgroup label="Breakfast">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "rice" then%>       
                                <optgroup label="Rice">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "drinks" then%>       
                                <optgroup label="Drinks">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "dessert" then%>       
                                <optgroup label="Dessert">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "snacks" then%>       
                                <optgroup label="Snacks">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "candies" then%>       
                                <optgroup label="Candies">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "groceries" then%>       
                                <optgroup label="Groceries">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                                <optgroup label="Fresh Meat">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "others" then%>       
                                <optgroup label="Others">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & qty%>
                                    </option>
                                </optgroup>
                                <%end if%>


                            <%
                                isExitDo = true
                                rs.MoveNext

                            end if
                            %>
                            

                        <%
                        'Response.Write("Hey Exit!")
                        if isExitDo=true then 
                            if rs.EOF<>true then
                                if i=Ubound(orderIDS) then %>

                        <%if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%> 
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
                        
 
                        <%rs.MoveNext 

                        else    
                            Exit Do
                        end if

                        else 
                            Exit Do
                        end if     

                        else %> 

                        <%if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>
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

                        end if
                        
                        
                        loop
                        Response.Write("Hey!")
                        objaccess.MoveNext
                    next
                

                else 
                
                    do until rs.EOF %>

                        <%if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>
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

                        <% rs.MoveNext %>
                    <%loop%>
                <%end if

                set objAccess = nothing
                rs.close
                
                %>   
            <%end if%>
            </select>
                <input type="number" class="form-control" id="quantity" name="salesQty"  min="1" placeholder="Qty" autocomplete="off" style="width: 68px; height:30px; padding-top:6px; padding-bottom: 4px; margin-right: 4px; font-size:15px;" required>
                <button name="btnAdd" value="btnAddDetails" type="submit" class="btn btn-success" min="1" max="100" >Add</button>
            </form>
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
                    <!--<th>Profit</th>-->
                    <th>Action</th>
                </thead>
            
                <tbody>
                    
                    <%	

                        Dim totalAmount, totalProfit, hasOrdered
                        totalAmount = 0.00
                        totalProfit = 0.00
                        hasOrdered = true
                  
                            rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""Pending"" and cust_id=0", CN2
  
                    %>

                        <%if not rs.EOF then%>
                            <%do until rs.EOF%>
                                
                                <tr>
                                <td><%=rs("prod_brand")%> </td>
                                <td><%=rs("prod_name")%> </td>
                                <td><%="<span class='text-primary' >&#8369; </span>"&rs("price")%> </td>
                                <td><%=rs("qty")%> </td>
                                <td><%="<span class='text-primary' >&#8369; </span>"&rs("amount")%> </td>
                                <!--<td><'%=rs("profit")%> </td>-->
                                <td width="90">
                                    <button onClick="delete_order(<%=CDbl(rs("id"))%>, <%=productQty%>, <%=productID%>)" class="btn btn-sm btn-warning"> Cancel </button>
                                </td>
                                </tr>
                            <%  
                                totalAmount = totalAmount + CDbl(rs("amount"))
                                totalProfit = totalProfit + CDbl(rs("profit"))
                                rs.MoveNext

                            loop
                            
                            %>
                        
                                <tr>
                                    <!--<td colspan="3"><h1 class="lead"><strong>Total Profit</h1></strong> <h4>  &#8369; <'%=totalProfit%></h4> </td> -->
                                    <td colspan="6"><h1 class="lead"><strong>Total Amount</h1></strong> <h4>  <span class="text-primary">&#8369;</span> <%=totalAmount%></h4> </td>
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

                <%if hasOrdered = false then%>
                    <button type="button" class="btn btn-success btn-block mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal" disabled>
                    Pay Cash
                    </button>

                <%else%>   
                    <button type="button" class="btn btn-success btn-block mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal">
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
                                        <input type="text" style="color: #f6ab6c; font-weight: 600;" class="form-control" name="referenceNo" id="referenceNo" value="<%=maxRefNo%>" pattern="[0-9]{9}" min="1" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="ml-1" style="font-weight: 500"> Cash Payment </label>
                                        <div class="input-group mb-3">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text bg-primary text-light">&#8369;</span>
                                            </div>
                                            <!--<input type="hidden" name="invoiceNumber" value="<'%=invoice%>"> -->
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

<!-- Login -->
<div id="login" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form action="login_authentication.asp" method="POST">
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
        <form action="canteen_logout.asp">
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
<!--
    <footer class="footer bg-dark text-white text-center p-5">
        <span class=".lead">Email: curiosojet@gmail.com  &nbsp;&nbsp; <span class="text-danger">&copy <script>document.write(new Date().getFullYear())</script> </span> All rights reserved. </span>
    </footer>
-->    
    </body>        
    <%else%>   
        <body class="closed">     
        <%if currDate = dateClosed then%>
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

    tail.select("#products", {
        search: true,
        deselect: true,    
    });

    function delete_order(transactID , qty, productID, uniqueNum, custID) {

        if(confirm('Are you sure that you want to cancel this order?'))
        {
            window.location.href='cashier_cancel_order.asp?transact_id='+transactID+'&salesQty='+qty+'&product_id='+productID;
            //window.location.href='delete.asp?delete_id='+id;
        }

    }

</script> 

</body>
</html>   

 <%end if %> 
