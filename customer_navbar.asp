<link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
<style>

    .navbar-date {
        margin-right: 40px;
        font-size: .90rem;
        color: #fff;
        font-weight: 600;
    }

    .fas.fa-calendar-check {
        font-size: 1.5rem;
        padding-right: 10px;
        color: #f4ea8e;
    }

    .brand-name {
        color: #fff;
        font-family: 'Merienda', 'Brush Script MT', cursive;
    }

    .brand-name a {
        text-decoration: none;
        color: #fff;
    }

    .jollychef-text {
        /* color: #f4ea8e; */
        color: #fff490;
    }

    .navbar--user-info {
        color: #fff;
        font-family: Helvetica;
        padding-top: 5px;
    }

    /* .dataTables_paginate paging_simple_numbers {
        background: #28a745 !important;
        color: #28a745 !important;
    } */

</style>

<nav class="navigation">

        <div class="menu-1">

            <input type="checkbox" class="checkbox" id="btn-collapsible-bar" hidden>
            <label for="btn-collapsible-bar" hidden>
                <div class="menu-icon-bar" id="burger-btn">
                    <div class="line line-1"></div>
                    <div class="line line-2"></div>
                    <div class="line line-3"></div> 
                </div>
            </label>  
            <div class="brand-name">
                <a href="default.asp"><span class="jollychef-text">JollyChef </span></a>
                Inc.
            </div>

            
        </div>
        <%
            systemDate = CDate(Application("date"))
        %>

        <div class="user-info">
            
            <div class='navbar-date'> 
                <i class='fas fa-calendar-check'></i><%=FormatDateTime(systemDate, 1)%>
            </div>
       
        </div>

        
</nav>

<script>

    const userInfo = document.querySelector('.user-info');

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

        const btnLogin = document.createElement('button');
        btnLogin.className = 'btn btn-sm btn-success';
        btnLogin.setAttribute('data-toggle', 'modal'); 
        btnLogin.setAttribute('data-target', '#login'); 
        btnLogin.textContent = 'Login';

        userInfo.appendChild(btnLogin);

    }
    

</script>