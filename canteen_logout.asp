<%

    ' Session.Abandon
    ' Response.Write("<script language=""javascript"">")
    ' Response.Write("alert('You successfully logged out')")
    ' Response.Write("</script>")
    ' loggedOut = true
    ' if loggedOut = true then
    '     Response.Write("<script language=""javascript"">")
    '     Response.Write("window.location.href=""canteen_login.asp"";")
    '     Response.Write("</script>")
    ' end if

%>

<script>

    localStorage.clear();
    alert('You successfully logged out');
    window.location.href='canteen_login.asp';

</script>