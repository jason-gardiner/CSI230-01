# Storyline: Send an email.

# Body of the email
# Variable can have an underscore or any alphanumeric value
$msg = "Exterminate!"

write-host -BackgroundColor Red -ForegroundColor White $msg

# Email From Address
$email = "jason.gardiner@mymail.champlain.edu"

# To address
$toEmail = "deployer@csi-web"

# Sending the email
Send-MailMessage -From $email -To $toEmail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71