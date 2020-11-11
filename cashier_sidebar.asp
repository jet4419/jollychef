<div id="mySidebar" class="sidebar" onmouseover="toggleSidebar()" onmouseout="toggleSidebar()">
    <a href="products.asp" class="main-menus--items"><i class="fab fa-product-hunt sidebar-icons"></i> <span class="icon-text">Products</span></a>
    <a href="cashier_order_page.asp" class="main-menus--items"><i class="fas fa-dollar-sign sidebar-icons dollar-sign"></i> <span class="icon-text">Order</span></a>
    <a href="customers_order.asp" class="main-menus--items"><i class="fa fa-shopping-cart sidebar-icons cart-icon"></i> <span class="icon-text">Cart</span></a>

        <input class="checkbox" type="checkbox" id="reports">
        <label class="sidebar-label" for="reports" id="reports-container">
            <a class="main-menus--items reports-container"><i class="fas fa-chart-bar sidebar-icons"></i> <span class="icon-text">Reports</span> <i id="arrow-down" class="fas fa-chevron-circle-down" style="visibility: hidden;"></i></a>
        </label>
        <!--<a class="main-menus--items"><i class="fas fa-chart-bar"></i> Reports</a> -->
        <div class="checked-items">
            <!--<a href="bootTopSeller.asp">Top Selling Products</a>-->
            <a href="inventory_reports.asp">Inventory Reports</a>
            <a href="sales_report.asp">Sales Reports</a>
            <!--<a href="bootOrdersReport.asp">Orders Reports</a>-->
            <a href="sales_report_daily.asp">Daily Reports</a>
            <a href="collections_report.asp">Collections Reports</a>
            <a href="ob_reports.asp">OB Reports</a>
            <a href="adjustments_report.asp">Adjustments Report</a>
            <a href="ar_reports.asp">AR Reports</a>
        </div>
    
    <!--<a href="t_ob_main.asp" class="main-menus--items"><i class="fas fa-layer-group sidebar-icons"></i> <span class="icon-text">Receivables</span></a>-->
    <input class="checkbox-receivables" type="checkbox" id="reports2">
        <label class="sidebar-label" for="reports2" id="reports-container2">    
            <a class="main-menus--items"><i class="fas fa-layer-group sidebar-icons"></i> <span class="icon-text">Receivables</span></a>
        </label>
        <div class="checked-items--receivables">
            <a href="ob_main.asp">Credit Payment</a>
            <a href="adjustments_main.asp">Adjustments</a>
        </div>

    <a href="customers_list.asp" class="main-menus--items customers-icon"><i class="fas fa-users sidebar-icons"></i> <span class="icon-text">Customers</span></a>
    <!--
    <input class="checkbox-receivables" type="checkbox" id="reports2">
        <label class="sidebar-label" for="reports2" id="reports-container2">    
            <a class="main-menus--items"><i class="fas fa-layer-group sidebar-icons"></i> <span class="icon-text">Receivables</span></a>
        </label>
        <div class="checked-items--receivables">
            <a href="bootAccountsReceivables.asp">Receivables</a>
            <a href="t_ob_main.asp">OB Royce</a>
            <a href="t_ob_others.asp">OB Other Customer</a>
            <a href="t_monthly_reports.asp">Monthly Reports Royce</a>
        </div>
    -->  
    <%if Session("type") <> "" or Session("type") <> "" then %>      
        <%if ASC(Session("type")) = ASC("admin") or ASC(Session("type")) = ASC("programmer") then%>
            <a href="customer_registration.asp" class="main-menus--items customers-icon"><i class="fas fa-user-plus sidebar-icons"></i> <span class="icon-text">Add Customer</span></a>
        <%end if%>
    <%end if%>
    
            <!--
            <a href="t_ob_others.asp">OB Other Customer</a>
            <a href="t_monthly_reports.asp">Monthly Reports Royce</a>
        </div>

    <input class="checkbox-customers" type="checkbox" id="reports3">
        <label class="sidebar-label" for="reports3" id="reports-container3">
            <a class="main-menus--items customers-icon"><i class="fas fa-users sidebar-icons"></i> <span class="icon-text">Customers</span></a>
        </label>
        <div class="checked-items--customers">
            <a href="a_customers_list.asp">Royce Customers</a>
    -->        
            <!--
            <a href="a_customers_others.asp">Other Customers</a>
            
            
        </div>-->
        <%'if ASC(Session("type")) = ASC("admin") then%>
    <!--
    <input class="checkbox-add-customer" type="checkbox" id="add-customer">
        <label class="sidebar-label" for="add-customer" >
            <a class="main-menus--items customers-icon"><i class="fas fa-user-plus sidebar-icons"></i> <span class="icon-text">Add Customer</span></a>
        </label>

        
        <div class="checked--add-customers">
            <a href="a_register_customer.asp">Royce Customer</a>
            
            <a href="a_register_other_cust.asp">Other Customer</a>
            
        </div> 
        -->   
        <%'end if%>
</div>