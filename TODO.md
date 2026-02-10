Bash has a ton of features you could expose with cleaner syntax:

**Control flow:**
- `switch/case` - bash has `case ... esac`
- `try/catch` - bash has trap for error handling
- `break/continue` - bash has these
- `return` in functions - bash supports this

**Data structures:**
- Associative arrays (hash maps/objects): `declare -A map`
- Regular arrays (you're adding)
- Strings with methods (substring, replace, etc.)

**Functions:**
- Named parameters instead of `$1, $2, $3`
- Return values (bash only returns exit codes, not values)
- Local variables: `local x=value`

**String operations:**
```javascript
// SMASH could have:
let result = str.substring(0, 5);
let parts = str.split(",");
let upper = str.toUpperCase();

// Bash has:
result="${str:0:5}"
IFS=',' read -ra parts <<< "$str"
upper="${str^^}"
```

**Math operations:**
```javascript
// SMASH:
let result = x + y * 2;
let mod = x % 3;

// Bash:
result=$((x + y * 2))
mod=$((x % 3))
```

**File operations:**
```javascript
// SMASH could have:
if (file.exists("test.txt")) { }
if (dir.isEmpty("/tmp/foo")) { }

// Bash has:
if [[ -f "test.txt" ]]; then
if [[ -z $(ls -A /tmp/foo) ]]; then
```

**Process management:**
```javascript
// Background jobs:
let pid = background(() => {
    long_running_task();
});
wait(pid);

// Bash:
long_running_task &
pid=$!
wait $pid
```

**Pattern matching (case):**
```javascript
// SMASH:
switch (var) {
    case "option1":
        echo "one";
        break;
    case "option2":
        echo "two";
        break;
    default:
        echo "other";
}

// Bash:
case "$var" in
    option1)
        echo "one"
        ;;
    option2)
        echo "two"
        ;;
    *)
        echo "other"
        ;;
esac
```

**Error handling:**
```javascript
// SMASH:
try {
    risky_command();
} catch (error) {
    echo "Failed: " + error;
}

// Bash equivalent:
if ! risky_command; then
    echo "Failed: $?"
fi
```

**Associative arrays (objects):**
```javascript
// SMASH:
let config = {
    "host": "localhost",
    "port": 8080,
    "debug": true
};

echo config["host"];

// Bash:
declare -A config=(
    [host]="localhost"
    [port]=8080
    [debug]=true
)

echo "${config[host]}"
```

**Built-in tests:**
```javascript
// SMASH could make these readable:
if (file.exists(path)) { }
if (file.isDirectory(path)) { }
if (file.isReadable(path)) { }
if (string.isEmpty(str)) { }
if (number.isEven(x)) { }

// Instead of bash:
if [[ -f "$path" ]]; then
if [[ -d "$path" ]]; then
if [[ -r "$path" ]]; then
if [[ -z "$str" ]]; then
if (( x % 2 == 0 )); then
```

**My suggestions for priority:**

**v1.0-2 (keep it focused):**
- Arrays (basic)
- While loops (you have the stub)
- Logical operators: `&&`, `||`, `!`
- Switch/case (very useful)

**v1.0-3:**
- Associative arrays (objects)
- String methods
- Math expressions without `$(( ))`
- File test helpers

**v1.0-4:**
- Try/catch error handling
- Function improvements (named params)
- Background jobs/async
- Advanced array methods

**Don't transpile:**
- Promises/async-await (doesn't map well)
- Classes (too complex for shell)
- Modules/imports (not how bash works)


---

# Imports.

**SMASH syntax:**
```javascript
// Import other scripts
import("./lib/utils.sh");
import("/usr/local/lib/helpers.smash");
import("../config.sh");

// Or even cleaner:
import "./lib/utils.sh";
import "/usr/local/lib/helpers.smash";
```

**Transpiles to:**
```bash
source "./lib/utils.sh"
source "/usr/local/lib/helpers.smash"
source "../config.sh"
```

**Implementation:**
```python
def transpile_smash(code):
    # ... existing preprocessing ...
    
    # Import statements: import("path") or import "path"
    code = re.sub(
        r'import\s*\(\s*["\']([^"\']+)["\']\s*\)\s*;?',
        r'source "\1"',
        code
    )
    
    code = re.sub(
        r'import\s+["\']([^"\']+)["\']\s*;?',
        r'source "\1"',
        code
    )
    
    # ... rest of transpilation ...
```

**Enhanced features:**

```javascript
// Import and auto-transpile .smash files
import "./helpers.smash";  // Transpile first, then source

// Import with error checking
import("./config.sh") || exit 1;

// Multiple imports
import "./lib1.sh";
import "./lib2.sh";
import "./lib3.sh";
```

**Advanced idea - import specific functions:**
```javascript
// This would be harder but powerful:
import { greet, calculate } from "./utils.smash";

// Could generate:
source "./utils.smash"
# (make available only greet and calculate)
```

**Practical example:**

```javascript
// main.smash
import "./config.smash";
import "./logger.smash";

log("Starting application...");

if (environment == "production") {
    log("Production mode enabled");
    deploy();
}
```

```javascript
// config.smash
let environment = "production";
let app_name = "myapp";
let version = "1.0.0";
```

```javascript
// logger.smash
function log(message) {
    let timestamp = $(date "+%Y-%m-%d %H:%M:%S");
    echo "[" + timestamp + "] " + message;
}
```

**Considerations:**

1. **Path resolution** - relative to what? The calling script or SMASH itself?
2. **Circular imports** - bash will source multiple times
3. **Auto-transpile .smash imports** - should SMASH automatically transpile imported .smash files?
4. **.sh vs .smash** - treat differently or same?

**My recommendation:**

**v1.0-2:**
- Basic import: `import "path";` → `source "path"`
- Works with both .sh and .smash files
- Simple path resolution (relative to script directory)

**v1.0-3:**
- Auto-transpile .smash imports
- Import guards (prevent double-sourcing)
- Better error messages

# Error handling

Brilliant! Flags/pragmas would make SMASH scripts more robust. Here's how:

**SMASH syntax:**
```javascript
"use strict";        // Enable strict mode
"use pipefail";      // Bash: set -o pipefail
"use errexit";       // Bash: set -e (exit on error)
"use nounset";       // Bash: set -u (error on undefined vars)
"use xtrace";        // Bash: set -x (debug/trace mode)

// Or combined:
"use strict pipefail errexit";
```

**Transpiles to:**
```bash
set -euo pipefail    # Common combo for robust scripts
# or individually:
set -o pipefail
set -e
set -u
set -x
```

**Implementation:**
```python
def transpile_smash(code):
    # ... preprocessing ...
    
    # Detect "use X" directives at the top
    use_directives = []
    
    # "use strict" and bash flags
    if re.search(r'["\']use\s+strict["\']', code):
        use_directives.append('-e')  # errexit
        use_directives.append('-u')  # nounset
    
    if re.search(r'["\']use\s+pipefail["\']', code):
        use_directives.append('-o pipefail')
    
    if re.search(r'["\']use\s+errexit["\']', code):
        use_directives.append('-e')
    
    if re.search(r'["\']use\s+nounset["\']', code):
        use_directives.append('-u')
    
    if re.search(r'["\']use\s+xtrace["\']', code):
        use_directives.append('-x')
    
    # Remove the directives from code
    code = re.sub(r'["\']use\s+[^"\']+["\'];?\n?', '', code)
    
    # Add set command at the beginning
    if use_directives:
        unique_flags = list(dict.fromkeys(use_directives))  # Remove dupes
        set_cmd = 'set ' + ' '.join(unique_flags) + '\n\n'
        code = set_cmd + code
    
    # ... rest of transpilation ...
```

**Practical examples:**

```javascript
#!/usr/bin/env smash
"use strict pipefail";

// This script will:
// - Exit on any error (errexit)
// - Error on undefined variables (nounset)  
// - Fail pipelines if any command fails (pipefail)

let config_file = "/etc/myapp/config";

cat $config_file | grep "setting" | awk '{print $2}';
// If any part of pipeline fails, script exits
```

**More directive ideas:**

```javascript
"use noclobber";     // set -C (don't overwrite files with >)
"use vi-mode";       // set -o vi
"use emacs-mode";    // set -o emacs
"use verbose";       // set -v (print commands as read)

// Shebang alternatives:
"use bash-4.0";      // Require minimum bash version
"use posix";         // set -o posix (POSIX mode)
```

**Error handling directives:**
```javascript
"use errexit";       // Exit on error
"no errexit";        // Disable exit on error for a section

// Could even do scoped:
{
    "no errexit";    // Errors OK in this block
    risky_command() || echo "Failed but continuing";
}
// errexit restored here
```

**Combination patterns:**
```javascript
// Production script - strict everything:
"use strict pipefail errexit nounset";

// Development script - more forgiving:
"use pipefail";

// Debug mode:
"use xtrace verbose";
```

**Implementation improvements:**

```python
# Support multiple flags in one directive
def parse_use_directive(directive_str):
    """Parse 'use strict pipefail errexit' into bash flags"""
    flags = []
    
    mapping = {
        'strict': ['-e', '-u'],
        'pipefail': ['-o pipefail'],
        'errexit': ['-e'],
        'nounset': ['-u'],
        'xtrace': ['-x'],
        'verbose': ['-v'],
        'noclobber': ['-C'],
        'posix': ['-o posix']
    }
    
    parts = directive_str.replace('use', '').strip().split()
    for part in parts:
        if part in mapping:
            flags.extend(mapping[part])
    
    return flags

# Then in transpile_smash:
code = re.sub(
    r'["\']use\s+([^"\']+)["\'];?',
    lambda m: '',  # Remove directive, we'll add flags at top
    code
)
```

**Default SMASH behavior:**

You could make SMASH default to safe settings:

```python
# Always add these unless user overrides:
DEFAULT_FLAGS = ['-e', '-o pipefail']  # Safe defaults

# User can opt-out:
"no strict";  # Remove default flags
```

**My recommendation:**

**v1.0-2:**
- Basic `"use strict"` → `set -euo pipefail`
- Individual flags: `"use pipefail"`, `"use errexit"`, etc.
- Combined: `"use strict pipefail"`

**v1.0-3:**
- Scoped flag control
- Version requirements
- Custom error handlers

This would make SMASH scripts production-ready and safer by default. Add it?