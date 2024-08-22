
# Import-ConfigFile.ps1

## Overview

`Import-ConfigFile` is a PowerShell function designed to import a configuration file based on its file type. The function supports `.json`, `.xml`, `.ini`, and `.txt` file formats. Once imported, the content of the configuration file can be accessed using dot notation and iterated through for further processing.

## Features

- **File Path Verification:** The function checks if the provided file path exists and is accessible before attempting to import the file.
- **Multi-Format Support:** Supports importing configuration files in JSON, XML, INI, and text formats.
- **Verbose Output:** Provides detailed verbose output during the import process to help with debugging.

## Supported File Types

- `.json` - JSON formatted configuration files.
- `.xml` - XML formatted configuration files.
- `.ini` - INI formatted configuration files.
- `.txt` - Text files (default handling).

## Usage

### Syntax

```powershell
Import-ConfigFile.ps1 -FilePath <string> [-Verbose]
```

### Parameters
- FilePath (string): Mandatory. The file path of the configuration file to be imported.
- Verbose (switch): Optional. Provides detailed output during the import process.

### Example
```powershell
Import-ConfigFile.ps1 -FilePath "C:\path\to\config.json" -Verbose
This command imports a JSON configuration file located at C:\path\to\config.json and provides verbose output during the import process.
```

## License
This script is released under the GPL-3.0 License.

## Contributions
Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to submit a pull request or open an issue in the repository.
