# Standing up the Environment
* Note: I've bumped up the VMs. If using on a budget, make sure to change the size down from larges <3
* [Code used to stand up an AWS based Nomad environment](https://www.google.com)

To start, clone the repository.

```
git clone https://github.com/gogococo/nomad-autoscaler-demos.git`
```

For this webinar, I'm basing my environments off of the nomad-autoscaler-demos repository. Navigate to the directory we'll be working out of. 

```
cd nomad-autoscaler-demos/cloud/demos/on-demand-batch/aws
```

Next, you'll want to create a copy of the sample tfvars file.

```
cp terraform.tfvars.sample terraform.tfvars
```

Next, you'll want to fill this file in with the variables correct for your project. 

`region` - The region to deploy your infrastructure.

`availability_zones` - A list of specific availability zones eligible to deploy your infrastructure into.

`key_name` - The name of the AWS EC2 Key Pair that you want to associate to the instances.

`owner_name` - Added to the created infrastructure as a tag.

`owner_email` - Added to the created infrastructure as a tag.

`vpc_name` - the name for your vpc.

`vpc_cidr` - the cider block you'd like to use, I used "172.31.0.0/16"

Terraform time. Let's initialize Terraform & run a quick check for validation.
```
terraform init
terraform validate
```

Now that it looks like we're in the clear, let's go ahead and see what it's planning to build. 

```
terraform plan
```

Take a look through the resources it's creating, and verify that this works for you. If it looks good to you, we're ready to go ahead and stand up our environment. 

``` 
terraform apply
```

When this completes, we expect to see an output with information relevant to our autoscaler demo.

```
Outputs:

detail = <<EOT

Server IPs:
 * instance settling-halibut-server-1 - Public: 100.24.124.185, Private: 172.31.11.46

The Nomad UI can be accessed at http://settling-halibut-servers-1191809273.us-east-1.elb.amazonaws.com:4646/ui

The Consul UI can be accessed at http://settling-halibut-servers-1191809273.us-east-1.elb.amazonaws.com:8500/ui

Grafana dashboard can be accessed at http://settling-halibut-platform-628706379.us-east-1.elb.amazonaws.com:3000/d/CJlc3r_Mk/on-demand-batch-job-demo?orgId=1&refresh=5s

Traefik can be accessed at http://settling-halibut-platform-628706379.us-east-1.elb.amazonaws.com:8081

Prometheus can be accessed at http://settling-halibut-platform-628706379.us-east-1.elb.amazonaws.com:9090

CLI environment variables:
export NOMAD_ADDR=http://settling-halibut-servers-1191809273.us-east-1.elb.amazonaws.com:4646

EOT
```