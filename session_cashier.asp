<%
    Session.Timeout= 240
    if Session("name") = "" then

        Response.Write("<script language=""javascript"">")
		Response.Write("alert('Your session timed out!')")
		Response.Write("</script>")
        isActive = false
 
            if isValidQty=false then
                Response.Write("<script language=""javascript"">")
                Response.Write("window.location.href=""canteen_login.asp"";")
                Response.Write("</script>")
            end if

    end if

%>    