<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%
    Dim arFile

    arFile = "\accounts_receivables.dbf"

    Dim yearPath, monthPath

    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim arPath

    arPath = mainPath & yearPath & "-" & monthPath & arFile

    ' sqlUpdate = "UPDATE "&arPath&" "&_
    ' " SET balance = "&_
    ' "iif(invoice_no=3, 6, iif(invoice_no=4, 8, balance)) "&_
    ' "WHERE invoice_no IN (3,4)"

    ' sqlUpdate2 = "UPDATE "&arPath&" "&_
    ' " SET balance = "&_
    ' "iif(invoice_no=3, 6, iif(invoice_no=4, 8, iif(invoice_no=7, 14, balance))) "&_
    ' "WHERE invoice_no IN (3,4,7)"

    ' sqlUpdate2 = "UPDATE "&arPath&" "&_
    ' " SET balance = "&_
    ' "iif(invoice_no=3, 6, iif(invoice_no=4, 8, iif(invoice_no=7, 14, "&_
    ' "iif(invoice_no=8,16, iif(invoice_no=6,12, balance))))) "&_
    ' "WHERE invoice_no IN (3,4,7,8,6)"

    sqlUpdate2 = "UPDATE "&arPath&" "&_
    " SET balance = "&_
    "iif(invoice_no=25, 1, iif(invoice_no=26, 2, iif(invoice_no=27, 3, "&_
    "iif(invoice_no=28, 4, iif(invoice_no=29, 5, iif(invoice_no=30, 6, "&_
    "iif(invoice_no=31, 7, iif(invoice_no=32, 8, iif(invoice_no=33, 9, "&_
    "iif(invoice_no=36, 9, balance)))))))))) "&_
    "WHERE invoice_no IN (25,26,27,28,29,30,31,32,33,36)"

    Response.Write sqlUpdate2

    ' sqlUpdate3 = "UPDATE "&arPath&" "&_
    ' "SET balance = "&_
    ' "iif(invoice_no=3, 6) iif(invoice_no=4, 8) iff(invoice_no=7,14) WHERE invoice_no IN (3,4,7)"

    cnroot.execute(sqlUpdate2)

%>