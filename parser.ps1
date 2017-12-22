param(
  [string]$infile
)

Write-Host
Write-Host "========================"

if ($infile -eq ""){
  Write-Host "Bitte den Dateinamen der Eingabedatei angeben:"
  Write-Host
  Write-Host "> script_name.ps1 -infile 'meine-datei.txt'"
  Write-Host "========================"
  Write-Host
  return
}
Write-Host "Eingabedatei:" $infile

$csv_encoding = "UTF8"

$curr_dir = (Get-Item -Path ".\" -Verbose).FullName
$reader = [System.IO.File]::OpenText($curr_dir + "\" + $infile)
$outfile = '.\table.csv'
$csv_separator = ';'
$result = @()

Write-Host
Write-Host "starte Konvertierung."
Write-Host

$line_nr = 1
while($null -ne ($line = $reader.ReadLine())) {
    if($line.length -ne 0){
      if($line.SubString(0,1) -eq "#"){
        # #<Time># <Name> <Symbol[<,>,#] optional> <Content>
        $time = $line.SubString(2,4)
        $name = $line.Split(':',3)[1]
        $name = $name.substring($name.length - 1,1)
        # symbol is extracted later
        $content = $line.Split(':',3)[2]
      }
      if($line.SubString(0,1) -ne "#"){
        # <Name>: #<Time># <Symbol[<,>,#] optional> <Content>
        $name = $line.Split(':',2)[0]
        $time = $line.Split('#',3)[1]
        $content = $line.Split('#',3)[2]
      }

      # Some formatting stuff
      # remove whitespaces at the beginning
      while($content.StartsWith(" ")){
        $content = $content.TrimStart(" ")
      }

      # check if there is a symbol at the beginning of the content
      if($content.StartsWith('#') -or $content.StartsWith('>') -or $content.StartsWith('<')){
        $symbol = $content.SubString(0,1)
        $content = $content.TrimStart($symbol + " ")
      }else{
        $symbol = ""
      }

      # remove whitespaces at the beginning
      while($content.StartsWith(" ")){
        $content = $content.TrimStart(" ")
      }

      # save row data into an object
      $newrow = New-Object PSObject -Property @{
        Nr = $line_nr
        Zeit = $time
        Name = $name
        Symbol = $symbol
        Inhalt = $content
      }
      $result += $newrow
      $line_nr++
    }
}

# write result to a csv file
$result | Select-Object Nr, Zeit, Name, Symbol, Inhalt | Export-Csv $outfile -notypeinformation -Delimiter ";" -Encoding $csv_encoding

Write-Host "ferdsch! (" ($line_nr-1) "Zeilen )"
Write-Host "========================"
Write-Host
