## Development

### Start

No magic involved here, fires up a vagrant build on the recent [opnsense-build](https://app.vagrantup.com/eugenmayer/boxes/opnsense)

**Setup**
Before you start, you need vagrant and docker locally, docker for mac/windows or linux is expected.
Als you need an loopback alias `172.31.31.254` on your loopback device so we can connect to our docker-ldap server 
on the host easily

```
make start
```

- Connect to `localhost:10443` using "root/opnsense" and download the OpenVPN client configuration from the already configured server
- you need the client to connect to localhost 11194 since that is what is NATted in vagrant - so set that host/port while exporting the client configuration
- you can use "included1/included1" or "included2/included2" as users to connect to Openvpn, getting the ip `172.16.101` or `172.16.0102`  
- set logging level to 3 if you want to see our mapping logs ( in the ldap server )

1. You see the plugin deployed in the opnsense instance, access it by https://localhost:10443
2. If you change code, just run `make sync`
3. If you want to ssh into the opnsense box use `vagrant ssh` with "opnsense" as password
4. Its all on you now :)

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
                          
#### API credentials

Use the key as username, secret as password

key=PBa+SNy78z/Z4BhVR5JQUGTQFqMQhlpwAif7JSgYAlNICbR9H5Nou3vpbIFAq83I5zizInbV/RE1b5xW
secret=5WLNgjlP+vSRol1mHEz+ZvuNG7MVXK/fNkMYqx5hvlLWbebN+N4V5PF7K3CUOlJhtPPo+nqMKOb5WgmK
                           


