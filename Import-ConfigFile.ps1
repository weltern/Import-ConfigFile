function Import-ConfigFile {
    <#
    .SYNOPSIS
        Imports config file via provided SourcePath based on its file type.
    .DESCRIPTION
        Imports config file via provided SourcePath based on its file type to be used with dot notation and iterated through
    .NOTES
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
                $SourcePath = Get-Item -Path "$SourcePath" -ErrorAction Stop
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
        switch ($SourcePath.Extension) {
            ".json" {$ConfigFile = Get-Content -Path $SourcePath | Out-String | ConvertFrom-Json }
            ".xml" {$XMLFile = Get-Content -Path $SourcePath; $ConfigFile = [xml]$XMLFile }
            ".ini" {$ConfigFile = Get-Content -Path $SourcePath | Select-Object -Skip 1 | ConvertFrom-StringData }
            Default {
                try {
                    $ConfigFile = Get-Content -Path $SourcePath
                }
                catch {
                    Write-Error -Message "Failed to read the configuration file at path '$SourcePath'. Error: $_"
                    throw
                }
            }
        }
        Write-Verbose -Message "Config File Imported."
    }
    end {
        #- Return the contents of the config file
        return $ConfigFile
    }
}