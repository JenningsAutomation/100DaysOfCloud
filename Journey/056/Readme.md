![Project Architecture](images/HybridMultiCloudArch%20.png)

# Azure Arc
## Introduction
In this hour I built a Hybrid Multi-Cloud Control Plane using Azure Arc is the Single Pane of Glass. I used
pulumi to orchestrate infrastructure across different providers. In this example Azure and DigitalOcean

## Prerequisite
- Azure account
- Digital Ocean Account

## Use Case

- The use case is to avoid vendor lock in and to take advantage of other cloud providers options in terms of price and functionality.

## Cloud Research

- ✍️ So issues you may run into are setting appropriate permissions in your RBAC role and another would be selecting an appropriate instance of what you want to deploy

## Try yourself

### Prepare Azure
Log onto the Azure console:
- Create a resource group
    A dedicated resource group to include only Azure Arc-enabled servers and centralize management and monitoring of these resources.
- Design and deploy azure monitor logs
    [Setup Log Analytics](images/LogAnalytics.png)

### Install Azure CLI
```curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash```

Verify

```az version```

Login

```az login```

### Install pulumi
```curl -fsSL https://get.pulumi.com | sh```

Reload shell config

```source ~/.bashrc```

Verify pulumi installation

```pulumi version```

### Set Up Your State Backend
```pulumi login```

### Export DigitalOcean Token
In the terminal
```export DIGITALOCEAN_TOKEN="your_toke_here"```

### Create a Role for the Azure Account

```
az ad sp create-for-rbac  \
    --name "Arc-Onboarding-Worker"   \
    --role "Azure Connected Machine Onboarding"   \
    --scopes "/subscriptions/<YOUR_SUBSCRIPTION_ID>/resourceGroups/<YOUR_RESOURCE_GROUP_NAME>"
```
The output will be JSON like this
```
{
    "appID":"11111-2222-3333-4444",
    "displayName": "Arc-Onboarding-Worker",
    "password": "xxxxxxxxxxxxxxxxx",
    "tenant": "6666-7777-8888-9999-000000"
}
```

Assign the role explicitly
```
az role assignment create \
    --- assignee "SERVICE_PRINCIPAL_ID" \
    --role "Azure Connected Machine Onboarding" \
    --scope "SUBSCRIPTION_ID"
```

Store the password as a Pulumi secret

```pulumi config set --secret arcSecret xxxxxxxx```

### Initialize a Pulumi Go Project
This does not have to be Go. Pulumi has options for many languages

```
mkdir -p ~/<whereever you want to store this project>
cd ~/<whereever you want to store this project>
pulumi new azure-go
```

Pulumi will ask for Project Name, Description, and Stack Name
Then it will download all the dependencies

### Swap Boilerplate Go Code
```
package main

import (
	"fmt"

	"github.com/pulumi/pulumi-digitalocean/sdk/v4/go/digitalocean"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// !!! CONFIGURATION: PASTE YOUR AZURE SP DATA HERE !!!
		arcClientId := "PASTE_YOUR_APP_ID_HERE"
		arcSecret := "PASTE_YOUR_PASSWORD_HERE"
		arcTenant := "PASTE_YOUR_TENANT_HERE"
		subscriptionId := "YOUR_SUBSCRIPTION_ID"
		resourceGroup := "AzureArcEnabledServers"

		// 1. Upgraded Cloud-Init: Automatically onboards the DO droplet to Azure Arc
		rawCloudInit := fmt.Sprintf(`#!/bin/bash
# Install the Azure Connected Machine Agent
wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
apt-get update
apt-get install -y azcmagent

# Connect to Azure Arc non-interactively via your Service Principal
azcmagent connect \
 --service-principal-id "%s" \
 --service-principal-secret "%s" \
 --tenant-id "%s" \
 --subscription-id "%s" \
 --resource-group "%s" \
 --location "eastus2"
`, arcClientId, arcSecret, arcTenant, subscriptionId, resourceGroup)

		// 2. Spawn the standard DigitalOcean Droplet
		droplet, err := digitalocean.NewDroplet(ctx, "sanity-worker", &digitalocean.DropletArgs{
			Image:    pulumi.String("ubuntu-24-04-x64"),
			Region:   pulumi.String("nyc3"),
			Size:     pulumi.String("s-1vcpu-1gb"),
			UserData: pulumi.String(rawCloudInit), // Hand the Arc script to DO
            RootPassword: pulumi.String("TestPassword123"),
		})
		if err != nil {
			return err
		}

		ctx.Export("dropletPublicIp", droplet.Ipv4Address)
		return nil
	})
}

```

Tidy up code and download dependencies

```go mod tidy```

### Deploy Stack

```pumuli up```

That's it. You should now see your droplet deployed to digitalocean, and see the server on Azure Arc

### Destroy the Stack
Once you are finished, you can shutdown and delete resources

```pumuli destroy```


## ☁️ Cloud Outcome

✍️ The result was an overwhelming success. 

## Next Steps

✍️ I'd like to expand to other cloud providers as well

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[mastodon](https://mastodon.social/@code_sentinel/116636803485917194)
[LinkedIn](https://www.linkedin.com/posts/demian-jennings_100daysofcloud-cloudcomputing-golang-share-7464757760363098113-rbHz/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADXbhxEBzxsfNpRcEjDWcxJMI75kD_O-eRA)


[def]: images/HybridMultiCloudArch.png