<%

myDate = CDate("1/10/2021")
myYear = Year(myDate)
myMonth = MonthName(Month(myDate))
myDay = Day(myDate)

' Response.Write Mid(d1, 3)
Response.Write "Date: " & myMonth & " " & myDay & ", " & myYear


%>