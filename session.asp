<%
    ' Session.Timeout=60

    ' if Session("cust_id") = "" then

    '     Response.Write("<script language=""javascript"">")
	' 	Response.Write("alert('Your session timed out!')")
	' 	Response.Write("</script>")
    '     isActive = false
 
    '         if isValidQty=false then
    '             Response.Write("<script language=""javascript"">")
    '             Response.Write("window.location.href=""cust_login.asp"";")
    '             Response.Write("</script>")
    '         end if

    ' end if

%>    
<script src="./jquery/jquery_uncompressed.js"></script>
<script>

    const userID = localStorage.getItem('cust_id');
    const fname = localStorage.getItem('fname');
    const lname = localStorage.getItem('lname');
    const email = localStorage.getItem('email'); 
    const custDept = localStorage.getItem('department')
    const tokenID = localStorage.getItem('tokenid')

    if (!tokenID) {
        window.location.href='cust_login.asp';
    } else {
        $.ajax({

            url: "auth_customer.asp",
            type: "POST",
            data: {userID: userID, fname: fname, lname: lname, email: email, custDept: custDept, tokenID: tokenID},
            success: function(data) {
                
                if (data==='access denied') {
                    localStorage.clear();
                    window.location.href='cust_login.asp';
                } 

            }
        })
    }


</script>