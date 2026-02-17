# Smash - Simple Modern Advanced Shell

Smash is a modern JavaScript-style shell scripting language that transpiles directly to Bash.

```
     _____   _    _   _____   _____ _       _
    |     | | \  / | |     | |     | |     |    
    |_____  |  \/  | |_____| |_____  |_____|    
          | |      | |     |       | |     |    
    ______| |      | |     | |_____| |     |____.flaneurette'26
    
    Installation:
    sudo add-apt-repository ppa:flaneurette/smash
    sudo apt update
    sudo apt install smash

    Usage:
        ./<script.smash>                        Run a Smash script
        smash <script.smash>                    Run a Smash script
        smash <script.smash> -debug             Show generated bash code
        smash <script.smash> -test              Show generated code without running
        smash <script.smash> -emit mytool.sh    Build tool generator
        smash -v                                Show version
        smash -h                                   Show this help
    
    Features:
     JavaScript-like syntax for shell scripts
     All Linux commands work (pipes, redirects, everything)
     Transpiles to bash (works everywhere)
     No dependencies except Python 3 and bash
     
```

Tired of Bash's 1970s syntax? Write shell scripts with modern JavaScript-like syntax that transpiles to bash.

## Smash scripting example

```
#!/usr/bin/env smash
// File: server-info.smash

"use strict";
"use logging /var/log/disk.log";

// Check server memory
let mem_usage = $(free | grep Mem | awk '{print int($3/$2 * 100)}');
let today = date("time");

if (mem_usage > 90) {    
    let warning = today + " - WARNING: Memory usage is " + mem_usage + "%";
    echo `{warning}`;
    console.warn(warning);
} else {
    let ok = today + " - Memory usage: " + mem_usage + "% (OK)";
    echo `{ok}`;
    console.log(ok);
}
```

## How it works

Smash is a runtime transpiler, it converts your Smash syntax to bash, instantly in memory and executes it:

```
Your Smash code
      |
Python transpiler
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
- Drop-in replacement. Use Smash for new scripts, keep old bash scripts
- Debug mode. See the generated bash code
- Emit mode. Convert JavaScript smash directly to .sh scripts.

## Get it

Install:

```
sudo add-apt-repository ppa:flaneurette/smash
sudo apt update
sudo apt install smash
smash -v
```

## Syntax guide

### All Bash/Linux commands work out of the box

```
#!/usr/bin/env smash

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
"use strict";            // Enable strict mode

"use pipefail";          // Bash: set -o pipefail
"use errexit";           // Bash: set -e (exit on error)
"use nounset";           // Bash: set -u (error on undefined vars)
"use xtrace";            // Bash: set -x (debug/trace mode)

"use noclobber";         // Bash: set -C (don't overwrite files with >)
"use vi-mode";           // Bash: set -o vi
"use emacs-mode";        // Bash: set -o emacs
"use verbose";           // Bash: set -v (print commands as read)

// Combined
"use strict pipefail errexit";

// Floats
"use precision 4"        // Precision of floating points. Default value (if not set): 2

"use comments"          // Keep comments in generated bash (default: strip)
                        // Warning: keywords in comments (let, var, function) may break transpiling
"use logging /app.log"; // Default: console.log, see all console functions in readme.

"use unsafe";             // Disable code security. If set, you can use: rm -f, exec, etc.
                        // By default, dangerous commands are not allowed. Use with caution.
```

### Elevated commands

By default, some risky commands cannot be used. This prevents severe accidental issues. You'll need to set a pragma for it to bypass security:

```
#!/usr/bin/env smash

"use unsafe"; 

let remove_file = $(rm -f /tmp/test.log);
```

### Console

```
#!/usr/bin/env smash

"use logging /home/admin/app.log";

console.log("Application started");
console.info("Processing 100 items");
console.warn("Disk space at 85%");
console.error("Database connection failed");
console.debug("Variable x = " + x);
```
Result in app.log:
```
Application started
[INFO] Processing 100 items
[WARN] Disk space at 85%
[ERROR] Database connection failed
[DEBUG] Variable x = 42
```

### Printing

In Smash, there are several ways to print. We do recommend Smash `interpolation`

```
#!/usr/bin/env smash

let today = date("time");

echo `Today it is: {today}`;   // Smash text interpolation
echo `Today it is: ${today}`;  // JS-style
echo `Today it is: #{today}`;  // Ruby-style
echo "Today it is: " + today;  // Concatenation
echo $today;                    // Bash and PHP style
```

### Syntactic sugar

The following aliases can be utilized in Smash:

```
echo
print
print()
document.write();
```

### Type awareness, casting, type coercion and interpolation

```
#!/usr/bin/env smash

let name = "Alice";
let count = "Price:42";
let count1 = "Price:133.60";

echo `Count: (int) {count}`;    // Type cast integer
echo `Count: (float) {count1}`; // Type cast float, printf.
echo `Count: (string) {name}`;  // Type cast explicit string.

echo `Count: n{count}`;         // Type cast integer
echo `Count: f{count1}`;          // Type cast float, printf.
echo `Count: s{name}`;          // Type cast explicit string.

echo `User: u{name}`;           // String upper
echo `User: l{name}`;           // String lower
echo `User: b{name}`;           // String basename
echo `User: d{name}`;           // String dirname
```

### Date

```
#!/usr/bin/env smash

// Readable format
let readable = date("D, M d, y");  // Thursday, February 12, 2026

// Custom formats
date("D, M d, y")   // "%A, %B %d, %Y"
date("y-m-d")       // "%Y-%m-%d"
date("H:i:s")       // "%H:%M:%S"
date("y/m/d H:i")   // "%Y/%m/%d %H:%M"

// Presets (just keywords)
date("today");        // "%Y-%m-%d"
date("now");        // "%s" # Like JS Date.now() & PHP time()
date("unix");       // "%s" # Ibid
date("timestamp");  // "%s" # Ibid
date("sql");        // "%Y-%m-%d %H:%M:%S"
date("human");      // "%A, %B %d, %Y"
date("log");        // "%Y-%m-%d %H:%M:%S"
date("filename");   // "%Y-%m-%d_%H-%M-%S"
date("iso");        // "%Y-%m-%dT%H:%M:%S"
date("isostring")    // "%Y-%m-%dT%H:%M:%S%z" # Like JS toISOString()

let timestamp = date("timestamp");

console.log("Backup started at " + timestamp);
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
#!/usr/bin/env smash

let name = "world";

if (name == "world") {
    echo `Hello {name}`;
    echo `Hello ${name}`; // also works
    echo `Hello #{name}`; // also works
}
```

### String concatenation

```
#!/usr/bin/env smash

let name = "world";
echo "Hello, " + name + "!";
```

### String operations

```
str.substring(0,5);
str.split(",");
str.toUpperCase();
str.toLowerCase() 
```

### Array operations

```
arr = [];                                    // Array creation
arr = [...array1, ...array2]                // Array spread operator
arr[0];                                        // Indexing
arr.length;                                    // Array length
arr.push(value);                            // Push value unto array
arr.join(",");                                // Join
arr.slice(0, 2);                            // Slice array
arr.filter(item => item.endsWith(".log"));    // Filter array
arr.forEach(f => {echo "File:" + f;});         // For Each loops.
arr.includes("value");                        // Used in if conditions
```

Examples:

```
#!/usr/bin/env smash

let files     = ["a.txt", "b.txt", "c.txt", "test.log"];
let arr     = ['a','b','c']; // Array creation
arr.push('d');                 // Push value unto array
echo arr.length;             // Array length
echo arr[1];                 // Indexing

// Spread
let arr1 = [1, 2, 3];
let arr2 = [4, 5, 6];
let combined = [...arr1, ...arr2];

if(arr[1] == 'b') {             // Idx comparison
    echo "Works fine";
}

let val = arr[1];             // New assignment
if(val == 'b') {              // Idx comparison
    echo "Also works!";
}

// forEach
files.forEach(f => 
    {
        echo "File:" + f;
    }
); 

// filter
let logs = files.filter(f => f.endsWith(".log"));

echo $logs;

// includes
if (files.includes("a.txt")) {
    echo "Found it!";
}

// join
let csv = files.join(",");  // "a.txt,b.txt,c.txt"

echo $csv;
```

### If/Else statements

```
#!/usr/bin/env smash

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

### Object Literals

Smash has support for `basic` objects, or objects literals.

```
#!/usr/bin/env smash

let config = {
    host: "localhost",
    port: 8080,
    timeout: 3.14
};

let db = {
    name: "mydb",
    port: 5432
};

// You must assign a var/let/const to access it:

let isp = config.host;
let db = db.name;

if(db == "mydb") {
    echo "Yes mydb database is correct";
    echo "My ISP is: " + isp;
}
```

<sup>NOTE: Be careful with complex nested objects, it might not work as expected.</sup>

<sup>NOTE: To avoid confusion, associative array access is not allowed on objects i.e. `config[port]`</sup>

<sup>NOTE: Object destructuring is not possible (yet) i.e. `let {host, port} = config;`, and probably won't be, as variable assignment suffices for simple tasks.</sup>

### Functions

- Keep functions simple.
  Heavy nesting or complex JavaScript patterns may break the transpiler.
- Functions return via `echo`, not `return`.
  The `return` keyword is converted to `echo` automatically.
- Booleans are strings in Bash.
  `true` and `false` are literal strings, not boolean types.
  
```
#!/usr/bin/env smash

// Variable returns
function test() {
    let a = 10;
    return a;           // Becomes: echo "$a"
}
let result = $(test);   // Captures the echoed value
echo `{result}`;        // Prints: 10

// Direct string returns
function test() {
    return "success";   // Becomes: echo "success"
}
let result = $(test);
echo `{result}`;        // Prints: success

// Boolean handling
function test() {
    let a = false;
    return a;           // Becomes: echo "$a"
}
let result = $(test);
echo `{result}`;        // Prints: false (as a string)

// To use booleans in conditions:
if (result == "false") {
    echo "It was false";
}
```

Key Points:

- Bash has no boolean type - everything is a string or number
- `true` and `false` are `commands` in Bash (exit codes 0 and 1)
- Smash transpiler treats them as string literals
- Comparisons work fine: `if (x == "false")` or `if (x == "true")`

### Loops

```
| Syntax                 | Meaning              |
| ---------------------- | -------------------- |
| `for (let x of arr)`   | iterate array values |
| `for (let x in arr)`   | same as `of`         |
| `for (x in arr)`       | same as `of`         |
| `for (let f in *.log)` | iterate glob results |
| `arr.forEach()`        | same as `of`         |
```

Example:

```
#!/usr/bin/env smash

let arr = ['a','b','c'];

for(let str of arr) {        
    echo `{str}`;            // Required text interpolation
}

for(let str in arr) {        // NOTE: In Smash similar to `of`
    echo `{str}`;            // Required text interpolation
}

arr.forEach(f => 
    {
        echo "File:" + f;
    }
); 

for(let file in *.log) {
    echo "Processing: " + file;
    cat $file | grep ERROR;
}

// Use very sparingly...
let i = 0;
while (i < 10) {
    echo "Count: " + i;
    i = $(expr $i + 1);
}
```

### Switches

```
#!/usr/bin/env smash

let fruit = "apple";
let result = "undefined";

switch (fruit) {
    case "apple":
        result = "apple";
        break;
    case "banana":
        result = "banana";
        break;
    default:
        result = "no fruit!";
        break;
}

echo `I like this fruit: {result}`;
```

### Comments

By default, Smash will remove comments in the `generated bash` to avoid difficult regex issues. You can unset this by setting the pragma: `"use comments"` at the top of your script.

Advise: if you do use comments, try to avoid too much commenting or keep it minimal. Comments might break transpiling to bash if reserved words are use inside comments. 
Keywords in comments such as: `function, let, var, const,` etc. etc. can lead to transpiling errors and edge cases.

```
#!/usr/bin/env smash

// Single line comment, just textual hint

/*
   Multi- line
   comment
   Just textual hint
*/

let x = "value"; // Inline comment, just textual hint
```

### Math operations
```
#!/usr/bin/env smash

let result = x + y * 2;
let mod = x % 3;
```

### File operations

```
#!/usr/bin/env smash

if(exists("/usr/local/bin/smash")) {
    echo "File exists";
}

if(isfile("/usr/local/bin/smash")) {
    echo "File exists";
}
```

### Special functions

setTimeout/setInterval

```
#!/usr/bin/env smash

setTimeout(() => {
    echo "5 seconds later...";
}, 5);

setInterval(() => {
    echo "Every 10 seconds";
}, 10);

// function
function draft() {
    echo "Around the world!";
}

setTimeout(draft, 5);
```

# Smash Exotics

Smash has it's own reserved keywords you could use. Some of them are quite useful, but still exotic.

Current exotics:

```
let it be;                // Deferred coercion    
run bird <service>;        // Execution handler
free bird <service>;    // Execution handler
what if() {}            // Code explaination with file log reporting, and/or custom IF statement.
```

### Exotic: Deferred Coercion.

Smash has deferred coercion: `let it be;` for known or unknown strings, values or expressions.

`let it be` is:

- A placeholder for unknown/dynamic values: "I don't know what this is yet"
- The subject of transformation: "Whatever it is, do this to it"
- And supports "quoted" floating points.

```
let it    = value;                             // Known or unknown. Often "it" means: unknown.
be         = string or (expression|typecast);    // An expression or type-cast.
let it be;                                    // Processing.
echo $it;                                    // Result
```

Interest rate conversion

```
#!/usr/bin/env smash

let it = 1000; // Principal
let rate = 1.5; // 1.5% interest
for (let year in 1 2 3 4 5) {
    be = (it + (it * rate / 100));  // Add 1.5% each year.
    let it be;
    echo `Year {year}: ${it}`;
}
```

> Note: By default, Smash uses precision 2 with floats. i.e. 1.50 - If you want higher, then declare: "use precision 4" at the top of the script. 4, can be any number.

Temperature conversion

```
#!/usr/bin/env smash

let temps = [32, 68, 98, 212];

for (let f in ${temps[@]}) {
    let it = f;
    be = ((it - 32) * 5 / 9);
    let it be;
    echo `{f}°F = {it}°C`;
}
```

Progressive price calculations

```
#!/usr/bin/env smash

let it = 100;
be = (it * 121 / 100);  // Add 21% VAT
let it be;
be = (it + 50);         // Add shipping
let it be;
be = (it * 90 / 100);   // Apply 10% discount
let it be;

echo `Final price: {it}`;
```

Casting

```
#!/usr/bin/env smash

let it = "Yesterday's score: 167";
be = (int);
let it be;
be = (it + 100);
let it be;
echo $it;   // Outputs: 267
```

### Exotic: Execution Handling

Smash has its own execution handlers: `run bird` and `free bird`.

`free bird` is multi-purpose and context-aware. It automatically handles resource cleanup including resetting variables, arrays, integers, and stopping running services.

> NOTE: All `birds` are required to be unique. Do not re-use any bird `variable, array, integer, or service`, as Smash tracks subsequent declarations.

#### 🐥 run bird `service`

Start a service or command and track it for automatic cleanup.

Syntax:

```
let variable = run bird $(command);     // Explicit command
let variable = run bird servicename;    // Named service (uses systemctl)
```

Examples:

```
#!/usr/bin/env smash
// Explicit command
let nginx = run bird $(systemctl start nginx);
doWork();
free bird $nginx;    // Automatically runs: systemctl stop nginx

// Named service
let db = run bird postgresql;
queryData();
free bird $db;       // Runs: systemctl stop postgresql
```

#### 🐥 free bird `optional $var`

Context-aware cleanup and loop breaking.

Syntax:

```
free bird;       // Break from loop
free bird $var;  // Reset variable, int, float, array or stop a `service`
```

Examples:

```
#!/usr/bin/env smash

// Services
let db = run bird postgresql;
queryData();
free bird $db;       // Automatically runs: systemctl stop postgresql

// Variable reset
let arr = [0, 1, 2, 3];
let str = "Hello";
let num = 7;

free bird $arr;      // Resets to []
free bird $num;      // Resets to 0
free bird $str;      // Resets to ""

// You must reassign the array.
let arr = [5, 6, 7, 8];

// Loop breaking
for(item in arr) {
    echo $item;
    if (item > 7) {
        free bird;   // Breaks the loop
    }
}
```

### Exotic: What if?

It is possible with Smash to run tests in runtime. For example, you migth want to know what a certain abstract variable is doing (if there is much code). Or, you might want to log all occurences to a log file for explaination of the code.

For reporting, we can use: `console.report(file)` this is function only works for `what if`. Reports are written `during` transpilation.

Example cases where it might be of use:

```
#!/usr/bin/env smash

what if (vda_usage > 90) {
    echo "Then disk is almost full! vda_usage is disk 1 on system X and client Y!";
}

what if (userId < 2) {
    echo "Then user is admin!";
}

what if (userId == 233622) {
    echo "Then user is moderator of the forum, that is the account of moderator Alice!";
}

what if (password == "123456") {
    echo "Then the user set a very insecure password!";
    console.report('/var/log/explain.log');    
    // Reports: Where is $password declared, what is accessing it? and so on.
}

what if (user == "admin") {
    console.report('/var/log/explain.log');    
    // Reports: what code handles $user? etc.
}
```

Report format:

```
=== WHAT IF: user == admin ===
Line 1: user = "admin";  // Admin has extra rights
Line 5: if (user == 'admin') {
Line 12: echo "Hello, $user";
Line 20: // Check user permissions
```

### Limitations

Smash transpiles Light-JS. It is not a *complete* JavaScript interpeter. Meaning, only basic JavaScript features and nesting is supported. Smash does not support nested weirdness, overly long and complex comparisons and operator edge cases. Keep it as simple as possible. Also easier to debug, and for others to understand the code.

Example of too much complexity:

```
#!/usr/bin/env smash

x += (a + b) * (c - d) && foo(bar()) - x2 * (t / e + i);
```

This will not transpile! it is too complex, even for BASH, and few can understand it instantly, which makes it also harder to maintain, let alone transpile correctly.

Instead, write it straight-forward procedurally:

```
#!/usr/bin/env smash

let x = 0;
let bar = bar();
let foo = foo(bar);

x += (a + b) * (c - d);
x += foo();
...
```

> Rule of thumb: if you can do it simplistically/procedurally, then do it. Smash is not a full fledged OOPL.

#### What Smash Is Not

- Not a JS interpreter
- Not ECMAScript compliant
- Not a browser runtime
- Not Node.js
- Not a full language implementation

It intentionally supports only features that map cleanly and predictably to Bash.

## Usage

### Basic usage

```
// Run a script
./script.smash

// See generated bash code (debug)
./script.smash -d
./script.smash -debug

// Dry run (show code without executing)
./script.smash -test
./script.smash --dry-run

// Show help
smash -h
smash --help

// Show version
smash -v
smash --version
```

### Making scripts executable

```
// Add shebang to your script
echo '#!/usr/bin/env smash' > myscript.smash
cat >> myscript.smash <<'EOF'
let name = "Smash";
echo "Hello from " + name;
EOF

// Make it executable
chmod +x myscript.smash

// Run it directly
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

Q: Can I mix Smash and bash?  
A: Yes! Any bash command works in Smash. You can gradually migrate scripts.

Q: What about errors?  
A: Smash shows bash errors directly. Use `-debug` to see the generated bash code.

Q: Is this production- ready?  
A: v1.0-1 is experimental. Use for new projects, automation scripts. Test thoroughly for critical systems.

Q: Why not just use Python/Node?  
A: Those are great for complex logic. Smash is for shell scripts - when you need to glue Linux commands together. You still want pipes, redirects, and instant access to all CLI tools.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

Flaneurette, Claude AI, and contributors.

## Links

- GitHub: https://github.com/flaneurette/smash
- Issues: https://github.com/flaneurette/smash/issues
- Discussions: https://github.com/flaneurette/smash/discussions

--- 


Made with ❤️ and frustration with bash syntax.
