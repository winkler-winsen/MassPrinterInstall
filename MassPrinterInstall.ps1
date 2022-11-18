# CSV text file for installing printer on computer. One hostname per line
$csvfile = '.\MassPrinterInstall.csv'
# printer hostname or IP
$prhostname = 'DR5359'
# printer driver name / pls see Get-Printer output
$drivername = 'Lexmark Universal v2 XL'
# CSV text file list Computer non succeeded
$notdonecsv = '.\notdonecsv.txt'
# CSV text file list Computer succeeded
$donecsv = '.\donecsv.txt'

# read input file
$pcs = Import-Csv $csvfile -Header Name
$pcs | Out-GridView -Title "List of Computers to intall"

#recreate successfull and unsuccessfull output files
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
    Write-Progress -Activity "Trying Computer to Install $prhostname on $pc" -Status "Trying $c/$l" -PercentComplete $percent

    Write-Host $pc.Name
    if (Test-Connection $pc.Name -Count 1 -Quiet)
    {  
        # 
        # add local Printer
        #
        Add-PrinterPort -ComputerName $pc.Name -Name $prhostname.ToUpper() -PrinterHostAddress $prhostname.ToUpper() -Verbose
        Add-Printer -ComputerName $pc.Name -Name $prhostname.ToUpper() -DriverName $drivername -PortName $prhostname.ToUpper() -Verbose

        #
        # add remote printer e.g. via LRQ queue
        #
        # Add-PrinterPort -ComputerName $pc.Name -LprHostAddress "TA0077" -LprQueueName "TA0077-direct" -LprByteCounting -Name "TA0077-direct" -Verbose
        # Add-Printer -ComputerName $pc.Name -PortName "TA0077-direct" -DriverName "4007ci KX" -Name "TA0077-direct" -Verbose
        
        Write-Output $pc.Name | Out-File $donecsv -Append

    } else
    {
        Write-Host "Fehler: " $pc.Name " not reachable."
        Write-Output $pc.Name | Out-File $notdonecsv -Append
    }
}

Write-Output "Successfull list of computer in $donecsv"
Write-Output "Unsuccessfull list of computer in $notdonecsv"
