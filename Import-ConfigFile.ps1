function Import-ConfigFile {
    <#
    .SYNOPSIS
        Imports config file via provided SourcePath based on its file type.
    .DESCRIPTION
        Imports config file via provided SourcePath based on its file type to be used with dot notation and iterated through
    .NOTES
        Author: Nick Welter
        Function Created: 03/28/2024
        Function Updated: 04/17/2024

        Currently supported file types:
        .json
        .xml
        .ini
        .txt
    .EXAMPLE
        Import-ConfigFile.ps1 -Verbose
        Imports config file via provided SourcePath based on its file type. 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SourcePath
    )
    begin {
        #- Test-Path of Config File
        Write-Verbose -Message "Checking file path of provided config file."
        if(!(Test-Path -Path $SourcePath -ErrorAction Stop)){
            Write-Error -Message "File path `"$SourcePath`" does not exist or cannot be accessed."
            throw
        }else{
            try {
                $ConfigFileSource = Get-Item -Path "$SourcePath" -Verbose -ErrorAction Stop
                Write-Verbose -Message "Config file found."
            }
            catch {
                Write-Error -Message "Failed to get item at path '$SourcePath'. Error: $_"
                throw
            }
        }
    }
    process {
        #- import its contents
        switch ($ConfigFileSource.Extension) {
            ".json" {
                $ConfigFile = Get-Content -Path $SourcePath | Out-String | ConvertFrom-Json 
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a JSON file"
            }
            ".xml" {
                $XMLFile = Get-Content -Path $SourcePath; $ConfigFile = [xml]$XMLFile
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a XML file"
            }
            ".ini" {
                $ConfigFile = Get-Content -Path $SourcePath | Select-Object -Skip 1 | ConvertFrom-StringData
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a INI file"
            }
            Default {
                try {
                    $ConfigFile = Get-Content -Path $SourcePath
                    Write-Verbose -Message "$($ConfigFileSource.Name) has been imported with default settings."
                }
                catch {
                    Write-Error -Message "Failed to read the configuration file at path '$SourcePath'. Error: $_"
                    throw
                }
            }
        }
    }
    end {
        #- Return the contents of the config file
        return $ConfigFile
    }
}
