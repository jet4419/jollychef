<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

    Dim mainPath, systemDate

    mainPath = CStr(Application("main_path"))
    systemDate = CDate(Application("date"))
    
    Dim userID
    userID = CLng(Request.Form("custID"))

    'Response.Write userID

    Dim monthLength, monthPath, yearPath

    monthLength = Month(systemDate)
    if Len(monthLength) = 1 then
        monthPath = "0" & CStr(Month(systemDate))
    else
        monthPath = Month(systemDate)
    end if

    yearPath = Year(systemDate)

    Dim obFile, folderPath, obPath

    obFile = "\ob_test.dbf"
    folderPath = mainPath & yearPath & "-" & monthPath
    obPath = folderPath & obFile

    'Check if table has a data record'
    isThereObData = "SELECT id FROM "&obPath&""
    set objAccess = cnroot.execute(isThereObData)


    if objAccess.EOF then

        Dim recentMonthPath, recentYearPath

        recentMonthPath = CInt(monthPath) - 1
        recentYearPath = CInt(yearPath)

        Dim fs
        Set fs = Server.CreateObject("Scripting.FileSystemObject")

        if recentMonthPath = 0 then

            recentMonthPath = 12
            recentYearPath = CInt(yearPath) - 1

        end if

        if Len(recentMonthPath) = 1 then

            recentMonthPath = "0" & recentMonthPath

        end if

        Dim recentFolderPath

        recentFolderPath = mainPath & recentYearPath & "-" & recentMonthPath

        Dim isFolderExist, recentObPath, isFileExist

        isFolderExist = fs.FolderExists(recentFolderPath)         
        
        do until isFolderExist = false 

            recentObPath = recentFolderPath & obFile
            isFileExist = fs.FileExists(recentObPath)     

            if isFileExist <> true then EXIT DO   

            'Check if table has a data record'
            checkRecord = "SELECT id FROM "&recentObPath&""
            set objAccess = cnroot.execute(checkRecord)

            if objAccess.EOF then

                recentMonthPath = CInt(recentMonthPath) - 1
                recentYearPath = CInt(recentYearPath)

                if recentMonthPath = 0 then

                    recentMonthPath = 12
                    recentYearPath = CInt(recentYearPath) - 1

                end if

                if Len(recentMonthPath) = 1 then
                    recentMonthPath = "0" & recentMonthPath
                end if

                recentFolderPath = mainPath & recentYearPath & "-" & recentMonthPath
                isFolderExist = fs.FolderExists(recentFolderPath)

            else

                obPath = recentObPath
                EXIT DO

            end if

        loop

    end if

    ' Response.Write obPath

    ' getCustId = "SELECT cust_lname, cust_fname, department FROM customers WHERE cust_id="&userID
    ' set objAccess = cnroot.execute(getCustId)

    ' if not objAccess.EOF then

    '     custFullName = Trim(CStr(objAccess("cust_lname").value)) & " " & Trim(CStr(objAccess("cust_fname").value))
    '     department = Trim(CStr(objAccess("department")))

    ' end if

    ' rs.open "SELECT id, ref_no, cust_id, balance "&_
    ' "FROM "&obPath&" "&_
    ' "WHERE cust_id="&userID&" and id IN ( SELECT MAX(id) FROM "&obPath&" GROUP BY cust_id)", CN2

    'Response.Write obPath

    rs.open "SELECT OB_TEST.id, OB_TEST.ref_no, OB_TEST.cust_id, OB_TEST.balance, CUSTOMERS.cust_fname, CUSTOMERS.cust_lname, CUSTOMERS.department "&_
    "FROM "&obPath&" "&_
    "INNER JOIN CUSTOMERS ON OB_TEST.cust_id = CUSTOMERS.cust_id "&_
    "WHERE CUSTOMERS.cust_id="&userID&" and id IN ( SELECT MAX(OB_TEST.id) FROM "&obPath&" GROUP BY OB_TEST.cust_id)", CN2

    Dim i
    i = 0

    if not rs.EOF then

        Set oJSON = New aspJSON

        With oJSON.data

        oJSON.Collection()

            do until rs.EOF

                .Add i, oJSON.Collection()
                With .item(i)      
                    .Add "id", CStr(rs("cust_id").value)
                    .Add "name", Trim(rs("cust_lname").value) & " " & Trim(rs("cust_fname").value) 
                    .Add "department", CStr(rs("department").value)
                    .Add "balance", CDbl(rs("balance").value)
                End With

                i = i + 1

                rs.MoveNext
            loop

        End With

        Response.Write(oJSON.JSONoutput())

    else        
        Response.Write "no data " 
    end if


%>