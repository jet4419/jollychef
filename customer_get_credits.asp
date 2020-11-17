<!--#include file="dbConnect.asp"-->
<!--#include file="aspJSON1.17.asp" -->

<%

    Dim fs, currOB, custID

    custID = CLng(Request.Form("custID"))

    Set fs=Server.CreateObject("Scripting.FileSystemObject")

    Dim systemDate, yearPath, monthPath

    systemDate = CDate(Application("date"))
    yearPath = CStr(Year(systemDate))
    monthPath = CStr(Month(systemDate))

    if Len(monthPath) = 1 then
        monthPath = "0" & monthPath
    end if

    Dim arFile

    arFile = "\accounts_receivables.dbf"


    Dim mainPath, folderPath

    mainPath = CStr(Application("main_path"))
    folderPath = mainPath & yearPath & "-" & monthPath

    arPath = folderPath & arFile

    rs.Open "SELECT * FROM "&arPath&" WHERE cust_id="&custID&" and balance > 0 ORDER BY date_owed DESC, balance DESC GROUP BY invoice_no", CN2


    Dim i
    i = 0

    if not rs.EOF then

        Set oJSON = New aspJSON

        With oJSON.data

        oJSON.Collection()

            do until rs.EOF

                .Add i, oJSON.Collection()
                With .item(i)      
                    .Add "name", CStr(rs("cust_name").value)
                    .Add "department", CStr(rs("cust_dept").value)
                    .Add "date", FormatDateTime(CDate(rs("date_owed").value), 2)
                    .Add "invoice", CLng(rs("invoice_no").value)
                    .Add "receivable", CDbl(rs("receivable").value)
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