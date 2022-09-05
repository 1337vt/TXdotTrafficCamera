$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36"
$response = Invoke-RestMethod -UseBasicParsing -Uri "https://its.txdot.gov/its/DistrictIts/GetCctvSnapshotByIcdId?icdId=LP%20410%20at%20Rolling%20Ridge&districtCode=SAT" `
-WebSession $session `
-Headers @{
"authority"="its.txdot.gov"
  "method"="GET"
  "scheme"="https"
  "accept"="application/json"
  "dnt"="1"
  "referer"="https://its.txdot.gov/its/District/SAT/cameras"
} `
-ContentType "application/json; charset=utf-8"
$name = "$(get-location)" + '\' + $response.icd_Id.Replace(" ","") + ([datetime]::Now).Ticks + ".jpg"
$imageBytes = [System.Convert]::FromBase64String($response.snippet)
$memoryStream = [System.IO.MemoryStream][System.Convert]::FromBase64String($response.snippet)
$image = [System.Drawing.Bitmap][System.Drawing.Image]::FromStream($memoryStream)

#Saves image to user's Downloads folder.
#$image.Save($name, [System.Drawing.Imaging.ImageFormat]::jpeg)

Add-Type -AssemblyName 'System.Windows.Forms'

[System.Windows.Forms.Application]::EnableVisualStyles()
$form = new-object Windows.Forms.Form

$form.Text = "Image Viewer"
$form.Width = $image.Size.Width + 16;
$form.Height =  $image.Size.Height + 39;
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Width =  $image.Size.Width;
$pictureBox.Height =  $image.Size.Height;
$pictureBox.Image = $image;
$form.controls.add($pictureBox)
$form.Add_Shown( { $form.Activate() } )
$form.ShowDialog()

