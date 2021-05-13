# Nomad 1.1 Demos - May 19th
This repository contains my demos for the May 19th, 2021 feature preview of Nomad 1.1. Demos include Autoscaling Improvements, Memory Oversubscription, CSI with Ceph, UI Improvements and more. 

## Standing up the Environment
* For this demo, I've forked [hashicorp/nomad-autoscaler-demos](https://github.com/hashicorp/nomad-autoscaler-demos)
* Find the step-by-step instructions in `aws-env-setup.md`

## Demos Demos Demos 
### Autoscaling Updates
I'll be running through the On Demand Batch demos found in `nomad-autoscaler-demos/cloud/demos/on-demand-batch/`
We'll follow this up by discussing the 1.1 autoscaling strategy updates. 

### CSI with Ceph
* This demo will be jumping off from [an internal demo which can be found here.](https://github.com/hashicorp/nomad/tree/main/demo/csi/ceph-csi-plugin)

### Multifeature Demo
This demo will leverages [nicholasjackson/fake-service](https://github.com/nicholasjackson/fake-service) & highlights multiple Nomad 1.1 features.
* [Memory Oversubscription](https://github.com/hashicorp/team-nomad/blob/enablement-memory-max/enablement/memory-oversubscription/README.md)
* Readiness Checks 
* UI Improvements (fuzzy search & improved resource monitoring)


## Additional References
* [Blogpost: Announcing HashiCorp Nomad 1.1 Beta](https://www.hashicorp.com/blog/announcing-hashicorp-nomad-1-1-beta)
