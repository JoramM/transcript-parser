param(
  [string]$infile
)

# remove all chars before the first space
function rm_to_space($in){
  $pos = $in.IndexOf(' ')+1
  return $in.SubString($pos)
}

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
      # #<Time># <Name> <Symbol[<,>,#] optional> <Content>
      if($line.SubString(0,1) -eq "#"){
        $time = $line.SubString(1,5)
        $name = rm_to_space($line.Split(':',3)[1])
        if ($line.Split(':',3).length -gt 2){
          $content = $line.Split(':',3)[2]
        } else {
          $content = $name
          $name = "not found"
        }
      }

      # <Name>: #<Time># <Symbol[<,>,#] optional> <Content>
      if($line.SubString(0,1) -ne "#"){
        $name = rm_to_space($line.Split(':',2)[0])
        $time = $line.Split('#',3)[1]
        if ($line.Split(':',3).length -gt 2){
          $content = $line.Split('#',3)[2]
        } else {
          $content = $name
          $name = "not found"
        }
      }

      # separate symbols
      # remove whitespaces at the beginning
      if ($content -ne $null){
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
      }

      # save row data into an object
      $newrow = New-Object PSObject -Property @{
        Nr = $line_nr
        Zeit = ' ' + $time
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
