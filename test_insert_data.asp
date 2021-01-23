<!--#include file="dbConnect.asp"-->
<%

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = "11"

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim referenceNoFile
    referenceNoFile = "\reference_no.dbf" 

    Dim referenceNoPath
    referenceNoPath = mainPath & yearPath & "-" & monthPath & referenceNoFile 



    rs.open "SELECT ref_no FROM reference_no WHERE id > 39 AND id < 48", CN2


    do until rs.EOF 

        id = id + 1

        insertRef = insertRef & "INSERT INTO "&referenceNoPath&" (id, ref_no, duplicate) "&_
                    "VALUES ("&id&", '"&rs("ref_no")&"', ''); "

        rs.MoveNext
    loop

    rs.close

    cnroot.execute(insertRef)




%>