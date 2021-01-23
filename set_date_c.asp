<!--#include file="dbConnect.asp"-->
<%

    Dim btnSetDate, isSetted

    btnSetDate = Request.Form("btnSetDate")

    if btnSetDate <> "" then 

        settingDate = CDate(Request.Form("date"))
        storeScheduleTime = CStr(settingDate)

        Dim maxSdId, updateSystemDate
        maxSdId = 0
        updateSystemDate = false

        rs.Open "SELECT MAX(id) FROM system_date;", CN2
            if not rs.EOF then
                updateSystemDate = true
            end if
        rs.close
        
        'Response.Write updateSystemDate

        maxSdId = maxSdId + 1

        Dim maxSsId

        rs.Open "SELECT MAX(sched_id) FROM store_schedule;", CN2
            do until rs.EOF
                for each x in rs.Fields
                    maxSsId = x.value
                next
                rs.MoveNext
            loop
        rs.close

        maxSsId = CInt(maxSsId) + 1

        if updateSystemDate = true then
            sqlUpdate = "UPDATE system_date SET date=CTOD(["&settingDate&"])"
            cnroot.execute(sqlUpdate)
        else
            sqlAdd = "INSERT INTO system_date (id, date) VALUES ("&maxSdId&", ctod(["&settingDate&"]))"
            cnroot.execute(sqlAdd)
        end if

        sqlAdd2 = "INSERT INTO store_schedule (sched_id, date_time, status) VALUES ("&maxSsId&", '"&storeScheduleTime&"', 'open')"
        cnroot.execute(sqlAdd2)
        Dim newYearPath, newMonthPath

        newYearPath = Year(settingDate)
        newMonthPath = Month(settingDate)

        if Len(newMonthPath) = 1 then
            newMonthPath = "0" & CStr(newMonthPath)
        end if

        Dim newFolderPath
        newFolderPath = mainPath & newYearPath & "-" & newMonthPath

        Dim fs, folder
        Set fs = Server.CreateObject("Scripting.FileSystemObject")

        if fs.FolderExists(newFolderPath) <> true then
            
            Set folder = fs.CreateFolder(newFolderPath)

            Dim arFile, adjustmentFile, collectionsFile, obFile, salesFile, salesOrderFile, transactionsFile, ordersHolderFile, ebFile

            arFile = "\accounts_receivables.dbf" 
            adjustmentFile = "\adjustments.dbf" 
            collectionsFile = "\collections.dbf" 
            obFile = "\ob_test.dbf" 
            salesFile = "\sales.dbf" 
            salesOrderFile = "\sales_order.dbf" 
            transactionsFile = "\transactions.dbf" 
            ordersHolderFile = "\orders_holder.dbf" 
            ebFile = "\eb_test.dbf" 
            referenceNoFile = "\reference_no.dbf" 
            arReferenceNoFile = "\ar_reference_no.dbf" 
            adReferenceNoFile = "\adjustment_ref_no.dbf" 

            Dim arBlankFile, adjustmentBlankFile, collectionsBlankFile, obBlankFile
            Dim salesBlankFile, salesOrderBlankFile, transactionsBlankFile, ordersHolderBlankFile, ebBlankFile, referenceNoBlankFile, arReferenceNoBlankFile, adReferenceNoBlankFile

            arBlankFile = mainPath & "tbl_blank" & arFile
            adjustmentBlankFile = mainPath & "tbl_blank" & adjustmentFile
            collectionsBlankFile = mainPath & "tbl_blank" & collectionsFile
            obBlankFile = mainPath & "tbl_blank" & obFile
            salesBlankFile = mainPath & "tbl_blank" & salesFile
            salesOrderBlankFile = mainPath & "tbl_blank" & salesOrderFile
            transactionsBlankFile = mainPath & "tbl_blank" & transactionsFile
            ordersHolderBlankFile = mainPath & "tbl_blank" & ordersHolderFile
            ebBlankFile = mainPath & "tbl_blank" & ebFile
            referenceNoBlankFile = mainPath & "tbl_blank" & referenceNoFile
            arReferenceNoBlankFile = mainPath & "tbl_blank" & arReferenceNoFile
            adReferenceNoBlankFile = mainPath & "tbl_blank" & adReferenceNoFile

            Dim newArPath, newAdjustmentPath, newCollectionsPath, newObPath
            Dim newSalesPath, newSalesOrderPath, newTransactionsPath, newOrdersHolderPath
            Dim newEbPath, newReferenceNoPath, newArReferenceNoPath, newAdReferencePath

            newArPath = newFolderPath & arFile
            newAdjustmentPath = newFolderPath & adjustmentFile
            newCollectionsPath = newFolderPath & collectionsFile
            newObPath = newFolderPath & obFile
            newSalesPath = newFolderPath & salesFile
            newSalesOrderPath = newFolderPath & salesOrderFile
            newTransactionsPath = newFolderPath & transactionsFile
            newOrdersHolderPath = newFolderPath & ordersHolderFile
            newEbPath = newFolderPath & ebFile
            newReferenceNoPath = newFolderPath & referenceNoFile
            newArReferenceNoPath = newFolderPath & arReferenceNoFile
            newAdReferencePath = newFolderPath & adReferenceNoFile

            ' Response.Write ebBlankFile & "<br>"
            ' Response.Write newEbPath & "<br>"

            if fs.FileExists(newArPath) <> true AND fs.FileExists(newAdjustmentPath) <> true AND _ 
            fs.FileExists(newCollectionsPath) <> true AND fs.FileExists(newObPath) <> true AND _
            fs.FileExists(newSalesPath) <> true AND fs.FileExists(newSalesOrderPath) <> true AND _
            fs.FileExists(newTransactionsPath) <> true AND fs.FileExists(newOrdersHolderPath) <> true AND _
            fs.FileExists(newEbPath) <> true AND _
            fs.FileExists(newReferenceNoPath) <> true AND _
            fs.FileExists(newArReferenceNoPath) <> true AND _
            fs.FileExists(newAdReferencePath) <> true _
            then 

                fs.CopyFile arBlankFile, newArPath
                fs.CopyFile adjustmentBlankFile, newAdjustmentPath
                fs.CopyFile collectionsBlankFile, newCollectionsPath
                fs.CopyFile obBlankFile, newObPath
                fs.CopyFile salesBlankFile, newSalesPath
                fs.CopyFile salesOrderBlankFile, newSalesOrderPath
                fs.CopyFile transactionsBlankFile, newTransactionsPath
                fs.CopyFile ordersHolderBlankFile, newOrdersHolderPath
                fs.CopyFile ebBlankFile, newEbPath
                fs.CopyFile referenceNoBlankFile, newReferenceNoPath
                fs.CopyFile arReferenceNoBlankFile, newArReferenceNoPath
                fs.CopyFile adReferenceNoBlankFile, newAdReferencePath
                Response.Write "Files successfully copied!"
            else
                Response.Write "Files not copied"
            end if

            set fs = nothing

        else

             Response.Write("<script>")
            Response.Write("alert('Files already exist!')")
            Response.Write("</script>")
            isSetted = true

            if isSetted = true then

                Response.Write("<script>")
                Response.Write("window.location.href = 'set_date.asp' ")
                Response.Write("</script>")

            end if

        end if



        Response.Write("<script>")
        Response.Write("alert('System date setted successfully!')")
        Response.Write("</script>")
        isSetted = true

        if isSetted = true then

            Response.Write("<script>")
            Response.Write("window.location.href = 'set_date.asp' ")
            Response.Write("</script>")

        end if




    end if

%>