<%
    mysub()
    mysub()
    mysub()
    mysub()

    Dim total
    total = sum(5, 10)
    'Response.Write "Sum of 5 and 10: " & total

    'Sub Procedure (can't return a value)'
    Sub mysub() 
        Response.Write "test sub <br>"
    End Sub

    'Function Procedure (can return a value)'
    Function sum(a, b)
        sum = a + b
        Response.Write "<h1> Sum of two numbers </h1>"
        Response.Write a & " + " & b & " = " & sum
    End Function


%>