<!--#include file="dbConnect.asp"-->
<!--#include file="session.asp"-->

<%
    
    ' if Session("type") <> "" then

    '     Response.Redirect("canteen_homepage.asp")

    ' end if

    ' Session.Timeout=60

    ' if Session("cust_id") = "" then

    '     Response.Write("<script language=""javascript"">")
	' 	Response.Write("alert('Your session timed out!')")
	' 	Response.Write("</script>")
    '     isActive = false
 
    '         if isValidQty=false then
    '             Response.Write("<script language=""javascript"">")
    '             Response.Write("window.location.href=""cust_login.asp"";")
    '             Response.Write("</script>")
    '         end if

    ' end if

%>
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
    'currDate = CDate(Date)

    if not objAccess.EOF then
        schedID = CInt(objAccess("sched_id"))
        isStoreClosed = CStr(objAccess("status"))
        dateClosed = CDate(FormatDateTime(objAccess("date_time"), 2))
        'currDate = CDate(Date)
    else
        isStoreClosed = "open"
        dateClosed = CDate(Date)
        'currDate = CDate(Date)
    end if

    set objAccess = nothing

    if dateClosed < systemDate then
        sqlUpdate = "UPDATE store_schedule SET status='closed' WHERE sched_id="&schedID
        cnroot.execute(sqlUpdate)
    end if
%>

<%if systemDate >= dateClosed then%>

    <%if ASC(isStoreClosed) <> ASC("closed") then%>

<!--#include file="customer_navbar.asp"-->
<!--#include file="customer_sidebar.asp"-->

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
            ' productID = CInt(Request.QueryString("productID"))
            ' productQty = CInt(Request.QueryString("prodQty"))
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
            <form class="form-group form-inline mainForm">
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
            'Response.Write(systemDate)
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
                <button name="btnAdd" value="btnAddDetails" class="btn btnAdd btn-success" min="1" max="100" >Add</button>
            </form>
            <!-- END OF ORDER FORM -->

            <%'Response.Write(Session("cust_id"))%>
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

                <button type="button" class="btn btnPayment btn-success btn-block text-white mx-auto mb-2" style="max-width: 300px;" data-toggle="modal" data-target="#paymentMethodModal">
                Process Order
                </button> 
  
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
                                <button type="submit" class="btn btn-success">Yes</button>
                                <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                            </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- END OF Payment Method MODAL -->

            </div>
    </div>
    
    <footer class="footer">
        <p> <span class="copyright"> All rights reserved &copy </span> <script>document.write(new Date().getFullYear())</script> </p>
        <p>Feel free to contact me via email at:<span class="email">curiosojet@gmail.com</span></p>

        <div class="footer__social-media">
            <a href="https://twitter.com/devjet04" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://www.facebook.com/DevJet04" target="_blank"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>

        </div>
    </footer>
            
    <%else%>   
        <body class="closed">     
        <%if currDate = dateClosed then%>
            <p class='center cursive'>Sorry :( , We're CLOSED</p>
        <%else
            if Session("cust_id") <> "" then%>
                <a href="default.asp"> 
                    <i class="fas fa-home home-link"></i> 
                </a>
                
                <p class='center cursive'>Sorry :( , We're CLOSED</p>

            <%else%>
                <p class='center cursive'>Sorry :( , We're CLOSED</p>
            <%end if%>
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
            
            $.ajax({
                url: URL,
                type: 'POST',
                data: {custID: custID, prodID: prodID, prodQty: prodQty},
                //data: {},
            })
            .done(function(data) { 
                //console.log(custID, prodID, prodQty);
                location.reload();
            })
            .fail(function() {
                console.log("error");
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
            console.log(data)
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
