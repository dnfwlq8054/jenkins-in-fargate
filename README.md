# jenkins_in_fargate
AWS ECS Fargate to set up a Jenkins master and agent structure.


### The advantages of using AWS Fargate for Jenkins are as follows:
- No need to manage agents.
- No throughput is generated even when builds are run from multiple sources.
- It is easy to use and the reusability of predefined Docker images is increased. For example, if a Docker image is created for building Python, it can be used by others as well.
- It is possible to divide build tasks into smaller units, and it is easy to identify logs and checkpoints.

## Architecture
![image](https://user-images.githubusercontent.com/15880397/229363514-a2e20b89-81ad-43ac-bcdd-0d831e7de6e2.png)

## Use
```
$ terraform init
$ terraform plan
$ terraform apply
```

This creates a `.tfstate` file locally without using the Terraform backend.  
If you want, you can download the code and modify it as desired.

`terraform_lint.sh` checks the conventions and validity of variables in Terraform.

## Note
- This code does not provide a DNS for accessing Jenkins. After installation is complete, access Jenkins via the ALB Domain name (using http).
- If the version of the installed agent image is too low, the build may not run. If necessary, you need to create an image yourself.

