function Import-ConfigFile {
    <#
    .SYNOPSIS
        Imports config file via provided FilePath based on its file type.
    .DESCRIPTION
        Imports config file via provided FilePath based on its file type to be used with dot notation and iterated through
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
        Imports config file via provided FilePath based on its file type. 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FilePath
    )
    begin {
        #- Test-Path of Config File
        Write-Verbose -Message "Checking file path of provided config file."
        if(!(Test-Path -Path $FilePath -ErrorAction Stop)){
            Write-Error -Message "File path `"$FilePath`" does not exist or cannot be accessed."
            throw
        }else{
            try {
                $ConfigFileSource = Get-Item -Path "$FilePath" -Verbose -ErrorAction Stop
                Write-Verbose -Message "Config file found."
            }
            catch {
                Write-Error -Message "Failed to get item at path '$FilePath'. Error: $_"
                throw
            }
        }
    }
    process {
        #- import its contents
        switch ($ConfigFileSource.Extension) {
            ".json" {
                $ConfigFile = Get-Content -Path $FilePath | Out-String | ConvertFrom-Json 
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a JSON file"
            }
            ".xml" {
                $XMLFile = Get-Content -Path $FilePath; $ConfigFile = [xml]$XMLFile
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a XML file"
            }
            ".ini" {
                $ConfigFile = Get-Content -Path $FilePath | Select-Object -Skip 1 | ConvertFrom-StringData
                Write-Verbose -Message "$($ConfigFileSource.Name) has been imported from a INI file"
            }
            Default {
                try {
                    $ConfigFile = Get-Content -Path $FilePath
                    Write-Verbose -Message "$($ConfigFileSource.Name) has been imported with default settings."
                }
                catch {
                    Write-Error -Message "Failed to read the configuration file at path '$FilePath'. Error: $_"
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
