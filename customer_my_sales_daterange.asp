<!--#include file="dbConnect.asp"-->
<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">


        <style>
        span.option-description {
            font-size: .75rem !important;
            color: #007bff !important;
        }

        </style>
    </head>

<body>    

<%

    custID = CInt(Request.Form("custID"))

    sqlGetInfo = "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&custID
    set objAccess = cnroot.execute(sqlGetInfo)

    if not objAccess.EOF then

        cust_name = Trim(objAccess("cust_lname").value) & " " & Trim(objAccess("cust_fname").value)
        department = objAccess("department").value

    end if

    set objAccess = nothing
   ' CN2.close
   
%>
 
    <div class="form-group">    
        <label class="ml-1" style="font-weight: 500"> Customer ID </label>
        <input type="number" class="form-control" name="cust_id" id="cust_id" value="<%=custID%>" placeholder="ID" readonly>
    </div>    
        <!--<input type="number" class="form-control" name="arID" id="arID" value="<'%=arID%>" placeholder="ID" readonly> -->
    <div class="form-group">         
        <label class="ml-1" style="font-weight: 500"> Customer Name </label>
        <input type="text" class="form-control" name="cust_name" id="cust_name" value="<%=cust_name%>" readonly>
        <input type="hidden" name="department" id="department" value="<%=department%>">
    </div>

    <div class="form-group">    
        <label>Start Date</label>
        <input class="form-control form-control-sm d-inline col-2" name="startDate" id="startDate" type="date"> 
    
        <label class="ml-3">End Date&nbsp;</label>
        <input class="form-control form-control-sm d-inline col-2" name="endDate" id="endDate" type="date"> 
        
    </div>

</body>
</html>