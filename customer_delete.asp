<!--#include file="dbConnect.asp"-->

<%
    customerID = Request.Form("customerID")

    rs.open "SELECT cust_fname, cust_lname, department FROM customers WHERE cust_id="&customerID, CN2

    firstName = Trim(CStr(rs("cust_fname")))
    lastName = Trim(CStr(rs("cust_lname")))
    department = Trim(CStr(rs("department")))

    rs.close
    CN2.close
%>

<style>

.form-inputs[readonly] {
    background-color: #e9ecef;
}
.btn-delete {
	background-color: #dc3545;
    border-color: #dc3545;
    outline: none;
}

.btn-delete:active {
    background-color: #dc3545;
    border-color: #dc3545;
    outline: none;
}    

</style>

<body>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Customer ID</label>
        <input type="number" class="form-control form-control-sm" name="customerID" id="customerID" value="<%=customerID%>" placeholder="ID" readonly>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Fist Name</label>
        <input type="text" class="form-control form-control-sm" name="firstName" id="firstName" value="<%=firstName%>" readonly>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Last Name </label>
        <input type="text" class="form-control form-control-sm" name="lastName" id="lastName" value="<%=lastName%>" readonly>
    </div>

    <div class="form-group mb-1"> 
        <label class="ml-1" style="font-weight: 500"> Department </label>
        <input type="text" class="form-control form-control-sm" name="department" id="department" value="<%=department%>" readonly>
    </div>

</body>


