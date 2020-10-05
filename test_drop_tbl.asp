<!--#include file="dbConnect.asp"-->

<%

    systemDate = CDate(Application("date"))

    'Start of the update

    Dim mainPath, yearPath, monthPath

    mainPath = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim ordersHolderFile

    ordersHolderFile = "\orders_holder.dbf"

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    
    dropTbl = "DROP TABLE "&ordersHolderPath
    cnroot.execute(dropTbl)







%>