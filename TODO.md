

## Object Literals / Associative Arrays

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

## Destructuring

```
let [first, second, ...rest] = arr;
echo first;  // arr[0]
echo rest;   // remaining elements

// Object destructuring
let {host, port} = config;
```

## Default Parameters

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

## String Methods

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

## Number Methods

```
let x = "42.5";
parseInt(x);      // 42
parseFloat(x);    // 42.5
Math.floor(x);    // 42
Math.ceil(x);     // 43
Math.round(x);    // 43
Math.abs(-5);     // 5
```

## JSON Support

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

## Async/Await

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


### Useful 

```
hostnamectl
```

### CPU details

```
lscpu
```

### Memory

```
free -h
```

### Disk type (see if it's SSD/NVMe)

```
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
```

### Full hardware summary

```
sudo lshw -short
```

