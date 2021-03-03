# Tailscale on AWS

This project came about because I switched over to T-Mobile's 5G home ISP which unfortunately does not offer any port forwarding capabilities. This broke external integrations to my Home Assistant setup among other things, so I set out to find a solution. I stumbled upon Tailscale, an interesting Wireguard based VPN service that makes managing things very easy. 

I deployed the `fn61/tailscale` container on my local home server and authenticated that, but needed another end of the tunnel. I already had a `linuxserver/swag` container running on my server handling external DNS syncing, certbot renewal, and server hosting via proxy routes through nginx, so I figured adding Tailscale to that container and deploying it on an Amazon AWS EC2 instance would work -- which it has! So far so good, my HA instance is now externally accessible again, requests hit the container running on EC2 and then tunnel over Tailscale back into my home network.

## Terraform Scripts

Much of this is based off this [excellent post by Guillermo Musumeci](https://gmusumeci.medium.com/how-to-deploy-aws-ecs-fargate-containers-step-by-step-using-terraform-545eeac743be), with some key differences to enable Tailscale to work, to use a private container registry, and use persistent storage for the SWAG container config and Tailscale's internal config. Tailscale requires privileged mode, which Fargate does not allow, so I also had to adapt the configuration to deploy using the EC2 instances instead.

### Initializing

Copy the `terraform.tfvars_sample` to `terraform.tfvars` and populate as needed. [This blog post covers](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) how to fetch credentials needed for Terraform. Then run `terraform init` followed by `terraform apply` to create the infrastructure needed. 

I'm not sure of the best way to handle seamlessly uploading a Docker image to a newly created ECR, so I did this step manually by logging into the Amazon AWS console, going to the Elastic Container Registry section, selecting my new image repo, and clicking View Push Commands to get the instructions needed.

Once the image was uploaded, I popped over to the Elastic Container Services page and selected the new cluster, went to the ECS instances tab, selected the EC2 instance and got the public DNS so I could SSH in. I used `scp` to copy my existing SWAG container config over to the EC2 instance. (Side note: I'm not sure this is the best storage location, input welcome.)

`scp -r -i ~/.ssh/aws_key.pem ~/Documents/Projects/ssl/ ec2-user@[redacted]:/ecs/config`

I then altered the proxy configurations I was using already to point to the Tailscale internal IP of my home server container. Over the many iterations I restarted the container multiple times, but you'll likely need to restart it manually after uploading the config. Once that was settled, I grabbed the container logs by first checking for the deployed container id with `docker ps` and then using `docker logs`. In the startup output you should see a Tailscale auth URL, I grabbed that and popped it into my browser to authenticate the instance. I updated my DuckDNS entry, and lo' and behold, I had a working tunneling server!

