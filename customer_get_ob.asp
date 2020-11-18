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

    Dim monthLength

    monthLength = Month(systemDate)
    if Len(monthLength) = 1 then
        monthPath = "0" & CStr(Month(systemDate))
    else
        monthPath = Month(systemDate)
    end if

    Dim folderPath

    folderPath = mainPath & yearPath & "-" & monthPath

    Dim obFile, obFilePath

    obFile = "\ob_test.dbf"
    obFilePath = folderPath & obFile

    sqlGetOB = "SELECT * FROM "&obFilePath&" WHERE cust_id="&custID&" GROUP BY cust_id"
    set objAccess = cnroot.execute(sqlGetOB)

    Dim i
    i = 0

    if not objAccess.EOF then

        Set oJSON = New aspJSON

        With oJSON.data

        oJSON.Collection()

            .Add i, oJSON.Collection()
            With .item(i)       
                .Add "name", CStr(objAccess("cust_name").value)
                .Add "department", CStr(objAccess("department").value)
                .Add "balance", CDbl(objAccess("balance").value)
            End With

        End With

        Response.Write(oJSON.JSONoutput())
    else        
        Response.Write "no data"
    end if

%>