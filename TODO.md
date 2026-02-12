
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

**Default SMASH behavior:**

You could make SMASH default to safe settings:

```python
# Always add these unless user overrides:
DEFAULT_FLAGS = ['-e', '-o pipefail']  # Safe defaults

# User can opt-out:
"no strict";  # Remove default flags
```