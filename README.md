# transcript-parser
A script for creating a *.csv file from the *.txt output of a (bad?) transcription software

## Preparation

Run the PowerShell and set the Execuation-Policy to Unrestricted
```PowerShell
Set-ExecutionPolicy Unrestricted
```

## Run the parser
1. `cd` into the directory with the `parser.ps1` file
2. Run the script. Do not forget to set the `-infile` parameter, which expects the path to your (`*.txt`) transcript file
```
parser.ps1 -infile 'path/to/transcript.txt'
```
