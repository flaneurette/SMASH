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