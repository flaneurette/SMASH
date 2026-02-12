# SMASH - Simple Modern Advanced SHell

SMASH is a modern JavaScript-style shell scripting language that transpiles directly to Bash, with Unix power: Modern structured syntax for Unix automation.

```
    ███████╗███╗   ███╗ █████╗ ███████╗██╗  ██╗
    ██╔════╝████╗ ████║██╔══██╗██╔════╝██║  ██║
    ███████╗██╔████╔██║███████║███████╗███████║
    ╚════██║██║╚██╔╝██║██╔══██║╚════██║██╔══██║
    ███████║██║ ╚═╝ ██║██║  ██║███████║██║  ██║
    ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

    Usage:
        smash <script.smash>            		Run a SMASH script
        smash <script.smash> -debug     		Show generated bash code
        smash <script.smash> -test      		Show generated code without running
		smash <script.smash> -emit mytool.sh    Build tool generator
        smash -v								Show version
        smash -h                   				Show this help
    
    Features:
     JavaScript-like syntax for shell scripts
     All Linux commands work (pipes, redirects, everything)
     Transpiles to bash (works everywhere)
     No dependencies except Python 3 and bash
	 
```

Tired of Bash's 1970s syntax? Write shell scripts with modern JavaScript-like (Light-JS) syntax that transpiles to bash.

## SMASH scripting example

```
#!/usr/bin/env smash

"use strict";

echo "System Health Check";
echo "-------------------";

// Get system info
let system = $(uname -a);
let uptime = $(uptime -p);

echo "System: " + system;
echo "Uptime: " + uptime;

// Check disk space
echo "Disk Space:";
echo "-------------------";
let disk_usage = $(df -h / | tail -1 | awk '{print $5}' | sed 's/%//');

if (disk_usage > 80) {
    echo "WARNING: Disk usage is " + disk_usage + "% (threshold: 80%)";
} else if (disk_usage > 60) {
    echo "Disk usage: " + disk_usage + "% (getting high)";
} else {
    echo "Disk usage: " + disk_usage + "% (OK)";
}
```

## How it works

SMASH is a runtime transpiler `it converts your JavaScript .smash` syntax to bash, instantly in memory and executes it:

```
Your SMASH code
      |
Python transpiler
      |
Generated bash code
      |
Executed by bash
```

> SMASH is not a full-blown JavaScript interpreter. It is a small, controlled JavaScript-inspired DSL interpeter, designed specifically for shell scripting.

## Features

- JavaScript-like syntax. Familiar to millions of developers
- All Linux commands work. Pipes, redirects, grep, awk, everything
- Transpiles to bash. Works everywhere bash works
- No runtime dependencies. Just Python 3 and bash
- Drop-in replacement. Use SMASH for new scripts, keep old bash scripts
- Debug mode. See the generated bash code
- Emit mode. Convert JavaScript smash directly to .sh scripts.

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

## Syntax guide

### All Bash/Linux commands work out of the box

```
// You get the ENTIRE Linux ecosystem.
// $(...) is executed at runtime by Bash

let disk = $(df -h);
let docker =  $(docker ps | grep nginx);
let uri = $(curl -s https://api.github.com | jq '.items[0]');
let ssh = $(ssh user@server "systemctl restart app");
let log = $(find . -name "*.log" -mtime +7 -delete);
```

### Flags

Possible flags/pragmas to set:

```
"use strict";        // Enable strict mode

"use pipefail";      // Bash: set -o pipefail
"use errexit";       // Bash: set -e (exit on error)
"use nounset";       // Bash: set -u (error on undefined vars)
"use xtrace";        // Bash: set -x (debug/trace mode)

"use noclobber";     // Bash: set -C (don't overwrite files with >)
"use vi-mode";       // Bash: set -o vi
"use emacs-mode";    // Bash: set -o emacs
"use verbose";       // Bash: set -v (print commands as read)

// Or combined:
"use strict pipefail errexit";
```

### Operators

```
| Category        | Operator | Example  | Meaning             | Notes            |
| --------------- | -------- | -------- | ------------------- |------------------|
| Assignment      | `=`      | `x = 5`  | Assign value        |                  |
| Add assign      | `+=`     | `x += 1` | Add and assign      | numeric += only  |
| Sub assign      | `-=`     | `x -= 1` | Subtract and assign | numeric -= only  |
| Multiply assign | `*=`     | `x *= 2` | Multiply and assign |                  |
| Divide assign   | `/=`     | `x /= 2` | Divide and assign   |                  |
| Add             | `+`      | `x + y`  | Addition            |                  |
| Subtract        | `-`      | `x - y`  | Subtraction         |                  |
| Multiply        | `*`      | `x * y`  | Multiplication      |                  |
| Divide          | `/`      | `x / y`  | Division            |                  |
| Modulo          | `%`      | `x % y`  | Remainder           |                  |
| Greater than    | `>`      | `x > y`  | Comparison          |                  |
| Less than       | `<`      | `x < y`  | Comparison          |                  |
| Greater/equal   | `>=`     | `x >= y` | Comparison          |                  |
| Less/equal      | `<=`     | `x <= y` | Comparison          |                  |
| Equal           | `==`     | `x == y` | Comparison          |                  |
| Not equal       | `!=`     | `x != y` | Comparison          |                  |
| Logical AND     | `&&`     | `a && b` | Logical AND         |                  |
| Logical NOT     | `!`      | `!x`     | Logical NOT         |                  |
| Increment       | `++`     | `x++`    | Add 1               |                  |
| Decrement       | `--`     | `x--`    | Subtract 1          |                  |
```

### Variables

```
| Keyword  | Description                   | Enforced  |
|----------|-------------------------------|-----------|
| let      | Standard variable declaration | Yes       |
| var      | Alias of let                  | Yes       |
| const    | Constant (semantic only)      | No        |

let name = "John";
let count = 10;
let files = $(ls *.txt);
```

### Text interpolation

```
let name = "world";

if (name == "world") {
    echo `Hello {name}`;
}
```

### String concatenation

```
let name = "world";
echo "Hello, " + name + "!";

// Becomes: echo "Hello, $name!"
```

### String operations

```
str.substring(0,5);
str.split(",");
str.toUpperCase();
str.toLowerCase() 
```

Examples

```
let lower = "hello";
let upper = "LOWER";

let a = lower.substring(2,3);
echo `{a}`;

let splitter = "Hello,world";
let a = splitter.split(",");
echo a.length;
echo a[1];

let up = lower.toUpperCase();
let low = upper.toLowerCase();

echo `Upper: {up}`;
echo `Lower: {low}`;
```

### Array operations

```
arr = [];			// Array creation
arr.push(value);	// Push value unto array
arr.length;			// Array length
arr[0];				// Indexing
```

Examples:

```
let arr = ['a','b','c'];	// Array creation
arr.push('d');				// Push value unto array
echo arr.length;			// Array length
echo arr[1];				// Indexing

if(arr[1] == 'b') {			// Idx comparison
	echo "Works fine";
}

let val = arr[1];			// New assignment
if(val == 'b') { 			// Idx comparison
	echo "Also works!";
} 			
```

### If/Else statements

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
| Syntax                 | Meaning              |
| ---------------------- | -------------------- |
| `for (let x of arr)`   | iterate array values |
| `for (let x in arr)`   | same as `of`         |
| `for (let f in *.log)` | iterate glob results |

let arr = ['a','b','c'];

for(let str of arr) {		
    echo `{str}`;			// Required text interpolation
}

for(let str in arr) {		// NOTE: In SMASH similar to `of`
    echo `{str}`;			// Required text interpolation
}

for(let file in *.log) {
    echo "Processing: " + file;
    cat $file | grep ERROR;
}

// While loop (use very sparingly, breaks fast)
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

### Math operations
```
let result = x + y * 2;
let mod = x % 3;
```


### File operations

```
if(exists("/usr/local/bin/smash")) {
    echo "File exists";
}

if(isfile("/usr/local/bin/smash")) {
    echo "File exists";
}
```

### Limitations

SMASH transpiles Light-JS. It is not a *complete* JavaScript interpeter. Meaning, only basic JavaScript features and nesting is supported. SMASH does not support nested weirdness, overly long and complex comparisons and operator edge cases. Keep it as simple as possible. Also easier to debug, and for others to understand the code.

Example of too much complexity:

```
x += (a + b) * (c - d) && foo(bar());
```

This will not transpile! it is too complex, even for BASH, and few can understand it instantly, which makes it also harder to maintain, let alone transpile correctly.

Instead, write it straight-forward procedurally:

```
temp1 = a + b;
temp2 = c - d;
x += temp1 * temp2;
...
```

#### What SMASH Is Not

- Not a JS interpreter
- Not ECMAScript compliant
- Not a browser runtime
- Not Node.js
- Not a full language implementation

It intentionally supports only features that map cleanly and predictably to Bash.

## Usage

### Basic usage

```
# Run a script
smash script.smash

# See generated bash code (debug)
smash script.smash -d
smash script.smash -debug

# Dry run (show code without executing)
smash script.smash -test
smash script.smash --dry-run

# Show help
smash -h
smash --help

# Show version
smash -v
smash --version
```

### Making scripts executable

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
A: SMASH shows bash errors directly. Use `-debug` to see the generated bash code.

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

Flaneurette, Claude AI and contributors

## Links

- GitHub: https://github.com/flaneurette/smash
- Issues: https://github.com/flaneurette/smash/issues
- Discussions: https://github.com/flaneurette/smash/discussions

--- 


Made with ❤️ and frustration with bash syntax.
