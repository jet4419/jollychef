<%

    Dim str1

    str1 = "hell yeah"

    upperChar = Ucase(Left(str1, 1))
    length = Len(str1) - 1

    newString = upperChar & Mid(str1, 2)
    Response.Write newString




%>