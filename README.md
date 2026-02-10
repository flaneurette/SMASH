# SMASH - Simple Modern Advanced SHell

Introducing: SMASH! - a JavaScript-style shell scripting.

```
    ███████╗███╗   ███╗ █████╗ ███████╗██╗  ██╗
    ██╔════╝████╗ ████║██╔══██╗██╔════╝██║  ██║
    ███████╗██╔████╔██║███████║███████╗███████║
    ╚════██║██║╚██╔╝██║██╔══██║╚════██║██╔══██║
    ███████║██║ ╚═╝ ██║██║  ██║███████║██║  ██║
    ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
```

Tired of bash's `seventies` syntax? Write shell scripts with modern JavaScript-like syntax that transpiles to bash.

## How it works

SMASH is a runtime transpiler `it converts your JavaScript .smash` like syntax to bash, instantly in memory and executes it:

```
Your SMASH code
      |
Python transpiler (regex-based)
      |
Generated bash code
      |
Executed by bash
```

## Features

- JavaScript-like syntax. Familiar to millions of developers
- All Linux commands work. Pipes, redirects, grep, awk, everything
- Transpiles to bash. Works everywhere bash works
- No runtime dependencies. Just Python 3 and bash
- Drop-in replacement. Use SMASH for new scripts, keep old bash scripts
- Debug mode. See the generated bash code

## Example .smash
```
// Write this beautiful code:
let name = "world";

if (name == "world") {
    echo "Hello, " + name + "!";
}

// Instead of this:
# name="world"
# if [ "$name" = "world" ]; then
#     echo "Hello, $name!"
# fi
```

## Quick Start

Install:

```
# Download SMASH
curl -o smash https://raw.githubusercontent.com/flaneurette/smash/main/smash
chmod +x smash
sudo mv smash /usr/local/bin/

# Or just copy it to your project
wget https://raw.githubusercontent.com/flaneurette/smash/main/smash
chmod +x smash
```

Test it:

```
./smash examples/hello.smash
```

Install it

```
sudo ./install.sh
```

Write your first script:

```
// hello.smash
let name = "SMASH";
echo "Hello from " + name + "!";
```

Run it:

```
smash hello.smash
# Output: Hello from SMASH!
```

## Syntax Guide

### Variables

```
// SMASH
let name = "John";
let count = 10;
let files = $(ls *.txt);

// Becomes bash:
// name="John"
// count=10
// files=$(ls *.txt)
```

### If/Else Statements

```
// SMASH
if (environment == "production") {
    echo "Running in production";
} else if (environment == "staging") {
    echo "Running in staging";
} else {
    echo "Running in development";
}

// String comparison
if (status != "active") {
    echo "Service is down!";
}

// Numeric comparison
if (count > 10) {
    echo "Too many items";
}
```

### Loops

```
// For loop
for (let file in *.log) {
    echo "Processing: " + file;
    cat $file | grep ERROR;
}

// While loop (coming soon)
let i = 0;
while (i < 10) {
    echo "Count: " + i;
    i = $(expr $i + 1);
}
```

### Comments

```
// Single line comment

/*
   Multi- line
   comment
*/

let x = "value"; // Inline comment
```

### String Concatenation

```
let name = "world";
echo "Hello, " + name + "!";

// Becomes: echo "Hello, $name!"
```

### All Bash Commands Work!

```
// Everything just passes through to bash
docker ps | grep nginx;
curl -s https://api.github.com | jq '.items[0]';
ssh user@server "systemctl restart app";
find . -name "*.log" -mtime +7 -delete;

// You get the ENTIRE Linux ecosystem!
```

## Real- World Examples

Note: Functions are partially implemented but have some edge cases in v1.0-1. They'll be fully supported in v1.0-2!

### System Health Check

```
#!/usr/bin/env smash
// system- check.smash

let hostname = $(hostname);
let uptime = $(uptime -p);
let disk = $(df -h / | tail -1 | awk '{print $5}' | sed 's/%//');

echo "System: " + hostname;
echo "Uptime: " + uptime;

if (disk > 80) {
    echo "WARNING: Disk usage high: " + disk + "%";
    bash /usr/local/bin/cleanup.sh;
} else {
    echo "Disk usage OK: " + disk + "%";
}
```

### Deployment Script

```
#!/usr/bin/env smash
// deploy.smash

let environment = "production";
let app = "myapp";
let version = $(git describe --tags);

echo "Deploying " + app + " v" + version;

if (environment == "production") {
    docker build -t $app:$version .;
    docker push registry.io/$app:$version;
    kubectl set image deployment/$app app=registry.io/$app:$version;
    kubectl rollout status deployment/$app;
    echo "Deployed to production!";
} else {
    docker-compose up -d;
    echo "Started in development mode";
}
```

### Backup Automation

```
#!/usr/bin/env smash
// backup.smash

let date = $(date +%Y-%m-%d);
let backup_dir = "/backups/" + date;

mkdir -p $backup_dir;

echo "Backing up database...";
pg_dump mydb | gzip > $backup_dir/db.sql.gz;

echo "Backing up files...";
tar -czf $backup_dir/files.tar.gz /var/www;

echo "Uploading to S3...";
aws s3 cp $backup_dir s3://my- backups/$date/ --recursive;

echo "Backup complete!";
```

### Log Processing

```
#!/usr/bin/env smash
// process- logs.smash

let threshold = 100;

for (let logfile in /var/log/*.log) {
    let errors = $(grep -c ERROR $logfile);
    
    if (errors > threshold) {
        echo "High error count in " + logfile + ": " + errors;
        // Send alert
        curl -X POST https://alerts.example.com \
             -d '{"file":"'$logfile'","count":"'$errors'"}';
    }
}
```

## Usage

### Basic Usage

```
# Run a script
smash script.smash

# See generated bash code (debug)
smash script.smash --debug

# Dry run (show code without executing)
smash script.smash --dry-run

# Show help
smash -h
smash --help

# Show version
smash -v
smash --version
```

### Making Scripts Executable

```
# Add shebang to your script
echo '#!/usr/bin/env smash' > myscript.smash
cat >> myscript.smash <<'EOF'
let name = "SMASH";
echo "Hello from " + name;
EOF

# Make it executable
chmod +x myscript.smash

# Run it directly
./myscript.smash
```

The beauty: You get modern syntax, but it runs as plain bash everywhere!

## Supported Features

### Currently Supported

- Variables (`let`, `const`, `var`)
- If/else/else if statements
- String comparisons (`==`, `!=`)
- Numeric comparisons (`>`, `<`, `>=`, `<=`)
- For loops
- String concatenation with `+`
- Single- line comments (`//`)
- Multi- line comments (`/* */`)
- All bash commands (pipes, redirects, etc.)

### Coming Soon (v1.0-2)

- Functions (basic support exists but needs work)
- While loops
- Switch/case statements
- Array support
- Better error messages
- Syntax highlighting (VS Code extension)
- More operators (`&&`, `||`, `!`)

### Maybe Future

- Type checking (optional)
- Linting
- Package manager integration
- REPL mode

## Roadmap

### v1.0-2 - Arrays & Loops (Next)
- Array declaration: `let arr = ["a", "b", "c"];`
- Array indexing: `arr[0]`
- Array length: `arr.length`
- Array methods: `push()`, `pop()`, `shift()`
- While loops: `while (x < 10) { }`
- Logical operators: `&&`, `||`, `!`
- Better error messages

### v1.0-3 Advanced Features
- Functions (properly implemented)
- Switch/case statements
- String methods: `.split()`, `.join()`, `.replace()`
- For...of loops: `for (let item of array)`

## Why SMASH?

The Problem:

```
# Bash syntax is weird and error- prone
if [ "$x" = "$y" ]; then  # Spaces matter!
    echo "match"          # Why [ ]?
fi                         # Why fi?

# Easy to make mistakes:
if ["$x"="$y"]; then      # Breaks - no spaces
if [ $x = $y ]; then      # Breaks if $x is empty
if [ "$x" == "$y" ]       # Missing semicolon
```

The SMASH Solution:

```
// Clean, familiar, hard to mess up
if (x == y) {
    echo "match";
}

// Everyone already knows this syntax
```

## Comparison

| Feature | Bash | SMASH |
|--------- |------|------- |
| Syntax | `if [ "$x" = "$y" ]` | `if (x == y)` |
| Variables | `name="value"` | `let name = "value"` |
| Loops | `for x in *.txt; do` | `for (let x in *.txt) {` |
| Learning curve | Steep (weird rules) | Gentle (like JS) |
| Compatibility | Everywhere | Everywhere (transpiles to bash) |
| Commands | All Linux tools | All Linux tools |

## FAQ

Q: Do I need to install anything?  
A: Just Python 3 (usually pre- installed) and bash (definitely pre- installed on Linux/Mac).

Q: Does it work on my system?  
A: If you have bash, yes. Linux, macOS, WSL, BSD, anywhere bash runs.

Q: Is it slow?  
A: The transpilation is instant (milliseconds). The execution speed is identical to bash because it IS bash.

Q: Can I mix SMASH and bash?  
A: Yes! Any bash command works in SMASH. You can gradually migrate scripts.

Q: What about errors?  
A: SMASH shows bash errors directly. Use `--debug` to see the generated bash code.

Q: Is this production- ready?  
A: v1.0-1 is experimental. Use for new projects, automation scripts. Test thoroughly for critical systems.

Q: Why not just use Python/Node?  
A: Those are great for complex logic. SMASH is for shell scripts - when you need to glue Linux commands together. You still want pipes, redirects, and instant access to all CLI tools.

## Contributing

Contributions welcome! Here's how you can help:

- Report bugs
- Suggest features
- Improve documentation
- Submit pull requests

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the frustration of writing bash scripts for 30+ years
- Thanks to everyone who said "just use Python" (you were right, but also wrong)
- Flaneurette, Claude AI and contributors

## Links

- GitHub: https://github.com/flaneurette/smash
- Issues: https://github.com/flaneurette/smash/issues
- Discussions: https://github.com/flaneurette/smash/discussions

--- 


Made with ❤️ and frustration with bash syntax.
