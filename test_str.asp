<%

myDate = CDate("1/10/2021")
myYear = Year(myDate)
myMonth = MonthName(Month(myDate))
myDay = Day(myDate)

' Response.Write Mid(d1, 3)
Response.Write "Date: " & myMonth & " " & myDay & ", " & myYear


%>

<form class="form-group form-inline mainForm">
    <select id="products" class="form-control mr-2" name="productID" style="width:650px; " class="chzn-select" required placeholder="Select Product">

    <% 
        rs.open "SELECT daily_meals.prod_id, daily_meals.prod_name, daily_meals.prod_price, daily_meals.qty - (IIF(ISNULL(orders_holder.qty), 0, SUM(orders_holder.qty))) AS qty, daily_meals.category, orders_holder.id FROM daily_meals LEFT JOIN "&ordersHolderPath&" ON daily_meals.prod_id = orders_holder.prod_id AND (orders_holder.status = 'Pending' OR orders_holder.status = 'On Process') GROUP BY daily_meals.prod_id ORDER BY daily_meals.prod_brand, daily_meals.prod_name", CN2

        if not rs.EOF then%>

            <option value="" disabled selected>Select a product</option>

            <%do until rs.EOF 

                dbQty = CInt(rs("qty"))

                if dbQty < 0 then
                    dbQty = 0
                end if

                if Trim(rs("category").value) = "lunch" or  Trim(rs("category").value) = "meat" or Trim(rs("category").value) = "vegetable" or Trim(rs("category").value) = "fish" or Trim(rs("category").value) = "chicken" then%>

                <optgroup label="Lunch">
                    <option value="<%=rs("prod_id")%>"> 
                        <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                    </option>   
                </optgroup>

                <%elseif Trim(rs("category").value) = "breakfast" then%>       
                    <optgroup label="Breakfast">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "rice" then%>       
                    <optgroup label="Rice">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "drinks" then%>       
                    <optgroup label="Drinks">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "dessert" then%>       
                    <optgroup label="Dessert">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "snacks" then%>       
                    <optgroup label="Snacks">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "candies" then%>       
                    <optgroup label="Candies">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "groceries" then%>       
                    <optgroup label="Groceries">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "fresh-meat" then%>       
                    <optgroup label="Fresh Meat">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
                        </option>
                    </optgroup>

                <%elseif Trim(rs("category").value) = "others" then%>       
                    <optgroup label="Others">    
                        <option value="<%=rs("prod_id")%>"> 
                            <%="<span>&#8369; </span>" & rs("prod_price") & " / " & rs("prod_name") & "/ Qty Left: " & dbQty%>
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
    <button name="btnAdd" value="btnAddDetails" class="btn btnAdd btn-success" min="1" max="100" >Add</button>
</form>