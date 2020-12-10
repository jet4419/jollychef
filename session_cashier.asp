<%
    ' Session.Timeout= 240
    ' if Session("name") = "" then

    '     Response.Write("<script language=""javascript"">")
	' 	Response.Write("alert('Your session timed out!')")
	' 	Response.Write("</script>")
    '     isActive = false
 
    '         if isValidQty=false then
    '             Response.Write("<script language=""javascript"">")
    '             Response.Write("window.location.href=""canteen_login.asp"";")
    '             Response.Write("</script>")
    '         end if

    ' end if

%>    
<script src="./jquery/jquery_uncompressed.js"></script>
<script>

    const userID = localStorage.getItem('id')
    const name = localStorage.getItem('name')
    const fullname = localStorage.getItem('fullname')
    const email = localStorage.getItem('email')
    const type = localStorage.getItem('type')
    const tokenID = localStorage.getItem('tokenid')

    if (!tokenID) {
        
        window.location.href='canteen_login.asp';

    } else {
        
        $.ajax({

            url: "auth_staff.asp",
            type: "POST",
            data: {userID: userID, name: name, fullname: fullname, email: email, type: type, tokenID: tokenID},
            success: function(data) {
                
                if (data==='access denied') {
                    localStorage.clear();
                    window.location.href='canteen_login.asp';
                } 

            }
        })
    }

    

</script>
