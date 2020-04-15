# Terraform Scripts

A collection of terraform scripts for various tasks

### VPC

Inside the `vpc` directory is a collection of scripts to build a new secure vpc.
You will see a file `env.tfvars.example` this file contains values that can be updated
to your preference.

standard deploy without custom config:

```
terraform init
terraform apply
```

   
to apply the custom config (optional):

```
cp env.tfvars.example myenv.tfvars
vi myenv.tfvars # vi or any editor to edit the file
terraform init
terraform apply -var-file myenv.tfvars
```

