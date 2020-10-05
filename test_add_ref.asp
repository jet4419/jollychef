<!--#include file="dbConnect.asp"-->

<%  
    ' currentPath = "C:\www\www.testjet4419.com\fastfood_f\pos_test\tables"
    ' file = "\accounts_receivables.dbf"
    ' filePath = currentPath & file

    ' getMaxId = "SELECT MAX(id) AS id FROM "&currentPath&"\ar_reference_no.dbf"
    ' set objAccess = cnroot.execute(getMaxId)

    ' maxId = 0

    ' if not objAccess.EOF then

    '     maxId = CDbl(objAccess("id"))

    ' end if

    ' maxId = maxId + 1

    ' set objAccess = nothing

    ' rs.open "SELECT DISTINCT(ref_no) AS ref_no FROM "&filePath&" ", CN2

    ' do until rs.EOF

    '     sqlAdd = "INSERT INTO "&currentPath&"\ar_reference_no.dbf (id, ref_no) VALUES("&maxId&", '"&rs("ref_no")&"')"
    '     cnroot.execute(sqlAdd)

    '     maxId = maxId + 1

    '     rs.movenext
    ' loop

    ' rs.close

    'systemDate = CDate(Application("date"))
    systemDate = CDate("07/31/2020")
    currentPath = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))
    newMonthPath = CStr(Month(systemDate) + 1)
    newYearPath = CStr(Year(systemDate + 1))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    if Len(newMonthPath) = 1 then
        newMonthPath = "0" & newMonthPath
    end if

    file = "\accounts_receivables.dbf"
    folderPath = currentPath & yearPath & "-" & monthPath
    newFolderPath = currentPath & newYearPath & "-" & newMonthPath
    arPath = folderPath & file
    newArPath = newFolderPath & file

    Response.Write arPath & "<br>"
    Response.Write newArPath & "<br>"

    ' sqlAdd =  "INSERT INTO "&newArPath&" (ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, status) "&_
    '           "SELECT ar_id, cust_id, cust_name, cust_dept, ref_no, invoice_no, receivable, balance, date_owed, status FROM "&arPath&" WHERE balance > 0;"
    ' cnroot.execute(sqlAdd)
    


%>