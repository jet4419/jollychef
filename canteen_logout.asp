
<script src="./jquery/jquery_uncompressed.js"></script>
<script>

    const tokenID = localStorage.getItem('tokenid')

    $.ajax({

        url: "logout_staff.asp",
        type: "POST",
        data: {tokenID: tokenID},
        success: function(data) {
            
            //console.log(data)
            if (data==='logout success') {
                localStorage.clear();
                alert('You successfully logged out');
                window.location.href='canteen_login.asp';
            } else {
                alert('Error on logging out');
                localStorage.clear();
            }

        }
    })

    // localStorage.clear();
    // alert('You successfully logged out');
    // window.location.href='canteen_login.asp';

</script>