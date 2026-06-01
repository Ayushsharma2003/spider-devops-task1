# Vault Sweep

## Overview

Vault Sweep is a Bash-based security scanner designed to identify potential security issues in shell scripts and configuration files. It scans for dangerous commands, unsafe file permissions, suspicious executable files, and malformed environment variable files.

## Features

* Detects dangerous commands such as `rm -rf`, `reboot`, and `shutdown`
* Detects files with dangerous permissions (`777`)
* Allows users to fix unsafe permissions
* Logs warnings to `scan.log`
* Sanitizes environment variable files and generates `.env.sanitized`
* Detects suspicious executable files
* Displays Git author information for flagged files

## How to Run

```bash
chmod +x vault_sweep.sh
./vault_sweep.sh
```

## Project Structure

```text
vault_sweep.sh      - Main security scanner
scan.log            - Warning logs
.env.sanitized      - Sanitized environment file
test_files/         - Test files used for validation
testfolder/         - Additional shell script files
```

## Technologies Used

* Bash Scripting
* Linux Commands
* Git
* Regular Expressions (Regex)

## Author

Ayush Birthla
