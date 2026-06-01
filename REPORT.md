# REPORT

## 1. Dangerous Patterns Identified

The following patterns were considered dangerous:

### Destructive Commands

* `rm -rf`
* `reboot`
* `shutdown`

These commands can delete files, restart the system, or shut down the machine. Accidental or malicious execution of these commands can cause data loss or service disruption.

### Insecure Permissions

Files with permission `777` were flagged as dangerous.

Reason:

* Any user can read, write, and execute the file.
* Attackers can modify scripts and execute malicious code.

### Suspicious Executables

Unexpected executable files located within the scanned directory were flagged.

Reason:

* Executable files may contain malicious payloads.
* Hidden or unexpected executables are common indicators of compromise.

### Git Audit Information

For flagged files, Git history was checked to identify the last contributor.

Reason:

* Helps determine ownership and accountability.
* Useful during incident investigation.

---

## 2. Environment File Validation

Only correctly formatted environment variables were accepted.

Valid examples:

```text
API_KEY=spider26
PORT=3000
_DEBUG=false
```

### Rejected Patterns

#### Spaces around '='

Rejected:

```text
KEY = value
```

Reason:
Environment variables should follow the format:

```text
KEY=value
```

#### Invalid Variable Names

Rejected:

```text
SERVER-NAME=x
```

Reason:
Variable names should contain only uppercase letters, digits, and underscores.

#### Quoted Values

Rejected:

```text
USER="admin"
```

Reason:
The task specification marked unnecessary quotes as invalid.

#### Sensitive Variables

Rejected:

```text
PASSWORD=secret123
TOKEN=abc123
SECRET=mysecret
```

Reason:
Sensitive credentials should not be copied into sanitized output files.

#### PATH Modification

Rejected:

```text
export PATH=$PATH:/tmp
```

Reason:
Modifying system paths may introduce security risks and unexpected behavior.

---

## 3. Technical Challenges and Solutions

### Recursive File Scanning

Challenge:
Scanning all files and folders recursively, including hidden files.

Solution:
Used the `find` command to traverse directories automatically.

### Permission Detection

Challenge:
Identifying files with dangerous permissions.

Solution:
Used `stat` to retrieve file permission values and checked for unsafe permissions such as `777`.

### Environment File Validation

Challenge:
Separating valid and invalid environment variables.

Solution:
Used Bash regular expressions to validate variable names and formats.

### Executable Detection

Challenge:
Finding executable files while avoiding unnecessary results from Git internals.

Solution:
Excluded the `.git` directory during scanning and checked executable files using `find`.

### Git Integration

Challenge:
Identifying contributors of suspicious files.

Solution:
Used Git commands to retrieve author information and include it in scan results.

---

## Conclusion

The project successfully detects dangerous shell scripts, insecure permissions, suspicious executables, and malformed environment files. It also generates logs, creates sanitized environment files, and provides basic Git-based auditing information for flagged files.
