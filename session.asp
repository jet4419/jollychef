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

<script>

    if (!localStorage.getItem('cust_id')) {

        alert('Your session timed out!');
        window.location.href='cust_login.asp';
    }


</script>