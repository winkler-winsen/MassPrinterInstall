# File for installing printer on computer. One hostname per line
$csvfile = '.\MassPrinterInstall.csv'
# Drucker Hostname oder IP
$prhostname = 'DR5359'
# Druckertreiber-Name
$drivername = 'Lexmark Universal v2 XL'
# File list Computer non succeeded
$notdonecsv = '.\notdonecsv.txt'
# File list Computer succeeded
$donecsv = '.\donecsv.txt'

$pcs = Import-Csv $csvfile -Header Name
$pcs | Out-GridView


Remove-Item $notdonecsv -Force | Out-Null
New-Item -Path $notdonecsv -ItemType "file" -Force | Out-Null
Remove-Item $donecsv -Force | Out-Null
New-Item -Path $donecsv -ItemType "file" -Force | Out-Null

$c=0

foreach ($pc in $pcs)
{
    $c++
    $percent = $c / $pcs.Length * 100
    $l = $pcs.Length
    Write-Progress -Activity "Trying Computer to Install $prhostname" -Status "Trying $c/$l" -PercentComplete $percent

    Write-Host $pc.Name
    if (Test-Connection $pc.Name -Count 1 -Quiet)
    {  
        Add-PrinterPort -ComputerName $pc.Name -Name $prhostname.ToUpper() -PrinterHostAddress $prhostname.ToUpper() -Verbose

        Add-Printer -ComputerName $pc.Name -Name $prhostname.ToUpper() -DriverName $drivername -PortName $prhostname.ToUpper() -Verbose
        
        Write-Output $pc.Name | Out-File $donecsv -Append
        
    } else
    {
        Write-Host "Fehler: " $pc.Name " not reachable."
        Write-Output $pc.Name | Out-File $notdonecsv -Append
    }
}

Write-Output "Successfull list of computer in $donecsv"
Write-Output "Unsuccessfull list of computer in $notdonecsv"
