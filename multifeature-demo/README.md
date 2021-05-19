# Memory Oversubscription & More
* Note: I've bumped up the VMs. If using on a budget, make sure to change the size down from larges <3

## Getting Started
* [Memory Oversubscription](https://github.com/hashicorp/team-nomad/tree/main/enablement/memory-oversubscription)

## Use Case 
Applications typically have a steady state memory footprint, but with occasional temporary spikes.

For example, a web/api service might use 250MB RAM typically; but with occasional spikes for unexpected load (social media effect!) which last until the autoscaler adds new web servers.

Another case: batch processes might need more memory at the start or end (while downloading/uploading data) but have a typical low (comparatively) memory footprint otherwise. Batch applications might have a common memory requirement during the execution of the operation, but may spike

Also, setting the limit is brittle: you set the limit too low, and app gets terminated prematurely; set it too high, and you waste cluster resources. Job submitters err on the side of specifying too much memory to avoid having their applications terminated.

Memory oversubscription is disabled by default. Nomad cluster operators must activate it first:

The following command updates the current scheduler configuration to set MemoryOversubscriptionEnabled:

```
curl -sSL  http://localhost:4646/v1/operator/scheduler/configuration \
  | jq '.SchedulerConfig + {MemoryOversubscriptionEnabled: true}' \
  | curl --request POST --data @- http://localhost:4646/v1/operator/scheduler/configuration
```

We can confirm it was enabled by:
```
curl -sSL  http://localhost:4646/v1/operator/scheduler/configuration | jq .
```

## Demo Time 
Now that we've enabled these settings/verified they're enabled, let's get to the demo. 
I'll be leveraging [nicholasjackson/fake-service](https://github.com/nicholasjackson/fake-service) for this demo. 
`api.nomad`