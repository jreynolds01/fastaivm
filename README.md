# fastaivm

The goal of this repository is to supply a simple mechanism for deploying the requirements for the [fastai course: Practical Deep Learning for Coders: Part 1](http://course.fast.ai/index.html). The button below deploys to an [Ubuntu-based Data Science VM](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro) (NC-series) to azure and installs the relevant dependencies.

**NOTE**: An Azure subscription is required - see below.

## Deployment

Azure subscription required.

Hardware compute [fees](https://azure.microsoft.com/en-us/marketplace/partners/microsoft-ads/linux-data-science-vm/) apply. [Free Trial](https://azure.microsoft.com/free/) available for new customers.

**IMPORTANT NOTE**: Before you proceed to use the **Deploy to Azure** button you must perform a one-time task to accept the terms of the data science virtual machine on your Azure subscription. You can do this by visiting [Configure Programmatic Deployment](https://ms.portal.azure.com/#blade/Microsoft_Azure_Marketplace/LegalTermsSkuProgrammaticAccessBlade/legalTermsSkuProgrammaticAccessData/%7B%22product%22%3A%7B%22publisherId%22%3A%22microsoft-ads%22%2C%22offerId%22%3A%22linux-data-science-vm%22%2C%22planId%22%3A%22linuxdsvm%22%7D%7D)

Just click this button (see below for details).

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fwmpauli%2Ffastaivm%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

## VM size options

The default option (`NC6`) is the cheapest GPU option, but it's also the oldest and slowest. Other GPU-enabled vmSizes are available from the template, but please see the notes in the vm sizes [documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/sizes-gpu).

**Specifically** note that the `vCPU` core quota for `_v2` and `_v3` series VMs is initially **set to 0 in each region** for every subscription. You must [request a vCPU quota increase](https://docs.microsoft.com/en-us/azure/azure-supportability/resource-manager-core-quotas-request) for these families in an [available region](https://azure.microsoft.com/regions/services/). If you choose one of the `NCXX_v2` or `NCXX_v3` VM sizes in the template without increasing your quota, the deployment **WILL FAIL**.

## What is deployed?

You define the name of a resource group, and the following services get deployed to that resource group:
  - An [Ubuntu-based Data Science VM](https://docs.microsoft.com/en-us/azure/machine-learning/data-science-virtual-machine/dsvm-ubuntu-intro) with your defined user name and password.
  - Storage: A storage account and 2 disks for storing data
  - A network interface, virtual network, and public IP address
  
## What do I as a user control?

When you click on the `Deploy to Azure` button above, a custom template will launch in the Azure portal that asks you for some information:

- Subscription you are creating the resources in
- Resource group you want to create all the resources in
- Location (i.e. Data Center where the resource group and resources physically live)
- DNS label prefix
- Admin Username
- Admin Password
- VmSize (`NC6` as default; other NC options avail, see note above)
- Vm Name

All of this information is controlled with the [azuredeploy.json](azuredeploy.json) file in the root directory of this repository.

## What happens when I deploy?

The resources are created, and then a [custom script extension](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment) is used to download the [dsvm-setup.sh](dsvm-setup.sh) script from this github repository and then run it. This script is run as root and takes a single argument: the name of the admin you specify in the portal.

## What does the script do?

It does the following:

- Clones the [fastai repository](https://github.com/fastai/fastai.git) so all the notebooks are available
- Downloads and unzips the [data for the first lab](http://files.fast.ai/data/dogscats.zip).
- Cleans up anaconda and installs a new conda env based on the [environment file](https://github.com/fastai/fastai/blob/master/environment.yml) in the fastai repository (the env name is fastai and it is installed in /home/\<adminUser\>/.conda/envs).
- Installs the environment as a kernel for jupyter notebooks so that the notebooks can be run.
- Makes sure that permissions are appropriate to the admin user.

See the [dsvm-setup.sh](dsvm-setup.sh) file for details.

## How do I access the course materials?

- Identify the DNS name prefix and geo used in deployment.
- Proceed to `https://<dnsprefix>.<location>.cloudapp.azure.com:8000` to access the jupyter server
  - **NOTE**: You will encounter a certificate error - proceed through it
- Log in with the username and password you specified when you deployed.
- Within the jupyter file navigator, you should see a large list of directories and files.
  - Navigate to `fastai -> courses -> dl1`
  - Within, `dl1`, click on  `lesson1.ipynb` to launch the notebook.
- In the tab that has launched notebook, click on the `kernel` menu item, Select `Change kernel`, and select `fastai` in order to change the kernel to the right environment.
  - **Note** - you will likely need to do this step for each notebook!
- Watch videos at [fastai](http://course.fast.ai/index.html), execute cells, experiment, and learn!
