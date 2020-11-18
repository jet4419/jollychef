<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->

<!DOCTYPE html>
<html>
    <head>
        
        <title>Orders List</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="css/homepage_style.css">
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

            div.tail-select.no-classes {
                width: 400px !important;
            }

        </style>
    </head>
    <%
        Dim userType
        userType = CStr(Request.QueryString("userType"))

        if userType = "" then
            Response.Redirect("canteen_login.asp")
        end if
    %> 

<body>

<% Dim custID, uniqueNum, customerType, isValidOrder

    if Request.QueryString("cust_id") = "" or Request.QueryString("unique_num") = "" then
        Response.Redirect("customers_order.asp")
    end if

    if IsNumeric(Request.QueryString("cust_id")) = false or IsNumeric(Request.QueryString("unique_num")) = false then
        Response.Redirect("customers_order.asp")
    end if

   custID = CLng(Request.QueryString("cust_id"))
   uniqueNum = CLng(Request.QueryString("unique_num"))
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

    Dim maxRefNoChar, maxRefNo
    rs.Open "SELECT MAX(ref_no) FROM reference_no;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxRefNoChar = x.value

            next
            rs.MoveNext
        loop
        ' Response.Write(TypeName(maxRefNo))   

    rs.close  

    'Cash Reference No
    if maxRefNoChar <> "" then
        maxRefNo = Mid(maxRefNoChar, 6) + 1
    else
        maxRefNo = "000000000" + 1
    end if

    Dim maxArRefChar, maxArRefNo
    rs.Open "SELECT MAX(ref_no) FROM ar_reference_no;", CN2
        do until rs.EOF
            for each x in rs.Fields

                maxArRefChar = x.value

            next
            rs.MoveNext
        loop
        ' Response.Write(TypeName(maxRefNo))
        'maxArRefChar = CStr(maxArRefChar)
        
    rs.close  

    'Response.Write maxArRefChar

    'AR Reference No
    if maxArRefChar <> "" then
        maxArRefNo = Mid(maxArRefChar, 8) + 1
    else
        maxArRefNo = "000000000" + 1
    end if

    'Response.Write maxArRefNo

    Const NUMBER_DIGITS = 9
    Dim formattedInteger, formattedIntegerAR

    formattedInteger = Right(String(NUMBER_DIGITS, "0") & maxRefNo, NUMBER_DIGITS)
    formattedIntegerAR = Right(String(NUMBER_DIGITS, "0") & maxArRefNo, NUMBER_DIGITS)

    maxRefNo = formattedInteger
    maxArRefNo = formattedIntegerAR

    'Response.Write(maxArRefNo)
%>

<%  sqlQuery = "SELECT MAX(sched_id) AS sched_id, status, date_time FROM store_schedule" 
    set objAccess = cnroot.execute(sqlQuery)
    Dim maxDailyDate
    
    if not objAccess.EOF then
        schedID = CLng(objAccess("sched_id"))
        isStoreClosed = CStr(objAccess("status"))
        dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
        'systemDate = CDate(Date)
    else
        isStoreClosed = "open"
        dateClosed = CDate(Date)
        'systemDate = CDate(Date)
    end if

    set objAccess = nothing

    if dateClosed < systemDate then
        sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
        cnroot.execute(sqlUpdate)
    end if
%>

<%if systemDate >= dateClosed then%>

    <%if ASC(isStoreClosed) <> ASC("closed") then%>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

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
            productID = CLng(Request.QueryString("productID"))
            productQty = CLng(Request.QueryString("prodQty"))
            productsIDs = ""
            ordersIDs = ""
            sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""On Process"" and cust_id="&custID&" GROUP BY prod_id ORDER BY prod_brand, prod_name"
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

            rsCount = CLng(rs("recordCount"))
            rs.close

            'Response.Write("Record Count: " & rsCount & "<br>")%>

            <!-- ORDER FORM -->
            <%if userType = "admin" then%>
                <!-- ORDER FORM -->
            <form action="customer_incoming2.asp" class="form-group form-inline" method="POST">
                <input type="number" name="cust_id" id="cust_id" value="<%=custID%>" hidden>
                <input type="number" name="unique_num" id="unique_num" value="<%=uniqueNum%>" hidden>
                <input type="text" name="userType" id="userType" value="<%=userType%>" hidden>
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

            sqlAccess = "SELECT DISTINCT prod_id, SUM(qty) AS qty FROM "&ordersHolderPath&" WHERE status=""On Process"" and cust_id="&custID&" GROUP BY prod_id ORDER BY prod_brand, prod_name"
            set objAccess  = cnroot.execute(sqlAccess)

                if objAccess.EOF >= 0 then
                    'objAccess.MoveFirst 
                    for i=0 to Ubound(orderIDS)
                    
                    isExitDo = false
                        do until rs.EOF %>
                            
                            <%  if CLng(objAccess("prod_id")) = CLng(rs("prod_id")) then 
                                qty = CLng(rs("qty")) - CLng(objAccess("qty")) %>
                                <%if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>
                                <optgroup label="Lunch">
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>   
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "breakfast" then%>       
                                <optgroup label="Breakfast">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "rice" then%>       
                                <optgroup label="Rice">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "drinks" then%>       
                                <optgroup label="Drinks">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "dessert" then%>       
                                <optgroup label="Dessert">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "snacks" then%>       
                                <optgroup label="Snacks">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "candies" then%>       
                                <optgroup label="Candies">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "groceries" then%>       
                                <optgroup label="Groceries">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                                <optgroup label="Fresh Meat">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
                                    </option>
                                </optgroup>

                                <%elseif Trim(rs("category").value) = "others" then%>       
                                <optgroup label="Others">    
                                    <option value="<%=rs("prod_id")%>"> 
                                        <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & qty%>
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
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "breakfast" then%>       
                            <optgroup label="Breakfast">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "rice" then%>       
                            <optgroup label="Rice">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "drinks" then%>       
                            <optgroup label="Drinks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "dessert" then%>       
                            <optgroup label="Dessert">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "snacks" then%>       
                            <optgroup label="Snacks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "candies" then%>       
                            <optgroup label="Candies">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "groceries" then%>       
                            <optgroup label="Groceries">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                            <optgroup label="Fresh Meat">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>               

                        <%elseif Trim(rs("category").value) = "others" then%> 
                            <optgroup label="Others">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
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
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>  

                        <%elseif Trim(rs("category").value) = "breakfast" then%>       
                            <optgroup label="Breakfast">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "rice" then%>       
                            <optgroup label="Rice">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "drinks" then%>       
                            <optgroup label="Drinks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "dessert" then%>       
                            <optgroup label="Dessert">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "snacks" then%>       
                            <optgroup label="Snacks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "candies" then%>       
                            <optgroup label="Candies">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "groceries" then%>       
                            <optgroup label="Groceries">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                            <optgroup label="Fresh Meat">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>                                    
                            
                        <%elseif Trim(rs("category").value) = "others" then%> 
                        <optgroup label="Others">   
                             <option value="<%=rs("prod_id")%>"> 
                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
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
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>
                        
                        <%elseif Trim(rs("category").value) = "breakfast" then%>       
                            <optgroup label="Breakfast">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "rice" then%>       
                            <optgroup label="Rice">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "drinks" then%>       
                            <optgroup label="Drinks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "dessert" then%>       
                            <optgroup label="Dessert">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "snacks" then%>       
                            <optgroup label="Snacks">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "candies" then%>       
                            <optgroup label="Candies">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "groceries" then%>       
                            <optgroup label="Groceries">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>

                        <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                            <optgroup label="Fresh Meat">    
                                <option value="<%=rs("prod_id")%>"> 
                                    <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
                                </option>
                            </optgroup>                                    
                            
                        <%elseif Trim(rs("category").value) = "others" then%> 
                        <optgroup label="Others">   
                             <option value="<%=rs("prod_id")%>"> 
                                <%="<span>&#8369;</span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Stock: " & rs("qty")%>
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
            <%end if%>
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
                    <th>Action</th>
                </thead>
            
                <tbody>
                    
                    <%	
                        'invoice = CLng(Request.QueryString("invoice_number"))
                        'productID = CLng(Request.QueryString("product_id"))
                        'productQty = CLng(Request.QueryString("prodQty"))
                        Dim totalAmount, totalProfit
                        totalAmount = 0.00
                        totalProfit = 0.00
                  
                        rs.Open "SELECT * FROM "&ordersHolderPath&" WHERE status=""On Process"" and unique_num="&uniqueNum, CN2

                    %>
                        <%if not rs.EOF then
                            hasOrdered = true%>
                            <%do until rs.EOF%>
                                
                                <tr>
                                <td><%=rs("prod_brand")%> </td>
                                <td><%=rs("prod_name")%> </td>
                                <td> <span class="text-primary">&#8369;</span><%=rs("price")%> </td>
                                <td><%=rs("qty")%> </td>
                                <td> <span class="text-primary">&#8369;</span><%=rs("profit")%> </td>
                            <%if userType = "admin" then%>    
                                <!--
                                    <td width="90"><a href="a_order_process_cancel.asp?transact_id=<'%=CLng(rs("id"))%>&salesQty=<'%=productQty%>&product_id=<'%=productID%>&unique_num=<'%=uniqueNum%>&cust_id=<'%=custID%>"><button class="btn btn-sm btn-warning"> Cancel </button></a></td>
                                -->
                                <td width="90">
                                    <button onClick="delete_order(<%=CLng(rs("id"))%>, <%=uniqueNum%>, <%=custID%>)" class="btn btn-sm btn-warning"> Cancel </button>
                                </td>
                            <%else%>    
                                <td width="90"><a href="#" hidden><button class="btn btn-sm btn-outline-dark"> Cancel </button></a></td>
                            <%end if%>
                                </tr>
                            <%totalAmount = totalAmount + CDbl(rs("amount"))
                                totalProfit = totalProfit + CDbl(rs("profit"))
                                rs.MoveNext
                            loop%>
                        
                                <tr>
                                    <td colspan="6"><h1 class="lead"><strong>Total Amount</h1></strong> <h4> <span class="text-primary">&#8369;</span> <%=totalAmount%></h4> </td>
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
                <!-- MODAL BUTTONS -->
                <!--<button type="button" class="btn btn-primary btn-block mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#payCashModal">
                Pay Cash
                </button> -->
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
                <!--<button type="button" class="btn btn-danger btn-block btn-sm text-white mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#confirmDayEnd">
                Day End
                </button> -->
                <!-- END OF MODAL BUTTONS -->

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
                                <form action="customer_pay2.asp" method="POST">
                                    <input type="number" name="custID" id="custID" value="<%=custID%>" hidden>
                                    <input type="number" name="uniqueNum" id="uniqueNum" value="<%=uniqueNum%>" hidden>
                                    <input type="text" name="userType" class="userType" value="<%=userType%>" hidden>
                                     <input type="text" name="userEmail" class="userEmail" value="" hidden>
                                    <div class="form-group mb-3">    
                                        <label class="ml-1" style="font-weight: 500"> Reference No. </label>
                                        <input type="text" style="color: #f6ab6c; font-weight: 600;" pattern="[0-9]{9}" class="form-control" name="referenceNo" id="referenceNo" value="<%=maxRefNo%>" min="1" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="ml-1" style="font-weight: 500"> Cash Payment </label>
                                        <div class="input-group mb-3">
                                            <div class="input-group-prepend">
                                                <span class="input-group-text bg-success text-light">&#8369;</span>
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
                                        <button type="submit" class="btn btn-success">Proceed</button>
                                    </div>
                                </form>  
                        </div>
                    </div>
                </div>
            <!-- END OF PAY CASH MODAL -->    

            <!-- CREDIT PAY MODAL -->
                <div class="modal fade" id="oweCashModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <form action="customer_order_credit_c.asp" method="POST">
                            <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Pay In Credit</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <input type="number" name="unique_num" value="<%=uniqueNum%>" hidden>
                                <input type="number" name="cust_id" value="<%=custID%>" hidden>
                                <input type="number" name="totalProfit" value="<%=totalProfit%>" hidden>
                                <input type="number" name="totalAmount" value="<%=totalAmount%>" hidden>
                                <input type="text" name="customerType" value="<%=customerType%>" hidden>
                                <input type="text" name="userType" class="userType" value="<%=userType%>" hidden>
                                <input type="text" name="userEmail" class="userEmail" value="" hidden>
                                <input type="text" name="isClosed" value="yes" hidden>
                                <!--
                                <p>Are you sure to process your order?</p>
                                -->
                                <div class="form-group mb-3">    
                                    <label class="ml-1" style="font-weight: 500"> Reference No. </label>
                                    <input type="text" style="color: #f6ab6c; font-weight: 600;" class="form-control" name="arReferenceNo" id="arReferenceNo" value="<%=maxArRefNo%>" pattern="[0-9]{9}" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-dark" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-success">Proceed</button>
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

<script src="js/main.js"></script> 
<script src="./jquery/jquery_uncompressed.js"></script>
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>
<script src="tail.select-full.min.js"></script>

<script>

    const cashierType = localStorage.getItem('type');
    const cashierEmail = localStorage.getItem('email');
    document.querySelector('.userEmail').value = cashierEmail;

    tail.select("#select1", {
        search: true,
        deselect: true,
        descriptions: true
    });

    tail.select("#products", {
        search: true,
        deselect: true,    
    });

    function delete_order(transactID , uniqueNum, custID) {

        if(confirm('Are you sure that you want to cancel this order?'))
        {
            window.location.href=`customer_order_process_cancel.asp?transact_id=${transactID}&unique_num=${uniqueNum}&cust_id=${custID}&userType=${cashierType}`;
            //window.location.href='delete.asp?delete_id='+id;
        }

    }


</script> 

</body>
</html>   
