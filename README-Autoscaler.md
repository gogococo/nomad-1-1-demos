# Nomad Autoscaler Demo 
I'll be running through the On Demand Batch demos found in `nomad-autoscaler-demos/cloud/demos/on-demand-batch/`
We'll follow this up by discussing the 1.1 autoscaling strategy updates. 

## Standing Up the Environment
`terraform apply --auto-approve`

This demo creates two sets of clients, identified by their node class. The first set runs service and system type jobs: a Traefik job for traffic ingress, Prometheus for scraping and storing metrics, Grafana for dashboards, and the Nomad Autoscaler.

The second set of clients runs instances of a dispatch batch job. The number of clients in this set will depend on how many batch jobs are in progress. Since initially there are no batch jobs running or enqueued, there are zero clients in this node class.

## Demo time 
Let's start off by taking a look at which jobs we've deployed 
```
nomad job status
```

We can use the nomad node status command to see that there is only one client running, and that it is part of the platform node class. 
As we can see, there are no clients for the batch class yet. 

```
nomad node status
```

## batch.nomad
Let's take a look at `batch.nomad`
Things to keep in mind:
* It is a parameterized batch job, so we can dispatch it multiple times. 
* It's restricted to only run in clients with the node class batch.
* It also requires a large amount of memory, so each instance of this job requires a full client to run.

## autoscaler.nomad
The scaling policy is described in a template block that is rendered inside the autoscaler task.

Every 10 seconds, the Nomad Autoscaler will check how many batch jobs are in progress by querying Prometheus for the sum of the number of instances that are in the queued or running state.

In this case, the pass-through strategy is used, so there is no extra processing, and the number of batch clients will equal the number of batch job instances in progress.

Let's talk about the target piece, which varies depending on cloud provider. 

The `node_selector_strategy` which defines how the Autoscaler will choose the nodes that will be removed when it's time to scale in the cluster.

This policy uses the `empty_ignore_system` strategy.We'll only remove clients that don't have any running allocations running. This is ideal for batch jobs, since it avoids any disruption and allows them to run to completion.

To avoid overprovisioning, the max attribute defines that up to 5 clients will be running at a given time. If there are more than 5 batch jobs in progress, the number of clients is capped to max.

## Let's get to it 
Open up the Grafana dashboard. 
As you can see, there's no clients from the batch node class and also no instances of the batch job recorded.

Let's change that. 
```
nomad job dispatch batch
```
Don't worry, this output is expected. 
The command output indicates that the job was not able to start, since there are no clients in the batch node class to satisfy its constraint.

The dashboard shows that a new instance is now enqueued.
Dashed blue line indicates that the Autoscaler detected that the cluster needs to be scaled.

Let's run it 2 more times. 

* The dashboard now displays two instances in the queue and one running.
* The total number of instances in progress is three, and so the Autoscaler scales out the cluster so that there are three clients running.
* After a few more minutes, the first job completes, and the Autoscaler removes one client since it is not used anymore. The client removed is the one with no allocations running, so the other batch jobs continue running without disruption.
* Finally, the last two jobs complete, and the Autoscaler brings the batch cluster back to zero, saving us the cost of having any clients running without work.

Tada. 

## 
Strategies
1. The `pass-through` strategy allows users to defer scaling logic to their APM of choice.
2. The `fixed-value` strategy maintains a fixed number of nodes.
3. The `threshold` strategy lets you toggle different scaling strategies based on whether a tracked metric is within a defined range.