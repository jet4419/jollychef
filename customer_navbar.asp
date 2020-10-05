<link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
<style>

    .navbar-date {
        margin-right: 40px;
        font-size: .90rem;
        color: #ccc;
    }

    .fas.fa-calendar-check {
        font-size: 1.5rem;
        padding-right: 10px;
        color: #f4ea8e;
    }

    .brand-name {
        color: #fff;
        font-family: 'Merienda', cursive;
    }

    .brand-name a {
        text-decoration: none;
        color: #fff;
    }

    .jollychef-text {
        color: #f4ea8e;
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
            
            <%
                if Session("fname")<>"" or Session("name")<>"" then
                    Response.Write("<button class='btn btn-sm btn-success' data-toggle='modal' data-target='#login' hidden>Login</button>")
                    if Session("type") = "" then
                    Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                    Response.Write("<div class='user-profile-pic'><i class='fas fa-user'></i></div><p class='navbar--user-info'>"&Session("fname")&" - "&"Customer"&" <button class='user-logout-btn btn btn-sm' data-toggle='modal' data-target='#logout'><i class='fas fa-sign-out-alt'></i></button></p> ")
                    else
                    Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                    Response.Write("<div class='user-profile-pic'><i class='fas fa-user'></i></div><p class='navbar--user-info'>"&Session("fname")&" - "&Session("type")&" <a class='user-logout-btn'><i class='fas fa-sign-out-alt'></i></a></p> ")
                    ' Response.Write(" <a href='logout.asp' class='user-logout'>Logout</a>")
                    end if
                else
                    Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                    Response.Write("<button class='btn btn-sm btn-success' data-toggle='modal' data-target='#login'>Login</button>")
                end if                    
            %>
       
        </div>

        
</nav>