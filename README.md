## Local NFS test 

### Setting up

```
vagrant up
```

Once this has completed bringing up the two instances and mounted the nfs shares

```
export NOMAD_ADDR=http://192.168.1.11:4646
nomad job run jobs/hello_world.nomad
nomad job run jobs/hello_world_no_root.nomad
```


The NFS options are configured here: 
https://github.com/nickwales/nomad_nfs_test/blob/main/bootstrap_nfs.sh#L15-L16

