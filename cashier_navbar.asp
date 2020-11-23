

<link href="https://fonts.googleapis.com/css2?family=Merienda:wght@400;700&display=swap" rel="stylesheet">
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
<!-- Bootstrap JS -->
<script src="./bootstrap/js/bootstrap.min.js"></script>

<style>

    button.btn-end-date {
        font-weight: 600;
    }

    .nav {
        font-family: Verdana, Geneva, sans-serif;
    }

    .navbar-date {
        margin-right: 13px;
        font-size: .90rem;
        font-weight: 600;
        color: #fff;
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

    .hidden {
        display: none;
    }

</style>


<nav class="navigation d-flex justify-content-between">

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
                <a href="canteen_homepage.asp"><span class="jollychef-text">JollyChef</span> Inc.</a>
            </div>
            
        </div>
        <%
            Dim cutoff
            
            if (Month(systemDate) <> Month(systemDate + 1)) then
                cutoff = "<div class='mr-5 pr-5' ><button class='btn-end-date btn btn-sm btn-danger float-right' onClick='monthEnd()'>Month End</button></div>"

            else
                cutoff = "<div class='mr-5 pr-5' ><button class='btn-end-date btn btn-sm btn-danger' data-toggle='modal' data-target='#confirmDayEnd'>Day End</button></div>"
            end if
        %>

        <div class="user-info">

            <div class='navbar-date'> 
                <i class='fas fa-calendar-check'></i><%=FormatDateTime(systemDate, 1)%>
            </div>
            <span class='btn-cutoff'>
             <%Response.Write(cutoff)%>
            </span>
            <%
                ' if Session("name")<>"" then
                '     Response.Write("<button class='btn btn-sm btn-success' data-toggle='modal' data-target='#login' hidden>Login</button>")

                '     if ASC(Session("type")) <> ASC("admin") then

                '         if ASC(Session("type")) = ASC("programmer") then
                            
                '             Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                '             Response.Write(cutoff)
                '             Response.Write("<div class='user-profile-pic'><i class='fas fa-user'></i></div><p class='navbar--user-info'>"&Session("name")&" - Programmer <button class='user-logout-btn btn btn-sm' data-toggle='modal' data-target='#logout'><i class='fas fa-sign-out-alt'></i></button></p> ")

                '         else
                '             'Response.Write("<div class='mr-5'><button class='btn btn-sm btn-danger'>Day End</button></div>")
                '             Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                '             Response.Write(cutoff)
                '             Response.Write("<div class='user-profile-pic'><i class='fas fa-user'></i></div><p class='navbar--user-info'>"&Session("name")&" - Cashier <button class='user-logout-btn btn btn-sm' data-toggle='modal' data-target='#logout'><i class='fas fa-sign-out-alt'></i></button></p> ")

                '         end if

                '     else
                '         'Response.Write("<div class='mr-5'><button class='btn btn-sm btn-danger'>Day End</button></div>")
                '         Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                '         Response.Write(cutoff)
                '         Response.Write("<div class='user-profile-pic'><i class='fas fa-user'></i></div><p class='navbar--user-info'>"&Session("name")&" - Admin <button class='user-logout-btn btn btn-sm' data-toggle='modal' data-target='#logout'><i class='fas fa-sign-out-alt'></i></button></p> ")
                '         ' Response.Write(" <a href='logout.asp' class='user-logout'>Logout</a>")
                '     end if
                ' else
                '     Response.Write("<div class='navbar-date'> <i class='fas fa-calendar-check'></i>"&FormatDateTime(systemDate, 1)&"</div>")
                '     Response.Write("<button class='btn btn-sm btn-success' data-toggle='modal' data-target='#login'>Login</button>")
                ' end if                    
            %>
       
        </div>

        
</nav>

<!-- Confirm Day End -->
        <div id="confirmDayEnd" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <form action="store_closed.asp" method="POST">
                    <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmation</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="text" name="isClosed" value="yes" hidden>
                        <p>Are you sure to end this day?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Yes</button>
                        <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                    </div>
                    </div>
                </form>
            </div>
        </div>
    <!-- End of Confirm Day End -->

<script>

    const userInfo = document.querySelector('.user-info');
    const btnCutoff = document.querySelector('.btn-cutoff');
    btnCutoff.classList.add('hidden');

    if (localStorage.getItem('type')) {
        
        const userFname = localStorage.getItem('name');
        let userType = localStorage.getItem('type');
        userType = userType.charAt(0).toUpperCase() + userType.slice(1);

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

        btnCutoff.classList.remove('hidden');

    } else {

        const btnLogin = document.createElement('button');
        btnLogin.className = 'btn btn-sm btn-success';
        btnLogin.setAttribute('data-toggle', 'modal'); 
        btnLogin.setAttribute('data-target', '#login'); 
        btnLogin.textContent = 'Login';

        userInfo.appendChild(btnLogin);

    }

    function monthEnd() {

        //alert("Are you sure to cutoff?")
        if(confirm('Are you sure to month end on this date?'))
        {
            window.location.href='a_ob_month_end.asp';
            //window.location.href='delete.asp?delete_id='+id;
        }

    }

</script>