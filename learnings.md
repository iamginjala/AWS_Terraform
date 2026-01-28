
# Terraform Learnings

### State Management 
when ran terraform plan / apply terraform creates a .tfstate and .tfstate.backup and some other files 

Desired state is what you want .tf files 
Actual state is what exists in AWS Real cloud resources 
what happpens during terraform plan/apply .tf files will be compared with .tfstate and determines changes needed 

### Remote Backend 
.tfstate files will contain sensitive data and need to store it in a remote backend like S3 because of advantages shared access for the team, state locking with S3, Versioning and Encrypted storage. 

## Commands Used 
terraform init    -  Initialize, download providers
terraform plan    -  Preview changes
terraform apply   -  Apply changes 
terraform destroy -  Delete all resources 