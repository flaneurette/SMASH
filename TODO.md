Pattern matching (case):

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

Associative arrays (objects):

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

Default SMASH behavior:

We could make SMASH default to safe settings:

```python
# Always add these unless user overrides:
DEFAULT_FLAGS = ['-e', '-o pipefail']  # Safe defaults

# User can opt-out:
"no strict";  # Remove default flags
```