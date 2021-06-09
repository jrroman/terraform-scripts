## VPC

The `vpc/` directory is a collection of scripts to build a new secure vpc.
You will see a file `env.tfvars.example` this file contains values that can be updated
to your preference.

   
to apply:

```sh
cp env.tfvars.example myenv.tfvars
vi myenv.tfvars # vi or any editor to edit the file
terraform init
terraform apply -var-file myenv.tfvars
```

