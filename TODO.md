## String Methods

```
str.startsWith("http");
str.endsWith(".log");
str.includes("error");
str.trim();
str.replace("old", "new");
str.replaceAll("old", "new");
str.repeat(3);
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
let data = JSON.parse(response,jq=null);
echo data.name;

// detect if jq is present, then let user give custom jq command:
let jq = ('echo "$response"' | jq -r '.name');
let data = JSON.parse(response,jq);
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