<!--#include file="dbConnect.asp"-->

<link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
<style>

    .navbar-date {
        /* margin-right: 40px; */
        margin-right: 13px;
        font-size: .90rem;
        color: #fff;
        font-weight: 600;
    }

    .fas.fa-calendar-check {
        font-size: 1.5rem;
        padding-right: 10px;
        /* color: #f4ea8e; */
        color: #a3deb1;
    }

    .brand-name {
        color: #fff;
        font-family: 'Merienda', "Lucida Sans Unicode", "Lucida Grande", sans-serif;
    }

    .brand-name a {
        text-decoration: none;
        color: #fff;
    }

    .jollychef-text {
        /* color: #f4ea8e; */
        /* color: #fff490; */
        padding-left: 2rem;
        color: #a3deb1;
    }

    .navbar--user-info {
        color: #fff;
        /* font-family: Helvetica; */
        padding-top: 5px;
    }

    .user-profile-pic {
        color: #fff;   
    }

    i.fas.fa-user {
        background-color: #000;
    }

    .menu-icon-bar {
        margin-top: 20px;
    }

    .line {
        height: 2px;
        width: 25px;
        background-color: #fff;
        margin-bottom: 6px;
    }

    .line-1,
    .line-3 {
        width: 18px;
        transition: all .5s;
    }

    .menu-icon-bar:hover .line-1,
    .menu-icon-bar:hover .line-3 {
        width: 25px;
    }

    .brand-name {
        height: 100%;
        margin-left: .8rem;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .user-logout-container {
        width: auto;
        display: flex;
        justify-content: space-between;
    }

    .cust-link, .staff-link {
        display: inline-block;
        margin-right: .8rem;
    }

    /* .dataTables_paginate paging_simple_numbers {
        background: #28a745 !important;
        color: #28a745 !important;
    } */

</style>

<nav class="navigation  d-flex justify-content-between">

        <div class="menu-1">

            <div class="brand-name">
                <label for="btn-collapsible-bar" id="btn-collapsible-bar">
                    <div class="menu-icon-bar" id="burger-btn">
                        <div class="line line-1"></div>
                        <div class="line line-2"></div>
                        <div class="line line-3"></div> 
                    </div>
                </label>  
                <a href="default.asp"><span class="jollychef-text">JollyChef </span>
                Inc.</a>
            </div>
            
        </div>

        <div class="user-info">
            
            <div class='navbar-date'> 
                <i class='fas fa-calendar-check'></i><%=FormatDateTime(systemDate, 1)%>
            </div>
       
        </div>

        <div class="user-logout-container"></div>
        
</nav>

<script>

    const userInfo = document.querySelector('.user-logout-container');

    if (localStorage.getItem('cust_id')) {
        
        const userFname = localStorage.getItem('fname');
        const userType = 'Customer';

        const userProfile = document.createElement('div');
        userProfile.className = 'user-profile-pic';

        const userIcon = document.createElement('i');
        userIcon.className = 'fas fa-user';

        userProfile.appendChild(userIcon);

        const pElement = document.createElement('p');
        pElement.className = 'navbar--user-info';
        pElement.textContent = userFname + ' - ' + userType;

        const btnSignOut = document.createElement('button');
        btnSignOut.className = 'user-logout-btn btn btn-sm';
        btnSignOut.setAttribute('data-toggle', 'modal');
        btnSignOut.setAttribute('data-target', '#logout');

        const btnSignOutIcon = document.createElement('i');
        btnSignOutIcon.className = 'fas fa-sign-out-alt';

        btnSignOut.appendChild(btnSignOutIcon);

        pElement.appendChild(btnSignOut);

        userInfo.appendChild(userProfile);
        userInfo.appendChild(pElement);

    } else {

        const customerLink = document.createElement('a');
        customerLink.style.fontFamily = 'Segoe UI', 'Roboto', 'sans-serif';
        customerLink.setAttribute('href', 'cust_login.asp');
        customerLink.className = 'cust-link';

        const customerBtn = document.createElement('button');
        customerBtn.className = 'btn btn-sm btn-success';
        customerBtn.textContent = 'Customer';
        customerBtn.style.letterSpacing = '.09em';

        customerLink.appendChild(customerBtn);
        userInfo.appendChild(customerLink);

        const staffLink = document.createElement('a');
        staffLink.style.fontFamily = 'Segoe UI', 'Roboto', 'sans-serif';
        staffLink.setAttribute('href', 'canteen_login.asp');
        staffLink.className = 'staff-link';

        const staffBtn = document.createElement('button');
        staffBtn.className = 'btn btn-sm btn-success';
        staffBtn.textContent = 'Staff';
        staffBtn.style.letterSpacing = '.09em';

        staffLink.appendChild(staffBtn);
        userInfo.appendChild(staffLink);

    }
    

</script>