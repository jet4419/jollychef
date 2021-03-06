<!--#include file="dbConnect.asp"-->


<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="tail.select-default.css">
    

        <style>
        span.option-description {
            font-size: .75rem !important;
            color: #007bff !important;
        }

        label {
            font-weight: 500;
        }

        </style>
    </head>

<body>    
<script src="tail.select-master/js/tail.select-full.min.js"></script>
<%

    custID = CInt(Request.Form("custID"))

    sqlGetInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
    set objAccess = cnroot.execute(sqlGetInfo)

    if not objAccess.EOF then

        cust_name = Trim(objAccess("cust_fname").value) & " " & Trim(objAccess("cust_lname").value)
        department = objAccess("department").value

    end if

    set objAccess = nothing
   ' CN2.close

   Dim defaultDate, systemYear, systemMonth

   systemYear = Year(systemDate)
   systemMonth = Month(systemDate)

   if Len(systemMonth) = 1 then
      systemMonth = "0" & systemMonth
   end if

   defaultDate = systemYear & "-" & systemMonth

%>
 
    <div class="form-group">    
        <label class="ml-1"> Customer ID </label>
        <input type="number" class="form-control" name="cust_id" id="cust_id" value="<%=custID%>" placeholder="ID" readonly>
    </div>    
        <!--<input type="number" class="form-control" name="arID" id="arID" value="<'%=arID%>" placeholder="ID" readonly> -->
    <div class="form-group">         
        <label class="ml-1"> Customer Name </label>
        <input type="text" class="form-control" name="cust_name" id="cust_name" value="<%=cust_name%>" readonly>
        <input type="hidden" name="department" id="department" value="<%=department%>">
    </div>
    
    <div class="form-group">

        <label class="ml-1" for="startDate">Start month:</label>
        <input class="form-control" onchange="minDateFunc()" type="month" id="startDate" name="startDate" value="<%=defaultDate%>">

    </div>

    <div class="form-group">

        <label class="ml-1" for="endDate">End month:</label>
        <input class="form-control" type="month" id="endDate" name="endDate" value="<%=defaultDate%>" max="<%=defaultDate%>">

    </div>

    <!--<div class="form-group">  
        <label class="ml-1">Start Date</label>
        <input class="form-control form-control-sm d-block col-5 mb-3" name="startDate" id="startDate2" type="date"> 
    </div>
    <div class="form-group">  
        <label class="ml-1">End Date</label>
        <input class="form-control form-control-sm d-block col-5" name="endDate" id="endDate2" type="date"> 
    </div> -->



<script>

    const startDate = document.getElementById('startDate');
    const endDate = document.getElementById('endDate');

    endDate.min = startDate.value;

    function minDateFunc() {
        console.log(startDate);
        console.log(endDate);
        endDate.min = startDate.value;
    }


</script>

</body>
</html>