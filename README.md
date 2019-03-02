## Development

### Start

No magic involved here, fires up a vagrant build on the recent [opnsense-build](https://app.vagrantup.com/eugenmayer/boxes/opnsense)

```
make start
```

1. You see the plugin deployed in the opnsense instance, access it by https://localhost:10443
2. If you change code, just run `make sync_plugin`
3. Its all on you now :)

### Stop ( pause )
To stop the vm ( not losing state, continue later )
```   
make stop
```

### Clean ( end, remove all )
To remove the VM
```
make clean
```

### Login / Access

`https://localhost:10443` or `ssh -p 10022 root@localhost`
- username: root
- password: opnsense
                           


