<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

    Dim fs, currOB, custID

    custID = CLng(Request.Form("custID"))

    Set fs=Server.CreateObject("Scripting.FileSystemObject")

    Dim yearPath, monthPath

    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim arFile

    arFile = "\accounts_receivables.dbf"

    Dim arFolderPath

    arFolderPath = mainPath & yearPath & "-" & monthPath
    arMonthPath = monthPath
    arYearPath = yearPath
    arPath = arFolderPath & arFile


    Dim isArFolderExist
    isArFolderExist = fs.FolderExists(arFolderPath)

    Dim i
    i = 0

        Set oJSON = New aspJSON

            With oJSON.data

            oJSON.Collection()

   'do until isArFolderExist = false

        isArFileExist = fs.FileExists(arPath)

        if isArFileExist = true then

            getCredits = "SELECT * FROM "&arPath&" WHERE cust_id="&custID&" and balance > 0 ORDER BY date_owed DESC, invoice_no DESC GROUP BY invoice_no"
            set objAccess = cnroot.execute(getCredits)

            do until objAccess.EOF

                .Add i, oJSON.Collection()
                With .item(i)      
                    .Add "name", CStr(objAccess("cust_name").value)
                    .Add "department", CStr(objAccess("cust_dept").value)
                    .Add "date", FormatDateTime(CDate(objAccess("date_owed").value), 2)
                    .Add "invoice", CLng(objAccess("invoice_no").value)
                    .Add "receivable", CDbl(objAccess("receivable").value)
                    .Add "balance", CDbl(objAccess("balance").value)
                End With

                i = i + 1

                objAccess.MoveNext
            loop

        end if

    '     if isArFolderExist <> false then

    '         arMonthPath = CInt(arMonthPath) - 1

    '         if arMonthPath = 0 then
    '                 arMonthPath = 12
    '                 arYearPath = CInt(arYearPath) - 1
    '         end if

    '         if Len(arMonthPath) = 1 then
    '                 arMonthPath = "0" & arMonthPath
    '         end if

    '         arPath = mainPath & arYearPath & "-" & arMonthPath & arFile
    '         arFolderPath = mainPath & arYearPath & "-" & arMonthPath

    '         if fs.FolderExists(arFolderPath) <> true then 
    '             isArFolderExist = false
    '         end if

    '     end if   

    ' loop

            End With

    Response.Write(oJSON.JSONoutput())

    ' rs.Open "SELECT * FROM "&arPath&" WHERE cust_id="&custID&" and balance > 0 ORDER BY date_owed DESC, balance DESC GROUP BY invoice_no", CN2


    ' Dim i
    ' i = 0

    ' Set oJSON = New aspJSON

    ' if not rs.EOF then

    '     With oJSON.data

    '     oJSON.Collection()

    '         do until rs.EOF

    '             .Add i, oJSON.Collection()
    '             With .item(i)      
    '                 .Add "name", CStr(rs("cust_name").value)
    '                 .Add "department", CStr(rs("cust_dept").value)
    '                 .Add "date", FormatDateTime(CDate(rs("date_owed").value), 2)
    '                 .Add "invoice", CLng(rs("invoice_no").value)
    '                 .Add "receivable", CDbl(rs("receivable").value)
    '                 .Add "balance", CDbl(rs("balance").value)
    '             End With

    '             i = i + 1

    '             rs.MoveNext
    '         loop

    '     End With

    '     Response.Write(oJSON.JSONoutput())

    ' else    
    '      Set oJSON = New aspJSON    
    '     Response.Write(oJSON.JSONoutput())
    ' end if

%>