<!--#include file="dbConnect.asp"-->

<%
    Dim systemDate

    systemDate = CDate("08/31/2020")

    dim fs,f
    set fs=Server.CreateObject("Scripting.FileSystemObject")
    path1 = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate + 1))
    monthPath = CStr(Month(systemDate + 1))

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    folderName = yearPath & "-" & monthPath
    fileName = "\ob_test.dbf"
    folderPath = path1 & folderName

    if fs.FolderExists(folderPath) <> true then

        set f=fs.CreateFolder(path1 & folderName)
        'set f=nothing

        fileCopy = path1 & "ob_test.dbf"
        fileLocation = path1 & folderName & fileName
        fileLocationFolder = path1 & folderName & fileName

        if fs.FileExists(fileLocation) <> true then 

            fs.CopyFile fileCopy,fileLocationFolder
            set fs=nothing
            
            rs.open "SELECT * FROM "&path1&"\2020-08\ob_test.dbf WHERE id IN (SELECT MAX(id) FROM ob_test GROUP BY cust_id)", CN2

            ' file = "\ob_test.dbf"
            ' folderPath = path1 & folderName
            ' filePath = yearPath & "-" & monthPath & file

            if not rs.EOF then

                do until rs.EOF
                
                    sqlAdd2 = "INSERT INTO "&fileLocationFolder&" (id, ref_no, cust_id, t_type, cust_type, cash_paid, balance, date, status) "&_
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