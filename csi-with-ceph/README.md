# CSI with Ceph

Note: Demo & README are WIP.

- This demo will be jumping off from [an internal demo which can be found here.](https://github.com/hashicorp/nomad/tree/main/demo/csi/ceph-csi-plugin)

## Getting Started

```
vagrant up
vagrant ssh
cd csi-demo
```

Instantiate Ceph

```sh
./run-ceph.sh
```

Run the Plugins.

```
nomad job run -var-file=nomad.vars ./plugin-cephrbd-controller-vagrant.nomad

nomad job run -var-file=nomad.vars ./plugin-cephrbd-node.nomad
```

Watch for the plugins to come up.

```
watch nomad plugin status cephrbd
```

We expect to see this output:

```
ID                   = cephrbd
Provider             = rbd.csi.ceph.com
Version              = canary
Controllers Healthy  = 1
Controllers Expected = 1
Nodes Healthy        = 1
Nodes Expected       = 1

Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created    Modified
31dcd70d  5b02dc70  cephrbd     0        run      running  6m38s ago  6m ago
d6b23e8d  5b02dc70  cephrbd     0        run      running  6m31s ago  6m5s ago
```

Instantiate the Ceph Volume

```sh
nomad volume create volume.hcl
```
