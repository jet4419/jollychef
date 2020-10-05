
<!--#include file="rc4.inc"-->
<%
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   ':::                                                       :::
   ':::  This script is an example of how to use the RC4      :::
   ':::  algorithm (included in rc4.inc). It can serve as     :::
   ':::  a test harness for algorithm validation, as well.    :::
   ':::                                                       :::
   ':::  Note: This test expects to be called from a FORM     :::
   ':::        POST, and should include the fields PSW (the   :::
   ':::        password) and TXT (the plaintext)              :::
   ':::                                                       :::
   ':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

   dim etime, stime
   dim psw, txt
   dim strTemp
   dim x

   etime = 0
   stime = 0

   psw = request.form("psw")
   txt = request.form("txt")

   response.write "<html><body><h3>RC4 Test Harness</h3><b>Plaintext was:</b> " & txt & "<br>"

   stime = timer
   strTemp = EnDeCrypt(txt, psw)
   etime = cdbl(timer - stime)

   ' Here we display the encrypted text in urlencoded form.
   ' The reason it's urlencoded is because it is essentially now
   ' "binary" data, which may mess up many browser displays...
   response.write "<b>Encrypted text:</b> " & server.urlencode(strTemp) & "<br><br>"

   response.write "<b>Hex dump of encrypted string:</b><br><pre>"
   for x = 1 to len(strTemp)
      response.write right(string(2,"0") & hex(asc(mid(strTemp, x, 1))),2) & " "
      if x mod 26 = 0 then response.write vbCRLF
   next

   txt = EnDeCrypt(strTemp, psw)

   response.write  "</pre><br><br><b>Decrypted text:</b><br>" & txt & "<br><pre>"
   for x = 1 to len(txt)
      response.write right(string(2,"0") & hex(asc(mid(txt, x, 1))),2) & " "
      if x mod 26 = 0 then response.write vbCRLF
   next

   response.write "</pre><br><br><b>Encryption took:</b> " & etime & " seconds (&plusmn;55 msec)"
   response.write "</body></html>"
   response.end
%>