

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
        font-family: Helvetica;
        padding-top: 5px;
    }

    .hidden {
        display: none;
    }

    .user-profile-pic {
        color: #fff;
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

</style>


<nav class="navigation d-flex justify-content-between">

    <div class="menu-1">

        <div class="brand-name">
            <label for="btn-collapsible-bar" id="btn-collapsible-bar">
                <div class="menu-icon-bar" id="burger-btn">
                    <div class="line line-1"></div>
                    <div class="line line-2"></div>
                    <div class="line line-3"></div> 
                </div>
            </label>  
            <a href="canteen_homepage.asp"><span class="jollychef-text">JollyChef</span> Inc.</a>
        </div>
        
    </div>
        <%
            Dim cutoff
            
            if (Month(systemDate) <> Month(systemDate + 1)) then
                cutoff = "<div><button class='btn-end-date btn btn-sm btn-outline-success float-right' onClick='monthEnd()'>Month End</button></div>"

            else
                cutoff = "<div><button class='btn-end-date btn btn-sm btn-outline-success ' data-toggle='modal' data-target='#confirmDayEnd'>Day End</button></div>"
            end if
        %>

    <div class="user-info">

        <div class='navbar-date'> 
            <i class='fas fa-calendar-check'></i><%=FormatDateTime(systemDate, 1)%>
        </div>
        <span class='btn-cutoff'>
            <%Response.Write(cutoff)%>
        </span>

    </div>

    <div class="user-logout-container"></div>

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
                    <button type="submit" class="btn btn-primary">Yes</button>
                    <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- End of Confirm Day End -->

<script>

    const userInfo = document.querySelector('.user-logout-container');
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