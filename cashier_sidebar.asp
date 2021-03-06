<div id="mySidebar" class="sidebar">
    <a href="products.asp" class="main-menus--items">
        <span class="icon-container">
            <i class="fab fa-product-hunt sidebar-icons fa-fw"></i> 
        </span><span class="icon-text">Products</span>
    </a>

    <a href="cashier_order_page.asp" class="main-menus--items">
        <span class="icon-container">
            <i class="fas fa-dollar-sign sidebar-icons dollar-sign fa-fw"></i> 
        </span><span class="icon-text">Order</span>
    </a>

    <a href="customers_order.asp" class="main-menus--items">
        <span class="icon-container">
            <i class="fa fa-shopping-cart sidebar-icons cart-icon fa-fw"></i> 
        </span><span class="icon-text">Cart</span>
    </a>

    <a href="customers_edited_orders.asp" class="main-menus--items">
        <span class="icon-container">
            <i class="fas fa-history sidebar-icons"></i> 
        </span><span class="icon-text">Edited Orders</span>
    </a>

        <input class="checkbox" type="checkbox" id="reports">
        <label class="sidebar-label" for="reports" id="reports-container">
            <a class="main-menus--items reports-container">
                <span class="icon-container">
                    <i class="fas fa-chart-bar sidebar-icons fa-fw"></i>
                </span><span class="icon-text">Reports</span> <i id="arrow-down" class="fas fa-chevron-circle-down fa-fw" style="visibility: hidden;"></i>
            </a>
        </label>
        <!--<a class="main-menus--items"><i class="fas fa-chart-bar"></i> Reports</a> -->
        <div class="checked-items">
            <!--<a href="bootTopSeller.asp">Top Selling Products</a>-->
            <!--<a href="inventory_reports.asp">Inventory Reports</a>-->
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
            <a class="main-menus--items">
                <span class="icon-container">
                    <i class="fas fa-layer-group sidebar-icons fa-fw"></i>
                </span><span class="icon-text">Receivables</span>
            </a>
        </label>
        <div class="checked-items--receivables">
            <a href="schedule_receivables.asp">Schedule of Receivables</a>
            <a href="ob_main.asp">Credit Payment</a>
            <a href="adjustments_main.asp">Adjustments</a>
        </div>

    <!--
    <a href="customers_list.asp" class="main-menus--items customers-icon"><i class="fas fa-users sidebar-icons"></i> <span class="icon-text">Customers</span></a>
    -->
   

</div>

<script>

    const sidebar = document.getElementById('mySidebar');

    const addCustomerList = document.createElement('a');

    if (localStorage.getItem('type') === 'programmer') {
        addCustomerList.setAttribute('href', 'customers_list_prog.asp');
    } else {
        addCustomerList.setAttribute('href', 'customers_list.asp');
    }
    
    addCustomerList.className = 'main-menus--items customers-icon';

    const iconCustomerContainer = document.createElement('span');
    iconCustomerContainer.className = 'icon-container';

    const iconCustomerList = document.createElement('i');
    iconCustomerList.className = 'fas fa-users sidebar-icons fa-fw';

    const iconTextCustomerList = document.createElement('span');
    iconTextCustomerList.textContent = 'Customers';
    iconTextCustomerList.className = 'icon-text';

    iconCustomerContainer.appendChild(iconCustomerList);
    addCustomerList.appendChild(iconCustomerContainer);
    addCustomerList.appendChild(iconTextCustomerList); 

    sidebar.appendChild(addCustomerList);

    

    if (localStorage.getItem('type') === 'admin' || localStorage.getItem('type') === 'programmer') {

        const addCustomerLink = document.createElement('a');
        addCustomerLink.setAttribute('href', 'customer_registration.asp');
        addCustomerLink.className = 'main-menus--items customers-icon';

        const iconAddCustContainer = document.createElement('span');
        iconAddCustContainer.className = 'icon-container';

        const icon = document.createElement('i');
        icon.className = 'fas fa-user-plus sidebar-icons fa-fw';

        const iconText = document.createElement('span');
        iconText.textContent = 'Add Customer';
        iconText.className = 'icon-text';

        iconAddCustContainer.appendChild(icon);
        addCustomerLink.appendChild(iconAddCustContainer);
        addCustomerLink.appendChild(iconText); 

        sidebar.appendChild(addCustomerLink);

    }

</script>