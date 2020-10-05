<!--#include file="dbConnect.asp"-->

<%
    Dim systemDate

    systemDate = CDate("08/31/2020")

    Dim fs
    Set fs=Server.CreateObject("Scripting.FileSystemObject")
    currentPath = CStr(Application("main_path"))
    recentMonthPath = Month(systemDate)

    if Len(recentMonthPath) = 1 then
        recentMonthPath = "0" & CStr(recentMonthPath)
    end if

    recentObRececordPath = currentPath & Year(systemDate) & "-" & recentMonthPath & "\ob_test.dbf" 
    yearPath = CStr(Year(systemDate + 1))
    monthPath = CStr(Month(systemDate + 1))

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    newFolderName = yearPath & "-" & monthPath
    newObFileName = "\ob_test.dbf"
    newFolderPath = currentPath & newFolderName

    if fs.FolderExists(newFolderPath) <> true then

        set f=fs.CreateFolder(newFolderPath)
        'set f=nothing

        blankObFileCopy = currentPath & "ob_test.dbf"
        newObFileLocation = currentPath & newFolderName & newObFileName
        'obFileLocationFolder = path1 & folderName & fileName

        if fs.FileExists(newObFileLocation) <> true then 

            fs.CopyFile blankObFileCopy, newObFileLocation
            set fs=nothing
            
            rs.open "SELECT * FROM "&recentObRececordPath&" WHERE id IN (SELECT MAX(id) FROM ob_test GROUP BY cust_id)", CN2

            ' file = "\ob_test.dbf"
            ' folderPath = path1 & folderName
            ' filePath = yearPath & "-" & monthPath & file

            if not rs.EOF then

                do until rs.EOF
                
                    sqlAdd2 = "INSERT INTO "&newObFileLocation&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status) "&_
                            "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&" , "&rs("balance")&", ctod(["&rs("date")&"]), '"&rs("status")&"')"
                    cnroot.execute(sqlAdd2)

                rs.movenext
                loop
        

            end if

            rs.close

        else

            Response.Write "File already exist!"

        end if

    else    

        Response.Write "Folder already exist!"

    end if

    'REMINDER!!! DROP THE ORDERS_HOLDER TABLE'

    ' if fs.FileExists(folderPath & file) <> true then EXIT DO

    ' set f=fs.CreateFolder(path1 & folderName)
    ' set f=nothing

    ' rs.open "SELECT * FROM ob_test WHERE id IN (SELECT MAX(id) FROM ob_test GROUP BY cust_id)", CN2

    

    ' file = "\ob_test.dbf"
    ' folderPath = "C:\www\www.testjet4419.com\fastfood_f\pos_test\2020-09"
    ' filePath = "2020-09" & file

    ' ' do until rs.EOF 


    ' '     for each x in rs.fields

    ' '         Response.Write x.name & ": " & x.value & "<br>"


    ' '     next
    ' '     rs.movenext

    ' ' loop

    ' if not rs.EOF then

    '     do until rs.EOF
        
    '     sqlAdd2 = "INSERT INTO "&filePath&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status) "&_
    '               "VALUES ("&rs("id")&", '"&rs("ref_no")&"', "&rs("cust_id")&", '"&rs("t_type")&"', '"&rs("cust_type")&"', "&rs("cash_paid")&" , "&rs("balance")&", ctod(["&rs("date")&"]), '"&rs("status")&"')"
    '     cnroot.execute(sqlAdd2)

    '     rs.movenext
    '     loop
       

    ' end if

    ' rs.close



%>