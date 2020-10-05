<!--#include file="sha256.asp"-->
<%
    btnSubmit = Request.Form("btnSubmit")
    if btnSubmit<>"" then

        myHashed = "2cfeb64fee74a15a66d31ba55814bd6154bf876b232cc44ed38d49c8d892808d"
        userInput = CStr(Request.Form("pass"))
        salt = "2435uhu34hi34"
        userInput = sha256(userInput&salt)


        if ASC(myHashed) = ASC(userInput) Then
            Response.Write("Correct Password!")
        else
            Response.Write("Wrong Password!")
        end if   
    end if             
%>

<html>
<head>
 <title>Encrypt</title>
</head>

<body>

<form action="encrypt_test.asp" method="post">
<input type="text" name="pass">
<input type="submit" name="btnSubmit" value="yes">
</form>

</body>
</html>