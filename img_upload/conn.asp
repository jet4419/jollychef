 <%
   	Dim DBConn,debug
	Set DBConn = server.CreateObject("ADODB.connection")	
	DBConn.Open "Driver={SQL Server};Server=;UID=;PWD=;DataBase="

	' Fill in Your Connection Details Here
	'Create a table with the following Fields for the files to be uploaded
	' Here is the Query which can help you
	'CREATE TABLE [dbo].[doc_warhouse] (
	'[doc_id] [int] IDENTITY (1, 1) NOT NULL ,
	'[doc_name] [varchar] (50) NOT NULL ,
	'[doc_type] [varchar] (50) NOT NULL ,
	'[doc_data] [image] NOT NULL 
	') ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	'GO

	'	ALTER TABLE [dbo].[doc_warhouse] WITH NOCHECK ADD 
	'CONSTRAINT [PK_doc_warhouse] PRIMARY KEY  NONCLUSTERED 
	'(
	'	[doc_id]
	')  ON [PRIMARY] 
	'GO
	
 %>
<%
	'*****************************************************************************************	 
	' By : selvi
	' Aim : retrieving data
	' boolean Function GetData(selsql,byref rs)
	'*****************************************************************************************
	function GetData (selsql,byref rs)
		on error resume next
		Set rs = Nothing
		set rs = server.CreateObject("ADODB.RECORDSET")
		rs.CursorLocation = 3
		rs.LockType = 3

		rs.Open selsql, DBConn

		if Err.number <> 0 then	
			GetData= -1
		else
			GetData = rs.recordCount
		end if
		if Err.number <> 0 then	
			Response.Write("<font color=red>Error<br>")
			Response.Write(Err.number & ":" & Err.Description & "<br>")			
			Response.Write(selsql & "<br></font>")
		end if
		on Error goto 0		
	end function

	%>