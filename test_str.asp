<%

myDate = CDate("1/10/2021")
myYear = Year(myDate)
myMonth = MonthName(Month(myDate))
myDay = Day(myDate)

' Response.Write Mid(d1, 3)
Response.Write "Date: " & myMonth & " " & myDay & ", " & myYear
Response.Write "<br>"
Response.Write "<br>"
Response.Write "<br>"

Dim myNum
myNum = CStr(15512355)

Response.Write "Number: " & myNum & "<br> Format: " & formatNumber(myNum) 


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

' Response.Write "<br> Type: " & Join(myNum,",") & "<br>"

' if Len(myNum) > 3 then

'     Response.Write "Number: " & myNum

' end if

%>

<script>

    let myNumber = 1323;
    myNumber = myNumber.toString().split('');

    let formattedNum = numberFormat(myNumber);
    console.log('Number: ', myNumber);
    console.log('New Format: ', formattedNum );


    function numberFormat(num) {
    
        let counter = 1;
        let numFormat = '';

        for (let i = num.length -1; i >= 0; i--) {
        
            if (counter % 3 === 0) {
                if (counter === num.length) {
                    numFormat = num[i] + numFormat;
                } else {
                    numFormat = `,${num[i]}${numFormat}`
                }  
            } else {
                numFormat = num[i] + numFormat
            }

            counter++;

        }

        return numFormat;

    }


</script>
