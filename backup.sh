# Defineeri muutujad
$databaseName = "rimi"
$backupPath = "C:/Users/backups/databases"
$backupFileName = "rimi_TravisSova.bak"
$backupFile = "$backupPath/$backupFileName"
$serverAddress = "172.18.24.8"
$serverUsername = "backups"
$serverPassword = "Passw0rd"

# Käivita andmebaasi varundamine
sqlcmd -S localhost -Q "BACKUP DATABASE $databaseName TO DISK='$backupFile' WITH FORMAT"

# Lae varundusserverisse SFTP kaudu
$session = New-SFTPSession -ComputerName $serverAddress -Credential (New-Object PSCredential $serverUsername, (ConvertTo-SecureString $serverPassword -AsPlainText -Force))
Write-SFTPSession -SessionId $session.SessionId -LocalFile $backupFile -RemotePath "/home/backups/$backupFileName" # Kohanda kausta vastavalt oma serverile
Remove-SFTPSession -SessionId $session.SessionId

# Kustuta kohalik varundusfail
Remove-Item $backupFile

# Kuvab teate, et operatsioon on lõpule viidud
Write-Host "Andmebaasi varundamine ja ülekanne on lõpule viidud."