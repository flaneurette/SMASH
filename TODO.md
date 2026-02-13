## 2. Array Methods

```
let f = ["a.txt", "b.txt", "c.txt"];

// map
let uppercase = files.map(f => f.toUpperCase());

// forEach
files.forEach(f => {
    echo "Processing: " + f;
});

// slice
let first_two = files.slice(0, 2);
```

## 3. Object Literals / Associative Arrays

```
let config = {
    host: "localhost",
    port: 8080,
    user: "admin"
};

echo config.host;       // localhost
echo config["port"];    // 8080
```

Bash associative arrays:
```
declare -A config
config[host]="localhost"
config[port]=8080
echo ${config[host]}
```

## 4. Try/Catch Error Handling

```
try {
    let result = $(risky-command);
    echo "Success: " + result;
} catch (error) {
    echo "Failed: " + error;
    console.error(error);
}
```

Bash:
```
if result=$(risky-command 2>&1); then
    echo "Success: $result"
else
    echo "Failed: $result"
fi
```

## 5. Destructuring

```
let [first, second, ...rest] = arr;
echo first;  // arr[0]
echo rest;   // remaining elements

// Object destructuring
let {host, port} = config;
```

## 6. Default Parameters

```
function greet(name = "World") {
    echo "Hello, " + name;
}

greet();           // Hello, World
greet("Alice");    // Hello, Alice
```

Bash:
```
greet() {
    local name=${1:-World}
    echo "Hello, $name"
}
```

## 7. String Methods

```
str.startsWith("http");
str.endsWith(".log");
str.includes("error");
str.trim();
str.replace("old", "new");
str.replaceAll("old", "new");
str.repeat(3);
str.padStart(5, "0");  // "00042"
```

## 8. Number Methods

```
let x = "42.5";
parseInt(x);      // 42
parseFloat(x);    // 42.5
Math.floor(x);    // 42
Math.ceil(x);     // 43
Math.round(x);    // 43
Math.abs(-5);     // 5
```

## 9. JSON Support

```
// Parse JSON
let data = JSON.parse(response);
echo data.name;

// Stringify
let json = JSON.stringify(obj);
```

Use `jq` under the hood:
```
data=$(echo "$response" | jq -r '.name')
```

## 10. Async/Await

```
// Run commands in parallel
async function deploy() {
    await Promise.all([
        $(rsync -av /app server1:/deploy),
        $(rsync -av /app server2:/deploy),
        $(rsync -av /app server3:/deploy)
    ]);
    echo "All deployed!";
}
```

Bash background jobs:

```
rsync -av /app server1:/deploy &
rsync -av /app server2:/deploy &
rsync -av /app server3:/deploy &
wait
echo "All deployed!"
```

## 11. setTimeout/setInterval

```
setTimeout(() => {
    echo "5 seconds later...";
}, 5);

setInterval(() => {
    echo "Every 10 seconds";
}, 10);
```

Bash:
```
sleep 5
echo "5 seconds later..."

while true; do
    echo "Every 10 seconds"
    sleep 10
done
```

## 12. Spread Operator

```
let arr1 = [1, 2, 3];
let arr2 = [4, 5, 6];
let combined = [...arr1, ...arr2];
```
