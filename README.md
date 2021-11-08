# packer-windows-azure

This repository builds Windows Master Images and publishes it to Azure Shared Image Gallery with a single [run command](./run.sh).\
It nicely integrates [Packer](https://www.packer.io/downloads), [Terraform](https://www.terraform.io/downloads.html) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Hook this thing into a real CI/CD pipeline and run it.

**Terraform** is used to fulfill the pre-requesites in Azure.

Terraform creates:

- a resource group
- a shared image gallery
- a shared image definition

**Packer** is used to build the windows master image from a Windows Marketplace image. 
Packer is also reponsible for versioning the the master image and placing into the share image gallery. 

To customize the master image, Packer runs **Ansible** and a specific [ansible playbook](./ansible/playbook.yml).\
The ansible playbook is quite basic, but this is the place to do the real customization of you windows master image.

## How to use this repo

### Pre-requesites

Make sure you have an azure service principal account. To create one you can use to following command in the azure command line tool. 
Replace your-azure-subscription-id with your real Scription ID. Feel free to also adjust the value of the `--name` attribute.\
Otherwise you can configure a service principal using the Azure Portal. Make sure it has `Contributor` role in your Azure subscription.

```bash
# Login
az login

# Create service principal with Contributor role
az ad sp create-for-rbac \
--name="packer_sp" \
--role="Contributor" \
--scope="/subscriptions/your-azure-subscription-id" \
--sdk-auth \
> az_client_credentials.json
```

### Step 1: Adjust variables

Rename the file [shared_vars.hcl.sample](./shared_vars.hcl.sample) to `shared_vars.hcl` and adjust the variables for your Azure environment. 
Some documentation on each variable is inside the sample file.

```bash
# Rename the file
mv shared_vars.hcl.sample shared_vars.hcl

# Edit the file
nano shared_vars.hcl
```


Especially for each new run you should increment the version number in the variable `azure_shared_image_gallery_destination_image_version`.\
If you do not increment the version, then an existing image-version gets overridden. 

### Step 2: Make sure to enter you own SSH Public Key into openssh.ps1

Edit the file [./packer/setup/openssh.ps1](./packer/setup/openssh.ps1) and replace the existing SSH Public Key with your own.
Otherwise I have access to your machines :-)\
The relevant part is in **Line 24-27**.

```powershell
# Configure SSH public key
$content = @"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRYCV99Ge9LI5Y61t95pkcG7trsDyg/eAHLfTGDMHOGxPDdXSk7wW/OCNsKWeJV20wjayoti2JYB+u4FRvsuyccjRZPlRTsul67QOJEzXfORCHD4EYDTR45l0n08zkUPRfs70yo5L5YG9HYgVr6+EK/F8fFReFDvhZwy8LW/hJSeyVCWlbszmuQYcHRmCkWBeAgEiPqx0Mx17txjw9p4RK/LbweYxN4fGu5Nh2Dz9uSBi2IfGds3rPcQvjnJBzt2GEDoZXdXgwXl4T5B0xEDJVMqS/Q+gArcL82cGsY7zpoWpKfOuVy88GD1qaHZgMvQ3LQRyxVysfhxvzSXRX0eF8518/8hGNLxmSak3dZyi5J2ojPdaYzOxtn4JTDFUKNCBQNLHJZCBl1J7HvilTnwQDbgWm0UoFB0dWG3fX4u1wGm11L9sX0kzQ+NZH2Q+9HVX+1vJWZJuNjlhogcsmXG1hecLZPD7WFl82nbmN7zBQwHtUbjUNERMHvXuUvjPnkjJh0avZVtUCRupJhNgyhTR0cWpzffmA2nzdQpIn6z93zVrgefwIpfr+Grk/XQTOXisIfYz/3sofQ9a2hTdPTj0UwKzULB0Pvsf/aYvVEG7zC0sRfPG/pj5cGeFnOB3Ar2/jd58EB7mLzm45MZ+ztSNRW+Eg32Lq1WgOJZ15TiH/pQ== prianto_autodeploy_id_2018
"@ 
```

If you don't need SSH Public Key Authentication, you can remove the whole part between Line 24 and 40.

### Step 3: Run

Run the [run.sh](./run.sh).

[run.sh](./run.sh) runs the [build.sh](./terraform/build.sh) in the [./terrform](./terraform) directory. 

After that it runs the [build.sh](./packer/build.sh) in the [./packer](./packer) directory.

```bash
./run.sh
```

----

## Cleanup

To cleanup everything in azure, make sure to manually delete all image-versions in the share image gallery. `terraform destroy` is not able to delete the image-version, because the image-versions have been built by packer. 
After you have cleanup any image-version in the share image gallery you can use the following terraform command to destroy everything.

```bash
# cd into terraform directory
cd ./terraform

# run terraform destroy
terraform destroy -var-file ../shared_vars.hcl
```
