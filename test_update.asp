<!--#include file="dbConnect.asp"-->

<%

    Response.Write "Hey" & "<br>"

    Dim mainPath, yearPath, monthPath, systemDate

    systemDate = CDate(Application("date"))

    mainPath = CStr(Application("main_path"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim arFile

    arFile = "\accounts_receivables.dbf"

    Dim arPath, folderPath

    folderPath = mainPath & yearPath & "-" & monthPath
    arPath = mainPath & yearPath & "-" & monthPath & arFile

    
    Dim fs
    set fs=Server.CreateObject("Scripting.FileSystemObject")

    isFolderExist = fs.FolderExists(folderPath)


    do until isFolderExist = false

        isFileExist = fs.FileExists(arPath)
 
            'if fs.FolderExists(folderPath) <> true then EXIT DO

        if isFileExist = true then

            getMaxVal = "SELECT ref_no, invoice_no FROM "&arPath&" WHERE invoice_no=63 GROUP BY invoice_no"
            set objAccess = cnroot.execute(getMaxVal)

                if not objAccess.EOF then

                    ref_no = CStr(objAccess("ref_no"))

                        ' sqlUpdate = "UPDATE "&arPath&" SET balance = balance - 10 WHERE invoice_no=63 and ref_no ='"&ref_no&"' ",
                        ' cnroot.execute(sqlUpdate)

                end if

                

            set objAccess = nothing   

        end if

        monthPath = CInt(monthPath) - 1

        if monthPath = 0 then
                monthPath = 12
                yearPath = CInt(yearPath) - 1
        end if

        if Len(monthPath) = 1 then
                monthPath = "0" & monthPath
        end if

        arPath = mainPath & yearPath & "-" & monthPath & arFile
        folderPath = mainPath & yearPath & "-" & monthPath

        if fs.FolderExists(folderPath) <> true then 
            isFolderExist = false
        end if


    loop

    Response.Write arPath & "<br>"

    Response.Write "Ref No: " & ref_no & "<br>"
    
%>