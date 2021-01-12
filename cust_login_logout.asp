<!-- Login -->
<div id="login" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <form id="login-form">
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
                        <input type="email" class="form-control" name="email" id="email" placeholder="Email" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" name="password" id="loginPassword" placeholder="Password" required>
                        <p class="wrong-password-text" style="padding-top: 10px; color: red; font-size: 11px; text-align: center;"></p>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-center">
                    <button type="submit" class="btn-main btn btn-sm btn-info" name="btn-login" value="login" >Login</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- End of Login -->

<!-- User Settings -->
    <div id="logout" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Settings</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body d-flex flex-column ">
                        <a href="reset_pass.asp"><button class="btn btn-sm btn-dark mb-4 w-100">Change Password</button></a>
                        <button id="btnLogout" class="btn btn-sm btn-dark w-100" data-toggle="modal"  data-target="#user-logout">Logout</button>
                    </div>
                    <div class="modal-footer">

                    </div>
                </div>
        </div>
    </div>  
<!-- End of User Settings -->

<!-- Logout -->
    <div id="user-logout" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm" role="document">
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
                    <div class="modal-footer d-flex justify-content-center">
                        <button type="submit" class="btn btn-primary">Yes</button>
                        <button type="button" class="btn btn-dark" data-dismiss="modal">No</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
<!-- End of Logout -->

<script>

    document.getElementById('btnLogout').addEventListener('click', () => {
        
        $("#logout").modal("hide");

        $("#user-logout").modal("show");
    });

</script>