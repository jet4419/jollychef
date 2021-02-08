<%

    balance = 300


    for i = 0 to 10 

        balance = balance - 100

        if balance < 0 then
            Response.Write "invalid payment <br>"
            isValidTransact = false
            EXIT FOR
        end if

        Response.Write "completed <br>"

    next



%>