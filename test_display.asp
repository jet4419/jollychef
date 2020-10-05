<!--#include file="dbConnect.asp"-->

<%
    
    ' systemDate = CDate(Application("date"))
    ' Response.Write systemDate & "<br>" 
    ' 'checkGlobalAsa =  Application("test_global_asa")
    ' Response.Write checkGlobalAsa & "<br>"
    'Response.Write DateDiff("m", 1, systemDate)

    ' mainPath = "C:\www\www.testjet4419.com\fastfood_f\pos_test\"
    ' yearPath = CStr(Year(ref_date))
    ' monthPath = CStr(Month(ref_date))
    ' path = "C:\www\www.testjet4419.com\fastfood_f\pos_test\2020-08"
    ' arFile = "\accounts_receivables.dbf"

    ' getAr = "SELECT ref_no, balance, date_owed FROM "&path & arFile&" WHERE invoice_no = 70 GROUP BY invoice_no"
    ' set objAccess = cnroot.execute(getAr)

    ' do until objAccess.EOF

    '     for each x in objAccess.fields 

    '         Response.Write x.name & ": " & x.value & "<br>"

    '     next
    '     objAccess.movenext
    ' loop

    ' rs.open "SELECT MAX(ref_no) AS max_val FROM ob_test", CN2

    ' do until rs.EOF 

    '     Response.Write rs("max_val")

    ' loop

    mainPath = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Response.Write monthPath & "<br>"
    Response.Write CInt(monthPath)


    ' rs.open "SELECT * FROM system_date", CN2

    ' do until rs.EOF

    '     for each x in rs.fields 

    '         Response.Write x.name & ": " & x.value & "<br>" 

    '     next

    '     rs.movenext
    ' loop

%>