<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>

    <style>

        main {
            display: flex;
            justify-content: center;
            align-items: center;
        }

        main h1 {
            color: red;
        }

    </style>

</head>
<body>
    <%
        Dim error

        if Request.QueryString <> "" then
            error = Request.QueryString("error")
        end if
    %>
    <main>
        <h1>ERROR: <%=error%></h1>
    </main>
    
</body>
</html>