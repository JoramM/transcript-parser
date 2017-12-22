# transcript-parser
A script for creating a *.csv file from the *.txt output of a (bad?) transcription software

## Preparation

Run the PowerShell and set the Execuation-Policy to Unrestricted
```PowerShell
Set-ExecutionPolicy Unrestricted
```

## Supported Input Format
```
#<Time># <Name>: <Symbol[<,>,#] optional> <Content>
```
also supported:
```
<Name>: #<Time># <Symbol[<,>,#] optional> <Content>
```

## Run the parser
1. Download the repository or at least the `parser.ps1` file
2. `cd` into the directory with the `parser.ps1` file e.g.:
```
cd C:\Users\User\dev\transcript-parser
```
3. Run the script. Do not forget to set the `-infile` parameter, which expects the path to your (`*.txt`) transcript file
```PowerShell
parser.ps1 -infile 'path/to/transcript.txt'
```
