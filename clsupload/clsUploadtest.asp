<!DOCTYPE html>
<html>
<head>
<!--#include file="clsUpload.asp"-->
</head>
<body>

	<form action="clsUploadTEST.asp" enctype="multipart/form-data" method="POST">
		<p> File Name: <input type="file" id="fileUpload" name="txtFile" required> </p>
		<p> <input type="submit"  name="cmdSubmit" value="Submit"> </p>
	</form>
	
<%

	Set o = New clsUpload

	if o.Exists("cmdSubmit") then

		'get client file name without path
		sFileSplit = split(o.FileNameOf("txtFile"), "\")
		sFile = sFileSplit(Ubound(sFileSplit))

		o.FileInputName = "txtFile"
		o.FileFullPath = Server.MapPath("/img") & "\" & sFile
		o.save

		if o.Error = "" then
			Response.Write "Success. File saved to  " & o.FileFullPath
			Response.Write "<br> File name: "&sFile
		else
			Response.Write "Failed due to the following error: " & o.Error
		end if

	end if
	Set o = nothing
%>

<script>

	const fileContainer = document.getElementById('fileUpload');
	

	fileContainer.onchange = function(e) {
		
		const [file] = e.currentTarget.files;
		let fileSize = (file.size / 1000) / 1000;
		fileSize = fileSize.toFixed(2);

		console.log(fileSize + ' MB');

		if (fileSize > 3) console.error('file size is too big');
		else console.log('File uploaded successfully');
	

    };

</script>

</body>
</html>