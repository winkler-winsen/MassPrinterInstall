# MassPrinterInstall
Mass printer install with import via CSV / text file, each hostname per line. You need administrative rights on these computers.

## Configuration
```$csvfile = '.\MassPrinterInstall.csv'``` CSV text file for installing printer on computer. One hostname per line

```$prhostname = 'DR5359'``` printer hostname or IP

```$drivername = 'Lexmark Universal v2 XL'``` printer driver name / pls see Get-Printer output

```$notdonecsv = '.\notdonecsv.txt'``` CSV text file list Computer non succeeded

```$donecsv = '.\donecsv.txt'``` CSV text file list Computer succeeded

