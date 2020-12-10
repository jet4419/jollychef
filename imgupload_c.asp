<%@ LANGUAGE="VBSCRIPT" %>
<%
Response.Expires=0
Response.Buffer = TRUE
Response.Clear
byteCount = Request.TotalBytes
RequestBin = Request.BinaryRead(byteCount)
Dim UploadRequest
Set UploadRequest = CreateObject("Scripting.Dictionary")
BuildUploadRequest  RequestBin

'file 1 

'######### Funzione per memorizare un numero casuale attaccato al file uploato 

    Function Password_GenPass( nNoChars, sValidChars )

  Const szDefault = "0123456789"
  
  Randomize
  
   If sValidChars = "" Then
    sValidChars = szDefault    
  End If
  nLength = Len( sValidChars )
  
  For nCount = 1 To nNoChars
    nNumber = Int((nLength * Rnd) + 1)
    sRet = sRet & Mid( sValidChars, nNumber, 1 )
  Next
  Password_GenPass = sRet  
End Function

  sOtherId = Password_GenPass( 10, "" ) 
 

'################################################# Fine funzione numero casuale



contentType = UploadRequest.Item("file1").Item("ContentType")
filepathname = UploadRequest.Item("file1").Item("FileName")
filename = Right(filepathname,Len(filepathname)-InstrRev(filepathname,"\"))
if not filename="" then 
value = UploadRequest.Item("file1").Item("Value")
Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")
Set MyFile = ScriptObject.CreateTextFile(Server.mappath(sOtherId &"_"& filename ))
For i = 1 to LenB(value)
MyFile.Write chr(AscB(MidB(value,i,1)))
Next
MyFile.Close
set myfile = nothing


Sub BuildUploadRequest(RequestBin)
    PosBeg = 1
  PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
  boundary = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
  boundaryPos = InstrB(1,RequestBin,boundary)
    Do until (boundaryPos=InstrB(RequestBin,boundary & getByteString("--")))
    
    Dim UploadControl
    Set UploadControl = CreateObject("Scripting.Dictionary")
    
    Pos = InstrB(BoundaryPos,RequestBin,getByteString("Content-Disposition"))
    Pos = InstrB(Pos,RequestBin,getByteString("name="))
    PosBeg = Pos+6
    PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(34)))
    Name = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
    PosFile = InstrB(BoundaryPos,RequestBin,getByteString("filename="))
    PosBound = InstrB(PosEnd,RequestBin,boundary)
    
    If  PosFile<>0 AND (PosFile<PosBound) Then
      
      PosBeg = PosFile + 10
      PosEnd =  InstrB(PosBeg,RequestBin,getByteString(chr(34)))
      FileName = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
      
      UploadControl.Add "FileName", FileName
      Pos = InstrB(PosEnd,RequestBin,getByteString("Content-Type:"))
      PosBeg = Pos+14
      PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
      
      ContentType = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
      UploadControl.Add "ContentType",ContentType
      
      PosBeg = PosEnd+4
      PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
      Value = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
      Else
      
      Pos = InstrB(Pos,RequestBin,getByteString(chr(13)))
      PosBeg = Pos+4
      PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
      Value = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
    End If
    
  UploadControl.Add "Value" , Value  
    
  UploadRequest.Add name, UploadControl  
    
    BoundaryPos=InstrB(BoundaryPos+LenB(boundary),RequestBin,boundary)
  Loop

End Sub

Function getByteString(StringStr)
 For i = 1 to Len(StringStr)
   char = Mid(StringStr,i,1)
  getByteString = getByteString & chrB(AscB(char))
 Next
End Function

Function getString(StringBin)
 getString =""
 For intCount = 1 to LenB(StringBin)
  getString = getString & chr(AscB(MidB(StringBin,intCount,1))) 
 Next
End Function

Response.Write filename & " Uploaded success! <br>"
end if



'file 2 
'######### Funzione per memorizare un numero casuale attaccato al file uploato 

    Function Password_GenPass( nNoChars, sValidChars )

  Const szDefault = "0123456789"
  
  Randomize
  
   If sValidChars = "" Then
    sValidChars = szDefault    
  End If
  nLength = Len( sValidChars )
  
  For nCount = 1 To nNoChars
    nNumber = Int((nLength * Rnd) + 1)
    sRet = sRet & Mid( sValidChars, nNumber, 1 )
  Next
  Password_GenPass = sRet  
End Function

  sOtherId = Password_GenPass( 10, "" ) 
 

'################################################# Fine funzione numero casuale

contentType = UploadRequest.Item("file2").Item("ContentType")
filepathname = UploadRequest.Item("file2").Item("FileName")
filename2 = Right(filepathname,Len(filepathname)-InstrRev(filepathname,"\"))
if not filename="" then 
value = UploadRequest.Item("file2").Item("Value")
Set ScriptObject = Server.CreateObject("Scripting.FileSystemObject")
Set MyFile = ScriptObject.CreateTextFile(Server.mappath(sOtherId &"_"& filename))
For i = 1 to LenB(value)
MyFile.Write chr(AscB(MidB(value,i,1)))
Next
MyFile.Close
set myfile = nothing


Sub BuildUploadRequest(RequestBin)
    PosBeg = 1
  PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
  boundary = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
  boundaryPos = InstrB(1,RequestBin,boundary)
    Do until (boundaryPos=InstrB(RequestBin,boundary & getByteString("--")))
    
    Dim UploadControl
    Set UploadControl = CreateObject("Scripting.Dictionary")
    
    Pos = InstrB(BoundaryPos,RequestBin,getByteString("Content-Disposition"))
    Pos = InstrB(Pos,RequestBin,getByteString("name="))
    PosBeg = Pos+6
    PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(34)))
    Name = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
    PosFile = InstrB(BoundaryPos,RequestBin,getByteString("filename="))
    PosBound = InstrB(PosEnd,RequestBin,boundary)
    
    If  PosFile<>0 AND (PosFile<PosBound) Then
      
      PosBeg = PosFile + 10
      PosEnd =  InstrB(PosBeg,RequestBin,getByteString(chr(34)))
      FileName = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
      
      UploadControl.Add "FileName", FileName
      Pos = InstrB(PosEnd,RequestBin,getByteString("Content-Type:"))
      PosBeg = Pos+14
      PosEnd = InstrB(PosBeg,RequestBin,getByteString(chr(13)))
      
      ContentType = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
      UploadControl.Add "ContentType",ContentType
      
      PosBeg = PosEnd+4
      PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
      Value = MidB(RequestBin,PosBeg,PosEnd-PosBeg)
      Else
      
      Pos = InstrB(Pos,RequestBin,getByteString(chr(13)))
      PosBeg = Pos+4
      PosEnd = InstrB(PosBeg,RequestBin,boundary)-2
      Value = getString(MidB(RequestBin,PosBeg,PosEnd-PosBeg))
    End If
    
  UploadControl.Add "Value" , Value  
    
  UploadRequest.Add name, UploadControl  
    
    BoundaryPos=InstrB(BoundaryPos+LenB(boundary),RequestBin,boundary)
  Loop

End Sub

Function getByteString(StringStr)
 For i = 1 to Len(StringStr)
   char = Mid(StringStr,i,1)
  getByteString = getByteString & chrB(AscB(char))
 Next
End Function

Function getString(StringBin)
 getString =""
 For intCount = 1 to LenB(StringBin)
  getString = getString & chr(AscB(MidB(StringBin,intCount,1))) 
 Next
End Function

Response.Write filename & " Uploaded success! <br>"
end if 
 


Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" & server.MapPath("prova.mdb")

sql = "SELECT * FROM prova"
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open sql, conn, 3, 3
                     
                     rs.AddNew
  rs.Fields("filename") = Request.Form("filename")
                     rs.Fields("nome") = Request.Form("nome")
  rs.update
    

%>