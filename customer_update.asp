<!--#include file="dbConnect.asp"-->

<%
    customerID = Request.Form("customerID")

    rs.open "SELECT cust_fname, cust_lname, address, contact_no, email, department FROM customers WHERE cust_id="&customerID, CN2

    firstName = Trim(CStr(rs("cust_fname")))
    lastName = Trim(CStr(rs("cust_lname")))
    address = Trim(CStr(rs("address")))
    contactNo = Trim(CStr(rs("contact_no")))
    emailAddress = Trim(CStr(rs("email")))
    department = Trim(CStr(rs("department")))
    
    rs.close
    CN2.close
%>

    <div class="form-group mb-1">    
        <input type="number" class="form-control form-control-sm" name="customerID" id="customerID" value="<%=customerID%>" placeholder="ID" hidden>  
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> First Name </label>
        <input type="text" class="form-control form-control-sm" name="firstName" id="firstName" value="<%=firstName%>" required>
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Last Name </label>
        <input type="text" class="form-control form-control-sm" name="lastName" id="lastName" value="<%=lastName%>" required>
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Address </label>
        <input type="text" class="form-control form-control-sm" name="address" id="address" value="<%=address%>">
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Contact No </label>
        <input type="text" id="contactNo" name="contactNo" class="form-control form-control-sm" pattern="[0-9]{11}" value="<%=contactNo%>">
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Department </label>
        <input type="text" id="department" name="department" class="form-control form-control-sm" value="<%=department%>" required>
    </div>

    <div class="form-group mb-1">    
        <label class="ml-1" style="font-weight: 500"> Email </label>
        <input type="email" id="email" name="email" class="form-control form-control-sm" autocomplete="off" value="<%=emailAddress%>" required>
    </div>
     


