<!--#include file="dbConnect.asp"-->
<!--#include file="session_cashier.asp"-->
<%

    ' if Session("type") = "" then
    '     Response.Redirect("canteen_homepage.asp")
    ' end if

%>

<!DOCTYPE html>
<html>
    <head>
        
        <title>Customers Order</title>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link rel="stylesheet" href="./css/main.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@100;300;400;500;700;900&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Great+Vibes&family=Tenali+Ramakrishna&display=swap" rel="stylesheet">
        <link href="fontawesome/css/fontawesome.css" rel="stylesheet">
        <link href="fontawesome/css/brands.css" rel="stylesheet">
        <link href="fontawesome/css/solid.css" rel="stylesheet">
        <link rel="stylesheet" href="tail.select-default.css">
        <link href="https://fonts.googleapis.com/css2?family=Kulim+Park:wght@200;300;400;600&display=swap" rel="stylesheet">
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/twitter-bootstrap.css"/>
        <link rel="stylesheet" type="text/css" href="bootstraptable/datatables/css/dataTables.bootstrap4.min.css"/>

        <script src="./jquery/jquery_uncompressed.js"></script>
        <!-- Bootstrap JS -->
        <script src="./bootstrap/js/bootstrap.min.js"></script>
  
        <script src="bootstraptable/datatables/js/jquery.dataTables.min.js"></script>
        <script src="bootstraptable/datatables/js/dataTables.bootstrap4.min.js"></script>

    </head>
    <%
        ' if Session("type") = "" then
        '     Response.Redirect("canteen_login.asp")
        ' end if
    %>     
<body>

<!--#include file="cashier_navbar.asp"-->
<!--#include file="cashier_sidebar.asp"-->

<%
    Dim isDayEnded

    Dim yearPath, monthPath

    yearPath = Year(systemDate)
    monthPath = Month(systemDate)

    if Len(monthPath) = 1 then
        monthPath = "0" & CStr(monthPath)
    end if

    Dim ordersHolderFile

    ordersHolderFile = "\orders_holder.dbf" 

    Dim ordersHolderPath

    ordersHolderPath = mainPath & yearPath & "-" & monthPath & ordersHolderFile

    Dim fs
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
%>

<div id="main">

    <section class="main-heading--container">
        <h1 class="text-center mb-4 main-heading--text">Customers Order</h1>
    </section>

    <div id="content">
        <div class="container mb-5">

            <%if fs.FileExists(ordersHolderPath) = true then %>

                <% rs.Open "SELECT DISTINCT id, unique_num, cust_id, cust_name, department, SUM(upd_amount) AS amount, date FROM "&ordersHolderPath&" WHERE status=""On Process"" and cust_id!=0 GROUP BY unique_num", CN2 %>
                <table class="table table-hover table-bordered table-sm" id="myTable">
                <caption>List of orders</caption>
                    <thead class="thead-bg">
                        <th>Order#</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Amount</th>
                        <th>Date</th>
                        <th>Action</th>
                        <!--<th>Date</th>-->
                    </thead>

                    <tbody>
                    <% Dim i, ordersID 
                    i = 0 
                    ordersID = 0
                    %>
                    <%do until rs.EOF%>
                    <tr>
                        <%
                            i = i + 1
                            ordersID = CLng(rs("id").value)
                        %>
                        <td class="text-bold"><%Response.Write(i)%></td> 
                        <td class="text-darker"><%Response.Write(rs("cust_name"))%></td> 
                        <td class="text-darker"><%Response.Write(rs("department"))%></td>   
                        <td class="text-darker"><%Response.Write("<strong class='currency-sign' >&#8369; </strong>"&formatNumber(rs("amount")))%></td> 
                        <td class="text-darker"><%Response.Write(dateFormat(rs("date")))%></td>
                        <td class="m-0">
                            <button id="<%=rs("unique_num")%>" value="<%=rs("cust_id")%>"  class="btn btn-sm btn-outline-dark mx-auto mb-2 btnViewOrder">
                            View
                            </button>

                            <button onClick="delete_order(<%=rs("unique_num")%>, '<%=i%>')" class="btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct">
                                Cancel
                            </button>
                        </td>
                    <%rs.MoveNext%>
                    </tr>
                    <%loop%>

                    <%rs.close%>
                    </tbody>
                </table>

                <%
                    Function formatNumber(myNum)

                        Dim i, counter, numFormat
                        counter = 1
                        numFormat = ""

                        for i = Len(myNum) to 1 step -1

                            ' Response.Write "<br>" & i & "<br>"
                            if counter mod 3 = 0 then
                                if counter = Len(myNum) then
                                    numFormat = Mid(myNum, i, 1) & numFormat
                                else
                                    numFormat = "," & Mid(myNum, i, 1) & numFormat
                                end if
                            else
                                numFormat = Mid(myNum, i, 1) & numFormat
                            end if

                            counter = counter + 1

                        next

                        formatNumber = numFormat

                    End Function

                %>

                <%
                    Function dateFormat(reportDate)

                        myYear = Year(reportDate)
                        myDay = Day(reportDate)
                        if Len(myDay) = 1 then
                            myDay = "0" & myDay
                        end if
     
                        myMonth = Month(reportDate)
                        if Len(myMonth) = 1 then
                            myMonth = "0" & myMonth
                        end if

                        dateFormat = myMonth & "/" & myDay & "/" & Mid(myYear, 3)

                    End Function

                %>

                <!-- Last ID number of order -->
                <span class="orderID" id="<%=ordersID%>" hidden> </span>
                <span class="orderNumber" id="<%=i%>" hidden> </span>
            <%end if%>
        </div>    
    </div>

    <!--#include file="cashier_login_logout.asp"-->
    
</div>

<!-- FOOTER -->

<!--#include file="footer.asp"-->

<!-- End of FOOTER -->

<script src="js/main.js"></script> 
<script>  

const cashierID = localStorage.getItem('id');
const cashierName = localStorage.getItem('fullname');
const userType = localStorage.getItem('type');

// const btnViewOrder = document.querySelector('.btnViewOrder');

 $(document).ready( function () {
    $('#myTable').DataTable({
        scrollY: "38vh",
        scroller: true,
        scrollCollapse: true,
        "paging": false,
        dom: "<'row'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
             "<'row'<'col-sm-12'tr>>" +
             "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
        buttons: [
            { extend: 'copy', className: 'btn btn-sm btn-success' },
            { extend: 'excel', className: 'btn btn-sm btn-success' },
            { extend: 'pdf', className: 'btn btn-sm btn-success' },
            { extend: 'print', className: 'btn btn-sm btn-success' }
        ]
    });
} ); 

// function processOrder(id) {
// 	window.location.href='a_order_process.asp?cust_id='+id;	
	
// }


if (document.querySelector('.btnViewOrder') !== null) {

    $('.btnViewOrder').click(function(e) {
        
        const uniqueNum = e.target.id;
        const custID = e.target.value;

        const formOrder = document.createElement('form');
        formOrder.setAttribute('action', 'customer_order_process.asp');
        formOrder.setAttribute('method', 'POST');

        const inputElUniqueNum = document.createElement('input');
        inputElUniqueNum.setAttribute('name', 'unique_num');
        inputElUniqueNum.setAttribute('value', uniqueNum);

        const inputElCustID = document.createElement('input');
        inputElCustID.setAttribute('name', 'cust_id');
        inputElCustID.setAttribute('value', custID);

        const inputElUserType = document.createElement('input');
        inputElUserType.setAttribute('name', 'userType');
        inputElUserType.setAttribute('value', userType);

        formOrder.appendChild(inputElUniqueNum);
        formOrder.appendChild(inputElCustID);
        formOrder.appendChild(inputElUserType);

        // console.log(formOrder);
        document.body.appendChild(formOrder);
        formOrder.submit();
    })
}



function view_order(unique_num ,custID) {

    window.location.href=`customer_order_process.asp?unique_num=${unique_num}&cust_id=${custID}&userType=${userType}`;

}

function delete_order(unique_num ,order_number) {

     if(confirm('Are you sure that you want to cancel Order# ' + order_number + ' ?'))
     {
        window.location.href=`customer_order_cancel.asp?unique_num=${unique_num}&cashierID=${cashierID}&cashierName=${cashierName}`;
		//window.location.href='delete.asp?delete_id='+id;
     }
}

// function get_post(){
//     //var Url = 'a_get_orders.asp'
//     var Url = 'aspJSON2.asp'
//     //var Url = 'aspJSON.asp'
//     var orderID = $('.orderID').attr('id')
//     var orderNumber = $('.orderNumber').attr('id')
//     $.ajax({
//         url: Url,
//         type: 'POST',
//         data: {orderID: orderID, orderNumber: orderNumber},
//         //data: {},
//     })
//     .done(function(data) {

//         if (data!=="no new data") {

//             let jsonObject = JSON.parse(data)

//             let output = '';

//             for (let i in jsonObject) {
//                 output += ` <tr>
//                                 <td class='text-bold'> ${jsonObject[i].orderNumber} </td>
//                                 <td class='text-darker'> ${jsonObject[i].custName} </td>
//                                 <td class='text-darker'> ${jsonObject[i].department} </td> 
//                                 <td class='text-darker'> <strong class='currency-sign'> &#8369; </strong> ${jsonObject[i].amount} </td> 
//                                 <td class='text-darker'> ${jsonObject[i].date} </td> 
//                                 <td class='m-0'>
//                                     <a href='customer_order_process.asp?unique_num=${jsonObject[i].uniqueNum}&cust_id=${jsonObject[i].custID}&userType=${userType}' class='btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct'>
//                                         View
//                                     </a>
//                                     <button onClick='delete_order(${jsonObject[i].uniqueNum}, ${jsonObject[i].orderNumber})' class='btn btn-sm btn-outline-dark mx-auto mb-2 deleteProduct'>
//                                         Cancel
//                                     </button>
//                                 </td>
//                             </tr>        
//                         `;
//                 $("span.orderID").attr('id', jsonObject[i].id)
//                 $('.orderNumber').attr('id', jsonObject[i].orderNumber)
//             }

//             $('td.dataTables_empty').attr('hidden', 'hidden');
//             $('#myTable tr:last').after(output);

//         } else {
//             console.log("no new data");
//         }
//     })
//     .fail(function() {
//         console.log("error");
//     });
// }

// setInterval(function(){
//     get_post()         
// },10000);

</script>

</body>
</html>    